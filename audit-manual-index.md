# Manual PDF con índice — 2026-10-16

Estado: compilación con índice implementada y comprobada.
Fuentes del paquete en `d296d70`, versión `0.1.6.9000`.

## Entorno y causa del bloqueo anterior

TinyTeX estaba instalado pero no contenía `makeindex.exe`.
`tlmgr info makeindex` confirmó `installed: No`. La instalación exigió
primero `tlmgr update --self`; después `tlmgr install makeindex` instaló
`makeindex` y su binario Windows. No se actualizaron todos los paquetes de
TeX Live ni se modificaron funciones, dependencias de R o archivos Rd.

Se usaron `LC_ALL=C`, `LC_CTYPE=C`, `LANG=C` y el directorio binario de
TinyTeX en PATH. La compilación se ejecutó fuera del aislamiento para
permitir el acceso normal a TinyTeX y a su configuración de Windows.

## Compilación

Comando base, sin `--no-index`:

```
R CMD Rd2pdf --no-preview --force --output=tidyactuarial-manual-0.1.6.9000.pdf C:/Users/LENOVO/tidyactuarial_MASTER/tidyactuarial
```

La compilación estándar terminó con salida 0 y produjo 233 páginas,
incluido el índice. Su log se conserva como `compilation.log`.
La revisión visual detectó desbordamiento de referencias largas, presente
en el formato estándar de Rd. Para el PDF entregable se usó un `Rd.cfg`
local a los artefactos: `sloppy`, `emergencystretch=3em` y tamaño `small`
en los bloques Usage. TEXINPUTS incorpora ese directorio y conserva la
búsqueda predeterminada. Estos cambios afectan solo la presentación del
PDF; no se copiaron al paquete ni alteraron su documentación generada.

## Resultado y evidencia

Compilación final: salida 0, **232 páginas**, índice en páginas **229–232**.
`makeindex`: **1197 entries accepted, 0 rejected**.
El log final no contiene `Overfull`. Se renderizaron y revisaron portada,
contenido e índice. La compilación aún informa sustituciones de fuentes y
destinos de enlaces externos ausentes en el PDF autónomo; no se afirma
haber validado todos los enlaces externos ni eliminado todos los avisos TeX.

Artefactos y configuración de presentación:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/manual-index/`.

PDF: `tidyactuarial-manual-0.1.6.9000.pdf`.
Log final: `compilation-final.log`. Ajustes: `Rd.cfg`.
SHA256 del PDF:
`266C0C63D3DF17F7115A686009670D7C1BCE8DE1DF0599A4D03099DEC2F96003`.

Queda resuelto el bloqueo de compilación del manual con índice. Esto es
una ejecución independiente de Rd2pdf; no se presenta como una repetición
de R CMD check con la fase del manual habilitada. No se repitió la suite
actuarial porque no cambió código. Continúan pendientes la revisión remota
de recepción de CRAN y la conciliación del informe externo original.
