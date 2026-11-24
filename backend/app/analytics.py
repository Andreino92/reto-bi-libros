"""Capa de procesamiento analítico: consultas SQL parametrizadas sobre `decision_libros`.

Granularidad de la tabla: una fila por libro (UPC) y por escenario. Clave primaria (escenario, upc).
Los umbrales de la regla llegan como PARÁMETROS de la consulta: las simulaciones nunca escriben en PostgreSQL.
"""
from dataclasses import dataclass, field
from decimal import Decimal
from typing import Optional

from sqlalchemy import bindparam, text

# --------------------------------------------------------------------------- filtros
@dataclass
class Filtros:
    categorias: list = field(default_factory=list)
    precio_max: Optional[float] = None
    q: Optional[str] = None
    solo_coincidencia: bool = False


def _where(escenario: str, f: Filtros, ignorar_categoria: bool = False):
    cond, p = ["escenario = :esc"], {"esc": escenario}
    if f.categorias and not ignorar_categoria:
        cond.append("categoria IN :cats")
        p["cats"] = list(f.categorias)
    if f.precio_max is not None:
        cond.append("precio_gbp <= :pmax")
        p["pmax"] = f.precio_max
    if f.q:
        cond.append("titulo ILIKE :q ESCAPE '\\'")
        p["q"] = "%" + f.q.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_") + "%"
    if f.solo_coincidencia:
        cond.append("coincide")
    return " AND ".join(cond), p


def _cte(where: str) -> str:
    """CTE común: recalcula el indicador, aplica la regla con umbrales paramétricos y asigna prioridad.
    El desempate por UPC usa COLLATE "C" para replicar el orden de Python en el ETL."""
    return f"""
WITH f AS (
  SELECT upc, titulo, categoria, precio_gbp, estrellas, stock, obras_ol, ediciones_ol,
         ratings_total, coincide, decision AS decision_etl, prioridad AS prioridad_etl, motivo AS motivo_etl,
         CASE WHEN coincide AND ediciones_ol IS NOT NULL
              THEN ROUND(ediciones_ol::numeric / precio_gbp, 6) END AS indicador,
         (coincide AND estrellas >= :me AND ediciones_ol >= :md) AS cumple
  FROM decision_libros
  WHERE {where}
), r AS (
  SELECT *, CASE WHEN cumple THEN ROW_NUMBER() OVER (PARTITION BY cumple
                 ORDER BY indicador DESC, upc COLLATE "C") END AS prioridad
  FROM f
), d AS (
  SELECT *,
    CASE WHEN prioridad <= :k THEN 'comprar' WHEN cumple THEN 'lista_espera' ELSE 'descartar' END AS decision,
    CASE WHEN NOT coincide THEN 'sin_coincidencia_ol'
         WHEN estrellas < :me THEN 'estrellas_bajo_umbral'
         WHEN ediciones_ol < :md THEN 'ediciones_bajo_umbral'
         ELSE '' END AS motivo
  FROM r
)"""


def _num(v):
    return float(v) if isinstance(v, Decimal) else v


def _fila(m):
    return {k: _num(v) for k, v in dict(m).items()}


def _params(p: dict, extra: dict):
    return {"me": p["min_estrellas"], "md": p["min_ediciones"], "k": p["top_k"], **extra}


def _run(con, escenario, p, f, tail, ignorar_categoria=False):
    where, wp = _where(escenario, f, ignorar_categoria)
    stmt = text(_cte(where) + "\n" + tail)
    if "cats" in wp:
        stmt = stmt.bindparams(bindparam("cats", expanding=True))
    return con.execute(stmt, _params(p, wp))


# --------------------------------------------------------------------------- consultas
def filas(con, escenario, p, f: Filtros):
    res = _run(con, escenario, p, f, """
SELECT upc, titulo, categoria, precio_gbp, estrellas, stock, obras_ol, ediciones_ol, ratings_total,
       coincide, indicador, cumple, prioridad, decision, motivo, decision_etl, prioridad_etl
FROM d ORDER BY prioridad NULLS LAST, indicador DESC NULLS LAST, titulo""")
    return [_fila(m) for m in res.mappings()]


def kpis(con, escenario, p, f: Filtros):
    res = _run(con, escenario, p, f, """
SELECT count(*) AS evaluadas,
       count(*) FILTER (WHERE coincide) AS con_coincidencia,
       count(*) FILTER (WHERE cumple) AS candidatos,
       count(*) FILTER (WHERE decision = 'comprar') AS seleccionados,
       COALESCE(SUM(precio_gbp) FILTER (WHERE decision = 'comprar'), 0) AS costo,
       AVG(indicador) FILTER (WHERE decision = 'comprar') AS indicador_medio
FROM d""").mappings().one()
    k = _fila(res)
    k["cumplimiento_pct"] = round(100.0 * k["candidatos"] / k["evaluadas"], 1) if k["evaluadas"] else 0.0
    k["costo"] = round(k["costo"] or 0, 2)
    k["indicador_medio"] = round(k["indicador_medio"], 4) if k["indicador_medio"] is not None else None
    return k


