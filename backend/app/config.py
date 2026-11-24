"""Configuración de la aplicación. Todo se lee de variables de entorno (o de un archivo .env).
Las credenciales viven solo en el servidor: el frontend nunca las ve."""
import os
from pathlib import Path

from dotenv import load_dotenv

load_dotenv()  # lee .env si existe (en el directorio de trabajo o en el repositorio)
load_dotenv(Path(__file__).resolve().parents[2] / ".env")


def database_url() -> str:
    url = os.getenv("DATABASE_URL")
    if url:
        return url
    return "postgresql+psycopg2://{u}:{p}@{h}:{port}/{d}".format(
        u=os.getenv("PGUSER", "reto"),
        p=os.getenv("PGPASSWORD", "reto"),
        h=os.getenv("PGHOST", "localhost"),
        port=os.getenv("PGPORT", "5432"),
        d=os.getenv("PGDATABASE", "retoetl"),
    )


# Umbrales ORIGINALES de la regla de decisión usados en el ETL. Deben coincidir con los del notebook.
ORIGINAL = {
    "min_estrellas": int(os.getenv("ORIG_MIN_ESTRELLAS", 3)),
    "min_ediciones": int(os.getenv("ORIG_MIN_EDICIONES", 5)),
    "top_k": int(os.getenv("ORIG_TOP_K", 10)),
}

# Escenarios generados por el reto ETL (valor de la columna `escenario`).
ESCENARIOS = [
    {"id": "base", "nombre": "Base", "corto": "Base",
     "descripcion": "Fuentes originales y regla de decisión inicial."},
    {"id": "esc_cambia_decision", "nombre": "Cambio que altera la decisión", "corto": "Cambio",
     "descripcion": "Se editó un dato de entrada (el precio de un libro) en el HTML local."},
    {"id": "esc_duplicado", "nombre": "Cambio que conserva la decisión", "corto": "Conservación",
     "descripcion": "Se duplicó un registro real en el HTML local; la limpieza lo elimina."},
]
ESC_IDS = [e["id"] for e in ESCENARIOS]

FRONTEND_DIR = Path(os.getenv("FRONTEND_DIR", Path(__file__).resolve().parents[2] / "frontend"))
