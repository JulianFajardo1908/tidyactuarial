# B07 — contingencias multivida

## B07-01: herencia CML en probabilidades y esperanzas (21 de octubre de 2026)

Base 11eeb49, rama audit/0.2.0-precran, Git inicialmente limpio,
DESCRIPTION 0.1.6.9000; 15 commits sobre la referencia local upstream,
sin consultar servidor. Se leyeron el prompt maestro, AGENTS y los registros
de continuación, check, inventario, API, B06, Monte Carlo y seguro diferido.
Se preservan B06 y las correcciones previas de e_xy, insurance_xy y reserve_xy.

Modelo: dos vidas inicialmente vivas e independientes. t_pxy devuelve un
escalar S_joint(t)=S_x(t)S_y(t) o S_last(t)=S_x(t)+S_y(t)-S_x(t)S_y(t).
e_xy devuelve sum(k=1..floor(t)) S(k) para vida curtata y la integral de
S(u), u=0..t, para vida completa, con reciclaje paralelo escalar y tibble
opcional. Mantiene el condicionamiento desde emisión ya corregido, no
reinicia dos vidas después de la primera muerte. Conserva truncación al
horizonte registrado y NA para edades iniciales ausentes/extinguidas.

### Defecto confirmado y diff mínimo

Con lx(60+j)=100 exp(-.8j) y atributo frac="CML", t_pxy a medio año
producía .5251386 en lugar de exp(-.8)=.4493290. La esperanza conjunta
completa temporal de un año producía .5504085 en lugar de
(1-exp(-1.6))/1.6=.4988147. Son referencias analíticas independientes.
La selección heredada excluía CML y caía silenciosamente a UDD; en dos
tablas también podía ignorar un conflicto CML/Balducci.

Corrección A: normalizar CML a CF antes de resolver el atributo, tanto en
t_pxy como en e_xy. CF/CML son equivalentes, por lo que no constituyen
conflicto; CML/Balducci exige frac explícito. No cambia firmas, columnas,
reciclaje, convenciones cero, horizontes ni modelos de otras funciones.
La normalización coincide con el alias explícito ya documentado; no requiere
decisión C nueva ni amplía C02-C04. Se aclara la herencia en R/Rd/NEWS.

### Evidencia y límites

test-b07-fraction-inheritance.R: 26 comprobaciones independientes de joint,
last, edades diferentes, dos tablas exponenciales, tres duraciones, override
UDD, conflicto real y equivalencia de atributos, integral analítica,
esperanza curtata, reciclaje y columna frac canónica CF.
El mismo archivo definitivo contra las funciones de 11eeb49 reproduce
15 fallos y 11 aprobadas, sin errores. Después pasan las 26.

Artefactos en
C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0:
validate-b07.R, b07-before.log y b07-final-tests.log. b07-compatibility.log
acredita 48 resultados ordinarios completos idénticos a 11eeb49 (incluidos
tibbles y atributos) y dos firmas idénticas. La ejecución inicial
del entorno sin R_LIBS_USER falló al cargar pkgload; se corrigieron las
variables antes de iniciar R, sin instalar dependencias. La validación
definitiva de archivo/check se registra en audit-precran-check.md.

Impacto: cambian los resultados fraccionarios que heredaban CML y usaban
UDD por error; e_xy tidy etiqueta CF. Entradas con CF, UDD, Balducci o frac
explícito conservan su ruta de ejecución. Esta unidad no certifica dominio,
precisión extrema ni máxima generalidad de estas funciones. e_xy sigue
aceptando una tabla y t_pxy una o dos; no se uniforma esa API. Quedan por
revisar validación anual/mortal, coerción de edades, controles, bordes y
precisión de ambas funciones antes de anualidades, seguros, primas y reservas.

Estado B07-01: confirmado, implementado, probado y cerrado para herencia CML.
Suite fuente e instalada: 5480 aprobadas, sin fallos/advertencias/omisiones;
build/check definitivos salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo.
Ejemplos y cuatro viñetas aprobados; 382 archivos verificados contra checkout.
Huella y entorno en audit-precran-check.md. B07 permanece abierto.
