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

## B07-02: dominio anual y controles de supervivencia (21 de octubre de 2026)

Base 6969b2d, misma rama y versión, Git limpio antes de editar. Se preservan
B07-01 y las correcciones de condicionamiento ya registradas. Esta unidad
revisa t_pxy/e_xy y sus llamadas desde insurance_xy/reserve_xy; no cierra
todavía las cuatro valoraciones de contratos multivida.

### Matemática, causa y reproducción

Para una cohorte anual válida, lx es finito, no negativo y no creciente por
edad; para lx>0, px=lx_siguiente/lx y qx=(lx-lx_siguiente)/lx. Las edades
representan años consecutivos únicos. La supervivencia del estado no puede
aumentar con el tiempo. t_pxy delegaba en t_px(check=FALSE) sin validar esas
identidades. e_xy repetía la llamada y tampoco validaba la base anual.

b07-02-diagnosis.log, contra 6969b2d: lx=(100,110,0) daba t_pxy(1)=1 y
e_xy(t=1)=1 por el recorte del motor marginal. lx=(100,80,0), qx=(.9,1,NA)
daba S_joint(.5)=.3025 y S_joint(1)=.64: supervivencia creciente al combinar
dos bases contradictorias. Son defectos de dominio, no mortalidad inferida.

Las edades fuera del rango integer se convertían en NA con advertencia;
Inf podía provocar un if con valor ausente. e_xy aceptaba tidy=1 como FALSE
y tolerancias/controles inválidos sin diagnóstico específico.

### Diff acotado y compatibilidad

Corrección A: helper privado utils-two-life-survival.R valida tablas antes
de valorar: edades anuales únicas/consecutivas, lx finito/no negativo/no
creciente, px/qx en [0,1] o NA y consistencia absoluta 1e-10 con lx y entre
sí. La comparación usa el decremento directo, no 1-lx_siguiente/lx para qx.
Los campos después de extinción no se interpretan como probabilidades
condicionales observables; no se exige una razón 0/0. No se añade un año
terminal ni se imputa qx faltante. Las tablas desordenadas válidas funcionan.

El helper marginal compartido conserva exactamente las fórmulas anteriores
y t_px(check=FALSE); e_xy valida una vez, no en cada nodo de cuadratura.
No se modifica t_px ni se refactorizan los motores cerrados de B05/B06;
el helper de pagos requiere una vida inicial válida y no se usa aquí porque
alteraría la política existente de NA para estados iniciales desconocidos.
Se validan edades representables y duración finita en t_pxy; e_xy comprueba
rango de edades cuando check=TRUE y siempre controles lógicos y tol finito
no negativo. check=FALSE conserva su omisión de comprobaciones de edades y
duraciones; no autoriza una tabla contradictoria ni controles inválidos.
tol de edad no relaja consistencia mortal. Clarificaciones B en R/Rd/NEWS.

Sin cambios de firmas, columnas, reciclaje o dependencias; no hay decisión C
nueva. Se preservan t_pxy(t=0)=1 incluso con edad inicial ausente, su
truncación más allá de omega y e_xy=NA para edades ausentes/extinguidas,
incluso t=0. No se uniforman esas convenciones entre funciones. El rechazo
de datos incompatibles sustituye resultados antes plausibles pero sin modelo.

### Evidencia y límites

test-b07-survival-domain.R añade 62 comprobaciones: 33 rechazos de tablas,
17 de controles/edades y 12 de identidades UDD independientes, supervivencia,
esperanza curtata/completa, permutación de filas, NA y bordes preservados.
La ejecución previa produjo 33 fallos, un error en el bloque de controles
y cuatro advertencias; sus 12 comprobaciones de casos válidos ya pasaban.
La ejecución corregida pasa las 62 sin advertencias. Referencias esperadas
usan productos, sumas y la integral del polinomio UDD (1-.2u)(1-.5u), no
otro consumidor del mismo motor. Evidencia anterior B07-01/e_xy/seguros
diferidos/reservas multestado se conserva y se ejecuta con la suite completa.

Artefactos en el directorio de la sesión: b07-02-before.log,
b07-02-diagnosis.log y b07-02-final-tests.log. En subdirectorio b07-02,
compatibility.log verifica 48 objetos ordinarios completos idénticos a
6969b2d y dos firmas idénticas. Build, check y archivo final se registran en
audit-precran-check.md, sin reutilizar el check de B07-01.

Pendiente: precisión extrema marginal y de la cuadratura, atributos frac
malformados, evaluación integral de anualidades, seguros, primas y reservas.
Se preserva la truncación de tablas abiertas: no representa una esperanza
vitalicia completa ni certifica extrapolación. No se promete soporte de
edades fuera del rango integer, dependencia entre vidas o muertes continuas.
Estado B07-02: confirmado, implementado, probado y cerrado para dominio anual
y controles. Suite fuente/instalada: 5542 aprobadas, sin fallos/advertencias/
omisiones. Archivo de 384 fuentes verificado, build/check salida 0, 0 ERROR,
0 WARNING, 1 NOTE por desarrollo; ejemplos y cuatro viñetas aprobados. Huella,
entorno y pausa del check registrados en audit-precran-check.md. B07 sigue
abierto; no se declara revisada la precisión extrema ni el conjunto de seis
funciones por estas dos unidades.
