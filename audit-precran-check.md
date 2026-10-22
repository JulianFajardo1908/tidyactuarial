# Verificación local de paquete — 2026-10-16

## Última validación: B08-01 — 22 de octubre de 2026

Base c7a0d29, rama audit/0.2.0-precran, versión 0.1.6.9000. Por indicación
del usuario se inicia B08, dejando explícitamente pendiente el suplemento
B05 t_px/e_x. Se corrigen CML/Balducci con p positivo pequeño, exposición
lx según radix, decrementos y validación/coerción de ambos generadores.
Sin cambios de firma/columnas, dependencias ni nueva decisión C.

94 comprobaciones nuevas aprobadas. Contra base: nueve fallos, cinco errores,
dos advertencias y 35 aprobadas; los errores originales abortan algunos
bloques y no se cuentan sus aserciones no ejecutadas como aprobadas.
78 objetos ordinarios completos concuerdan a 1e-12 y dos firmas idénticas.
Roxygen2 regenerado y diff --check aprobado. Suite fuente definitiva:
**6250 aprobadas, 0 fallos, 0 advertencias, 0 omisiones**.
Suite instalada: **6250 aprobadas, 0 fallos/advertencias/omisiones** (75 s).
Build --no-manual y check --as-cran --no-manual: salida 0, **0 ERROR,
0 WARNING, 1 NOTE**, exclusivamente por versión de desarrollo. Ejemplos
(23 s), cuatro viñetas y reconstrucción (12 s) aprobados. Informes build.log,
check.log, tidyactuarial.Rcheck/00check.log y tests/testthat.Rout.
snapshot-verification.txt comprueba 392 archivos R/tests/man/NEWS/NAMESPACE
y campos originales DESCRIPTION iguales al checkout normalizando CRLF y
el reformato de espacios de build; audit/AGENTS excluidos. SHA256:
2A1B0AC9A179ED64E5B8387FA3F5A0FD25D4AACAE3FFC75B1205E5551D183570.
Inventario comprobado: 102 nombres, 974 apariciones de parámetros y cero
descripciones Rd ausentes/vacías. B08-01 cerrado en su alcance puntual.

Artefactos: C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b08-01/.
final-tests.log es la suite fuente; before-final.log/compatibility.R contienen
la regresión definitiva y compatibilidad. before.log/after.log conservan la
primera versión de 73 comprobaciones; after-final.log es la regresión final
de 94. next-status-diagnosis.log confirma la discrepancia pendiente del
borde T=K+1 entre mc_multilife_status y mc_insurance; no corregida aquí.
El usuario autorizó C17 durante la validación, para la siguiente unidad;
el archivo fuente B08-01 aún no contiene esa modificación.

Entorno: Windows/R 4.6.1, biblioteca de usuario existente, locale C y Pandoc
de RStudio. Build/check fuera del aislamiento con recepción remota CRAN
desactivada; sin nueva CI, prueba de R mínimo, manual/PDF, versión o push.
B08 permanece abierto; evidencia y límites en audit-monte-carlo-review.md.

## Última validación: B07-06 — 21 de octubre de 2026

Base 4b0948e, rama audit/0.2.0-precran, versión 0.1.6.9000. Supervivencia
fraccionaria lx/log y esperanza multivida por áreas anuales analíticas.
Conciliación de seis nombres sin cambiar firmas, columnas, estados ni
convenciones públicas de horizonte/cero/NA. Fórmulas y límites en
audit-multilife-contingencies.md B07-06; sin nueva decisión C.

189 comprobaciones nuevas. Regresión definitiva contra base: 74 fallos,
cero errores/advertencias y 115 aprobadas. 138 resultados ordinarios
completos a tolerancia 1e-12 y seis firmas idénticas. Inventario verificado:
102 nombres públicos, 974 apariciones de parámetros, cero descripciones
Rd ausentes/vacías. Suite fuente definitiva: **6156 aprobadas, 0 fallos,
0 advertencias, 0 omisiones**. Roxygen2 regenerado y diff --check aprobado.
Suite instalada: **6156 aprobadas, 0 fallos/advertencias/omisiones** (72 s).
Build --no-manual y check --as-cran --no-manual finales: salida 0,
**0 ERROR, 0 WARNING, 1 NOTE**, exclusivamente por versión de desarrollo.
Ejemplos (24 s), cuatro viñetas y reconstrucción (10 s) aprobados.
Informes build.log, check.log, tidyactuarial.Rcheck/00check.log y
tests/testthat.Rout dentro del check. B07-06 y B07 cerrados dentro del
alcance/límites de los seis nombres documentados; suplemento B05 pendiente.

Artefactos: C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b07-06/.
final-tests.log es la suite fuente definitiva; before-final.log contiene
la regresión final y compatibilidad, inventory.log el inventario. El log
initial-ledger-timing-tests.log es intermedio: una aserción del nuevo libro
omitió timing="due" (annuity_xy tiene default immediate). El test definitivo
explicita due; no se cambió ese default para forzar la identidad.

snapshot-verification.txt acredita 391 archivos R/tests/man/NEWS/NAMESPACE
y campos originales DESCRIPTION iguales al checkout normalizando CRLF y
espacios de build en DESCRIPTION. Nueva regresión incluida, AGENTS/audit-*
excluidos. SHA256 del archivo fuente:
4D4B2C7904867CE6AF02714D95748F4F68E872702B29DF03E37FBAB6C400C696.

Entorno: Windows/R 4.6.1 y biblioteca de usuario existente; locale C,
Pandoc de RStudio, build/check fuera del aislamiento y recepción remota
CRAN desactivada. Sin dependencias nuevas, CI remota, prueba de R mínimo,
manual/PDF, cambio de versión o push. El defecto específico confirmado en
t_px/e_x se registra como suplemento B05 pendiente, no como corregido ni
como límite aceptado; single-life-followup.log verifica ambos fallos.

## Última validación: B07-05 — 21 de octubre de 2026

Base c126ccb, rama audit/0.2.0-precran, versión 0.1.6.9000. Dotal puro
directo, primas fraccionarias y reservas prospectivas/recursivas; C16
autorizada e implementada. Fórmulas, condicionamiento, límites y evidencia
en audit-multilife-contingencies.md. No se declara cerrado todo B07.

142 comprobaciones nuevas aprobadas. Contra base, el archivo final produce
33 fallos, tres errores y una advertencia, con 99 aprobadas; los errores
originales abortan algunos bloques antes de completar sus aserciones.
136 resultados ordinarios completos a tolerancia 1e-12, dos firmas idénticas.
Los probes domain-before.log comprueban además tablas incompatibles que antes
devolvían 100 en t terminal y ahora se rechazan. Roxygen2 y diff --check
aprobados. Suite fuente e instalada: **5967 aprobadas, 0 fallos,
0 advertencias, 0 omisiones**; instalada 72 s.

Build --no-manual y check --as-cran --no-manual definitivos: salida 0,
**0 ERROR, 0 WARNING, 1 NOTE**, exclusivamente por versión de desarrollo.
Ejemplos (24 s), cuatro viñetas y reconstrucción (11 s) aprobados.
Artefactos: C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b07-05/.
Informes build.log, check.log, tidyactuarial.Rcheck/00check.log y
tidyactuarial.Rcheck/tests/testthat.Rout. final-tests.log es la suite fuente
definitiva; before-final.log incluye regresión y compatibilidad con c126ccb.

initial-tests.log (5965), initial-build.log y draft-before-zero-premium.tar.gz
se conservan como evidencia intermedia ANTERIOR al fix adicional P=0; no
sustituyen la validación final. zero-premium-before.log reproduce ese error.
Se reconstruyó el archivo y se repitió la suite completa al añadir el fix.
No se sobrescribieron artefactos de unidades anteriores.

