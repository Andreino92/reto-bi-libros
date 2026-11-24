# Resultado de la validación automática

Ejecutada: 2026-11-24 17:36:03 · API: `http://localhost:8000` · umbrales originales: `{'me': 3, 'md': 5, 'k': 10}`

**42 de 42 comprobaciones correctas.**

| # | Verificación | Condición evaluada | Esperado (SQL/ETL) | Observado (dashboard/API) | Estado | Evidencia |
|---|---|---|---|---|---|---|
| 1 | KPI evaluadas | escenario=base, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 100 | 100 | ✅ | SQL independiente vs /api/analisis |
| 2 | KPI candidatos | escenario=base, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 16 | 16 | ✅ | SQL independiente vs /api/analisis |
| 3 | KPI seleccionados | escenario=base, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 10 | 10 | ✅ | SQL independiente vs /api/analisis |
| 4 | KPI cumplimiento_pct | escenario=base, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 16.0 | 16.0 | ✅ | SQL independiente vs /api/analisis |
| 5 | KPI costo | escenario=base, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 292.14 | 292.14 | ✅ | SQL independiente vs /api/analisis |
| 6 | KPI indicador_medio | escenario=base, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 1.1274 | 1.1274 | ✅ | SQL independiente vs /api/analisis |
| 7 | KPI evaluadas | escenario=esc_cambia_decision, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 100 | 100 | ✅ | SQL independiente vs /api/analisis |
| 8 | KPI candidatos | escenario=esc_cambia_decision, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 16 | 16 | ✅ | SQL independiente vs /api/analisis |
| 9 | KPI seleccionados | escenario=esc_cambia_decision, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 10 | 10 | ✅ | SQL independiente vs /api/analisis |
| 10 | KPI cumplimiento_pct | escenario=esc_cambia_decision, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 16.0 | 16.0 | ✅ | SQL independiente vs /api/analisis |
| 11 | KPI costo | escenario=esc_cambia_decision, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 301.47 | 301.47 | ✅ | SQL independiente vs /api/analisis |
| 12 | KPI indicador_medio | escenario=esc_cambia_decision, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 0.592 | 0.592 | ✅ | SQL independiente vs /api/analisis |
| 13 | KPI evaluadas | escenario=esc_duplicado, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 100 | 100 | ✅ | SQL independiente vs /api/analisis |
| 14 | KPI candidatos | escenario=esc_duplicado, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 16 | 16 | ✅ | SQL independiente vs /api/analisis |
| 15 | KPI seleccionados | escenario=esc_duplicado, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 10 | 10 | ✅ | SQL independiente vs /api/analisis |
| 16 | KPI cumplimiento_pct | escenario=esc_duplicado, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 16.0 | 16.0 | ✅ | SQL independiente vs /api/analisis |
| 17 | KPI costo | escenario=esc_duplicado, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 292.14 | 292.14 | ✅ | SQL independiente vs /api/analisis |
| 18 | KPI indicador_medio | escenario=esc_duplicado, umbrales originales {'me': 3, 'md': 5, 'k': 10} | 1.1274 | 1.1274 | ✅ | SQL independiente vs /api/analisis |
| 19 | Escenario = ETL | lista y orden de la selección en base | ['9429b4d59c537af5', '30a7f60cd76ca58c', 'ce6396b0f23f6ecc', 'e00eb4fd… | ['9429b4d59c537af5', '30a7f60cd76ca58c', 'ce6396b0f23f6ecc', 'e00eb4fd… | ✅ | decision/prioridad guardadas por el ETL |
| 20 | Escenario = ETL | lista y orden de la selección en esc_cambia_decision | ['30a7f60cd76ca58c', 'ce6396b0f23f6ecc', 'e00eb4fd7b871a48', 'be5cc846… | ['30a7f60cd76ca58c', 'ce6396b0f23f6ecc', 'e00eb4fd7b871a48', 'be5cc846… | ✅ | decision/prioridad guardadas por el ETL |
| 21 | Escenario = ETL | lista y orden de la selección en esc_duplicado | ['9429b4d59c537af5', '30a7f60cd76ca58c', 'ce6396b0f23f6ecc', 'e00eb4fd… | ['9429b4d59c537af5', '30a7f60cd76ca58c', 'ce6396b0f23f6ecc', 'e00eb4fd… | ✅ | decision/prioridad guardadas por el ETL |
| 22 | Escenario 2 altera | nº de registros con precio editado (SQL) vs datos_editados (API) | 1 | 1 | ✅ | join base-variante |
| 23 | Escenario 2 altera | la selección difiere de la base | True | True | ✅ | API /api/comparacion |
| 24 | Escenario 3 conserva | filas con indicador, prioridad o decisión distintos a la base | 0 | 0 | ✅ | validaciones.sql V6 |
| 25 | Escenario 3 conserva | misma lista y orden que la base (API) | True | True | ✅ | API /api/comparacion |
| 26 | Simulador candidatos | base, estrellas>=4, ediciones>=20, top 8 | 3 | 3 | ✅ | SQL equivalente |
| 27 | Simulador seleccionados | base, estrellas>=4, ediciones>=20, top 8 | 3 | 3 | ✅ | SQL equivalente |
| 28 | Simulador costo | base, estrellas>=4, ediciones>=20, top 8 | 120.7 | 120.7 | ✅ | SQL equivalente |
| 29 | Simulador candidatos | base, estrellas>=2, ediciones>=1, top 15 | 30 | 30 | ✅ | SQL equivalente |
| 30 | Simulador seleccionados | base, estrellas>=2, ediciones>=1, top 15 | 15 | 15 | ✅ | SQL equivalente |
| 31 | Simulador costo | base, estrellas>=2, ediciones>=1, top 15 | 459.12 | 459.12 | ✅ | SQL equivalente |
| 32 | Simulador candidatos | base, estrellas>=5, ediciones>=0, top 5 | 9 | 9 | ✅ | SQL equivalente |
| 33 | Simulador seleccionados | base, estrellas>=5, ediciones>=0, top 5 | 5 | 5 | ✅ | SQL equivalente |
| 34 | Simulador costo | base, estrellas>=5, ediciones>=0, top 5 | 109.51 | 109.51 | ✅ | SQL equivalente |
| 35 | Simulador candidatos | base, estrellas>=3, ediciones>=20, top 10 | 5 | 5 | ✅ | SQL equivalente |
| 36 | Simulador seleccionados | base, estrellas>=3, ediciones>=20, top 10 | 5 | 5 | ✅ | SQL equivalente |
| 37 | Simulador costo | base, estrellas>=3, ediciones>=20, top 10 | 182.63 | 182.63 | ✅ | SQL equivalente |
| 38 | Filtro categoría | categoría «Sequential Art»: evaluadas y candidatos | (14, 2) | (14, 2) | ✅ | SQL con WHERE categoria |
| 39 | Filtro precio | precio <= 20: evaluadas y candidatos | (26, 5) | (26, 5) | ✅ | SQL con WHERE precio |
| 40 | Selección vacía | título que no existe | (0, 0, 0) | (0, 0, 0) | ✅ | la API responde 200 con listas vacías; la interfaz muestra el estado vacío |
| 41 | Umbral imposible | ediciones >= 1.000.000: sin candidatos | (0, 0) | (0, 0) | ✅ | sin error; KPIs en cero |
| 42 | Recalculo = ETL | recalcular con umbrales originales reproduce decision y prioridad guardadas | True | True | ✅ | /api/validacion |
