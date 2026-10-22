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

## B07-04: anualidades y reversiones fraccionarias (21 de octubre de 2026)

Base 61fa813, Git limpio, misma rama audit/0.2.0-precran y versión
0.1.6.9000. Se sigue el orden solicitado: después de seguros por estados,
annuity_xy y sus relaciones; no se reabren las correcciones anteriores.

### Modelo e identidades

Ambas vidas están vivas e independientes en emisión. En una fecha t, los
estados 11/10/01 tienen probabilidades SxSy, SxQy, QxSy, con Q acumulada
de muerte. El pago esperado es w(t)=b11*SxSy+b10*SxQy+b01*QxSy.
Los b pueden tener signo; w no es en general una probabilidad. Para una
reversión designada a y se usa b=(0,0,1), para cualquiera de los supervivientes
únicos (0,1,1), y para joint-and-survivor b=(1,alpha,alpha). No se cambia
el significado histórico de reversionary en annuity_multi ni se añade un tipo.

La renta exacta anualizada vale sum(j) exp(-g*(h+j/k))*w(h+j/k)/k,
j=0..nk-1 due y j=1..nk immediate. h es entero y n puede ser fraccionario
con nk entero. La identidad de reversión a y = renta y - renta conjunta
se conserva, pero no se usa esa resta para calcular eventos diminutos.

Con F(t)=exp(-gt)w(t), Woolhouse first resta (1-1/k)(F(h)-F(h+n))/2
a la renta anual due. Second resta además (1-1/k^2)/12 por
[(g+eta(h))F(h)-(g+eta(h+n))F(h+n)]. eta(t)=-log(w(t+1)/w(t)) es una
estimación anual hacia adelante, no la fuerza instantánea exacta. Immediate
resta (F(h)-F(h+n))/k. Ya existían ambos extremos temporales: no se presenta
esa fórmula previamente correcta como hallazgo nuevo de esta unidad.

### Defectos reproducidos y cambios

lx=(1e16,1e16-2,0), otra vida con supervivencia uno el primer año, beneficio
revertido a y de 1e16, i=0,n=1: devolvía 2.220446 frente a 2. A medio año,
el error se amplificaba por restar 1-S redondeada. Una supervivencia 1e-400
multiplicada por beneficio 1e300 daba cero en lugar de 1e-100. Force=720
rechazaba una tasa válida porque su efectivo equivalente desbordaba; force
negativa grande podía redondear ese equivalente a -1. Con una cohorte
extinguida desde el primer año, i=-.9999999999999999 y n=100 daba NaN por
0*Inf, frente a cero. diagnosis.log, before-final.log y zero-discount-probe.log
conservan reproducciones sobre 61fa813 y el contraste corregido.

Corrección A: helper privado utils-two-life-annuity.R reutiliza la base de
pagos fraccionarios de B06 y calcula Q(t) como decremento acumulado directo
de lx más la masa fraccionaria del año actual. No resta supervivencia de uno.
Conserva logs de los tres estados hasta combinarlos con beneficio firmado,
descuento y división por k; los estados imposibles son ceros exactos. Se
reutilizan .interest_basis y los helpers monetarios existentes. Se comprueban
tablas anuales compatibles, edades, grillas finitas/representables y límites
integer; m/h/k/n grandes conservan double redondeado cuando procede, sin NA
por coerción. No se altera el motor de seguros ni otras funciones cerradas.

C15 autorizada expresamente antes de implementar: second exige pesos
positivos y soporte del año siguiente en ambos bordes. Antes, con tabla
lx=100 exp(-.2j), j=0:2, joint, i=.05,n=2,k=2,due/CF, suponía fuerza cero
al final sin datos y daba 1.463482 frente a 1.473671 con el modelo analítico
extendido. Ahora da un error recomendando none/first si no se aporta soporte.
No se extiende la aprobación C12 de annuity_multi por analogía. Se advierten
aproximaciones negativas sin recortarlas, y no se amplía Woolhouse a beneficios
por estados. Documentación aclara ocupaciones, pagos y estimación de fuerza.

### Evidencia y compatibilidad

