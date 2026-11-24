-- =====================================================================================
-- Validaciones SQL INDEPENDIENTES del código de la aplicación.
-- Condiciones equivalentes a las del dashboard, escritas con subconsultas simples
-- (sin ventanas ni CTE de la API) para contrastar los resultados.
-- Umbrales originales del ETL: min_estrellas = 3, min_ediciones = 5, top_k = 10
-- (cámbielos si usó otros en el notebook).
-- Uso:  psql -h localhost -p 5432 -U reto -d retoetl -f database/validaciones.sql
-- =====================================================================================

-- V1. Granularidad: una fila por (escenario, upc). Debe devolver 0 filas.
SELECT escenario, upc, count(*) FROM decision_libros GROUP BY escenario, upc HAVING count(*) > 1;

-- V2. KPI 1-3 y 4 por escenario: evaluadas, con coincidencia, candidatos, cumplimiento (%).
SELECT escenario,
       count(*)                                                            AS evaluadas,
       count(*) FILTER (WHERE coincide)                                    AS con_coincidencia,
       count(*) FILTER (WHERE coincide AND estrellas >= 3 AND ediciones_ol >= 5) AS candidatos,
       round(100.0 * count(*) FILTER (WHERE coincide AND estrellas >= 3 AND ediciones_ol >= 5) / count(*), 1) AS cumplimiento_pct
FROM decision_libros GROUP BY escenario ORDER BY escenario;

-- V3. KPI 5 y 6 (costo e indicador medio de la selección top 10) por escenario.
SELECT escenario, count(*) AS seleccionados, round(sum(precio_gbp), 2) AS costo,
       round(avg(ediciones_ol::numeric / precio_gbp), 4) AS indicador_medio
FROM (
  SELECT d.*, (SELECT count(*) FROM decision_libros x
               WHERE x.escenario = d.escenario AND x.coincide AND x.estrellas >= 3 AND x.ediciones_ol >= 5
                 AND (round(x.ediciones_ol::numeric / x.precio_gbp, 6) > round(d.ediciones_ol::numeric / d.precio_gbp, 6)
                   OR (round(x.ediciones_ol::numeric / x.precio_gbp, 6) = round(d.ediciones_ol::numeric / d.precio_gbp, 6)
                       AND x.upc COLLATE "C" < d.upc COLLATE "C"))) + 1 AS pos
  FROM decision_libros d WHERE d.coincide AND d.estrellas >= 3 AND d.ediciones_ol >= 5
) t WHERE pos <= 10 GROUP BY escenario ORDER BY escenario;

-- V4. La selección guardada por el ETL (decision = 'comprar') debe coincidir con V3.
SELECT escenario, count(*) AS comprar_etl, round(sum(precio_gbp), 2) AS costo_etl
FROM decision_libros WHERE decision = 'comprar' GROUP BY escenario ORDER BY escenario;

-- V5. Escenario 2: registro(s) cuyos datos difieren de la base (el dato editado).
SELECT b.upc, b.titulo, b.precio_gbp AS precio_base, v.precio_gbp AS precio_variante,
       b.prioridad AS prioridad_base, v.prioridad AS prioridad_variante
FROM decision_libros b JOIN decision_libros v ON v.upc = b.upc AND v.escenario = 'esc_cambia_decision'
WHERE b.escenario = 'base' AND (b.precio_gbp <> v.precio_gbp OR b.estrellas <> v.estrellas OR b.ediciones_ol IS DISTINCT FROM v.ediciones_ol);

-- V6. Escenario 3: no debe haber ninguna diferencia de indicador, prioridad o decisión frente a la base. Debe devolver 0.
SELECT count(*) AS filas_distintas
FROM decision_libros b JOIN decision_libros v ON v.upc = b.upc AND v.escenario = 'esc_duplicado'
WHERE b.escenario = 'base' AND (b.ediciones_por_libra IS DISTINCT FROM v.ediciones_por_libra
   OR b.prioridad IS DISTINCT FROM v.prioridad OR b.decision <> v.decision);

-- V7. Simulador (ejemplo): estrellas >= 4 y ediciones >= 20 en el escenario base.
SELECT count(*) AS candidatos_simulados
FROM decision_libros WHERE escenario = 'base' AND coincide AND estrellas >= 4 AND ediciones_ol >= 20;

-- V8. Filtro vacío: una búsqueda sin resultados debe producir 0 filas (la app muestra el estado vacío).
SELECT count(*) AS filas FROM decision_libros WHERE escenario = 'base' AND titulo ILIKE '%zzzzzz%';
