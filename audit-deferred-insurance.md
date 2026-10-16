# Seguro multivida diferido — 2026-10-16

Estado: confirmado, implementado y probado con sumas independientes.
Rama `audit/0.2.0-precran`, versión `0.1.6.9000`.

## Modelo e identidad

Ambas vidas están vivas en la emisión y sus mortalidades son independientes.
Sean px(t)=lx(x+t)/lx(x), py(t)=ly(y+t)/ly(y) y S(t) la supervivencia
del estado asegurado: px(t)py(t) para conjunta, px(t)+py(t)-px(t)py(t)
para último superviviente. Sea v=1/(1+i).

El temporal diferido h años, de duración n después del diferimiento, vale
por unidad de beneficio:

`sum(j=1..n) v^(h+j) [S(h+j-1)-S(h+j)]`.

El dotal añade `v^(h+n) S(h+n)`. Vida entera extiende la suma hasta la
extinción en las tablas cerradas. La supervivencia condicional correcta
desde h es `S(h+u)/S(h)`. En último superviviente no equivale a reiniciar
ambas vidas en x+h e y+h: incluye trayectorias con un único superviviente.

La identidad usada por el código sigue siendo la de seguro y anualidad:
con `D=v^h S(h)` y `a_h=sum(j=0..n-1) v^j S(h+j)/S(h)`,
el temporal vale `D [1-d a_h-v^n S(h+n)/S(h)]`, donde d=i/(1+i).

## Causa y reproducción

`insurance_xy()` multiplicaba un seguro desde ambas edades avanzadas por
`v^h S(h)`. Ese producto es válido para conjunta, pero mezcla estados para
último superviviente. Con lx=(100,80,40,10,0), ly=(100,50,30,5,0), edades
60:64, i=.05, h=1, n=2, temporal de último superviviente:

- Antes: 0.6200194363 aproximadamente por unidad.
- Suma independiente: 0.6660187885 aproximadamente por unidad.

La prueba nueva se ejecutó antes de corregir: fallaron 19 comprobaciones,
todas en último superviviente. Se observaron discrepancias tanto de APV
como de los campos de auditoría. La conjunta pasó antes de corregir.

## Diff mínimo y compatibilidad

Solo cambia `R/insurance_xy.R` como código funcional. Se usa la anualidad
diferida existente desde edades de emisión y se divide por D para obtener
la continuación condicional; la supervivencia a vencimiento se obtiene
desde emisión y se divide por S(h). Se conserva la salida temprana para
supervivencia nula y la convención existente de plazo cero.

No cambian argumentos, nombres ni columnas. Se corrigen las valoraciones
diferidas de último superviviente afectadas y sus campos
`annuity_due_value` y `survival_to_maturity`. Los valores sin diferimiento
y de conjunta conservan su identidad matemática. Consumidores como
`premium_xy()` que usan estos seguros heredan la corrección del beneficio.
El archivo Rd correspondiente y NEWS documentan el cambio.

## Pruebas

`tests/testthat/test-insurance-xy-deferred-conditioning.R`: 42
comprobaciones aprobadas después de corregir. Referencia construida
directamente desde lx y ly; no llama a una segunda valoración actuarial
para calcular el resultado esperado. Cubre conjunta y último superviviente,
temporal, dotal y vida entera, tasas 0, .05 y -.02 y columnas de auditoría.
Las diez comprobaciones de `test-insurance-xy-identities.R` también pasan.
La suite completa `testthat::test_local(reporter="summary")` terminó
sin fallos, salida 0; documentación regenerada con roxygen2.

Este hallazgo es independiente de la auditoría externa no disponible.
La validación de paquete anterior corresponde a la versión del código
previa a esta corrección; no se presenta como validación del nuevo diff.

## Revalidación del paquete corregido

Se ejecutaron `R CMD build --no-manual` y
`R CMD check --as-cran --no-manual` con R 4.6.1 en Windows.
Resultado: **0 ERROR, 0 WARNING, 1 NOTE**, salida 0. La NOTE corresponde
únicamente a `0.1.6.9000`. Pasaron ejemplos, pruebas instaladas,
documentación y reconstrucción de las cuatro viñetas.

Artefacto: `C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/precran-deferred/tidyactuarial_0.1.6.9000.tar.gz`.
SHA256: `0F919EC62F8F381AF83CD1E44827A4D1A09A4076AA0DCF5D8A6948C24F59042F`.
Informe válido: subdirectorio `locale-C/tidyactuarial.Rcheck/00check.log`.
Se comprobó que el archivo contiene la nueva regresión y excluye los
registros internos y AGENTS.md.

El primer intento de check se detuvo con ERROR/WARNING en DESCRIPTION
por mensajes de arranque: las variables regionales heredadas `C.UTF-8`
no eran aceptadas por esta instalación de R en Windows. Su informe se
conserva en `precran-deferred/tidyactuarial.Rcheck/00check.log`. La repetición
válida usó `LC_ALL=C`, `LC_CTYPE=C`, `LANG=C`, sin modificar el paquete
ni omitir comprobaciones de DESCRIPTION. Ambos checks se ejecutaron fuera
del aislamiento para permitir acceso a la biblioteca de dependencias.

Se mantuvo `_R_CHECK_CRAN_INCOMING_REMOTE_=false` y `--no-manual`:
no se validaron recepción remota de CRAN ni manual con índice. R 4.1.0
no está instalado localmente; su matriz de CI queda preparada y sin ejecutar
según `audit-ci-minimum-r.md`.