95 comprobaciones nuevas en test-b07-annuity-precision.R: seis de reversiones
diminutas anuales/fraccionarias con UDD/CF/Balducci, cuatro de rango monetario,
tasa original y signos, 17 de fórmulas Woolhouse/bordes, cinco de tablas/grillas,
60 sumas de pagos independientes con tres interpolaciones, dos frecuencias,
dos calendarios y cinco beneficios, y tres de aproximación negativa/exacta.
Se reutilizan las 46 conexiones independientes de B07-03 y pruebas previas.
Contra la base, el archivo final da 10 fallos, dos errores y 78 aprobadas;
los errores detienen los bloques de extremos y grillas antes de completar
sus aserciones. Son errores originales, no resultados aprobados u omitidos.
El probe adicional verifica con aserciones el NaN previo y cero corregido.

72 objetos tidy ordinarios completos concuerdan con 61fa813 a tolerancia
1e-12; firma idéntica, columnas/aliases/clases y herencias preservados.
Beneficios son pesos por estado, no escenarios. No hay nuevos parámetros,
dependencias, columnas ni versión. Artefactos en b07-04 del directorio de
la sesión: compatibility.R, before.log, before-final.log, diagnosis.log,
zero-discount-probe.log, final-tests.log y build/check/snapshot. Validación
definitiva y huella se registran en audit-precran-check.md.

### Límites preservados y continuación

Se conserva el horizonte anterior de annuity_xy y la truncación de cada
marginal abierta a cero más allá de su última edad; no es observación de
muerte y puede afectar estados last/reversiones después del horizonte más
corto. La documentación lo explicita; extender o cambiar esa convención
requiere otra decisión, no se aplica C13 del seguro automáticamente. n=Inf
es horizonte disponible, no promesa de cobertura hasta extinción. n=0 conserva
APV y esquema de renta vacía. No se promete vectorización universal, fuerzas
instantáneas exactas ni cancelación arbitraria de infinitos con factores
distintos. Las entradas frac malformadas y modelos dependientes no se certifican.

Estado B07-04: confirmado, implementado, probado y cerrado dentro del alcance
documentado. Suite fuente/instalada: 5825 aprobadas, sin fallos/advertencias/
omisiones; build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo.
Ejemplos y cuatro viñetas aprobados; 389 fuentes verificadas, huella y entorno
en audit-precran-check.md. Siguen premium_xy y reserve_xy, en particular dotal puro por diferencia,
primas fraccionarias extremas, equivalencia y reservas multestado. B07 sigue
abierto; también continúa pendiente precisión extrema propia de t_pxy/e_xy.

Preparación independiente de B07-05 durante el check: next-premium-diagnosis.log
reproduce premium_xy pure_endowment joint con lx=(1e16,2,0), i=0,n=1,
beneficio 1e16 y primas anuales due: devuelve 0 frente a 4e-16. La base de
primas es uno y la referencia es beneficio*(2/1e16)^2. Confirmado y pendiente
de implementación/pruebas en B07-05; no se presenta como corregido aquí.

## B07-05: primas y reservas multivida (21 de octubre de 2026)

Base c126ccb, Git limpio, misma rama audit/0.2.0-precran y versión
0.1.6.9000. Se retoma el dotal puro ya diagnosticado, sin reabrir B07-01/04,
ni los condicionamientos y recursión multestado previamente corregidos.

### Identidades y condicionamiento

Para T=h+n, dotal puro desde emisión: B exp(-gT)S_status(T). No se paga
por muerte. La prima anualizada satisface P*a=B_APV, donde a paga 1/k en
cada fecha elegible; cada cuota monetaria es P/k. El inicio de primas issue
o deferred determina el origen 0 o h; n_prem puede ser fraccionario alineado.
Se mantiene el estado contractual de prima joint/last seleccionado.

La reserva prospectiva a t es APV_t(beneficios)-APV_t(primas), condicionada
a AMBAS vidas vivas en t, como antes. Last no significa un superviviente
observado desconocido. Dotal puro usa entonces las tablas desde x+t,y+t;
en cambio, al valorar desde emisión conserva la mezcla de estados tras h.

