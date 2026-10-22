# B08 — simulación de vidas y Monte Carlo

## Inicio y alcance (22 de octubre de 2026)

El usuario pidió pasar a B08. Base c7a0d29, Git inicialmente limpio,
rama audit/0.2.0-precran y versión 0.1.6.9000 verificadas. B07 conserva su
cierre documentado. El suplemento B05 t_px/e_x sigue confirmado y pendiente;
cambiar el orden de trabajo no lo corrige ni lo elimina. Se preserva el
registro anterior audit-multilife-monte-carlo.md y sus regresiones de RNG,
fracciones CML, vidas faltantes, calendarios y coherencia K/T.

| Nombre | Modelo/contrato a conciliar | Estado actual |
|---|---|---|
| simulate_lifetime | PMF anual de K y fracción condicional de muerte; tabla qx | B08-01: precisión y validación puntual corregidas/probadas; revisión integral abierta |
| simulate_lifetimes | Vidas independientes; una corriente RNG por llamada; precedencia qx/px/lx | B08-01: radix/decrementos y validación puntual corregidos/probados; revisión integral abierta |
| mc_multilife_status | Min/max de K y T; mismos identificadores de vidas por simulación | B08-02: C17 y conservación de estados/almacenamiento/columnas probadas; límites abajo |
| simulate_annuity_x | Valor presente de pagos por trayectoria; motor lx propio | B08-03: motor lx, valoración monetaria, calendario y RNG comprobados; límites abajo |
| simulate_insurance_x | Seguro anual por trayectoria; motor lx propio | B08-03: masas, censura, valoración monetaria y RNG comprobados; límites abajo |
| mc_annuity | Pagos elegibles por trayectoria, garantías, diferimientos y NA | B08-04: calendarios/NA/RNG y valoración monetaria comprobados; límites abajo |
| mc_insurance | Evento y momento del beneficio por trayectoria | B08-04: seis tipos, tasas originales y C18 autorizada comprobados; límites abajo |
| mc_premium | Cociente de medias de pares Z,Y; prima anualizada/cuota | Precisión de conversión confirmada y pendiente; revisar integralmente en B08-05 |
| mc_loss | Z menos prima en la unidad de Y | Precisión de conversión confirmada y pendiente; revisar integralmente en B08-05 |
| mc_reserve | Flujos futuros por trayectoria; antes/después de pago; vigencia | Pendiente; preservar calendarios y NA ya corregidos |
| summary_mc | Momentos, error estándar, cuantiles y colas empíricas | Pendiente; preservar TVaR empírica ya corregida |

## B08-04 — valoración por trayectoria y C18 (22 de octubre de 2026)

Base 692477d, Git limpio al comenzar, rama audit/0.2.0-precran y versión
0.1.6.9000 conservadas. Se concilian primero las correcciones existentes de
audit-multilife-monte-carlo.md: NA, garantía con T=0, retícula h+j/k,
fronteras exactas de supervivencia y pares K/T. No se rehacen ni deshacen.

### Matemática y causa raíz

Para una trayectoria observada, Y=c*sum(exp(-g*t_j)) en fechas elegibles;
Z=b*exp(-g*t) si ocurre el evento, cero si no ocurre, NA si falta la vida
requerida. g proviene de la tasa original: log1p(i) efectiva, m*log1p(i/m)
nominal interés, -m*log1p(-i/m) nominal descuento, fuerza directamente.
Ambos consumidores exigían efectiva anual finita >-1 antes de valorar.
Fuerza 720 y b=1e300, muerte de fin de año uno: el flujo finito es
exp(log(1e300)-720)=2.032231e-13, pero se rechazaba. La renta fraccionaria
con pago en .5 también tenía valor finito 4.508027e143 y era rechazada.

Diff acotado: usar .interest_basis y helpers monetarios existentes, sin
cambiar .mc_effective_rate compartido ni calendarios. Los factores log de
fechas cero se fijan en cero antes de multiplicar, incluso si g desborda.
Importes conocidos cero conservan cero; NA no se convierte en cero. Las
columnas efectiva/v siguen como metadatos previos y pueden perder rango;
no se usan para valorar. m grande conserva double y k/m se validan antes
de redondear a cero o desbordar integer. No se añaden columnas o parámetros.

### C18 autorizada y partición de los seguros

