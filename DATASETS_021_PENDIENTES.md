# Datos pendientes fuera de 0.2.1

| Candidato | Impedimento y siguiente trabajo |
|---|---|
| WPP 2010/2019 y alcance mayor | Se prioriza 2023 para el paquete. Aplicar el mapeo por ID a otros años, con nueva verificación de cobertura, tamaño y períodos. |
| Colombia / invalidez (SFC) | La base instalada contiene seis tablas y se conservó. El [índice SFC](https://www.superfinanciera.gov.co/publicaciones/10103719/atencion-y-servicios-a-la-ciudadaniatramites-y-servicios-certificados-en-lineatablas-de-mortalidad-10103719/) identifica los actos 0996/1990, 1112/2007, 0110/2014, 1555/2010 y 0585/1994. Falta cotejo completo de anexos, población, unidad y autorización; el anexo de mortalidad de inválidos no es la incidencia de invalidez de activos. Para tasas por mil documentadas, convertir dividiendo por 1000. |
| TES emisiones / curvas | Se descargó el [XLSX original del 4 de noviembre](https://www.irc.gov.co/documents/d/guest/20261104-emisiones-vigentes?download=true); [Banrep](https://suameca.banrep.gov.co/descarga-multiple-de-datos/) identifica curvas cero cupón. Falta extracción verificada y permiso. Conciliar fechas, cupón y periodicidad, precio limpio/sucio, YTM versus spot y unidades COP/UVR antes de contrastar duración. |
| Perros y gatos | Las 78 transcripciones y 74 filas anuales truncadas del kit pasaron recuentos locales; verificaciones puntuales no sustituyen el cotejo íntegro. [Montoya (EE. UU.)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9989186/) usa CC BY; [perros UK](https://pmc.ncbi.nlm.nih.gov/articles/PMC9050668/), CC BY 4.0; [gatos UK](https://doi.org/10.1177/1098612X241234556), CC BY-NC 4.0. Separar fuentes y resolver permiso para distribución sin restricción comercial de la tabla de gatos UK. Conservar el qx publicado por estudio y marcar la última edad abierta. |
| DANE | Recuentos marginales del kit: 268.411 (2023), 275.778 (2024). No constituyen probabilidades. Falta cotejo externo/permiso de redistribución de marginales; para decrementos se necesita cruce edad-sexo-causa y exposición compatible. [Portal 2024](https://microdatos.dane.gov.co/index.php/catalog/878/get-microdata). |
| SFC 290 / Fasecolda | Pendientes originales, esquema y derechos de redistribución. Son agregados de negocio, no registros de frecuencia/severidad individual. Se conservan enlaces de fuente, sin republicar archivos. |
| SSA, EIOPA y triángulos | Futuro: revisar licencias y distinguir cohorte, curva normativa y desarrollo de siniestros antes de integrar. |

El [registro de fuentes](data-raw/sources-pending.csv) permite retomar las
descargas sin incorporar sus contenidos al paquete. Los originales WPP
son los únicos datos nuevos incorporados; los ejemplos externos no
copian observaciones.

Originales guardados para cotejo local, fuera de Git:

| Archivo | Bytes | SHA-256 |
|---|---:|---|
| TES 20261104 Emisiones Vigentes.xlsx | 98939 | `2327e46b2768f58dbd8259f17d35fd038e08d3bc2c5b5c625f03c7cea7de1fa3` |
| SFC Resolución 0585 (binario original del índice) | 8990208 | `3aa7df41506a0ff2b7a4e06bef7900e5b58af3c01b675ec3190733e43f45e784` |

Cotejos puntuales de mascotas: Montoya, perro US 17+: qx=0,4166;
Teng, perro UK 20+: qx=1 publicado; Teng, gato UK 20+: qx=0,524.
Las tres cifras coinciden con el kit y muestran por qué no procede
forzar el mismo cierre en todas las fuentes.
