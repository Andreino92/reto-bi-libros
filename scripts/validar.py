"""Validación automática: contrasta lo que muestra la API/dashboard con consultas SQL INDEPENDIENTES.

Requisitos: la API en ejecución (por defecto http://localhost:8000) y las mismas variables de entorno (.env).
Uso:   python scripts/validar.py [URL_API]
Salida: tabla en consola y archivo docs/validaciones_resultado.md (condición, esperado, observado, evidencia).
"""
import json, os, sys, urllib.parse, urllib.request
from datetime import datetime
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

RAIZ = Path(__file__).resolve().parents[1]
load_dotenv(RAIZ / ".env")
API = (sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8000").rstrip("/")
DSN = os.getenv("DATABASE_URL", "postgresql+psycopg2://reto:reto@localhost:5432/retoetl").replace("+psycopg2", "")
ORIG = dict(me=int(os.getenv("ORIG_MIN_ESTRELLAS", 3)), md=int(os.getenv("ORIG_MIN_EDICIONES", 5)), k=int(os.getenv("ORIG_TOP_K", 10)))
ESCENARIOS = ["base", "esc_cambia_decision", "esc_duplicado"]

con = psycopg2.connect(DSN)
cur = con.cursor()
filas = []


def api(path, **params):
    q = []
    for k, v in params.items():
        for x in (v if isinstance(v, list) else [v]):
            q.append((k, x))
    with urllib.request.urlopen(f"{API}{path}?{urllib.parse.urlencode(q)}", timeout=30) as r:
        return json.load(r)


def sql_kpis(esc, me, md, k, extra="", args=()):
    """KPIs calculados con SQL independiente (subconsulta con conteo de posición, sin funciones de ventana)."""
    cur.execute(f"""
      SELECT count(*) FROM decision_libros WHERE escenario=%s {extra}""", (esc, *args))
    evaluadas = cur.fetchone()[0]
    cur.execute(f"""
      SELECT count(*) FROM decision_libros WHERE escenario=%s {extra} AND coincide AND estrellas>=%s AND ediciones_ol>=%s""",
                (esc, *args, me, md))
    cand = cur.fetchone()[0]
    cur.execute(f"""
      WITH c AS (SELECT upc, precio_gbp, round(ediciones_ol::numeric/precio_gbp,6) AS ind
                 FROM decision_libros WHERE escenario=%s {extra} AND coincide AND estrellas>=%s AND ediciones_ol>=%s)
      SELECT count(*), coalesce(round(sum(precio_gbp),2),0), round(avg(ind),4) FROM (
        SELECT a.*, (SELECT count(*) FROM c b WHERE b.ind > a.ind OR (b.ind = a.ind AND b.upc COLLATE "C" < a.upc COLLATE "C")) + 1 AS pos
        FROM c a) t WHERE pos <= %s""", (esc, *args, me, md, k))
    n, costo, ind = cur.fetchone()
    return {"evaluadas": evaluadas, "candidatos": cand, "seleccionados": n, "costo": float(costo),
            "indicador_medio": float(ind) if ind is not None else None,
            "cumplimiento_pct": round(100.0 * cand / evaluadas, 1) if evaluadas else 0.0}


def comparar(nombre, condicion, esperado, observado, evidencia):
    ok = esperado == observado
    filas.append((nombre, condicion, esperado, observado, "✅" if ok else "❌", evidencia))
    print(("OK  " if ok else "FALLA"), nombre, "|", condicion)
    return ok


# 1) Cinco+ indicadores por escenario con umbrales originales -------------------------------------
for e in ESCENARIOS:
    a = api("/api/analisis", escenario=e, min_estrellas=ORIG["me"], min_ediciones=ORIG["md"], top_k=ORIG["k"])["kpis"]
    s = sql_kpis(e, ORIG["me"], ORIG["md"], ORIG["k"])
    for kpi in ["evaluadas", "candidatos", "seleccionados", "cumplimiento_pct", "costo", "indicador_medio"]:
        comparar(f"KPI {kpi}", f"escenario={e}, umbrales originales {ORIG}", s[kpi], a[kpi], "SQL independiente vs /api/analisis")

# 2) Escenarios vs resultado esperado del ETL (decision='comprar' guardada) ------------------------
for e in ESCENARIOS:
    cur.execute("SELECT upc FROM decision_libros WHERE escenario=%s AND decision='comprar' ORDER BY prioridad", (e,))
    etl = [r[0] for r in cur.fetchall()]
    a = api("/api/analisis", escenario=e, min_estrellas=ORIG["me"], min_ediciones=ORIG["md"], top_k=ORIG["k"])["filas"]
    obs = [r["upc"] for r in sorted((r for r in a if r["decision"] == "comprar"), key=lambda r: r["prioridad"])]
    comparar("Escenario = ETL", f"lista y orden de la selección en {e}", etl, obs, "decision/prioridad guardadas por el ETL")

# 3) Escenario 2 cambia y escenario 3 conserva -----------------------------------------------------
cmp_ = api("/api/comparacion", min_estrellas=ORIG["me"], min_ediciones=ORIG["md"], top_k=ORIG["k"])
por = {e["id"]: e for e in cmp_["escenarios"]}
cur.execute("""SELECT count(*) FROM decision_libros b JOIN decision_libros v ON v.upc=b.upc AND v.escenario='esc_cambia_decision'
               WHERE b.escenario='base' AND b.precio_gbp<>v.precio_gbp""")
comparar("Escenario 2 altera", "nº de registros con precio editado (SQL) vs datos_editados (API)", cur.fetchone()[0], len(por["esc_cambia_decision"]["datos_editados"]), "join base-variante")
comparar("Escenario 2 altera", "la selección difiere de la base", True, not por["esc_cambia_decision"]["misma_seleccion"], "API /api/comparacion")
cur.execute("""SELECT count(*) FROM decision_libros b JOIN decision_libros v ON v.upc=b.upc AND v.escenario='esc_duplicado'
               WHERE b.escenario='base' AND (b.ediciones_por_libra IS DISTINCT FROM v.ediciones_por_libra
               OR b.prioridad IS DISTINCT FROM v.prioridad OR b.decision<>v.decision)""")
comparar("Escenario 3 conserva", "filas con indicador, prioridad o decisión distintos a la base", 0, cur.fetchone()[0], "validaciones.sql V6")
comparar("Escenario 3 conserva", "misma lista y orden que la base (API)", True, por["esc_duplicado"]["misma_seleccion"], "API /api/comparacion")

# 4) Simulador: otros umbrales contra SQL equivalente -----------------------------------------------
for me, md, k in [(4, 20, 8), (2, 1, 15), (5, 0, 5), (ORIG["me"], ORIG["md"] + 15, ORIG["k"])]:
    a = api("/api/analisis", escenario="base", min_estrellas=me, min_ediciones=md, top_k=k)["kpis"]
    s = sql_kpis("base", me, md, k)
    for kpi in ["candidatos", "seleccionados", "costo"]:
        comparar(f"Simulador {kpi}", f"base, estrellas>={me}, ediciones>={md}, top {k}", s[kpi], a[kpi], "SQL equivalente")

# 5) Filtros y selección vacía -----------------------------------------------------------------------
cur.execute("SELECT categoria FROM decision_libros WHERE escenario='base' GROUP BY categoria ORDER BY count(*) DESC LIMIT 1")
cat = cur.fetchone()[0]
a = api("/api/analisis", escenario="base", min_estrellas=ORIG["me"], min_ediciones=ORIG["md"], top_k=ORIG["k"], categorias=[cat])["kpis"]
s = sql_kpis("base", ORIG["me"], ORIG["md"], ORIG["k"], "AND categoria=%s", (cat,))
comparar("Filtro categoría", f"categoría «{cat}»: evaluadas y candidatos", (s["evaluadas"], s["candidatos"]), (a["evaluadas"], a["candidatos"]), "SQL con WHERE categoria")
a = api("/api/analisis", escenario="base", min_estrellas=ORIG["me"], min_ediciones=ORIG["md"], top_k=ORIG["k"], precio_max=20)["kpis"]
s = sql_kpis("base", ORIG["me"], ORIG["md"], ORIG["k"], "AND precio_gbp<=%s", (20,))
comparar("Filtro precio", "precio <= 20: evaluadas y candidatos", (s["evaluadas"], s["candidatos"]), (a["evaluadas"], a["candidatos"]), "SQL con WHERE precio")
a = api("/api/analisis", escenario="base", q="zzzzzz")
comparar("Selección vacía", "título que no existe", (0, 0, 0), (a["kpis"]["evaluadas"], len(a["filas"]), a["kpis"]["seleccionados"]), "la API responde 200 con listas vacías; la interfaz muestra el estado vacío")
a = api("/api/analisis", escenario="base", min_ediciones=1_000_000)["kpis"]
comparar("Umbral imposible", "ediciones >= 1.000.000: sin candidatos", (0, 0), (a["candidatos"], a["seleccionados"]), "sin error; KPIs en cero")

# 6) Consistencia global ------------------------------------------------------------------------------
v = api("/api/validacion")
comparar("Recalculo = ETL", "recalcular con umbrales originales reproduce decision y prioridad guardadas", True, v["ok"], "/api/validacion")

# --------------------------------------------------------------------------------------------------------
total, bien = len(filas), sum(1 for f in filas if f[4] == "✅")
md = [f"# Resultado de la validación automática\n", f"Ejecutada: {datetime.now():%Y-%m-%d %H:%M:%S} · API: `{API}` · umbrales originales: `{ORIG}`\n",
      f"**{bien} de {total} comprobaciones correctas.**\n", "| # | Verificación | Condición evaluada | Esperado (SQL/ETL) | Observado (dashboard/API) | Estado | Evidencia |", "|---|---|---|---|---|---|---|"]
for i, (n, c, e, o, st, ev) in enumerate(filas, 1):
    short = lambda x: (str(x)[:70] + "…") if len(str(x)) > 70 else str(x)
    md.append(f"| {i} | {n} | {c} | {short(e)} | {short(o)} | {st} | {ev} |")
out = RAIZ / "docs" / "validaciones_resultado.md"
out.write_text("\n".join(md) + "\n", encoding="utf-8")
print(f"\n{bien}/{total} correctas -> {out}")
sys.exit(0 if bien == total else 1)
