# Auditoría inicial 0.2.1 — 6 de noviembre de 2026

Checkout de partida limpio: `audit/0.2.0-precran` en `92c2980`.
Consultados y descargados los refs oficiales: `origin/master` `2466fc1`
(0.2.0), `origin/develop` `4d4e4ba` (0.2.0.9000). Comparación
master...develop: 10/2 commits; diferencia de árboles: DESCRIPTION y
README. Frente a la candidata 607657e, master no cambia R, man, data,
tests ni viñetas; conserva README y AGENTS actualizados. Base recomendada:
origin/master; los tres commits multivida quedan intactos en su rama de
auditoría para que este PR no mezcle cambios de cálculo.

## Inventario reproducido con R 4.6.1

Paquete instalado 0.2.0: los ocho objetos son idénticos a los archivos
locales. Se cotejó que el árbol remoto master tiene esos mismos .rda.

| Objeto existente | Filas × columnas | Bytes |
|---|---:|---:|
| mortality_colombia_tables | 723 × 12 | 16716 |
| mortality_world_sample_2023 | 3939 × 13 | 130992 |
| mortality_world_sample_2015_2023 | 35451 × 14 | 1113120 |
| soa08lt | 141 × 5 | 4260 |
| multiple_decrement_sample | 7 × 6 | 544 |
| bonds_sample | 5 × 8 | 416 |
| cash_flows_sample | 19 × 5 | 528 |
| loans_sample | 4 × 7 | 392 |

Total data/: 1266968 bytes. Tarball público CRAN 0.2.0: 2042905 bytes,
SHA256 ED9AF3E23FE03C42A85E22AA63090DFEB5D17BABF22BD5F1F10A240E5B411539.
R mínimo 4.1.0; Imports dplyr, ggplot2, rlang, scales, stats, tibble,
utils; Suggests knitr, purrr, rmarkdown, testthat. MASS es candidato
solo como dependencia sugerida para una viñeta opcional.

Sin colisión para `mortality_regions`. La muestra 2023 replica el corte
2023 del panel instalado: se conservan ambas por compatibilidad.
Las seis tablas colombianas incluyen asegurados, BEPS, RV08, RV89 y
mortalidad de inválidos; no se ha certificado un cotejo celda por celda
con cada resolución. Los cinco códigos fuente se contrastaron con el
índice normativo SFC; un código común no convierte mortalidad de inválidos
en incidencia. `bonds_sample` es una muestra pedagógica, no un corte TES.
`soa08lt` está presente y documentada; su script referenciado no está
en la rama. Hay dos archivos de roxygen de muestras idénticos; documentar
sin introducir duplicación adicional.

`md_table()` con las tres causas explícitas y `close=FALSE` devuelve
7 edades, q_total inicial .098, final .082; error de suma máximo 1.4e-17.
El cierre por defecto rechaza correctamente la muestra abierta. No se
modifica ni se usan marginales DANE como qx.

Detalle colombiano: 11 combinaciones tabla/sexo. Cinco tienen huecos
de edades: Asegurados 1984–1988 unisex, mortalidad de inválidos 1980–1989
en ambos sexos y RV89 en ambos sexos. Las dos tablas de inválidos tienen
12 y 4 observaciones, con qx final 0,2621951 y 0,5. No tratarlas como
tablas anuales completas ni imputar las edades faltantes. El mayor
`abs(qx_diff)` almacenado es 0,00692308 (BEPS hombres); requiere cotejo
con el anexo, no una sustitución automática. `soa08lt` llega a edad
140 con qx terminal de 1; no se alteró.

## Insumos y criterios verificables

Validador del kit sin red: correcto; 46 checksums del kit y 26 del
inventario anidado cotejados. El ZIP no contiene originales WPP/TES/SFC.
Se descargaron tres originales WPP desde la ONU para analizar 2023.
El filtro histórico por nombre regional solo selecciona 97 áreas por
sexo, no 95: dos nombres también identifican agregados SDG. Se exigirá
clave oficial, nivel y sexo; 67 países + 28 agregados, 101 filas por
tabla, edad 100+ explícita y comparación numérica con los originales.
No se importan otras bases sin resolver derechos, fuente y semántica.

## Selección final y compatibilidad

Solo se añade mortality_regions (2023), una viñeta que refiere a
MASS::Melanoma y MASS en Suggests; ningún motor de cálculo cambia.
El ejemplo de incidencia acumulada suma supervivencia más ambas causas
a uno con residuo máximo 2,22e-16 en los 205 pacientes. No se incluyen
registros clínicos. Los artefactos SFC/TES se conservan fuera de Git.
Las bases no incluidas y motivos puntuales constan en DATASETS_021_PENDIENTES.md.

## Validación de la candidata

Los 259.065 valores numéricos seleccionados coinciden exactamente con
los originales y con el objeto del tarball. Data/ crece de 1.266.968
a 2.318.656 bytes; el objeto nuevo xz pesa 1.051.688 bytes. El tarball
0.2.1 pesa 3.022.754 bytes (CRAN 0.2.0: 2.042.905). Se cotejaron 421
archivos con el checkout. Los ocho .rda anteriores se conservaron.

Las suites fuente e instalada pasan 7476 comprobaciones cada una,
sin fallos/advertencias/omisiones. devtools::check ejecutó build y
R CMD check --as-cran --no-manual con Status: OK (0 ERROR, WARNING, NOTE).
Ejemplos y cinco viñetas pasan. Huella y entorno en cran-comments.md.