def composicion(con, escenario, p, f: Filtros):
    """Composición por categoría y decisión. Ignora el filtro de categoría para permitir cambiar de grupo (roll-up)."""
    res = _run(con, escenario, p, f, """
SELECT categoria, decision, count(*) AS n FROM d GROUP BY categoria, decision ORDER BY categoria""",
               ignorar_categoria=True)
    return [_fila(m) for m in res.mappings()]


def histograma(con, escenario, p, f: Filtros, bins=8):
    res = _run(con, escenario, p, f, f"""
, b AS (SELECT MIN(indicador) AS mn, MAX(indicador) AS mx FROM d WHERE indicador IS NOT NULL)
SELECT width_bucket(d.indicador, b.mn, b.mx + 0.000001, {int(bins)}) AS bin, count(*) AS n,
       count(*) FILTER (WHERE d.decision = 'comprar') AS comprar, b.mn, b.mx
FROM d, b WHERE d.indicador IS NOT NULL GROUP BY bin, b.mn, b.mx ORDER BY bin""")
    rows = [_fila(m) for m in res.mappings()]
    if not rows:
        return []
    mn, mx = rows[0]["mn"], rows[0]["mx"]
    ancho = (mx + 0.000001 - mn) / bins
    por_bin = {r["bin"]: r for r in rows}
    return [{"desde": round(mn + i * ancho, 4), "hasta": round(mn + (i + 1) * ancho, 4),
             "n": por_bin.get(i + 1, {}).get("n", 0), "comprar": por_bin.get(i + 1, {}).get("comprar", 0)}
            for i in range(bins)]


def metadatos(con):
    esc = [r[0] for r in con.execute(text("SELECT DISTINCT escenario FROM decision_libros"))]
    cats = [dict(c._mapping) for c in con.execute(text(
        "SELECT categoria, count(*) AS n FROM decision_libros WHERE escenario = 'base' "
        "GROUP BY categoria ORDER BY categoria"))]
    rng = con.execute(text("""
SELECT MIN(precio_gbp) AS pmin, MAX(precio_gbp) AS pmax, MAX(ediciones_ol) AS emax,
       MIN(estrellas) AS smin, MAX(estrellas) AS smax FROM decision_libros""")).mappings().one()
    ahora = con.execute(text("SELECT now()")).scalar()
    return {"escenarios_en_bd": esc, "categorias": cats, "rangos": _fila(rng),
            "consultado_en": ahora.isoformat(timespec="seconds")}


# --------------------------------------------------------------------------- comparaciones
def comparar_listas(a: list, b: list):
    """Compara dos selecciones (listas de dicts ordenadas por prioridad): entran, salen y cambian de posición."""
    pa = {r["upc"]: (i + 1, r) for i, r in enumerate(a)}
    pb = {r["upc"]: (i + 1, r) for i, r in enumerate(b)}
    corto = lambda r, pos: {"upc": r["upc"], "titulo": r["titulo"], "posicion": pos, "indicador": r["indicador"]}
    return {
        "entran": [corto(r, pb[u][0]) for u, (_, r) in pb.items() if u not in pa],
        "salen": [corto(r, pa[u][0]) for u, (_, r) in pa.items() if u not in pb],
        "cambian": [{"upc": u, "titulo": pa[u][1]["titulo"], "de": pa[u][0], "a": pb[u][0]}
                    for u in pa if u in pb and pa[u][0] != pb[u][0]],
    }


def seleccion(filas_):
    return [r for r in filas_ if r["decision"] == "comprar"]


def datos_editados(con, variante):
    """Registros cuyos datos de entrada difieren entre la variante y el escenario base (evidencia de la edición)."""
    res = con.execute(text("""
SELECT b.upc, b.titulo, b.precio_gbp AS precio_base, v.precio_gbp AS precio_variante,
       b.estrellas AS estrellas_base, v.estrellas AS estrellas_variante,
       b.ediciones_ol AS ediciones_base, v.ediciones_ol AS ediciones_variante
FROM decision_libros b JOIN decision_libros v ON v.upc = b.upc AND v.escenario = :v
WHERE b.escenario = 'base' AND (b.precio_gbp <> v.precio_gbp OR b.estrellas <> v.estrellas
      OR b.ediciones_ol IS DISTINCT FROM v.ediciones_ol OR b.categoria IS DISTINCT FROM v.categoria)"""),
                     {"v": variante})
    return [_fila(m) for m in res.mappings()]


def filas_por_escenario(con, escenario):
    return con.execute(text("SELECT count(*) FROM decision_libros WHERE escenario = :e"), {"e": escenario}).scalar()


def verificar_contra_etl(con, escenario, p):
    """Recalcula con los umbrales originales y compara con la decisión y prioridad guardadas por el ETL."""
    rows = filas(con, escenario, p, Filtros())
    distintas = [r["upc"] for r in rows
                 if r["decision"] != r["decision_etl"] or (r["prioridad"] or 0) != (r["prioridad_etl"] or 0)]
    return {"escenario": escenario, "filas": len(rows), "discrepancias": len(distintas),
            "ok": len(distintas) == 0 and len(rows) > 0}