snapshot-verification.txt acredita 390 archivos R/tests/Rd/NEWS/NAMESPACE y
campos originales DESCRIPTION iguales al checkout normalizando CRLF y el
reformato de espacios de build en DESCRIPTION. Regresión nueva incluida,
AGENTS/audit-* excluidos. SHA256 del archivo fuente definitivo:
28A86B568E19AF2B065E304B26EF00CD87E75610341FA1C0F966EB85294B1B6A.

Entorno: Windows/R 4.6.1, R_LIBS_USER 4.6 existente, LC_ALL/LC_CTYPE/LANG=C,
Pandoc de RStudio, build/check fuera del aislamiento y
_R_CHECK_CRAN_INCOMING_REMOTE_=false. Sin dependencias nuevas, CI remota,
prueba actual de R mínimo, manual/PDF, versión o push. B07-05 cerrado en
su alcance; siguen conciliación integral B07, precisión propia t_pxy/e_xy y
límites de equivalencia/estados condicionales fuera del rango double.

## Última validación: B07-04 — 21 de octubre de 2026

Base 61fa813, rama audit/0.2.0-precran, versión 0.1.6.9000. Anualidades
fraccionarias y reversiones designadas, precisión monetaria, tablas/grillas
y Woolhouse: audit-multilife-contingencies.md. C15 autorizada expresamente
antes de implementar; firma/esquema preservados, sin extender C12/C13.

95 comprobaciones nuevas aprobadas, más probe independiente NaN->0 para
cohorte extinguida y descuento desbordado. Contra base, el archivo final
produce 10 fallos, dos errores y 78 aprobadas; los dos errores abortan los
bloques originales antes de agotar sus aserciones. 72 objetos tidy ordinarios
completos concuerdan a 1e-12 y firma idéntica. Roxygen2 y diff --check aprobados.
Suite fuente e instalada: **5825 aprobadas, 0 fallos, 0 advertencias,
0 omisiones**; instalada 145 s. Se reutilizan las conexiones B07-03.

Build --no-manual y check --as-cran --no-manual: salida 0, **0 ERROR,
0 WARNING, 1 NOTE**, exclusivamente por versión de desarrollo. Ejemplos
(44 s), cuatro viñetas y reconstrucción (19 s) aprobados. Artefactos nuevos:
C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b07-04/.
Informes build.log, check.log, tidyactuarial.Rcheck/00check.log y tests/testthat.Rout
dentro del check. final-tests.log es la suite fuente; before-final.log contiene
regresión/compatibilidad con base y probes adicionales. zero-discount-probe.log
verifica con aserciones NaN original/cero corregido. before.log conserva el
archivo inicial de reproducción. No se sobrescriben artefactos anteriores.

snapshot-verification.txt acredita 389 archivos R/tests/Rd/NEWS/NAMESPACE y
campos originales de DESCRIPTION iguales al checkout normalizando CRLF y
reformato de espacios de build en DESCRIPTION. Helper y regresión incluidos,
AGENTS/audit-* excluidos. SHA256 del archivo fuente:
43D3C802D523E5984214BA947C67E9771E36BC82651DFF1A5B54223C741F63B3.

Entorno: Windows/R 4.6.1, R_LIBS_USER 4.6 existente, LC_ALL/LC_CTYPE/LANG=C,
Pandoc de RStudio, build/check fuera del aislamiento y
_R_CHECK_CRAN_INCOMING_REMOTE_=false. Sin nuevas dependencias, CI remota,
prueba actual de R mínimo, manual/PDF, versión o push. B07-04 cerrado dentro
de los límites documentados: truncación histórica de marginales abiertas
preservada y explícita, no inferencia de muerte ni máxima generalidad.
B07 sigue abierto. Next-premium-diagnosis.log confirma un dotal puro perdido
por diferencia en premium_xy; pendiente de B07-05, no corregido ni cerrado aquí.

## Última validación: B07-03 — 21 de octubre de 2026

Base 161cc3b, rama audit/0.2.0-precran, versión 0.1.6.9000. Seguro por masas
disjuntas de estados y relaciones con anualidades/reversionarias, primas y
reservas: audit-multilife-contingencies.md. C13/C14 autorizadas expresamente
por el usuario e implementadas sin ampliar firmas ni añadir tipos.

188 comprobaciones nuevas, todas aprobadas: 142 en test-b07-insurance-states.R
y 46 en test-b07-linked-valuations.R. Contra la base, el archivo definitivo
del seguro reproduce 17 fallos y 125 aprobadas, sin errores. 36 resultados
tidy ordinarios completos concuerdan a tolerancia 1e-12 y firma idéntica.
Roxygen2 regenerado, git diff --check aprobado. Suite fuente e instalada:
**5730 aprobadas, 0 fallos, 0 advertencias, 0 omisiones**; instalada 142 s.

Build --no-manual y check --as-cran --no-manual: salida 0, **0 ERROR,
0 WARNING, 1 NOTE**, exclusivamente por versión de desarrollo. Ejemplos
(41 s), cuatro viñetas y reconstrucción (20 s) aprobados. Artefactos nuevos:
C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b07-03/.
Informes: build.log, check.log, tidyactuarial.Rcheck/00check.log y
tidyactuarial.Rcheck/tests/testthat.Rout. before.log conserva la reproducción
inicial; before-final.log contiene la comparación final con 161cc3b, incluida
la conciliación de 36 resultados; final-tests.log es la suite fuente.

snapshot-verification.txt acredita 387 archivos R/tests/Rd/NEWS/NAMESPACE y
campos originales de DESCRIPTION iguales al checkout, normalizando CRLF y
reformato de espacios de build en DESCRIPTION. Helper y dos regresiones
nuevos incluidos, AGENTS/audit-* excluidos. SHA256 del archivo fuente:
6EBCE0FE44F7963C43C843F3C03395E44F145A30CAD433C4A29D85F2D63FF777.

Entorno: Windows/R 4.6.1, R_LIBS_USER 4.6 existente, LC_ALL/LC_CTYPE/LANG=C,
Pandoc de RStudio y _R_CHECK_CRAN_INCOMING_REMOTE_=false. Build/check fuera
del aislamiento para acceder al directorio padre y biblioteca existentes.
Sin instalar dependencias, nueva CI remota, prueba actual de R mínimo,
manual/PDF, cambio de versión o push. B07-03 cerrado dentro del alcance
documentado; B07 sigue abierto. Continúa annuity_xy (estados/reversiones,
pagos, Woolhouse y extremos), después premium_xy y reserve_xy; no confundir
comprobaciones cruzadas ordinarias con cierre integral de esos consumidores.

## Última validación: B07-02 — 21 de octubre de 2026

Base 6969b2d, rama audit/0.2.0-precran, versión 0.1.6.9000. Dominio anual
y controles t_pxy/e_xy; ver audit-multilife-contingencies.md. Se preservan
las correcciones anteriores; no se declara cerrado el bloque B07.

62 comprobaciones nuevas aprobadas; antes 33 fallos, un error en el bloque
de controles y cuatro advertencias. 48 objetos ordinarios completos y dos
firmas idénticos a la base. Roxygen2 regenerado y diff --check aprobado.
Suite fuente e instalada: **5542 aprobadas, 0 fallos, 0 advertencias,
0 omisiones**. Pruebas instaladas: 71 s. Build --no-manual y
check --as-cran --no-manual: salida 0, **0 ERROR, 0 WARNING, 1 NOTE**,
exclusivamente por versión de desarrollo. Ejemplos (25 s), cuatro viñetas
y reconstrucción (13 s) aprobados. Una pausa prolongada del entorno durante
la descarga del paquete figura como 41m en el log; esa fase aprobó y no se
usa ese tiempo como referencia de rendimiento del código.

