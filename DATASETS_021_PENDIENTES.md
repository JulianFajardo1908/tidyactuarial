# Datos pendientes fuera de 0.2.1

**Alcance de 0.2.1 cerrado el 7 de noviembre de 2026:** se incluyen los
dos objetos nuevos WPP y mascotas que ya superaron fuente, licencia y
cotejo. Los candidatos de esta lista se desplazan a 0.2.2 o a una entrega
posterior; no bloquean la revisión de 0.2.1 ni se publican incompletos.
La autorización del usuario para integrarlos no sustituye los términos
de los titulares ni la verificación del original correspondiente.

| Candidato | Impedimento y siguiente trabajo |
|---|---|
| WPP 2010/2019 y alcance mayor | Se prioriza 2023 para el paquete. Aplicar el mapeo por ID a otros años, con nueva verificación de cobertura, tamaño y períodos. |
| Colombia / invalidez (SFC) | La base instalada contiene seis tablas y se conservó. El [índice SFC](https://www.superfinanciera.gov.co/publicaciones/10103719/atencion-y-servicios-a-la-ciudadaniatramites-y-servicios-certificados-en-lineatablas-de-mortalidad-10103719/) identifica los actos 0996/1990, 1112/2007, 0110/2014, 1555/2010 y 0585/1994. Falta cotejo completo de anexos, población, unidad y autorización; el anexo de mortalidad de inválidos no es la incidencia de invalidez de activos. Para tasas por mil documentadas, convertir dividiendo por 1000. |
| TES emisiones / curvas | Se descargó el [XLSX original del 4 de noviembre](https://www.irc.gov.co/documents/d/guest/20261104-emisiones-vigentes?download=true); [Banrep](https://suameca.banrep.gov.co/descarga-multiple-de-datos/) identifica curvas cero cupón. Falta extracción verificada y permiso. Conciliar fechas, cupón y periodicidad, precio limpio/sucio, YTM versus spot y unidades COP/UVR antes de contrastar duración. |
| Gatos Reino Unido y tabla derivada de mascotas | Las tres tablas con CC BY 4.0 se integraron tras cotejo íntegro. La tabla de [gatos UK](https://doi.org/10.1177/1098612X241234556) usa CC BY-NC 4.0; para distribuirla sin restricción comercial se necesita permiso o una fuente alternativa. La tabla derivada de 74 filas no es una tabla completa ni se incluye. |
| DANE | Recuentos marginales del kit: 268.411 (2023), 275.778 (2024). No constituyen probabilidades. Falta cotejo externo/permiso de redistribución de marginales; para decrementos se necesita cruce edad-sexo-causa y exposición compatible. [Portal 2024](https://microdatos.dane.gov.co/index.php/catalog/878/get-microdata). |
| SFC 290 / Fasecolda | Pendientes originales, esquema y derechos de redistribución. Son agregados de negocio, no registros de frecuencia/severidad individual. Se conservan enlaces de fuente, sin republicar archivos. |
| SSA, EIOPA y triángulos | Futuro: revisar licencias y distinguir cohorte, curva normativa y desarrollo de siniestros antes de integrar. |

El [registro de fuentes](data-raw/sources-pending.csv) permite retomar las
descargas sin incorporar sus contenidos al paquete. Se incluyen la
selección WPP y las tres tablas de mascotas con CC BY 4.0; los ejemplos
externos no copian observaciones.

El [catálogo de datos abiertos de MinHacienda](https://www.minhacienda.gov.co/web/portal/transparencia/datos-abiertos/seccion-datos-abiertos)
indica CC BY-SA 4.0 para sus conjuntos de datos abiertos, pero no se
identificó una ficha que aplique esa licencia al XLSX específico del
IRC. El [aviso de Banrep](https://www.banrep.gov.co/es/aviso-legal)
distingue reproducción sin modificación de otras reutilizaciones.
La [licencia abierta de SFC](https://www.superfinanciera.gov.co/publicaciones/10116019/licencia-abierta-y-condiciones-de-uso-para-datos-abiertos/)
aplica a sus datos abiertos, sin cotejo todavía con los anexos ni
el reporte específico. Los [términos de DANE](https://www.dane.gov.co/index.php/servicios-al-ciudadano/tramites/transparencia-y-acceso-a-la-informacion-publica/terminos-y-condiciones)
permiten uso y transformación con cita; no se verificó una licencia
de redistribución para el extracto del kit. Los [totales definitivos](https://www.dane.gov.co/files/operaciones/EEVV/2026/6-feb-2026/bol-EEVV-Isem2025pr.pdf)
sí coinciden con los dos totales anotados; eso no valida cada marginal
ni provee exposición.

Originales guardados para cotejo local, fuera de Git:

| Archivo | Bytes | SHA-256 |
|---|---:|---|
| TES 20261104 Emisiones Vigentes.xlsx | 98939 | `2327e46b2768f58dbd8259f17d35fd038e08d3bc2c5b5c625f03c7cea7de1fa3` |
| SFC Resolución 0585 (binario original del índice) | 8990208 | `3aa7df41506a0ff2b7a4e06bef7900e5b58af3c01b675ec3190733e43f45e784` |

Cotejos puntuales de mascotas: Montoya, perro US 17+: qx=0,4166;
Teng, perro UK 20+: qx=1 publicado; Teng, gato UK 20+: qx=0,524.
Las tres cifras coinciden con el kit y muestran por qué no procede
forzar el mismo cierre en todas las fuentes.
