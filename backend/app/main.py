"""API del dashboard de inteligencia de negocios (FastAPI).
La conexión a PostgreSQL se hace aquí, en el servidor. El navegador solo habla con /api/*."""
from typing import List, Optional

from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy import create_engine, text
from sqlalchemy.exc import DBAPIError, SQLAlchemyError

from . import analytics as A
from .config import ESC_IDS, ESCENARIOS, FRONTEND_DIR, ORIGINAL, database_url

app = FastAPI(title="BiblioPrioriza BI", version="1.0.0",
              description="Dashboard decisional sobre los resultados del reto ETL (PostgreSQL).")
engine = create_engine(database_url(), pool_pre_ping=True)


@app.exception_handler(SQLAlchemyError)
async def error_bd(_, exc: SQLAlchemyError):
    detalle = "No se pudo consultar PostgreSQL. Verifique que la base esté en ejecución y que exista la tabla decision_libros."
    if isinstance(exc, DBAPIError):
        detalle += " (" + str(exc.orig).strip().splitlines()[0] + ")"
    return JSONResponse(status_code=503, content={"detail": detalle})


def _esc(escenario: str) -> str:
    if escenario not in ESC_IDS:
        raise HTTPException(404, f"Escenario desconocido: {escenario}")
    return escenario


def _p(min_estrellas, min_ediciones, top_k):
    return {"min_estrellas": min_estrellas, "min_ediciones": min_ediciones, "top_k": top_k}


def _f(categorias, precio_max, q, solo_coincidencia):
    return A.Filtros(categorias or [], precio_max, (q or "").strip() or None, solo_coincidencia)


# Parámetros de consulta reutilizables (con límites para evitar entradas absurdas)
ME = Query(ORIGINAL["min_estrellas"], ge=0, le=5, description="Estrellas mínimas (fuente A)")
MD = Query(ORIGINAL["min_ediciones"], ge=0, le=1_000_000, description="Ediciones mínimas (fuente B)")
TK = Query(ORIGINAL["top_k"], ge=1, le=500, description="Tamaño de la lista final")


@app.get("/api/meta")
def meta():
    with engine.connect() as con:
        m = A.metadatos(con)
    en_bd = m.pop("escenarios_en_bd")
    m["escenarios"] = [e for e in ESCENARIOS if e["id"] in en_bd]
    m["original"] = ORIGINAL
    return m


@app.get("/api/analisis")
def analisis(escenario: str = "base", min_estrellas: int = ME, min_ediciones: int = MD, top_k: int = TK,
             categorias: Optional[List[str]] = Query(None), precio_max: Optional[float] = Query(None, ge=0),
             q: Optional[str] = Query(None, max_length=80), solo_coincidencia: bool = False):
    """Todo lo que necesita la vista principal para un escenario, unos umbrales y unos filtros."""
    escenario = _esc(escenario)
    p, po, f = _p(min_estrellas, min_ediciones, top_k), dict(ORIGINAL), _f(categorias, precio_max, q, solo_coincidencia)
    with engine.connect() as con:
        sim = A.filas(con, escenario, p, f)
        orig = A.filas(con, escenario, po, f)
        out = {
            "escenario": escenario, "parametros": p, "original": po, "filtros_activos": bool(
                categorias or precio_max is not None or f.q or solo_coincidencia),
            "kpis": A.kpis(con, escenario, p, f), "kpis_original": A.kpis(con, escenario, po, f),
            "composicion": A.composicion(con, escenario, p, f), "histograma": A.histograma(con, escenario, p, f),
            "filas": sim,
            "diferencias": A.comparar_listas(A.seleccion(orig), A.seleccion(sim)),
            "consultado_en": con.execute(text("SELECT now()")).scalar().isoformat(timespec="seconds"),
        }
    return out