Artefactos nuevos, preservando B07-01:
C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b07-02/.
Informes build.log, check.log, tidyactuarial.Rcheck/00check.log y
tidyactuarial.Rcheck/tests/testthat.Rout. Evidencia fuente previa/corregida
en b07-02-before.log, b07-02-diagnosis.log y b07-02-final-tests.log del
directorio padre. compatibility.log compara los 48 resultados ordinarios.

snapshot-verification.txt acredita 384 archivos R/tests/Rd/NEWS/NAMESPACE y
campos originales de DESCRIPTION iguales al checkout normalizando CRLF y
reformato de espacios de build en DESCRIPTION. Helper y regresión incluidos,
AGENTS/audit-* excluidos. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
FEF9866618ACB115C6ED5BA6FB9DAA024BF45971A7E7AB611C422569D2020E4F.

Entorno: R 4.6.1/Windows, R_LIBS_USER 4.6 existente, LC_ALL/LC_CTYPE/LANG=C,
Pandoc de RStudio, build/check fuera del aislamiento para acceso a biblioteca
y directorio padre, _R_CHECK_CRAN_INCOMING_REMOTE_=false. Sin instalar
dependencias, nueva CI remota, prueba actual de R mínimo, manual/PDF, versión
nueva o push. B07-02 cerrado para dominio/controles; siguen precisión extrema
y revisión integral de anualidades, seguros, primas y reservas multivida.

## Última validación: B07-01 — 21 de octubre de 2026

Base 11eeb49, rama audit/0.2.0-precran, DESCRIPTION 0.1.6.9000.
Herencia CML corregida en t_pxy/e_xy; ver audit-multilife-contingencies.md.
26 comprobaciones nuevas, 15 fallos reproducidos contra la base; 48 objetos
ordinarios completos y dos firmas idénticos. Roxygen2 regenerado, diff limpio.
Suite fuente: 5480 aprobadas, 0 fallos/advertencias/omisiones.

Artefactos de esta unidad:
C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/.
Build --no-manual y check --as-cran --no-manual: salida 0, **0 ERROR,
0 WARNING, 1 NOTE**, exclusivamente por versión de desarrollo.
Suite instalada: 5480 aprobadas, 0 fallos/advertencias/omisiones (80 s).
Ejemplos (26 s), cuatro viñetas y reconstrucción (20 s) aprobados.
Informes: build-b07-final.log, check-b07.log,
tidyactuarial.Rcheck/00check.log y tests/testthat.Rout dentro del check.

snapshot-verification.txt verifica 382 archivos R/tests/Rd/NEWS/NAMESPACE y
DESCRIPTION contra checkout: normaliza CRLF y permite en DESCRIPTION solo
reformato de espacios y campos añadidos por build. Regresión nueva incluida,
AGENTS/audit-* excluidos. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
F29FCA3547F5F58250E28E11DA60A6A1A1CF3F1E6CE201EB5C9AB441ABFE98C2.

Entorno: Windows, R 4.6.1, bibliotecas existentes R_LIBS_USER 4.6,
LC_ALL/LC_CTYPE/LANG=C, Pandoc de RStudio y
_R_CHECK_CRAN_INCOMING_REMOTE_=false. El primer build aislado falló al
acceder al directorio padre (build-b07.log); la repetición autorizada fuera
del aislamiento y el check definitivo aprobaron. Sin nuevas dependencias,
CI remota, prueba actual de R mínimo, manual/PDF, cambio de versión o push.
B07-01 cerrado solo para herencia CML; B07 y la revisión integral de estas
dos funciones siguen abiertos. Continúa dominio, bordes y precisión.

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

## Manual con índice compilado

Se resolvió la falta de makeindex en TinyTeX y `R CMD Rd2pdf` compiló
con índice, salida 0. El PDF entregable tiene 232 páginas y su índice
ocupa las páginas 229–232; 1197 entradas aceptadas, ninguna rechazada.
Los ajustes locales de presentación y las verificaciones se describen
en `audit-manual-index.md`. No cambió el código del paquete ni sus Rd.

La antigua limitación sobre makeindex queda resuelta. No se repitió
R CMD check con la fase del manual habilitada: esta evidencia corresponde
a la compilación independiente del manual. Siguen pendientes la revisión
remota de recepción y la conciliación del informe externo.

## Revalidación de productos, Newton y gráfica financiera

Tras las correcciones B02-04 a B02-06 se ejecutaron suite local completa,
construcción y R CMD check del paquete instalado. Resultado:
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. La NOTE corresponde únicamente
a `Version contains large components (0.1.6.9000)`. Pasaron ejemplos,
pruebas instaladas y reconstrucción de las cuatro viñetas.

Comandos: `R CMD build --no-manual` y
`R CMD check --as-cran --no-manual tidyactuarial_0.1.6.9000.tar.gz`.
Se empleó R 4.6.1 en Windows, con locale válido
`English_United States.utf8`, Pandoc de RStudio accesible en PATH y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`. La ejecución fuera del aislamiento
permitió acceso normal a dependencias. No se cambiaron sus validaciones.

Evidencia en:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-api-products/`.
Informe: `tidyactuarial.Rcheck/00check.log`; archivo fuente:
`tidyactuarial_0.1.6.9000.tar.gz`.
SHA256: `AA9AE8BA29ACC9E5EB67C3C9244FBE731C2AAF0326E1A043F944BFFB102FA237`.

Las 47 comprobaciones nuevas específicas pasan. La matriz de 101 firmas
es un registro excluido del paquete, no una nueva API o dependencia.
No se ejecutó nuevamente CI ni recepción remota de CRAN; no se presenta
la ejecución remota previa como validación del nuevo código. El manual
provisional no se reconstruyó en esta unidad y el barrido sigue abierto.

## Revalidación de cancelación financiera y C01 autorizada

Tras B02-07/B02-08, la suite local completa pasó, salida 0, con 73
comprobaciones nuevas: 17 de cancelación y 56 de tolerancias. Se regeneraron
solo los cuatro Rd afectados. La matriz conserva 101 entradas públicas y
contiene 960 apariciones de parámetros; el único cambio de firma es el
argumento final residual_tol=tol autorizado expresamente por el usuario.

Construcción final y chequeo del paquete instalado:
`R CMD build --no-manual` y
`R CMD check --as-cran --no-manual tidyactuarial_0.1.6.9000.tar.gz`.
Resultado **0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE:
`Version contains large components (0.1.6.9000)`.
Pasaron análisis de código y dependencias, correspondencia código/Rd,
ejemplos (25 s), pruebas instaladas (52 s) y reconstrucción de las cuatro
viñetas (12 s). Windows/R 4.6.1, locale English_United States.utf8,
Pandoc de RStudio y `_R_CHECK_CRAN_INCOMING_REMOTE_=false`.