Con K=T=n=2, i=0 y b=100, el temporal y el dotal puro al momento de muerte
pagaban ambos 100, pero el mixto pagaba 100. El usuario autorizó expresamente
«Autorizar supervivencia estricta T>n». Solo pure_endowment con ese timing
cambia de T>=n a T>n; la muerte en n sigue cubierta por term/endowment.
Ahora Z_endowment=Z_term+Z_pure_endowment en cada trayectoria observada.
El calendario anual mantiene K<n frente a K>=n. Se documenta la frontera
y el impacto sobre llamadas anteriores, incluidas beneficio/fecha/indicador.

### Referencias independientes y alcance

test-b08-path-valuators.R añade 448 comprobaciones: enumeración explícita
de 72 calendarios (seis tipos, anual/trimestral, due/immediate y tres tasas),
36 libros de eventos de seguro (seis tipos, ambos timings y tres tasas),
garantías, h fraccionario, fronteras exactas y NA. Valores/conteos/primera y
última fecha contra retículas independientes, sin helpers de calendario como
oráculo. Más fuerzas extremas con importes compensatorios, cero, t=0, m/k,
partición C18 y RNG sin sorteos. Contra base: 18 fallos, 6 errores,
3 advertencias y 398 aprobadas; errores previos abortan otras aserciones.
Después pasan las 448. 182 objetos ordinarios completos coinciden a 1e-12,
incluidas las cinco convenciones/especificaciones financieras de la muestra,
alias obsoletos y columnas personalizadas; las dos firmas son idénticas.
La comparación evita T=n en el caso C18, cuyo cambio se verifica aparte.

Límites: se conservan calendarios materializados, sin certificar tamaños
arbitrarios ni fechas inferiores a la resolución double. .cash_flow_sum
recupera rango de cada flujo representable; no se promete exactitud relativa
para sumas subnormales. Las valoraciones siguen condicionadas a los K/T
recibidos, sin inferir un estado multivida a partir de una etiqueta.
mc_reserve tiene un motor propio con T>=n en el dotal puro: conciliar ese
borde y sus convenciones de vigencia en su unidad; C18 no autoriza cambiarlo
automáticamente. Lo mismo rige para sus tasas originales pendientes.

B08 permanece abierto, ahora con 690 comprobaciones nuevas acumuladas.
Siguiente unidad: mc_premium/mc_loss, equivalencia y unidades; luego reservas
y resúmenes/antitéticos. Suplemento B05 sigue pendiente.
next-premium-loss-diagnosis.log reproduce pérdida de cuota/flujo final
representable por q que subdesborda/desborda (escalas 1e-300 y 1e300).
No se ha corregido aún; separar el límite de q del valor monetario final.
Validación integral, huella y entorno en audit-precran-check.md.
Artefactos b08-04 de la sesión
del 21; before-c18-final.log y regression-c18-final.log son definitivos.
before.log/after.log y before-final.log/regression-final.log conservan etapas
previas a C18; final-tests.log inició antes de C18 y no certifica el cambio.

## B08-03 — motor lx y valoración de los dos wrappers (22 de octubre)

Base f87706e, Git limpio al comenzar, rama y versión conservadas. Esta unidad
es A matemática/computacional y B documental; no amplía C13-C17. Se conservan
firmas, columnas, importes por pago y convenciones anuales/fraccionarias.

Desde lx, la masa de muerte anual es (l_j-l_(j+1))/l_x; el horizonte finito
retiene la masa superviviente l_(x+n)/l_x. No normaliza condicionalmente las
muertes observadas. En esas filas Kx=n es marcador de censura, Tx=NA y
died_within_horizon=FALSE; no debe tratarse como vida completa observada.
Con n=Inf sigue exigiéndose cierre observado de la tabla. El nombre histórico
method="inverse" conserva sample.int y su orden de sorteos; no se sustituye
por el generador público ni se añade extrapolación.

Defecto reproducido: lx=(1e300,1e-300), horizonte uno. La razón anual
subdesborda a cero, pero log(p)=-600*log(10) es finito. CML debe producir
S=-log1p(-U)/(600*log(10)), no cero. Se obtiene log(p) desde los conteos
cuando hace falta; con q pequeño se usa log1p(-q), q por decremento directo.
Balducci usa log(U)+log(p)-log1p(-U*q). Solo l_end=0 conserva la degeneración
terminal previa. No cambia la distribución ni el número de uniformes.

