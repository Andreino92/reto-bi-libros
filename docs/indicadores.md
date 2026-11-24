# Diccionario de KPI

Todos se calculan en el servidor con SQL sobre `decision_libros`, para el escenario, los umbrales y los filtros activos. Referencia de comparación: la **selección original** (umbrales del ETL) del mismo escenario y filtros.

| KPI | Significado | Fórmula | Unidad | Granularidad / filtros | Referencia | Dirección esperada | Interpretación y acción | Responsable |
|---|---|---|---|---|---|---|---|---|
| **Entidades evaluadas** | Libros del catálogo bajo análisis | `COUNT(*)` | libros | libro; respeta categoría, precio, texto y «solo con datos OL» | — | Informativo | Define el tamaño de la población; si es bajo por filtros, las conclusiones son frágiles. | Coord. de adquisiciones |
| **Candidatos que cumplen la regla** | Libros con `estrellas ≥ min_estrellas` y `ediciones_ol ≥ min_ediciones` (y con datos en Open Library) | `COUNT(*) FILTER (WHERE cumple)` | libros | libro; todos los filtros | Candidatos con umbrales originales | ↑ más margen de elección | Si hay menos que el tamaño de la lista, relajar umbrales o ampliar el catálogo. | Coord. de adquisiciones |
| **Libros seleccionados** | Libros que entran en la lista de compra (prioridad ≤ top K) | `COUNT(*) FILTER (WHERE decision='comprar')` | libros | libro | Selección original | = top K | Lista de compra propuesta. | Coord. de adquisiciones |
| **Cumplimiento de la regla** | Proporción de libros que pasan el filtro de calidad | `100 · candidatos / evaluadas` | % | libro; todos los filtros | Cumplimiento original | ↑ | Un valor bajo indica un catálogo poco alineado con los criterios o umbrales muy exigentes. | Coord. de adquisiciones |
| **Costo de la selección** | Gasto total de comprar la lista | `SUM(precio_gbp)` de los seleccionados | £ | libro | Costo original | ↓ para el mismo K | Compararlo con el presupuesto disponible antes de comprar. | Coord. + Finanzas |
| **Indicador medio (ediciones/£)** | Trayectoria editorial obtenida por cada libra gastada, promedio de la selección | `AVG(ediciones_ol / precio_gbp)` | ediciones por £ | libro | Indicador original | ↑ | Mide la eficiencia de la compra; cae si se baja el umbral y entran libros menos eficientes. | Coord. de adquisiciones |

**Indicador por libro:** `ediciones_por_libra = ediciones_ol / precio_gbp` (redondeado a 6 decimales). Es la variable de orden de la lista; el desempate es por `upc`.

**Regla de decisión (2 variables de fuentes distintas):** `estrellas ≥ min_estrellas` (fuente A) y `ediciones_ol ≥ min_ediciones` (fuente B).
