# BiblioPrioriza · Dashboard decisional

Aplicación web de inteligencia de negocios que convierte los resultados del reto ETL (*dos fuentes, una decisión*) en una herramienta para **decidir qué libros comprar primero con un presupuesto limitado**, sin ejecutar notebooks, escribir SQL ni tocar el código.

> 🎥 **Video de demostración:** _(https://drive.google.com/file/d/1Cq4X_kBCqx9Vs7_7OyAepjg_cCzJDnNE/view?usp=sharing)_  ·  📦 **Repositorio ETL (actividad anterior):** https://github.com/Andreino92/reto-etl-libros

## Problema, audiencia y objetivo
- **Audiencia:** coordinación de adquisiciones de una biblioteca de barrio. **Alcance:** táctico.
- **Decisión:** ¿qué 10 libros comprar primero? Se combinan la calidad percibida (estrellas, fuente A: books.toscrape.com) y la trayectoria editorial (nº de ediciones, fuente B: Open Library) en relación con el precio.
- **Regla de decisión (2 variables):** `estrellas ≥ min_estrellas` **y** `ediciones ≥ min_ediciones`; prioridad por `ediciones / precio`.
- **Nota:** los precios de books.toscrape.com son ficticios; el resultado ilustra el método.

## Funcionalidades
- **6 KPI** con variación frente a la selección original (ver [diccionario](docs/indicadores.md)).
- **4 gráficos** que responden preguntas distintas: barras ordenadas (comparar), dispersión (relacionar), barras apiladas (composición) e histograma (distribución); más barras agrupadas para comparar escenarios.
- **Filtros:** escenario, categoría, precio máximo, texto y «solo con datos en Open Library»; chips de filtros activos y restablecimiento.
- **Simulador:** umbrales de las dos variables y tamaño de la lista; muestra entran / salen / cambian de posición frente a la selección original. No modifica PostgreSQL.
- **Comparación de escenarios:** Base · Cambio que altera la decisión · Cambio que conserva la decisión (variantes independientes, no períodos).
- **Drill-down:** KPI y gráficos → categoría (clic en barra) → panel de detalle del libro en los tres escenarios. **Roll-up:** quitar filtros.
- Estados de carga, error y vacío; última consulta a PostgreSQL; botón *Actualizar datos*; exportación CSV; diseño responsive y modo oscuro.

## Tecnologías
Python · **FastAPI** · SQLAlchemy/psycopg2 · **PostgreSQL 16** · HTML/CSS/JavaScript · **Apache ECharts** · Docker Compose. Justificación en [docs/diseno.md](docs/diseno.md).

## Arquitectura
```
Navegador (HTML/JS + ECharts) ──/api/*──▶ FastAPI (SQL parametrizado, KPIs, reglas) ──▶ PostgreSQL (decision_libros)
```
Las credenciales viven solo en el servidor (`.env`). Documentación: [diseño](docs/diseno.md) · [wireframe](docs/wireframe.png) · [KPI](docs/indicadores.md) · [validaciones](docs/validaciones.md) · [hallazgos](docs/hallazgos.md).

## Estructura
```
backend/app/        config.py · analytics.py (SQL) · main.py (API)
frontend/           index.html · styles.css · app.js
database/           datos.sql (respaldo de los escenarios) · validaciones.sql
scripts/validar.py  validación automática contra SQL independiente
docs/               diseno · indicadores · validaciones · hallazgos · wireframe
screenshots/        capturas del dashboard
docker-compose.yml · Dockerfile · .env.example
```

## Instalación y ejecución

### 0. Requisitos
Python 3.10+, Docker Desktop y Git. No hace falta instalar PostgreSQL: se usa en Docker.

### 1. Base de datos
**Opción A — Reutilizar la base del reto ETL** (si ya tiene el contenedor `reto_etl_pg` con la tabla `decision_libros`):
```powershell
docker start reto_etl_pg
```
**Opción B — Base nueva con el respaldo del repositorio** (`database/datos.sql`):
```powershell
docker compose up -d db        # PostgreSQL en localhost:5433, carga database/datos.sql
```
Para **generar** `database/datos.sql` desde su base del ETL (una sola vez):
```powershell
docker exec reto_etl_pg pg_dump -U reto -d retoetl --table=decision_libros --no-owner --clean --if-exists -f /tmp/datos.sql
docker cp reto_etl_pg:/tmp/datos.sql database/datos.sql
```
Si prefiere recrear los datos desde cero, ejecute el notebook del [reto ETL](https://github.com/Andreino92/reto-etl-libros): carga `decision_libros` con los tres escenarios (`base`, `esc_cambia_decision`, `esc_duplicado`).

### 2. Configuración
```powershell
copy .env.example .env
```
Edite `.env` si hace falta: `DATABASE_URL` (puerto 5432 con la Opción A, 5433 con la B) y los umbrales **originales** del ETL (`ORIG_MIN_ESTRELLAS`, `ORIG_MIN_EDICIONES`, `ORIG_TOP_K`; por defecto 3, 5 y 10). No suba `.env` a GitHub.

### 3. Ejecutar la API y el dashboard
```powershell
python -m venv .venv
.venv\Scripts\activate
pip install -r backend\requirements.txt
cd backend
uvicorn app.main:app --reload --port 8000
```
Abra **http://localhost:8000**. (El navegador necesita internet para cargar ECharts desde el CDN.)

### 4. Todo con Docker (base + API)
```powershell
docker compose up -d --build   # http://localhost:8000  (requiere database/datos.sql)
```

### 5. Validar
```powershell
python scripts\validar.py      # con la API en marcha; genera docs\validaciones_resultado.md
```
Ver [docs/validaciones.md](docs/validaciones.md).

## Endpoints
`GET /api/meta` · `GET /api/analisis` · `GET /api/comparacion` · `GET /api/libro/{upc}` · `GET /api/validacion` · `POST /api/refrescar` · `GET /api/salud` (documentación interactiva en `/docs`).

## Capturas
Guarde sus capturas en `screenshots/` y enlácelas aquí:
`screenshots/01-vista-general.png` · `02-simulador.png` · `03-comparacion-escenarios.png` · `04-detalle.png`

## Limitaciones
Sin dimensión temporal (no hay tendencias); unión entre fuentes por título normalizado; 58 de 100 libros sin coincidencia en Open Library; precios ficticios. Ver [hallazgos](docs/hallazgos.md).
