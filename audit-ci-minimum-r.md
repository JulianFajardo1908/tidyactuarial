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
