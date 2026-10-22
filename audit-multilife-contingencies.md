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

## B07-03: seguros por estados y relaciones conectadas (21 de octubre de 2026)

Base 161cc3b, Git limpio, audit/0.2.0-precran y 0.1.6.9000 verificados.
El usuario cambió expresamente el orden: insurance_xy primero, después
relaciones con anualidades incluidas reversionarias, primas y reservas.
Se preservan la corrección del seguro diferido y la recursión multestado.

### Modelo y todos los estados

Insurance_xy recibe ambas vidas vivas (11), independientes. 10 significa
solo x viva, 01 solo y viva, 00 ninguna. No recibe un estado observado inicial
10/01; una etiqueta last no lo identifica. Con Sx,Sy y Qx=1-Sx,Qy=1-Sy,
las masas de ocupación son SxSy, SxQy, QxSy y QxQy. No son beneficios.

Desde 11, las transiciones anuales tienen pesos px*py, px*qy, qx*py y qx*qy.
Desde 10 continúan px o salen qx; desde 01 continúan py o salen qy; 00 es
absorbente. Joint paga una vez al salir de 11; last paga al entrar en 00,
incluida la salida 11->00 por ambas muertes en el mismo intervalo anual.
No se observa el orden intranual ni se paga al instante exacto de muerte.

Sean Dx(t),Dy(t) masas marginales de muerte en (t,t+1] desde emisión.
La masa de primer fallecimiento es Dx(t)Sy(t)+Sx(t+1)Dy(t), suma disjunta.
La de segundo es Dx(t)Qy(t)+Qx(t)Dy(t)+Dx(t)Dy(t), desde 10,01,11.
APV temporal = B sum(t=h..h+n-1) exp(-g(t+1))*masa(t). Dotal añade
B exp(-g(h+n))*S_status(h+n). Whole extiende hasta extinción observada.
El diferimiento excluye muertes desencadenantes anteriores o en h; no
reinicia ambas vidas en h, particularmente en last. Las columnas existentes
de anualidad/madurez siguen condicionadas en S_status(h)>0, no en 11 en h.

### Defectos, decisiones y diff

Con lx=(1e16,1e16-2,0) y otra vida que sobrevive el primer año, i=0,
B=1e16, term n=1 daba 2.220446 en vez de 2. Con ambas tablas iguales,
last y B=1e32 daba 0 en vez de 4. Con i=1e20 un temporal podía dar APV
negativo por cancelar 1-d*a-v^n*S(n). Tasas originales muy altas y/o
supervivencia subdesbordada convertían prestaciones representables en cero.

Corrección A: insurance_xy suma las masas disjuntas directamente. Helper
privado utils-two-life-insurance.R calcula supervivencia, muerte acumulada
y decrementos desde lx, y combina en log con la tasa original y el beneficio.
El beneficio monetario se valora directamente, no multiplicando una APV
unitaria ya subdesbordada. La columna unitaria puede ser cero aunque el APV
monetario sea representable; no se inventan dígitos en esa columna. La
anualidad de auditoría se obtiene por sumas condicionales independientes,
no invocando annuity_xy como motor del seguro. No cambian firmas/columnas.
Se conserva el tipo integer ordinario y double redondeado para m/h/n grandes,
evitando coerción NA; x/y deben caber en integer. CML heredado normaliza a CF.

C13 autorizada expresamente por el usuario tras explicar la implicación:
whole con supervivencia residual no fuerza un pago terminal al final de
una tabla abierta. Ahora exige extinción observada del estado. Joint admite
que una marginal cierre mientras la otra siga abierta si la extinción
conjunta está soportada; last requiere ambas marginales cerradas. En tablas
abiertas lx=(100,80,60), last a i=0 devolvía 1 pese a que .84 era saldo
superviviente. Ahora whole da error, term n=2 da .16 y endowment n=2 da 1.
No se extrapola un intervalo de una marginal abierta más corta. La muerte
terminal desconocida no es una prestación dotal.

