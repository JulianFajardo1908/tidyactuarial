# Preparación de CI para R mínimo — 2026-10-16

Estado: configuración implementada y sintaxis comprobada; ejecución pendiente.

DESCRIPTION declara `R (>= 4.1.0)`. La matriz existente solo contemplaba
R release en Ubuntu, Windows y macOS. Se añade una cuarta combinación:
Ubuntu con R `4.1.0` exacto. Se conservan los mismos pasos de instalación
de dependencias y chequeo; no se relajan tests ni requisitos del paquete.

Se usa una versión exacta porque `4.1` seleccionaría el último parche de
esa serie, no necesariamente el mínimo declarado. Referencia primaria:
https://github.com/r-lib/actions/tree/v2/setup-r#inputs

Validación local: lectura YAML y comprobación de las cuatro combinaciones,
de la presencia del mínimo declarado y de que setup-r recibe la variable
de la matriz. Esto solo valida la configuración. No prueba disponibilidad
del entorno remoto, resolución de dependencias ni compatibilidad con R 4.1.0.

No hay instalación local de R 4.1.0; se observaron R 4.4.2, 4.5.0 y 4.6.1.
No se ejecutaron acciones remotas, no se hizo push y no se cambiaron
DESCRIPTION ni versiones de dependencias. La primera ejecución remota
deberá revisarse antes de declarar validada la compatibilidad mínima.

## Ejecución remota posterior autorizada

El usuario autorizó publicar la rama y ejecutar CI. Se hizo push normal
de `audit/0.2.0-precran` a `origin`, sin modificar la rama principal.
Commit probado: `d57e56bfb514ff2ded54bee44295905a53b2f96b`.

Ejecución del 16 de octubre de 2026:
https://github.com/JulianFajardo1908/tidyactuarial/actions/runs/38972898289

| Entorno | R observado en el log | Job | Resultado |
|---|---|---|---|
| Ubuntu, release | 4.6.1 | 117215302148 | success; Status: OK |
| Windows, release | 4.6.1 | 117215302096 | success; Status: OK |
| macOS ARM64, release | 4.6.1 | 117215301804 | success; Status: OK |
| Ubuntu, mínimo declarado | 4.1.0 (2021-05-18) | 117215302334 | success; Status: OK |

Los cuatro jobs terminaron aprobados. Se leyeron sus logs completos para
confirmar la versión de R y `Status: OK`. Pasaron las fases de ejemplos,
pruebas instaladas y reconstrucción de viñetas. No hubo fallos que
requirieran cambios de código o de dependencias.

Alcance: esta ejecución valida el paquete con las dependencias resueltas
por esos runners; no todas las versiones históricas de sus dependencias.
Los checks usan `--no-manual --as-cran` y el entorno estándar de la acción
(`NOT_CRAN=true`). No equivalen a recepción remota de CRAN ni prueban el
manual con índice. El mínimo se verificó en Ubuntu, no en los tres sistemas.

Resumen durable con IDs y extractos de los logs:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a146a8-108d-79a3-a021-fdc08295e29e/ci-run-38972898289.json`.

Las secciones anteriores conservan el estado histórico de preparación.
Esta sección reemplaza su pendiente de ejecución de CI. El registro se
guarda en un commit documental local posterior al commit probado; no se
presenta ese commit documental como una nueva ejecución de la matriz.