Para fechas elegibles t_j el valor es payment*sum(exp(-g*t_j)); el seguro
paga benefit*exp(-g*t) cuando corresponde, g de la tasa original. Antes la
conversión obligatoria a efectiva anual rechazaba fuerzas con flujos finitos.
Ahora los importes se combinan en log y la efectiva queda como metadato que
puede ser Inf o -1. Para pagos consecutivos se reutiliza la suma geométrica
log estable. El atajo abs(i_period)<1e-12 borraba descuentos monetariamente
materiales: cuatro pagos due de 1e12 a i=1e-12 devolvían 4e12, en vez de
3999999999998.5. El error actual frente a fechas explícitas es menor de .02;
no se exige exactitud inferior al redondeo double de la suma log.

Se comprueban rangos antes de coerción/muestreo y horizonte antes de crear
edades. m grande válido conserva double; n grande se contrasta con soporte.
Se rechazan incrementos lx antes ocultados por tolerancia absoluta y edades
duplicadas después del redondeo entero. No se reparan tablas incompatibles.

test-b08-life-mc-precision.R añade 90 comprobaciones: CDF de las tres
fracciones contra uniformes reconstruidos, masas/censura, libros explícitos
de pagos/seguros con tasas negativas/cero/positivas, fuerzas extremas con
importes compensatorios, importe cero, tasa pequeña, límites de entrada,
invariancia al radix y restauración/avance RNG con semilla presente/ausente.
Contra f87706e: 11 fallos, 9 errores, 10 advertencias y 62 aprobadas;
los errores anteriores abortan algunas aserciones. Después pasan las 90.
172 resultados ordinarios completos coinciden a 1e-12, dos firmas idénticas,
incluidos contratos, argumentos obsoletos y ambos outputs.

Límites: una fracción Balducci inferior al mínimo double puede seguir siendo
cero; sumar una fracción diminuta a K puede redondear T a K. No se certifica
recuperación de fechas que no caben en double ni calendarios arbitrariamente
grandes. Se preserva la convención terminal CML/Balducci de fracción cero y
las convenciones locales de pago en ese borde. mc_annuity/mc_insurance y
otros consumidores aún requieren revisión propia de tasas originales; no
se propaga esta corrección por analogía. B08 sigue abierto con 242 nuevas
comprobaciones acumuladas; suplemento B05 pendiente. Validación final y
huella: audit-precran-check.md. Artefactos b08-03 de la sesión del 21.
regression-final.log y before-final.log son definitivos; after.log y otros
after-* conservan iteraciones anteriores de pruebas, no la evidencia final.

## B08-01 — fundamentos de los dos generadores

### Identidades y diagnóstico independiente

Desde la edad inicial x: P(K=k)=[producto de j<k de (1-q_j)]q_k.
Si la tabla no agota la distribución, conditional normaliza estas masas
por la probabilidad de muerte observada y advierte; error rechaza. Se
preservan ambos modos y el umbral existente de reconocimiento de truncación.

Condicionalmente al año de muerte, S=T-K tiene las distribuciones:

* UDD: F(s)=s.
* CML, p=1-q>0: F(s)=(1-p^s)/q; S=log1p(-U*q)/log1p(-q).
* Balducci, p>0: F(s)=s/(p+q*s); S=U*p/(1-U*q).

Antes se reemplazaba S por cero en CML/Balducci cuando p<=tol, incluso
si p era positivo. Con q=1-1e-11 y tol=1e-10, todas las fracciones eran
cero, pero sus CDF no devolvían los uniformes de la semilla 42. Es un
defecto A del modelo, no una propuesta de nueva distribución. Se cambia
la condición de degeneración a p==0 y se conserva exactamente la
convención de fracción cero para q==1 en CML/Balducci. La corrección CML
previa con q diminuto, basada en log1p(-q), permanece intacta.

La exposición positiva en lx es lx>0, independiente del radix. Antes
positive_rows usaba lx>tol: multiplicar (100,80,40,0) por 1e-100 podía
rechazar la tabla. Se elimina ese umbral absoluto. Se deriva q como
(l_y-l_(y+1))/l_y, evitando cancelación en 1-l_(y+1)/l_y. Por ejemplo,
lx=(1e16,1e16-2) implica q=2e-16; la resta de la razón redondeada daba
otro decremento. No se añade cierre, extrapolación ni una fila terminal.

