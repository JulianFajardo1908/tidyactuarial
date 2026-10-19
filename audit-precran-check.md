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