Artefactos finales:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-tolerances/`.
Informe: `tidyactuarial.Rcheck/00check.log`.
SHA256 del archivo fuente:
`388BA3DE82928D5754B92EA6152AA117D8B4CF9D1B1D4F37BCC28B0E8F90C25C`.
Se verificó que trece archivos relevantes de código/tests/NEWS/NAMESPACE/Rd
coinciden con el checkout, normalizando saltos de línea. DESCRIPTION mantiene
la versión de desarrollo; los registros audit-* y AGENTS siguen excluidos
del archivo, mientras que las dos pruebas nuevas están incluidas.

La validación intermedia en precran-cancellation precede a C01 y no debe
usarse como evidencia de ella. Esta sección corresponde al archivo final
precran-tolerances. No se ejecutó nueva CI ni recepción remota de CRAN;
no se reconstruyó el manual provisional ni se modificó la versión.

El alcance matemático y las limitaciones están en audit-cash-flow-roots.md.
La compatibilidad incluye conservar las llamadas posicionales; abreviaturas
parciales como res= deben escribirse result=, al ser ambiguas con el nuevo
residual_tol. B03 queda como siguiente bloque de revisión integral.

## B03: anualidades de nivel y calendarios de préstamos

Se revisaron a_angle, s_angle, amort_schedule, amort_schedule_general y
sinking_fund_schedule, con el alcance y los pendientes expresos en
audit-financial-annuities-loans.md. Siguen pendientes las anualidades
aritméticas/geométricas y extremos/eventos adicionales de los calendarios.

La suite local completa y 169 comprobaciones nuevas (54 de anualidades,
115 de préstamos/fondos) pasaron, salida 0. Se verificó igualdad de formals
con HEAD f7588f4 para las cinco funciones públicas. Se mantienen las columnas,
101 nombres públicos y 960 apariciones de parámetros. Sin nuevas dependencias.
Roxygen regeneró solo cinco Rd. git diff --check sin errores.

Se ejecutaron R CMD build --no-manual y R CMD check --as-cran --no-manual
sobre el archivo fuente final. Resultado: **0 ERROR, 0 WARNING, 1 NOTE**,
salida 0. Única NOTE: Version contains large components (0.1.6.9000).
Pasaron dependencias, análisis de código (42 s), documentación y ejemplos
(24 s), pruebas instaladas (47 s), y reconstrucción de cuatro viñetas (13 s).

Artefactos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b03-level-loans/`.
Informe: tidyactuarial.Rcheck/00check.log.
SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`38697E0FEA3D6A4EC0DA501611E92B398DCEE4A7398F033C1B788DEF5A3A1637`.
Se verificaron quince archivos de código, tests, NEWS, NAMESPACE y Rd contra
el checkout, normalizando saltos de línea; coinciden. El archivo incluye
los dos tests y los helpers nuevos; excluye AGENTS y los registros audit-*.

Entorno: R 4.6.1/Windows, locale English_United States.utf8 y Pandoc de RStudio.
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`; ejecución fuera del aislamiento
para acceder normalmente a las bibliotecas instaladas. No se ejecutó nueva
CI, comprobación remota de recepción de CRAN ni manual. No hay push,
publicación o cambio de versión. Este check no sustituye la revisión integral.

## B03: anualidades aritméticas y geométricas

Se implementaron y probaron B03-05/B03-07 de
audit-financial-annuities-loans.md: base original/productos aritméticos,
spreads geométricos pequeños, perpetuidades convergentes sin umbral
arbitrario, propagación de plazo NA y aclaraciones de unidades/horizonte.
No se cierra B03: faltan extras, recálculo y cancelación anticipada de préstamos.

La suite local final completa pasó, salida 0, con **91 comprobaciones nuevas**:
41 aritméticas y 50 geométricas. Se verificaron formals, clases y nombres de
columnas contra HEAD 8dba06e para las dos anualidades y s_angle (solo texto
en esta última): idénticos. Se conservan 101 nombres públicos y 960 apariciones
de parámetros, sin funciones/dependencias nuevas ni cambios de firma.
Roxygen regeneró solo tres Rd; git diff --check sin errores.

Construcción y check definitivos: R CMD build --no-manual y
R CMD check --as-cran --no-manual tidyactuarial_0.1.6.9000.tar.gz.
Resultado **0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE:
Version contains large components (0.1.6.9000). Pasaron análisis de código
(40 s), dependencias/documentación, ejemplos (23 s), pruebas instaladas
(52 s) y reconstrucción de las cuatro viñetas (12 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b03-varying-verified/`.
Informe: tidyactuarial.Rcheck/00check.log.
SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`F25714AD4130CF4D45F424B5009277B8F754AB0702D28879A79E136EC432D9BF`.
Diez archivos de código, tests, NEWS, NAMESPACE y Rd coinciden con el checkout
tras normalizar saltos de línea; se incluye la versión de desarrollo y las
dos nuevas regresiones, mientras que audit-* y AGENTS siguen excluidos.

Las ejecuciones en precran-b03-varying y precran-b03-varying-final fueron
intermedias: nuevos fallos reproducidos en familias coincidentes y límites
de ratios justificaron ampliar las regresiones y repetir la validación.
Solo la carpeta verified y el SHA256 anterior corresponden al código final.

Entorno R 4.6.1/Windows, locale English_United States.utf8, Pandoc de RStudio,
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`. Se ejecutó fuera del aislamiento
para disponer de bibliotecas instaladas. Sin nuevo push, CI remota, manual,
publicación ni cambio de versión. El push de respaldo anterior hasta 8dba06e
se conserva; no valida por sí solo este código posterior.

## Cierre B03: anticipos, recálculo y liquidación

Se completaron las verificaciones B03-08/B03-10, con 216 comprobaciones
nuevas en test-loan-prepayment-audit.R y suite local completa aprobada,
salida 0. Log local: b03-prepayment-local-tests.log en el directorio de
visualizaciones de esta conversación. Se contrastaron saldos, valores
fechados, recast, liquidación, flags, callbacks, períodos nombrados y fondos
con déficit/excedente. Las referencias son sumas, libro y Decimal a 90 dígitos.

Defectos corregidos: flag de amortización negativa due; truncado de nombres
fraccionarios; tol infinito; cuota recuperable de un factor de descuento
desbordado; y salida monetaria no representable sin diagnóstico explícito.
Formals, clases y nombres de columnas de los tres calendarios coinciden con
HEAD 579efdb. Se preservan 101 nombres públicos/960 apariciones de parámetros,
sin nuevas funciones, helpers o dependencias. Roxygen modificó solo tres Rd.

Build y check finales: R CMD build --no-manual y
R CMD check --as-cran --no-manual tidyactuarial_0.1.6.9000.tar.gz.
Resultado **0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: Version
contains large components (0.1.6.9000). Pasaron código (43 s), dependencias,
documentación, ejemplos (26 s), pruebas instaladas (50 s) y reconstrucción
de las cuatro viñetas (12 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b03-prepayments-verified/`.
Informe: tidyactuarial.Rcheck/00check.log.
SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`04F0AEA54E116DBC3A8E13E97409B4E74E805A21B813DD6D5E445B263F28185C`.
Nueve archivos fuente/tests/NEWS/NAMESPACE/Rd coinciden con el checkout
normalizando saltos de línea; la regresión nueva está incluida y audit-*/
AGENTS quedan excluidos. La versión de desarrollo sigue intacta.

La carpeta precran-b03-prepayments corresponde al intento intermedio con
una captura incorrecta de la tabla en expect_warning. Se corrigió el test,
se comprobó específicamente y se repitieron suite y build/check. Solo
verified y el SHA256 anterior acreditan el código/test final.

Entorno R 4.6.1/Windows, locale English_United States.utf8, Pandoc de RStudio
y `_R_CHECK_CRAN_INCOMING_REMOTE_=false`; bibliotecas accesibles mediante
ejecución fuera del aislamiento. Sin nuevo push, CI remota, manual,
publicación o cambio de versión. B03 queda cerrado en el alcance documentado;
B04 es la siguiente revisión integral. No se declara cerrado el paquete.

## B04: calendario, precio, rendimiento e interés corrido

Primera unidad B04-01/B04-05 implementada: 99 comprobaciones nuevas y suite
local completa aprobadas, sin fallos ni advertencias. Log b04-bond-local-tests.log
en el directorio de artefactos de esta conversación. Cinco firmas públicas
se compararon con 49da88a y coinciden; 101 nombres públicos/960 parámetros.
Los cambios de Rd se limitan a las cuatro funciones revisadas.