Se valida tol antes de usarlo y edades iniciales/de tabla antes de
as.integer, evitando advertencias y NA por coerción. Un n_sim positivo
que redondearía a cero se rechaza. death_age=x+K+1 se calcula sin overflow
entero, conservando integer ordinario y double solo cuando hace falta.
Se preservan las firmas, nombres/orden de columnas, aliases, métodos,
precedencia qx/px/lx y la política de tolerancia ya existente para qx/px.
No se certifica aún todo su dominio ni se uniforman otras funciones MC.

### RNG y comprobaciones

Con seed se conserva/restaura .Random.seed; sin seed se avanza la corriente
del llamador. simulate_lifetimes inicializa una sola semilla para toda la
llamada y no la reinicia por vida. Se conservan las llamadas explícitas de
muestreo, tamaños y orden; no se promete igualdad de muestras afectadas por
probabilidades corregidas ni detalles internos de sample.int entre versiones
de R. Los pares antitéticos introducen dependencia entre filas;
esta unidad no certifica el error estándar genérico bajo esos pares.

test-b08-lifetime-foundations.R añade 94 comprobaciones: CDF condicional
contra uniformes reconstruidos independientemente, métodos inverse/
multinomial/antithetic y tamaño impar; invariancia al radix para tres
escalas y tres fracciones; decremento pequeño; validación/coerción; masas
anuales explícitas; coherencia K=floor(T); restauración con semilla
presente/ausente, después de error en una vida posterior y consumo sin
semilla. No se usa aproximación estadística para decidir los regresores.

Contra c7a0d29, el archivo definitivo reproduce nueve fallos, cinco errores
y dos advertencias, con 35 comprobaciones ya aprobadas. Algunos errores
originales abortan bloques antes de completar sus aserciones; no se cuentan
las no ejecutadas como aprobadas. Tras el fix pasan las 94. 78 resultados
ordinarios COMPLETOS concuerdan a 1e-12 y las dos firmas son idénticas.

Artefactos: C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b08-01/.
before.log y after.log son la regresión inicial de 73 comprobaciones;
after-final.log/before-final.log contienen el archivo definitivo de 94 y
la compatibilidad. final-tests.log y build/check/snapshot son la evidencia
de paquete final, registrada en audit-precran-check.md. Sin nueva dependencia,
versión, push/publicación ni extensión de decisiones C previas.

B08-01 confirmado, implementado, probado y cerrado dentro del alcance
puntual anterior. Suite fuente/instalada: 6250 aprobadas, cero fallos/
advertencias/omisiones. Build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE
por desarrollo. Ejemplos y cuatro viñetas aprobados; 392 fuentes verificadas.
Entorno, archivo y huella en audit-precran-check.md. B08 completo sigue abierto.

### Continuación y límites

B08 permanece abierto; este subconjunto no cierra sus once nombres. Sigue
mc_multilife_status y el motor .simulate_lifetime_inverse_lx de los dos
wrappers simulate_*_x, luego valoración por trayectoria y resúmenes. No
asumir que corregir simulate_lifetime cambia el otro motor lx.

next-status-diagnosis.log confirma un borde pendiente: dos vidas con
K=(0,2),T=(1,2.5) pasan la tolerancia de mc_multilife_status y generan
K_status=0,T_status=1; mc_insurance rechaza después ese par por incumplir
K<=T<K+1. No está corregido aquí. Se debe conciliar el significado público
de tol antes de cambiar su dominio, además de revisar almacenamiento y
columnas de identificadores. No trasladar automáticamente la aprobación
de otros bordes. El defecto B05 t_px/e_x sigue separado y pendiente.

Actualización de decisión: C17 fue propuesta concretamente en
audit-api-review.md y el usuario autorizó «la coherencia exacta K/T» el
22 de octubre. Aplicar en la siguiente unidad, sin pedir de nuevo; el
snapshot B08-01 todavía no modifica mc_multilife_status.

next-lx-engine-diagnosis.log reproduce además simulate_annuity_x con
lx=(1e300,1e-300), CML, n=1,k=1000: devuelve T=0 y cero pagos en todas
las cinco trayectorias de semilla 42. La fuerza es 600*log(10), finita;
su fracción de vida no es cero casi seguramente. Se pierde la razón
anual antes de aplicar log. Defecto A confirmado pendiente del motor lx,
sin corregir en B08-01. No confundirlo con el soporte de p>0 recuperado
desde qx en el primer generador, ni prometer recuperación de información
que ya se haya redondeado en una conversión qx/px.