C14 autorizada expresamente: endowment n=0 paga B exp(-gh)S(h), term n=0
conserva cero. Se preservan columnas y survival_to_maturity=1 condicionado
en h. No se extiende C10 por analogía; se obtuvo autorización específica.

### Pruebas independientes y relaciones posteriores

test-b07-insurance-states.R tiene 142 comprobaciones: 108 comparaciones de
APV/columna unitaria con enumeración de parejas de años de muerte (ambas
tablas cerradas, edades diferentes, tipos, estados, h=0:2 y tasas positivas,
cero/negativas); seis extremos numéricos; ocho trayectorias deterministas
11->01->00, 11->10->00 y 11->00; trece bordes C14 y siete C13/horizontes.
El archivo final contra 161cc3b reproduce 17 fallos y 125 aprobadas sin errores
(before-final.log). La reproducción inicial antes de ampliar C13/C14 fue
cinco fallos numéricos, preservada en before.log. No se cuenta como nuevo
el condicionamiento corregido el 16 de octubre: su regresión sigue pasando.

test-b07-linked-valuations.R aporta 46 comprobaciones adicionales. Para
pagos k=1,2,4 y due/immediate, una interpolación lineal UDD propia construye
los flujos 11,10,01. Se verifica la reversión a y como renta sobre y menos
conjunta y last como suma de los tres estados. Esto distingue reversión
designada, superviviente único y joint-and-survivor; no se cambia la etiqueta
histórica reversionary de annuity_multi. No se añade una renta nueva.

Un libro independiente de muertes y pagos verifica primas anualizadas para
k=1,2 y reservas desde ambas vidas vivas a t=0:2. Prospectiva y recursiva se
comparan con el libro para primas anuales; con primas semestrales se comprueba
prospectiva según soporte vigente. La recursión de last conserva 11/10/01;
no se sustituye por una continuidad escalar. Ninguna prueba usa el seguro o
la anualidad del paquete para construir su referencia monetaria esperada.
36 resultados tidy ordinarios concuerdan con 161cc3b a tolerancia 1e-12,
incluidas clases, columnas, aliases y condicionamientos; firma idéntica.

Artefactos en el subdirectorio b07-03 de la sesión: before.log,
before-final.log, compatibility.R, final-tests.log, build/check/snapshot.
Los artefactos B07-01/02 se conservan. Validación definitiva y huella en
audit-precran-check.md, sin reutilizar checks anteriores.

### Límites y continuación

Insurance_xy soporta whole/term/endowment anuales, dos vidas independientes,
edad/h enteros, un beneficio escalar no negativo y una póliza por llamada.
No tiene k ni type=pure_endowment; premium_xy/reserve_xy construyen el dotal
puro por diferencia de seguros, pendiente de estabilidad extrema propia.
No admite un estado observado inicial 10/01, dependencia estocástica ni pago
al momento de muerte. No se agregan parámetros para suplir esas limitaciones.
Los campos de auditoría no se prometen finitos si su verdadero valor excede
double, aunque el APV monetario final sea representable.

Estas relaciones ordinarias no cierran todavía annuity_xy, premium_xy ni
reserve_xy: siguen Woolhouse, generalidad numérica de pagos/beneficios por
estado, dotales puros por diferencia, primas fraccionarias extremas y reservas
fuera del subconjunto contrastado. También sigue la precisión extrema de
t_pxy/e_xy. Estado B07-03: confirmado, implementado, probado y cerrado dentro
del alcance documentado. Suite fuente e instalada: 5730 aprobadas, sin fallos,
advertencias u omisiones; check salida 0, 0 ERROR, 0 WARNING y 1 NOTE por
versión de desarrollo. Ejemplos y cuatro viñetas aprobados; archivo de 387
fuentes verificado y huella/entorno en audit-precran-check.md. B07 continúa
abierto y las comprobaciones conectadas no cierran sus otros consumidores.