R CMD build --no-manual y R CMD check --as-cran --no-manual terminaron con
**0 ERROR, 0 WARNING, 1 NOTE**. Única NOTE: versión de desarrollo 0.1.6.9000.
Pasaron código (41 s), ejemplos (25 s), pruebas instaladas (57 s), viñetas
y reconstrucción de las cuatro viñetas (12 s).

Artefactos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b04-bonds-verified/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt compara
12 archivos fuente/tests/NEWS/NAMESPACE/Rd con el checkout (normalizando
CRLF). La prueba nueva está incluida; audit-*/AGENTS quedan excluidos.
SHA256: `75CF0FEB71A796657FFCB4EDD852829F79DBE3B5B0E5139F7D96A18FE0F7FE8A`.

Entorno R 4.6.1/Windows, locale UTF-8 y Pandoc de RStudio; check con
`_R_CHECK_CRAN_INCOMING_REMOTE_=false` y bibliotecas accesibles fuera del
aislamiento. Sin nueva CI remota, manual, publicación, push ni cambio de
versión. El usuario pidió continuar en orden: siguen book value y callable.
Esta verificación acredita la primera unidad, no los cambios posteriores.

## B04: valor contable y escenarios de rescate, C05 autorizada

Segunda unidad sobre 185423b: 142 comprobaciones nuevas aprobadas y suite
local completa sin fallos ni advertencias, salida 0. Log de suite:
b04-book-callable-local-tests.log; reproducción previa:
b04-book-callable-before.log, ambos en el directorio de artefactos.
Se verificaron tres identidades independientes de libro, precios por escenario,
tasas extremas, períodos de ejercicio y el indicador de mínimo de C05.
El usuario autorizó expresamente mínimo calculado y empates exactos.

Las dos firmas públicas y nombres/clases de columnas tidy coinciden con
185423b. Se mantienen 101 nombres públicos y 960 apariciones de parámetros.
Sin dependencias, exportaciones, helpers, argumentos o columnas nuevos.
Roxygen modificó únicamente los dos Rd correspondientes en esta unidad.