Para la recursión conjunta antes de prima:
V11(t)=v[p_x p_y V11(t+1)+(q_x+p_x q_y)B_t]-P_t.
Para last se conserva:
V11(t)=v[p_xp_y V11'+p_xq_y V10'+q_xp_y V01'+q_xq_y B_t]-P_t;
V10(t)=v[p_x V10'+q_x B_t]-P_t y análoga para V01. B_t=0 en dotal puro.
Las condiciones terminales existentes son B para dotales/dotales puros y
cero para temporal/whole; el valor prospectivo terminal mantiene su convención.
No se añade un estado inicial observado 10/01 ni se amplían restricciones:
recursive sigue h=0,k=1,due,issue. La prima nula hace exactamente cero la
obligación de primas, aunque su factor unitario no sea representable.

### Defectos demostrados y diff

Con lx=(1e16,2,0), i=0, joint,n=1,B=1e16, el APV dotal puro es 4e-16.
premium_xy y reserve_xy con P=0 daban cero al restar endowment-term. La
corrección A añade un helper privado de supervivencia monetaria en
utils-two-life-insurance.R, compartido por ambos consumidores. Reutiliza
la base anual por estados, valida horizonte y tasa original y combina
supervivencia, descuento e importe en log; no añade un tipo público nuevo.

La recursión conjunta hacia adelante cancelaba flujos casi iguales antes de
dividir por una supervivencia pequeña: con esa tabla, term n=2,B=1e16,P=0,
V(1) daba cero frente a 1e16. Se aplica la misma identidad hacia atrás, sin
dividir por probabilidades pequeñas ni forzar la curva desde un saldo de
emisión redondeado. Last conserva 11/10/01 y su algoritmo hacia atrás.
Ambas recursiones usan p y q directos de lx, no q=1-p, y log interest
original, evitando equivalentes anuales desbordados/redondeados a -1.
Cada transición pondera antes de exponenciar y omite estados imposibles.

Force=720 producía reservas last cero cuando el importe descontado era
representable; las probabilidades de muerte diminutas también se perdían.
Con P=0, n=20, force=-40, B=1e-300 y supervivencia uno hasta madurez, se
rechazaba una reserva 2.726375e47 porque se intentaba valorar una anualidad
unitaria de primas infinita. Ahora no se evalúa ese componente nulo.
zero-premium-before.log conserva la reproducción antes de esta corrección
adicional; se reconstruyó y revalidó el archivo final después de añadirla.

Se preservan enteros ordinarios, usando double redondeado para m/h/k/n
fuera del rango integer. Se rechazan grillas n_prem*k no finitas, edades y
t no representables y tablas anuales incompatibles incluso si solo se pide
el valor terminal. No se uniforman controles check/tol ni políticas n=0.

### C16 autorizada y calendarios

El usuario autorizó expresamente incluir la prima vencida programada en t,
para cumplir reserva ANTES de prima. Antes, annuity immediate desde t
omitía esa cuota. Con lx=(100,80,40,0), i=.05,joint,term n=2,B=100,P=10,
k=1,t=1 daba 69.04762 frente a 59.04762 por libro antes de prima.
En la vía prospectiva se añade P/k si timing=immediate, t>inicio y t<=fin
de primas. Como t e inicio son enteros y k entero, esas son precisamente
las fechas originales elegibles; no se inventa otro calendario. Esto incluye
la última cuota en madurez si existe. El futuro conserva none/first/second;
la cuota actual es exacta. No se extiende la recursión ni se cambia P anualizada.

### Evidencia y compatibilidad

test-b07-premium-reserve-precision.R añade 142 comprobaciones: seis de dotal
puro pequeño/rango, dos de prima cero y factor no representable, siete de
recursión/rates/decrementos, 25 de C16 incluyendo período de primas fraccionario,
96 de libros UDD independientes con joint/last, k=1/2/4, h=0/1 e inicios
issue/deferred, y seis de almacenamiento/tabla/grillas. Las referencias usan
conteos, interpolación y sumas de fechas; no invocan seguros/anualidades del
paquete para construir el valor esperado. Se conservan regresiones multestado
anteriores y las conexiones de B07-03/04.

before-final.log contra c126ccb muestra 33 fallos, tres errores y una
advertencia; 99 comprobaciones válidas ya pasaban. Los errores detienen
bloques antes de completar sus aserciones, no se cuentan como aprobados.
136 resultados completos ordinarios concuerdan a tolerancia 1e-12, incluidas
primas, reservas prospectivas/recursivas, tablas y formato audit. Dos firmas
idénticas, columnas/aliases/clases preservados. Cambian C16 y los extremos
numéricos demostrados; no hay nuevas dependencias ni versión.

Artefactos en b07-05 del directorio de la sesión: before.log, diagnosis.log,
before-final.log, compatibility.R, zero-premium-before.log, final-tests.log,
build/check/snapshot. initial-tests.log (5965 comprobaciones) y
draft-before-zero-premium.tar.gz se conservan como borrador anterior al último
fix; no son evidencia del código final. domain-before.log comprueba además
el rechazo de tablas incompatibles que antes se aceptaban al pedir solo
la reserva terminal. Validación definitiva y huella en audit-precran-check.md.
B07-05 confirmado, implementado, probado y cerrado en su alcance: suite
fuente/instalada 5967 aprobadas, sin fallos/advertencias/omisiones; build/check
salida 0, 0 ERROR, 0 WARNING y 1 NOTE por desarrollo. Ejemplos y cuatro viñetas
aprobados, 390 fuentes verificadas. B07 completo todavía no está cerrado.

### Límites y continuación

Una póliza por llamada, primas anuales/fraccionarias según API existente y
reserva en duraciones enteras desde el estado 11. No se amplían estados
observados, recursión subanual/diferida ni casos cero autorizados en otras
funciones. Para primas no nulas se sigue requiriendo APV de la anualidad
positivo, finito y representable: no se promete recuperar cualquier cociente
de dos APV fuera del rango double. Tampoco se recupera en general una
reserva condicional intermedia infinita multiplicada por probabilidad diminuta;
la valoración prospectiva puede ser preferible en esos casos.
Se conservan restricciones de horizonte, tratamiento de tablas abiertas y
condiciones terminales anteriores salvo la cuota C16 explícitamente autorizada.

B07 sigue abierto: conciliar inventario y límites de las seis funciones,
extremos de t_pxy/e_xy y los cocientes de equivalencia fuera de rango antes
de declarar cierre integral. No se presenta este subconjunto como máxima
generalidad ni como auditoría externa conciliada.

## B07-06: supervivencia extrema y conciliación de los seis nombres (21 de octubre)

Base 4b0948e, Git limpio al iniciar, rama audit/0.2.0-precran y versión
0.1.6.9000 verificadas. Se conservan B07-01/05, las decisiones C13-C16 y
las correcciones anteriores; no se introduce una nueva decisión C.

### Defectos reproducidos, matemática y corrección A

Con lx=(1,1e-200), x=y=60, CF y t=.5, t_pxy devolvía cero frente a
1e-200. El decremento q redondea a uno; reconstruir p=1-q pierde la
supervivencia anual observada. e_xy complete hasta un año devolvía cero
frente a 1/(400*log(10))=0.001085736. Bajo Balducci también devolvía cero
frente a 1e-200 para la esperanza conjunta. La cuadratura adaptativa no
es una garantía relativa para áreas diminutas o concentradas en el origen.
quadrature-probe.log aísla este segundo defecto con probabilidades ya
estables: para p=1e-20, integrar (p/(p+(1-p)u))^2 devuelve 2.754484e-37
frente al área analítica 1e-20. No se atribuye todo el error a p=1-q.
diagnosis.log conserva estos valores previos (su primer lanzamiento tuvo
advertencias regionales de arranque; las validaciones usan locale C).

La base privada usa .life_payment_basis ya existente, con lx observado y
log supervivencia; no recupera p restando q de uno. Se prepara una vez por
escenario de e_xy. Last se calcula como max(px,py)+(1-max(px,py))*min(px,py).
Se conservan t=0, NA inicial, truncación y controles públicos. Las columnas
px/qx siguen comprobándose con tolerancia 1e-10; las razones lx determinan
la interpolación, como en las valoraciones por estados revisadas antes.

La integral anual usa b en (0,1], supervivencias desde emisión Ax,Ay y
probabilidades anuales px,py, qx,qy. Las áreas condicionales conjuntas son:

* UDD: b-(qx+qy)b^2/2+qx*qy*b^3/3.
* CF: -expm1(b*(log(px)+log(py)))/(-log(px)-log(py)), con límites
  b si ambas supervivencias son uno y cero si alguna es cero.
* Balducci: para p1<=p2, b*p2/(p2+q2*b)*log1p(r)/r,
  r=b*(p2-p1)/(p1*(p2+q2*b)); el límite r=0 es uno.

El área conjunta se multiplica por Ax*Ay en log. Last es la suma de las
dos áreas marginales menos la conjunta. Para Balducci, la marginal es
p/q*log1p(q*b/p), y para p=0 tiene área cero. Diferencias y cocientes de
Balducci se evalúan en log, incluso si r o p2/p1 no caben en double;
se usa el límite de CF cuando b*log(p) subdesborda. No hay integración
numérica, extrapolación ni mortalidad terminal inventada.

### Evidencia y compatibilidad

test-b07-survival-precision.R incorpora 189 comprobaciones: 125 sobre
supervivencia/áreas extremas, tablas con razones anuales que subdesbordan,
CF/Balducci, vidas desiguales, fuerzas nulas y cero supervivencia;
60 conexiones de los seis nombres con un libro anual independiente;
y cuatro comprobaciones de límites de truncación/equivalencia.
Los oráculos usan fórmulas exponenciales, integrales racionales de vidas
idénticas y cuadratura independiente solo para casos moderados desiguales.
Las comparaciones extremas se hacen relativamente; una tolerancia absoluta
no puede aceptar cero frente a una probabilidad diminuta positiva.

before-final.log contra 4b0948e: 74 fallos, cero errores/advertencias y
115 aprobadas. 138 resultados ordinarios completos concuerdan a 1e-12,
incluyendo tablas de salida; las seis firmas son idénticas. El inventario
mantiene 102 nombres (101 funciones más A_xj), 974 apariciones de parámetros
y el alias idéntico. No se agregan dependencias, columnas ni parámetros.
El primer libro de conciliación omitía timing="due" en una aserción de
annuity_xy (su default es immediate); se corrigió el test explícitamente.
initial-ledger-timing-tests.log es evidencia intermedia fallida, no la suite
final. La versión definitiva conserva las convenciones distintas de ambas.

### Conciliación final y límites del bloque

| Nombre | Modelo/estado y resultado conservado | Evidencia y límites |
|---|---|---|
| t_pxy | Probabilidad escalar desde ambas vidas vivas, independencia, una/dos tablas | Productos/unión y fracciones estables; t=0 conserva uno; truncación abierta |
| e_xy | Suma curtata o integral completa desde edades iniciales; escenarios sobre una tabla | Áreas analíticas; NA si inicio falta/extinto; esperanza truncada en tabla abierta |
| annuity_xy | Sumas 1/k de pesos 11/10/01, incluyendo reversiones designadas | Libros independientes UDD/CF/Balducci y extremos B07-03/04; Woolhouse aproximado/C15; límites de marginal abierta |
| insurance_xy | Masas anuales del primer/segundo fallecimiento desde emisión, no renovación en h | Enumeración de parejas de muertes y estados; C13/C14; sin seguro continuo ni k público |
| premium_xy | P anualizada, cuota P/k, equivalencia de una póliza | Libros de primas anuales/fraccionarias B07-03/05; requiere anualidad positiva finita representable |
| reserve_xy | Beneficios menos primas, estado 11 observado en t entero | Libros prospectivos y recursión 11/10/01; C16; recursión h=0,k=1,due,issue; no estados observados 10/01 públicos |

En los libros independientes se verifica A_term=1-d*a_due-v^n*S(n),
endowment=term+v^n*S(n), P*a=APV_beneficio y V(0)=0 con prima de
equivalencia. Se preservan los 46 contrastes B07-03 y las 96 valoraciones
independientes B07-05. No se usa la concordancia de dos motores del paquete
como única prueba. Bajo tablas abiertas las identidades con vida entera
requieren cierre: no extender C13 a rentas/probabilidades por analogía.
La etiqueta last no informa qué vida está observada viva a una duración.
No se certifican vidas dependientes, cocientes de APV no representables,
cancelación general de infinitos ni extrapolación biológica.

La conciliación detectó también el mismo defecto de complemento en t_px
y e_x, fuera de los seis nombres B07: con lx=(1,1e-200) dan cero frente
a 1e-100 a medio año CF y 0.002171472 de esperanza de un año, respectivamente.
single-life-followup.log lo verifica con aserciones. Esto es un defecto A
confirmado pendiente de suplemento B05, no una limitación actuarial aceptada
ni una corrección ya realizada. B07 usa su base log y no depende de esos
valores fallidos. Se preserva el cierre histórico B05, pero se abre este
pendiente específico antes de iniciar B08. No declarar conciliación extrema
de t_px/e_x hasta corregir y validar el suplemento.

Artefactos nuevos: b07-06 del directorio de la sesión. La validación final,
archivo fuente y huella se documentan en audit-precran-check.md.
Estado B07-06: confirmado, implementado, probado y cerrado en su alcance.
Suite fuente e instalada: 6156 aprobadas, cero fallos/advertencias/omisiones;
build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo. Ejemplos
y cuatro viñetas aprobados; 391 fuentes verificadas. B07 queda cerrado
dentro del alcance/límites explícitos de sus seis nombres, con 702
comprobaciones nuevas acumuladas desde B06. No equivale a cierre del
paquete ni del suplemento B05 recién confirmado. Próximo paso: corregir
t_px/e_x con regresiones propias antes de iniciar B08. Sin push ni versión.
