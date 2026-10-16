# Verificación local de paquete — 2026-10-16

Rama `audit/0.2.0-precran`, versión `0.1.6.9000`, Windows 11,
R 4.6.1. No se cambió la versión ni se publicó el paquete.

## Hallazgo de empaquetado

Estado: confirmado, implementado y probado.

El archivo fuente inicial contenía `AGENTS.md`,
`audit-risk-coverage.md` y `audit-multilife-monte-carlo.md`.
Una aserción que exigía su ausencia falló sobre ese archivo.
R CMD check también señaló esos archivos de nivel superior.

Corrección mínima: añadir a `.Rbuildignore` las reglas
`^AGENTS[.]md$` y `^audit-.*[.]md$`. No se modificó código actuarial
en este paso. La exclusión se registró en NEWS.

Después de reconstruir, la aserción de ausencia pasa. También se comprobó
que los cuatro archivos nuevos de regresiones de inmunización, riesgo,
reservas por estados y consistencia de vidas siguen dentro del paquete.
Los documentos de auditoría permanecen disponibles en el repositorio.

## Resultado del chequeo final

Comandos principales:

```
R CMD build --no-manual tidyactuarial
R CMD check --as-cran --no-manual tidyactuarial_0.1.6.9000.tar.gz
```

Resultado: **0 ERROR, 0 WARNING, 1 NOTE**, salida 0.
La única NOTE corresponde al componente de desarrollo de la versión:
`Version contains large components (0.1.6.9000)`.

Pasaron instalación, carga y descarga del paquete y namespace, dependencias,
sintaxis, análisis del código R, registro y consistencia S3, documentación
Rd, correspondencia código/documentación, datos, ejemplos, pruebas del
paquete instalado y construcción/reconstrucción de las cuatro viñetas.

El archivo final ya no produce la NOTE de archivos internos.
Pandoc se hizo accesible tanto a rmarkdown como a R CMD check mediante
RSTUDIO_PANDOC y PATH, usando la instalación local de RStudio.

## Alcance y condiciones del entorno

El aislamiento de Windows devolvía `file.access(...,4)=-1` para archivos
de dependencias que sí podían leerse. Los resultados válidos anteriores
proceden de la ejecución fuera del aislamiento, con la biblioteca de
dependencias existente; no se modificaron ni instalaron dependencias.
La copia de dependencias usada para diagnosticar el problema se eliminó.

El chequeo se ejecutó con `_R_CHECK_CRAN_INCOMING_REMOTE_=false`:
no equivale a la revisión remota de recepción de CRAN.

Se comprobó aparte la compilación PDF con:

```
R CMD Rd2pdf --quiet --no-preview --no-index --force \
  --output=tidyactuarial-manual-no-index.pdf tidyactuarial
```

Salida 0. La compilación con índice no pudo completarse porque TinyTeX
no tiene `makeindex`. Por tanto, no se declara validado el manual con
índice ni se presenta como ejecutada la fase de manual de R CMD check.

## Evidencia y pendientes

Los artefactos están en:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a1466f-8f29-7903-ba68-1548e4e4b63e/precran-final/`.

Informe: `tidyactuarial.Rcheck/00check.log`.
Archivo fuente: `tidyactuarial_0.1.6.9000.tar.gz`.
SHA256: `4FD348015B17F6B656FF0B9FCD7A6CE636C649A075522346ABE90D9C81A7DD18`.

Revisión estática de CI: R-CMD-check configura R release en Ubuntu,
Windows y macOS. Los workflows no se modificaron ni ejecutaron remotamente.
Este resultado local no sustituye esa matriz ni una prueba en R 4.1.

Antes de una publicación quedan por resolver la compilación del índice,
las comprobaciones remotas y la conciliación con el informe externo
original. El cambio de versión y el envío a CRAN requieren autorización
explícita. Los cambios de la auditoría continúan locales, sin commit.

## Revalidación tras la revisión adicional

Después de corregir el origen de los calendarios diferidos y el
adelgazamiento binomial negativo/geométrico, se repitieron construcción,
R CMD check y compilación del manual sin índice. Resultado nuevamente:
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. La NOTE sigue siendo únicamente
la versión de desarrollo. Pasaron ejemplos, suite instalada y reconstrucción
de viñetas. Las 14 comprobaciones nuevas también pasan en la suite local.

Esta verificación más reciente corresponde a los artefactos de
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a1466f-8f29-7903-ba68-1548e4e4b63e/precran-followup/`.
El archivo de la sección anterior se conserva como evidencia histórica.

SHA256 del archivo fuente más reciente:
`2A246DFEBDA17E78604FCC99553FDCFE1F9F16FE4B858768D0E729BA47B5F4FA`.
Las limitaciones sobre índice PDF, revisión remota y matriz de CI permanecen.

## Revalidación del seguro diferido

Tras corregir el condicionamiento de `insurance_xy()` desde las edades de
emisión, la suite completa pasó y se repitieron construcción y check del
paquete instalado. Resultado: **0 ERROR, 0 WARNING, 1 NOTE**, salida 0.
La NOTE corresponde a la versión de desarrollo. Ejemplos, pruebas,
documentación y reconstrucción de viñetas OK.

La evidencia nueva y el incidente regional del primer intento están en
`audit-deferred-insurance.md`. Artefactos en
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-deferred/`;
informe válido en `locale-C/tidyactuarial.Rcheck/00check.log`.
SHA256 del archivo fuente:
`0F919EC62F8F381AF83CD1E44827A4D1A09A4076AA0DCF5D8A6948C24F59042F`.

La matriz ahora incluye R 4.1.0 exacto como configuración local preparada
(commit `a235fbf`), sin ejecución remota. Permanecen pendientes la ejecución
de CI, el manual con índice, las comprobaciones remotas de recepción y la
conciliación del informe externo. No se cambió la versión ni se publicó.

## CI remota aprobada

Tras autorización explícita del usuario se publicó la rama de auditoría.
La ejecución `38972898289` aprobó sus cuatro jobs sobre `d57e56b`: Ubuntu,
Windows y macOS ARM64 con R 4.6.1, y Ubuntu con R 4.1.0 exacto.
Cada log termina con `Status: OK`. Evidencia, enlaces y alcance detallados
en `audit-ci-minimum-r.md`.

Quedan resueltas la ejecución de esta matriz y la prueba del R mínimo en
Ubuntu. Siguen pendientes el manual con índice, la revisión remota de
recepción de CRAN y la conciliación con el informe externo original.
No se hizo merge, cambio de versión ni envío a CRAN.