R CMD build --no-manual y R CMD check --as-cran --no-manual:
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: versión de desarrollo
0.1.6.9000. Pasaron análisis de código (49 s), ejemplos (29 s), pruebas
instaladas (62 s), viñetas y reconstrucción de las cuatro viñetas (17 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b04-book-callable-verified/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
16 archivos fuente/tests/NEWS/NAMESPACE/Rd iguales al checkout normalizando
CRLF. Ambas regresiones de B04 están incluidas; audit-*/AGENTS excluidos.
SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`4E86D9DD1C978B0DE5F866A9B8B18AB74F1A8B6A4051A775E89111ED4C76E7E9`.

Entorno R 4.6.1/Windows, locale UTF-8, Pandoc de RStudio y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, ejecutado fuera del aislamiento con
bibliotecas instaladas. Sin push, CI remota nueva, manual, publicación o
cambio de versión. Segunda unidad cerrada en sus límites documentados;
B04 tiene seis de veinte funciones revisadas y sigue abierto. Próximo paso:
curvas spot/forward/par, después sensibilidad e inmunización.

## B04: curvas spot, forward, bootstrap y cupón par

Tercera unidad sobre a5d8948: 79 comprobaciones nuevas y suite local
completa aprobadas sin fallos ni advertencias, salida 0. Logs:
b04-curves-before.log (reproducción previa), b04-curves-local-tests.log
(suite final) y b04-curves-compatibility.log (contratos y reproducción de par).
Se contrastaron descuentos originales, forwards planos/no planos, origen
grande, interpolación efectiva, escala monetaria, NA/gráficos y recuperación
triangular independiente encadenada con par/forward. B04 acumula 320
comprobaciones nuevas entre sus tres unidades.

Las cinco firmas, clases y nombres/clases de columnas coinciden con a5d8948.
Bootstrap conserva su cuerpo ejecutable; solo se aclararon límites en Rd.
Inventario: 101 nombres públicos/960 apariciones de parámetros. Sin funciones,
helpers, dependencias, exportaciones, argumentos o columnas nuevas. No hay
decisión C nueva. C05 sigue implementada como se autorizó; C02–C04 pendientes.

R CMD build --no-manual y R CMD check --as-cran --no-manual terminaron con
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: versión de desarrollo
0.1.6.9000. Pasaron código, documentación, ejemplos (24 s), pruebas instaladas
(53 s), cuatro viñetas y su reconstrucción (12 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b04-curves-verified/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
27 archivos de fuente/tests/NEWS/NAMESPACE/Rd iguales al checkout normalizando
CRLF: las once funciones revisadas de B04 y las tres regresiones están incluidas.
AGENTS/audit-* quedan excluidos. SHA256 del archivo fuente:
`9FA785A5EB2101B940991486A42543606D822FBB0880002D23215EC92786CCD5`.

R 4.6.1/Windows, locale UTF-8 y Pandoc de RStudio;
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, ejecución con bibliotecas instaladas
fuera del aislamiento. Sin push, CI remota nueva, manual, publicación ni
cambio de versión. Tercera unidad cerrada en el alcance documentado; once
de veinte funciones B04 revisadas. Siguen sensibilidades e inmunización.

## B04: duración, convexidad y C06 de identificadores faltantes

Cuarta unidad sobre 20a9b48: 163 comprobaciones numéricas nuevas más 90 de
C06, autorizada expresamente por el usuario: 253 nuevas en total. Pasaron
los focos y la suite completa final, salida 0 y sin fallos/advertencias.
B04 acumula 573 comprobaciones nuevas entre cuatro unidades. La regla de
cadena distingue convexidad nominal anual de efectiva anual; se preservan
esa convención y las correcciones previas de inmunización.

Logs locales en el directorio de artefactos de la conversación:
b04-sensitivity-before.log y b04-c06-before.log reproducen los fallos;
b04-sensitivity-local-tests.log acredita la suite numérica previa a C06;
b04-sensitivity-c06-local-tests.log acredita la suite final con C06;
b04-sensitivity-compatibility.log y b04-sensitivity-c06-compatibility.log
comparan las seis firmas, clases y nombres/clases de columnas con 20a9b48
y muestran la fila autorizada antes/después. Se mantienen 101 nombres
públicos y 960 apariciones de parámetros. Sin dependencias, funciones,
helpers, exportaciones, parámetros o columnas nuevos.

R CMD build --no-manual y R CMD check --as-cran --no-manual terminaron con
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: versión de desarrollo
0.1.6.9000. Pasaron análisis de código, documentación, ejemplos (21 s),
pruebas instaladas (52 s), las cuatro viñetas y su reconstrucción (12 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b04-sensitivity-c06-verified/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
41 archivos fuente/tests/NEWS/NAMESPACE/Rd iguales al checkout normalizando
CRLF. Incluye las diecisiete funciones revisadas de B04 y las cinco regresiones.
AGENTS/audit-* excluidos; DESCRIPTION sigue en desarrollo. SHA256:
`25CBBC7C177A74F796EDE89E7F2FEBC59183F3FE580BA974D09BE039355EA4D4`.

R 4.6.1/Windows, locale UTF-8, Pandoc de RStudio y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, con bibliotecas instaladas accesibles
fuera del aislamiento. Sin push, CI remota nueva, manual, publicación ni
cambio de versión. Cuarta unidad y C06 cerradas en el alcance documentado;
B04 sigue abierto: diecisiete de veinte funciones revisadas, pendientes las
dos funciones de inmunización y su gráfico. C02–C04 siguen sin implementar.


## B04: cierre de inmunización y del bloque temático

Quinta unidad sobre d22e77e: immunize_duration, immunize_duration_convexity
y plot_immunization_gap. Añade 113 comprobaciones independientes; pasaron
además las 31 de regresiones previas de inmunización y la suite completa
local, salida 0. B04 acumula 686 comprobaciones nuevas entre cinco unidades.
El registro audit-bonds-curves-immunization.md detalla identidades, fallos
previos, correcciones, compatibilidad y límites. Se preservaron las tres
firmas, clases y columnas, y el helper SVD original: la norma mínima sigue
sobre cantidades de activos. Se renderizaron e inspeccionaron dos gráficos
PNG de 1100x660; ver b04-duration-gap.png y b04-convexity-gap.png en artefactos.

R CMD build --no-manual y R CMD check --as-cran --no-manual terminaron con
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: versión de desarrollo
0.1.6.9000. Pasaron análisis de código, documentación, ejemplos (22 s),
pruebas instaladas (53 s), las cuatro viñetas y su reconstrucción (12 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b04-closure-verified/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
49 archivos fuente/tests/NEWS/NAMESPACE/Rd iguales al checkout normalizando
CRLF. Incluye las veinte funciones de B04, el helper de inmunización y las
seis regresiones nuevas del bloque. AGENTS/audit-* excluidos; DESCRIPTION
sigue en desarrollo. SHA256 del archivo tidyactuarial_0.1.6.9000.tar.gz:
`51EBF79029669E629824E79A51E08D8294BB089FDE78C62E8A47226A0083349B`.

R 4.6.1/Windows, locale UTF-8, Pandoc de RStudio y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, con bibliotecas instaladas accesibles
fuera del aislamiento. Sin push, CI remota nueva, manual, publicación ni
cambio de versión. B04 cerrado dentro del alcance y límites documentados:
20/20 funciones revisadas; esto no cierra la auditoría integral ni valida
R mínimo/CI remota para estos cambios. C02–C04 siguen sin implementar.
Siguiente bloque: B05, empezando por lifetable y mortality_law_table,
preservando la evidencia y los arreglos históricos.

## Paréntesis: visualizaciones financieras y contingentes (18 de octubre)

Sobre 989b4cf se perfeccionó plot_cash_flow y se añadió la función solicitada
plot_contingent_cash_flow. El único cambio al productor apv_life_flow es el
atributo aditivo contingency y documentación; firmas y cálculos existentes
se preservan. Registro matemático, regresiones, compatibilidad y límites en
audit-cash-flow-visualizations.md. Hay 76 comprobaciones nuevas (19+57),
suite completa local aprobada, salida 0 y sin advertencias. Log local:
cash-flow-visualizations/local-tests.log en el directorio de artefactos.

La ayuda de los tres consumidores se regeneró con Markdown explícito para
obtener código y enlaces navegables. El build/check definitivo posterior a
esa edición documental terminó con **0 ERROR, 0 WARNING, 1 NOTE**, salida 0.
Única NOTE: versión de desarrollo 0.1.6.9000. Pasaron análisis de código,
metadatos/enlaces/consistencia de ayuda, ejemplos (28 s), pruebas instaladas
(63 s), las cuatro viñetas y su reconstrucción (15 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-visualizations-final/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
370 archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout normalizando
CRLF. Incluye las pruebas y ejemplos nuevos. AGENTS/audit-* excluidos;
DESCRIPTION conserva 0.1.6.9000. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`BA63842CFF37EF448C1333F576C37A5DBC2CB3A1373EAABB9295CCF2402E8691`.
El directorio preliminar precran-visualizations-verified queda como evidencia
anterior; el definitivo incluye el formato final de ayuda y lo reemplaza
como referencia de entrega.

Siete gráficos PNG inspeccionados y PDF vectoriales exportados en
cash-flow-visualizations; ZIP de entrega con figuras y script reproducible.
Inventario: 102 nombres públicos, 973 apariciones de parámetros y ninguna
sin descripción Rd. Sin dependencias nuevas ni cambios de versión.

R 4.6.1/Windows, locale UTF-8, Pandoc de RStudio y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, con bibliotecas instaladas accesibles
fuera del aislamiento. Sin push, publicación, CI remota nueva o prueba de R
mínimo para estos cambios. Paréntesis cerrado dentro del alcance documentado;
se retoma B05 cuando el usuario continúe el barrido, preservando B04 y todos
los pendientes históricos. La incorporación de una gráfica no cierra B06.

## B05: tablas anuales, leyes de mortalidad y C07 (18 de octubre)

Primera unidad sobre 67c2b70: lifetable y mortality_law_table. C07 fue
autorizada expresamente antes de implementar el extremo abierto desconocido.
Registro matemático, causas, compatibilidad y límites en
audit-life-tables-mortality.md. Se preservan los arreglos históricos de ax,
integración de fuerzas, ocho parámetros, Beta y cohortes extintas.

Hay 62 comprobaciones nuevas. La suite completa del código definitivo pasó
sin fallos ni advertencias, salida 0; log b05-foundations-final-tests.log en
artefactos. b05-foundations-before.log y b05-validation-before.log reproducen
fallos del HEAD previo. La evaluación inicial de Logistic aún perdía cifras
al restar log-sumas grandes; se confirmó el caso y se corrigió antes del cierre,
repitiendo suite y build/check sobre el código final.

R CMD build --no-manual y R CMD check --as-cran --no-manual definitivos:
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: versión de desarrollo
0.1.6.9000. Pasaron análisis de código (39 s), documentación, ejemplos (27 s),
pruebas instaladas (67 s), cuatro viñetas y su reconstrucción (12 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b05-foundations-final/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
371 archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout normalizando
CRLF. AGENTS/audit-* excluidos; pruebas nuevas incluidas. DESCRIPTION conserva
0.1.6.9000. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`E6190AAE3FEFE5384B5294FE394C4BDA960786849D3F63A1A41C1144F391456D`.
El directorio precran-b05-foundations corresponde al estado preliminar;
no sustituye la validación del ajuste definitivo de Logistic.

Firmas existentes preservadas, 102 nombres públicos y 973 apariciones de
parámetros documentadas. Sin funciones, dependencias, columnas o versión nuevas.
R 4.6.1/Windows, locale UTF-8, Pandoc de RStudio y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, con bibliotecas instaladas accesibles
fuera del aislamiento. Sin push, publicación o CI remota/R mínimo actuales.
Primera unidad y C07 cerradas en el alcance documentado; B05 sigue abierto,
dos de doce funciones revisadas. Siguen t_px/t_qx/t_Ex/e_x y luego los demás
constructores, conservando los arreglos multivida previos al llegar a B07.


## B05: conciliación y cierre de las doce funciones (18 de octubre)

Sobre d50c212 se conciliaron las diez funciones restantes con la evidencia
previa. C08 (dotal sin cap) y C09 (ax KM como años vividos) fueron autorizadas
expresamente antes de implementarse. La matriz de doce funciones, fórmulas,
causas raíz, impacto y límites está en audit-life-tables-mortality.md.

Esta unidad añade 77 comprobaciones; B05 acumula 139 nuevas entre ambas
unidades. Se conservaron y aprobaron las 170 comprobaciones enfocadas anteriores,
sin atribuirlas como nuevas. La suite local global pasó; los 77 focos finales
y las diez firmas/clases/tipos ordinarios están en b05-closure-focused-final.log
y b05-closure-compatibility.log. Este último recoge los 75 casos anteriores a
las dos guardas suplementarias de nombres. b05-closure-before.log,
b05-closure-additional-before.log y b05-names-before.log documentan fallos
previos; b05-closure-final-tests.log documenta la suite local. La referencia
exhaustiva final es la suite instalada del archivo construido (77 focos).

R CMD build --no-manual y R CMD check --as-cran --no-manual definitivos:
**0 ERROR, 0 WARNING, 1 NOTE**, salida 0. Única NOTE: versión de desarrollo
0.1.6.9000. Pasaron análisis de código (33 s), documentación, ejemplos (22 s),
pruebas instaladas (51 s), cuatro viñetas y su reconstrucción (10 s).

Artefactos definitivos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b05-closure-final/`.
Informe tidyactuarial.Rcheck/00check.log; snapshot-verification.txt acredita
372 archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout normalizando
CRLF. AGENTS/audit-* excluidos; pruebas de cierre incluidas. DESCRIPTION
conserva 0.1.6.9000. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`075B3DDD3587AAC705FBCA9F87D5B423B45DB52697E3EC75A2E005F4EE2D636C`.
El directorio precran-b05-closure es evidencia preliminar; no incluye las dos
últimas guardas de nombres y queda reemplazado por la validación definitiva.

Se inspeccionó b05-km-closure.png (1350x750), con exportación PDF vectorial:
curva/banda escalonadas legibles, sin recortes ni imputar CI indefinidos.
Sin funciones, dependencias, columnas o versión nuevas; inventario estable:
102 nombres públicos, 973 apariciones de parámetros documentadas.
R 4.6.1/Windows, locale UTF-8, Pandoc de RStudio y
`_R_CHECK_CRAN_INCOMING_REMOTE_=false`, con bibliotecas instaladas accesibles
fuera del aislamiento. Sin push, publicación, CI remota nueva ni prueba actual
de R mínimo. B05 cerrado dentro del alcance y límites documentados: 12/12;
C07/C08/C09 implementadas y verificadas. Sigue B06. La auditoría global y la
conciliación del informe externo ausente no se dan por cerradas.

## B06: primera unidad, apv_life_flow (18 de octubre)

Base fdd2d1f; firma/esquema conservados. Ver audit-single-life-contracts.md
para modelos, reproducciones, compatibilidad, límites y conciliación de los
catorce nombres. Solo cambia un archivo funcional: R/apv_life_flow.R.
Se reutilizan los helpers de interés/valoración existentes. Se actualizan
NEWS/Rd y los registros; no se modifica la versión ni hay dependencias nuevas.

test-b06-life-flow.R añade 60 comprobaciones; suite local completa aprobada,
sin fallos/advertencias, salida 0 (b06-life-flow-tests.log). Las 24 pruebas apv
y las 57 gráficas previas pasan y no se contabilizan como nuevas.
b06-life-flow-before.log reproduce errores anteriores y reserva de 74.5 GB
para un horizonte sin soporte; b06-life-flow-compatibility.log reproduce
validaciones adicionales y compara firma, nombres, clases, tipos y cálculos
ordinarios de cuatro estados con fdd2d1f, con tolerancia relativa 1e-12.

Directorio de construcción y check:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b06-life-flow/`.
R CMD build --no-manual aprobó construcción y viñetas. snapshot-verification.txt
acredita 373 archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout,
normalizando CRLF. Incluye la nueva prueba B06 y excluye AGENTS/audit-*.
SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`FE524C014249BDA8315791B0C93DC73B946B038878B54973A9EBFD6DAC50050C`.

R CMD check --as-cran --no-manual definitivo: salida 0, **0 ERROR, 0 WARNING,
1 NOTE** por versión de desarrollo 0.1.6.9000. Informe 00check.log en
tidyactuarial.Rcheck; pruebas instaladas: 4876 aprobadas, 0 fallos/advertencias
(63 s). Ejemplos aprobados (24 s), cuatro viñetas y reconstrucción aprobadas
(13 s). R 4.6.1/Windows, UTF-8,
Pandoc de RStudio, _R_CHECK_CRAN_INCOMING_REMOTE_=false y bibliotecas locales
accesibles fuera del aislamiento. Sin push/publicación/CI remota nueva ni
prueba actual de R mínimo. B06 sigue abierto; próximos annuity_x/insurance_x.

## B06-02: anualidades, seguros y escenarios (18 de octubre)

Base ede40b7. El usuario priorizó rigor y generalidad con vectorización de
escenarios. Dos archivos funcionales, un archivo de helpers privados compartidos,
dos archivos nuevos de tests, NEWS/Rd y registros/matriz de API actualizados.
Firmas públicas, versión 0.1.6.9000 y dependencias conservadas. C10/C11 fueron
autorizadas expresamente antes de aplicar los resultados públicos de plazo cero.
Ver audit-single-life-contracts.md B06-02 para fórmulas, causas, compatibilidad
y generalidad/límites; la ampliación no implica modelos de muerte continua.

74 comprobaciones nuevas matemáticas/validación y 44 de escenarios/C10/C11:
118 en esta unidad, 178 nuevas acumuladas B06. Suite local completa aprobada,
salida 0, sin fallos/advertencias (b06-annuity-insurance-tests.log). Las pruebas
previas de anualidades, seguros, primas/reservas y SOA permanecen aprobadas.
Las regresiones previas están en b06-annuity-insurance-before.log,
b06-woolhouse-before.log y b06-scenarios-c10-c11-before.log (este último
reproduce C10/C11 antes de aplicarlas). b06-annuity-insurance-compatibility.log
reproduce el rechazo previo de vectores y los casos cero, y compara 60 casos
ordinarios con ede40b7: mismas firmas, clases, columnas/tipos y valores con
tolerancia relativa 1e-12. Los cambios C10/C11 se verifican aparte.

R CMD build --no-manual y R CMD check --as-cran --no-manual definitivos:
salida 0, **0 ERROR, 0 WARNING, 1 NOTE** por versión de desarrollo 0.1.6.9000.
Pruebas instaladas: 4994 aprobadas, 0 fallos/advertencias (50 s);
ejemplos aprobados (20 s), cuatro viñetas
y reconstrucción aprobadas (10 s). Informe tidyactuarial.Rcheck/00check.log.
Artefactos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b06-annuity-insurance/`.
snapshot-verification.txt acredita 376 archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE
iguales al checkout normalizando CRLF; incluye helpers/tests nuevos y excluye
AGENTS/audit-*. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`7012ADF80F94412411AF9CA61870D27E7A178A4F4F4D9B9C5C792819C076A35E`.

Inventario estable: 102 nombres públicos, 973 apariciones de parámetros,
cero descripciones ausentes. Matriz regenerada solo para los textos Rd nuevos.
R 4.6.1/Windows, UTF-8, Pandoc de RStudio, bibliotecas instaladas accesibles
fuera del aislamiento y _R_CHECK_CRAN_INCOMING_REMOTE_=false. lifecontingencies
no está instalado en la biblioteca configurada; oráculos independientes son
enumeración de pagos, decrementos de lx e identidades exactas/expansión CF.
Sin push/publicación, CI remota nueva o prueba actual de R mínimo. B06 sigue
abierto: continuar primas y reservas, componentes y modelos restantes.

## B06-03: primas y reservas (19 de octubre de 2026)

Base 576c9a1, árbol inicialmente limpio. Tres fuentes funcionales,
tres Rd, NEWS, una prueba nueva y registros/matriz de firmas actualizados.
Sin dependencias, helpers, nombres públicos, columnas, versión o parámetros
nuevos. Se conservan C10/C11 y todos los arreglos previos. Matemática,
reproducciones, decisiones de compatibilidad y límites: B06-03 de
audit-single-life-contracts.md. No hay decisión C nueva.

239 comprobaciones nuevas definitivas, aprobadas sin fallos/advertencias;
B06 acumula 417 nuevas. Suite local completa aprobada, salida 0, en
b06-premiums-reserves-final-tests.log. Los focos iniciales de 212 y la suite
preliminar anterior a los casos adicionales quedan como evidencia histórica,
no sustituyen la validación final. Se reutilizan las pruebas v2 y consumidores
multivida anteriores, sin contarlos como nuevos. Fallos originales en
b06-premiums-reserves-before.log; revisión del residuo provisional en
b06-gross-residual-before.log; overflow de n_prem*k en
b06-premium-periods-before.log. Los residuos se conservan como diagnósticos
de la ecuación y de los importes redondeados, sin imponerles cero.

b06-premiums-reserves-compatibility.log verifica tres firmas y 42 casos
ordinarios/salidas: clases, nombres y tipos conservados; valores a tolerancia
relativa 1e-12. Residuos corregidos se comprueban por escala separadamente.
Inventario estable: 102 nombres públicos, 973 apariciones de parámetros,
cero descripciones ausentes; matriz actualizada solo por textos Rd pertinentes.

Artefactos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b06-premiums-reserves/`.
R CMD build --no-manual aprobado. snapshot-verification.txt acredita 377
archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout normalizando
CRLF; prueba B06 nueva incluida y AGENTS/audit-* excluidos. DESCRIPTION
conserva 0.1.6.9000. SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`D67DB3D2ADA143558C5E4C9D747FA89D7C1D875C4F9C18C1A93E0B774828733D`.

R CMD check --as-cran --no-manual definitivo: salida 0, **0 ERROR, 0 WARNING,
1 NOTE**, únicamente por versión de desarrollo 0.1.6.9000. Pruebas instaladas:
5233 aprobadas, 0 fallos/advertencias (117 s). Pasaron análisis de código
(69 s), documentación, ejemplos (43 s), cuatro viñetas y reconstrucción (20 s).
Informe tidyactuarial.Rcheck/00check.log. R 4.6.1/Windows,
UTF-8, Pandoc de RStudio, bibliotecas instaladas accesibles fuera del
aislamiento y _R_CHECK_CRAN_INCOMING_REMOTE_=false. Sin push/publicación,
CI remota nueva o prueba actual de R mínimo. B06 sigue abierto; próximos
life_contract/add_insurance/add_premium_schedule y valoraciones restantes.

## B06-04: especificaciones de contratos y componentes (19 de octubre)

Base acab741. Se revisan life_contract, add_insurance y add_premium_schedule:
coerciones NA, dominio de tasas y calendarios que desbordaban o redondeaban a
cero. Se mantienen esquema, firmas, tipos ordinarios, aliases, tasas originales
y supuestos capturados. Modelo, causas, compatibilidad y límites en
audit-single-life-contracts.md B06-04; no hay decisión C nueva.

68 comprobaciones nuevas, sin fallos/advertencias, y suite local completa
aprobada (salida 0): b06-contract-storage-final-tests.log. B06 acumula 485.
b06-contract-storage-before.log reproduce defectos originales; el reporter
muestra un máximo de diez fallos detallados. La comparación con acab741 en
b06-contract-storage-compatibility.log acredita 72 objetos ordinarios idénticos
y tres firmas preservadas. Se reutilizan pruebas de contratos/multivida y
unidades anteriores sin contarlas como nuevas. Inventario estable 102 nombres,
973 apariciones de parámetros; no se alteran descripciones de parámetros.

Artefactos:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b06-contract-storage/`.
R CMD build --no-manual aprobado. snapshot-verification.txt acredita 378
archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout normalizando
CRLF; pruebas nuevas incluidas, AGENTS/audit-* excluidos y versión 0.1.6.9000.
SHA256 de tidyactuarial_0.1.6.9000.tar.gz:
`0F5EFA173D4DC81EB9811BDB9ACB9D72DC1043E5A93101BFC66A9901ED52DED2`.

R CMD check --as-cran --no-manual definitivo: salida 0, **0 ERROR, 0 WARNING,
1 NOTE**, únicamente por versión de desarrollo 0.1.6.9000. Pruebas instaladas:
5301 aprobadas, 0 fallos/advertencias/omisiones (104 s). Análisis de código
aprobado (70 s), documentación, ejemplos (36 s), cuatro viñetas y reconstrucción
(15 s). Informe tidyactuarial.Rcheck/00check.log. R 4.6.1/Windows, UTF-8,
Pandoc de RStudio, bibliotecas instaladas accesibles fuera del aislamiento,
_R_CHECK_CRAN_INCOMING_REMOTE_=false. Sin nueva CI remota ni prueba actual
de R mínimo. Sin push/publicación ni cambio de versión. Unidad B06-04 cerrada
dentro de su alcance; siguen annuity_multi, insurance_variable_k y
insurance_xj/A_xj. B06 continúa abierto.

## B06-05: anualidad multivida y seguros restantes (21 de octubre de 2026)

Base d117df3. Se reanuda la unidad guardada tras la interrupción de conexión.
annuity_multi: C12 autorizada, frac final y extremos temporales de Woolhouse.
insurance_variable_k: masas fraccionarias directas y productos monetarios log.
insurance_xj: supervivencia del estado activo, probabilidades competidoras,
grilla anual y estabilidad log. No se cambian modelos de pago al instante de
muerte ni el significado histórico joint-and-survivor de reversionary.
Modelo, reproducciones, referencias y límites en audit-single-life-contracts.md.

153 comprobaciones nuevas (91 anualidad y 62 seguros), todas aprobadas sin
advertencias; suite fuente completa aprobada en b06-remaining-final-tests.log.
Se reutiliza esa suite ya terminada y se comprueba además el paquete final
instalado. B06 acumula 638 comprobaciones nuevas. Reproducciones originales:
b06-remaining-diagnosis.log, b06-annuity-multi-before.log y
b06-remaining-insurance-before.log. Evidencia de compatibilidad en
b06-remaining-compatibility.log: 62 comparaciones ordinarias a 1e-12,
clases/nombres/esquemas preservados, dos firmas idénticas y annuity_multi
con todos los formals previos más frac al final. A_xj idéntico a insurance_xj.
Inventario: 102 nombres públicos, 974 apariciones de parámetros, cero sin
describir. No hay otra decisión C ni dependencias o versión nuevas.

Artefactos de construcción/check:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-b06-remaining/`.

R CMD build --no-manual aprobado. snapshot-verification.txt acredita 381
archivos R/tests/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout final normalizando
CRLF; helper y dos pruebas nuevos incluidos, AGENTS/audit-* excluidos.
DESCRIPTION mantiene 0.1.6.9000. SHA256 del archivo fuente:
`EBABC669AE74ECC207B0067566F10C93D6AF639E485240F39AB79A95921D759C`.

R CMD check --as-cran --no-manual definitivo, salida 0: **0 ERROR, 0 WARNING,
1 NOTE**, exclusivamente por versión de desarrollo 0.1.6.9000. Pruebas
instaladas: 5454 aprobadas, 0 fallos/advertencias/omisiones (63 s). Análisis
de código (43 s), documentación, ejemplos (25 s), cuatro viñetas y
reconstrucción (12 s) aprobados. Ver tidyactuarial.Rcheck/00check.log.
Entorno: R 4.6.1/Windows, UTF-8, Pandoc de RStudio, bibliotecas instaladas
accesibles fuera del aislamiento, _R_CHECK_CRAN_INCOMING_REMOTE_=false.
Sin nueva CI remota ni prueba actual de R mínimo. Sin push/publicación,
dependencias o cambio de versión. El usuario autorizó el commit local tras
validación el 21 de octubre. B06-05 queda cerrado dentro del alcance expuesto;
B06 concilia sus 14 nombres, con 638 comprobaciones nuevas y límites
documentados. No se declara perfección ni conciliación de un informe externo
no proporcionado. Sigue B07; preservar la evidencia previa multivida/Monte Carlo.
