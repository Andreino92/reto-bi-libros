# Validación de resultados

La corrección de los resultados se comprueba de dos maneras complementarias:

1. **Automática** — `python scripts/validar.py` (con la API en ejecución) contrasta, por cada comprobación, el resultado del dashboard/API con una **consulta SQL independiente** y escribe la evidencia en [`validaciones_resultado.md`](validaciones_resultado.md) (condición, esperado, observado, estado).
2. **Manual en SQL** — [`../database/validaciones.sql`](../database/validaciones.sql) contiene las consultas que puede ejecutar en `psql` y comparar con lo que muestra la pantalla.

## Qué se verifica
| Requisito | Comprobación |
|---|---|
| Cinco indicadores | Evaluadas, candidatos, seleccionados, cumplimiento, costo e indicador medio, en cada uno de los tres escenarios (SQL independiente vs API). |
| Escenarios = ETL | Lista y orden de la selección de cada escenario coinciden con `decision='comprar'` / `prioridad` guardadas por el ETL; `/api/validacion` repite el recálculo completo. |
| Escenario 2 (cambia) | El registro con dato editado aparece (join base–variante) y la selección difiere de la base. |
| Escenario 3 (conserva) | 0 filas con indicador, prioridad o decisión distintos a la base; misma lista y orden. |
| Simulador | Cuatro combinaciones de umbrales (candidatos, seleccionados y costo) contra SQL equivalente. |
| Filtros | Categoría y precio máximo: evaluadas y candidatos contra SQL con `WHERE`. |
| Selección vacía | Un texto inexistente o un umbral imposible devuelve 200 con listas vacías y la interfaz muestra el estado vacío (sin errores). |

## Cómo ejecutar
```bash
python scripts/validar.py            # usa http://localhost:8000 y las variables de .env
psql -h localhost -p 5432 -U reto -d retoetl -f database/validaciones.sql
```
> Los umbrales de `.env` (`ORIG_*`) y los de `validaciones.sql` deben ser los mismos que usó en el ETL.

## Verificación visual (manual)
Con los umbrales originales, anote en [`validaciones_resultado.md`](validaciones_resultado.md) o en capturas (`screenshots/`) que los KPI de la pantalla coinciden con los resultados de las consultas V2 y V3 de `validaciones.sql`.
