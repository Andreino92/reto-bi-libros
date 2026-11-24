# Diseño previo a la implementación

## Definición del problema
| Elemento | Definición |
|---|---|
| **Audiencia** | Coordinador/a de adquisiciones de una biblioteca de barrio (usuario no técnico). |
| **Decisión** | Qué 10 libros del catálogo comprar primero con un presupuesto limitado. |
| **Alcance** | **Táctico**: prioriza compras del período, no define la estrategia de la colección. |
| **Frecuencia** | Al preparar cada compra (mensual o trimestral), o cuando cambian los precios del proveedor. |

## Preguntas de negocio
1. **¿Cuáles son los libros que conviene comprar primero y cuánto cuestan?** → barras ordenadas + KPIs de selección y costo.
2. **¿Cómo se relaciona el precio de un libro con su trayectoria editorial (ediciones)?** → dispersión.
3. **¿En qué categorías se concentran los libros recomendados y los descartados?** → barras apiladas por categoría.
4. **¿Qué pasa si cambian las condiciones de la regla (estrellas, ediciones, tamaño de la lista)?** → simulador.
5. **¿Cuánto cambia la decisión cuando cambian los datos (precio editado) y cuándo no (registro duplicado)?** → comparación de escenarios.

## Principio de diseño
Cada componente responde una pregunta. No se incluyó una serie temporal porque los datos **no tienen dimensión temporal**: los escenarios son variantes independientes y no períodos.

## Wireframe
Ver [`wireframe.png`](wireframe.png).

## Arquitectura
```
Navegador (HTML + CSS + JS + Apache ECharts)
        │  fetch /api/*  (JSON)
        ▼
FastAPI (Python)  ── capa de procesamiento analítico: SQL parametrizado, KPIs, reglas, comparaciones
        │  SQLAlchemy + psycopg2 (credenciales solo en el servidor, vía variables de entorno)
        ▼
PostgreSQL  ── tabla decision_libros (resultado del reto ETL, 3 escenarios)
```

### Granularidad de los datos
Tabla `decision_libros`: **una fila por libro (UPC) y por escenario**; clave primaria `(escenario, upc)`. Columnas principales: `precio_gbp`, `estrellas`, `categoria` (fuente A, web scraping de books.toscrape.com); `obras_ol`, `ediciones_ol` (fuente B, JSON de Open Library, agrupada por título); `ediciones_por_libra` (indicador); `cumple`, `prioridad`, `decision`, `motivo` (regla del ETL).

### Consultas y vistas usadas
Todas en `backend/app/analytics.py`: una CTE parametrizada recalcula el indicador, aplica la regla con umbrales recibidos como parámetros y numera la prioridad con `ROW_NUMBER()`. Sobre ella se construyen las consultas de filas, KPI, composición (GROUP BY) e histograma (`width_bucket`). **No se escribe nada en la base**: las simulaciones son solo parámetros.

### Justificación del stack
| Criterio | Decisión |
|---|---|
| Conectividad | FastAPI + SQLAlchemy/psycopg2: la misma conexión y SQL del reto ETL; las credenciales nunca llegan al navegador. |
| Facilidad de desarrollo | Un solo lenguaje (Python) en datos y servidor; el frontend en HTML/JS sin paso de compilación. |
| Personalización | Interfaz y componentes propios (sin herramientas BI); ECharts permite gráficos a medida (umbrales, clic, resaltado). |
| Mantenibilidad | Tres módulos pequeños en el backend (`config`, `analytics`, `main`) y tres archivos en el frontend. |
| Despliegue | Docker Compose (base + API) con un solo comando; también se ejecuta con `uvicorn` local. |

## Relación con las operaciones OLAP
| Operación | Interacción implementada |
|---|---|
| **Slice** | Seleccionar un escenario o una categoría (un valor de una dimensión). |
| **Dice** | Combinar categoría + precio máximo + texto + «solo con datos en Open Library». |
| **Drill-down** | De los KPI y gráficos generales a una categoría (clic en barra) y de ahí al libro individual (panel de detalle). |
| **Roll-up** | Quitar el filtro de categoría (chip ×) o «Restablecer filtros» para volver a la vista general. |
