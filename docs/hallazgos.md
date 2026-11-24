# Hallazgos analíticos y recomendación

> Las cifras salen de la ejecución real del ETL (umbrales finales: ≥ 3 estrellas, ≥ 5 ediciones, top 10) y deben **verificarse en el dashboard** antes de entregar (escenario y filtros indicados en cada punto). Si sus números difieren, actualice este archivo con los suyos.

## Hallazgo 1 · Más de la mitad del catálogo no puede evaluarse
- **Situación:** 58 de 100 libros no tienen coincidencia en Open Library, así que no se puede medir su trayectoria editorial.
- **Sustento:** KPI «Entidades evaluadas» (100) y el aviso «58 libros no tienen datos en Open Library»; en la tabla, motivo «Sin datos en Open Library».
- **Escenario y filtros:** Base, sin filtros, umbrales 3★ / 5 ediciones / top 10.
- **Limitaciones:** la unión es por título normalizado (el portal no trae ISBN); parte de esos 58 podría existir en Open Library con otro título o edición. La coincidencia ausente no significa que el libro sea malo.

## Hallazgo 2 · La lista es muy sensible al umbral de ediciones y estrellas
- **Situación:** con los umbrales iniciales (4★ y 10 ediciones) solo 7 libros eran candidatos; al relajarlos a 3★ y 5 ediciones, subieron a 16 de 100 (cumplimiento 16 %).
- **Sustento:** KPI «Candidatos» y «Cumplimiento» al mover los sliders del simulador; panel «Entran / Salen».
- **Escenario y filtros:** Base, sin filtros; simulador con 4★/10 ed. frente a 3★/5 ed.
- **Limitaciones:** con 7 candidatos no se podía llenar una lista de 10. Los umbrales son una decisión de negocio, no un resultado estadístico.

## Hallazgo 3 · El precio puede desplazar a un libro del primer lugar; un duplicado no cambia nada
- **Situación:** al subir el precio de «Patience» (prioridad 1; 57 ediciones a £10.16 → 5.61 ediciones/£), su indicador cae por debajo del de «This One Summer» y sale de la lista, mientras que duplicar «Set Me Free» (indicador 0.859107, prioridad 3) no altera la decisión porque la limpieza lo elimina por UPC.
- **Sustento:** sección «Comparación de escenarios»: tarjeta «Cambio que altera la decisión» (entra/sale, dato editado) y «Cambio que conserva la decisión» (0 filas con diferencias).
- **Escenario y filtros:** Base, Cambio y Conservación, umbrales originales.
- **Limitaciones:** los escenarios son variantes independientes de los datos, no períodos; no deben sumarse. La causa del cambio es el precio editado (se controla el experimento), no una relación observada en datos reales.

## Acción recomendada
**Comprar los 10 libros de la lista del escenario Base** (costo total £292.14, encabezada por «Patience»), **después de confirmar el precio vigente con el proveedor** para los 3 primeros puestos, porque una variación de precio puede cambiar el orden y la lista. Quién: la coordinación de adquisiciones, con apoyo de finanzas para validar el presupuesto. Evidencia: KPI de la selección y tabla de detalle (Base), y la comparación con el escenario «Cambio». Además, **revisar manualmente los libros sin datos en Open Library** (hallazgo 1) antes de descartarlos. Esta recomendación se basa en un análisis descriptivo: no implica causalidad entre calificación, ediciones y demanda real de los lectores.