@app.get("/api/comparacion")
def comparacion(min_estrellas: int = ME, min_ediciones: int = MD, top_k: int = TK):
    """Compara los escenarios entre sí con los mismos umbrales. Los escenarios son variantes independientes:
    no se suman ni representan períodos."""
    p, f = _p(min_estrellas, min_ediciones, top_k), A.Filtros()
    with engine.connect() as con:
        datos = {e: A.filas(con, e, p, f) for e in ESC_IDS if A.filas_por_escenario(con, e)}
        base_sel = A.seleccion(datos["base"])
        esc = []
        for e in ESCENARIOS:
            if e["id"] not in datos:
                continue
            sel = A.seleccion(datos[e["id"]])
            item = {**e, "filas": len(datos[e["id"]]), "candidatos": sum(1 for r in datos[e["id"]] if r["cumple"]),
                    "seleccionados": len(sel), "costo": round(sum(r["precio_gbp"] for r in sel), 2),
                    "seleccion": [{"upc": r["upc"], "titulo": r["titulo"], "prioridad": r["prioridad"],
                                   "indicador": r["indicador"], "precio_gbp": r["precio_gbp"],
                                   "ediciones_ol": r["ediciones_ol"]} for r in sel]}
            if e["id"] != "base":
                item["diferencias"] = A.comparar_listas(base_sel, sel)
                item["datos_editados"] = A.datos_editados(con, e["id"])
                base_por_upc = {r["upc"]: r for r in datos["base"]}
                item["filas_con_cambio"] = sum(
                    1 for r in datos[e["id"]] if r["upc"] in base_por_upc and (
                        r["indicador"] != base_por_upc[r["upc"]]["indicador"]
                        or r["prioridad"] != base_por_upc[r["upc"]]["prioridad"]))
                item["misma_seleccion"] = [r["upc"] for r in sel] == [r["upc"] for r in base_sel]
            esc.append(item)
        # Libros de la unión de las selecciones, con su indicador y prioridad en cada escenario
        union = []
        vistos = set()
        for e in datos.values():
            for r in A.seleccion(e):
                if r["upc"] not in vistos:
                    vistos.add(r["upc"])
                    union.append({"upc": r["upc"], "titulo": r["titulo"]})
        por = {e: {r["upc"]: r for r in rows} for e, rows in datos.items()}
        for u in union:
            for e in datos:
                r = por[e].get(u["upc"])
                u[e] = {"indicador": r["indicador"], "prioridad": r["prioridad"], "decision": r["decision"]} if r else None
        union.sort(key=lambda u: (u["base"]["prioridad"] if u.get("base") and u["base"]["prioridad"] else 10**6))
    return {"parametros": p, "escenarios": esc, "union": union}


@app.get("/api/libro/{upc}")
def libro(upc: str, min_estrellas: int = ME, min_ediciones: int = MD, top_k: int = TK):
    """Detalle de una entidad en todos los escenarios (drill-down)."""
    p = _p(min_estrellas, min_ediciones, top_k)
    out = []
    with engine.connect() as con:
        for e in ESCENARIOS:
            fila = next((r for r in A.filas(con, e["id"], p, A.Filtros()) if r["upc"] == upc), None)
            if fila:
                out.append({"escenario": e["id"], "nombre": e["nombre"], **fila})
    if not out:
        raise HTTPException(404, "Libro no encontrado")
    return {"upc": upc, "parametros": p, "escenarios": out}


@app.get("/api/validacion")
def validacion():
    """Comprueba que recalcular con los umbrales originales reproduce la decisión guardada por el ETL."""
    with engine.connect() as con:
        res = [A.verificar_contra_etl(con, e, ORIGINAL) for e in ESC_IDS if A.filas_por_escenario(con, e)]
    return {"original": ORIGINAL, "escenarios": res, "ok": all(r["ok"] for r in res)}


@app.post("/api/refrescar")
def refrescar():
    """Vuelve a consultar PostgreSQL y devuelve la marca de tiempo de la consulta (no modifica datos)."""
    with engine.connect() as con:
        return A.metadatos(con) | {"original": ORIGINAL}


@app.get("/api/salud")
def salud():
    with engine.connect() as con:
        con.execute(text("SELECT 1"))
    return {"estado": "ok"}


# El frontend estático se sirve desde la misma aplicación (debe ir al final).
app.mount("/", StaticFiles(directory=str(FRONTEND_DIR), html=True), name="web")