## B08-02 — estados multivida y C17 autorizada

Base 9a7b441, rama y versión preservadas. B08-01 quedó guardado y validado
antes de editar esta unidad. El usuario autorizó C17 expresamente el 22 de
octubre; no se pidió otra autorización ni se extendió a otros contratos.

### Modelo y correcciones

Para cada vida K_i=floor(T_i). El estado conjunto usa min(K_i),min(T_i),
y el último superviviente max(K_i),max(T_i). Como floor es monótona,
floor(min T_i)=min floor(T_i), y análogamente para max. La igualdad depende
de que cada par inicial sea compatible. Agregar primero no debe esconder
una vida inválida que no determine el mínimo o máximo del estado.

C17 exige exactamente K<=T<K+1 después de la comprobación/redondeo entero
de K ya existentes. Se comprueba floor(T)==K sin sumar uno a un double
grande; tol conserva la comprobación entera de K. No se redondea ni repara
T. Se rechazan tanto T=K+1 como T<K aunque la diferencia sea menor que tol.
La propuesta y la aprobación están en audit-api-review.md. Los pares válidos,
alias de estado, identidad de las vidas y convenciones de agrupación siguen
intactos. NA sigue rechazado; no se añade una política nueva de faltantes.

Corrección A: K_status=as.integer(K_status) convertía una vida curtata válida
de 3e9 en NA, con advertencia. Se mantiene integer ordinario y se conserva
double cuando el valor no cabe en integer. No se cambia el valor actuarial.
Los calendarios de pagos de tamaño enorme no se certifican por este arreglo.

Corrección A/aclaración B: col_sim con nombre K_status/T_status/n_lives/status
provocaba un error interno de columnas duplicadas de tibble. Ahora se rechaza
explícitamente ese mismo caso ya fallido, indicando que el nombre está
reservado. No se agrega una columna ni se renombra el identificador; sim_id,
sim y otros identificadores válidos conservan sus nombres y aliases.

### Evidencia y límites

test-b08-multilife-status.R añade 58 comprobaciones: doce rechazos C17 en
ambos estados y dos tolerancias; 32 libros de min/max, bordes válidos,
cinco alias, orden de identificadores y encadenamiento con seguro/anualidad;
siete de almacenamiento grande/ordinario y siete de nombres/identificadores.
Las referencias son min/max explícitos y conteos de pagos a tasa cero;
los consumidores constituyen una comprobación adicional, no el único oráculo.
Se conserva el redondeo permitido de K cercano al entero y T válido sin reparar.

Contra base: 16 fallos, un error y dos advertencias, con 35 aprobadas.
El error interno original de tibble aborta el bloque de nombres; las
aserciones restantes no se cuentan como aprobadas. Con el fix pasan las 58.
60 objetos válidos COMPLETOS idénticos a 9a7b441, incluyendo agrupaciones
de 12 simulaciones, alias, col_life=NULL e identificadores personalizados;
firma idéntica. initial-timing-before.log se conserva como borrador: el
primer libro omitía timing="due" en mc_annuity, cuyo default es immediate.
El archivo definitivo explicita due y before-final.log usa ese archivo.

Artefactos b08-02 del directorio de la sesión; suite/build/check/snapshot y
huella en audit-precran-check.md. B08 sigue abierto. Continúa el otro motor
lx con el defecto confirmado arriba, después valoración por trayectoria,
primas/pérdidas/reservas y resúmenes. El suplemento B05 sigue pendiente.
No se certifican dependencias entre vidas, reparación de trayectorias,
intervalos de confianza antitéticos ni todos los extremos de los consumidores.

Estado B08-02: autorizado C17, implementado, probado y cerrado dentro del
alcance anterior. Suite fuente/instalada final: 6308 aprobadas, sin fallos/
advertencias/omisiones; build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por
desarrollo. Ejemplos y cuatro viñetas aprobados; 393 fuentes verificadas,
huella y entorno en audit-precran-check.md. B08 acumula 152 comprobaciones
nuevas en dos unidades y permanece abierto. No se hizo push ni cambió versión.
