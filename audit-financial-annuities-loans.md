# B03 — anualidades financieras y préstamos

Rama audit/0.2.0-precran; versión 0.1.6.9000; objetivo 0.2.0.
Continuación del barrido, sin reiniciar B01/B02 ni la auditoría previa.
La primera unidad aborda a_angle, s_angle, amort_schedule,
amort_schedule_general y sinking_fund_schedule. La continuación B03-05 a
B03-07 añade annuity_arith y annuity_geom; B03-08 a B03-10 completa
anticipos, recálculo, liquidación y límites de los calendarios.
Estado: **revisión B03 cerrada dentro del alcance documentado**, con suite
completa y R CMD check final aprobados. Esto no cierra la auditoría del paquete.

## Modelo, unidades y convenciones conservadas

Sea delta la tasa logarítmica anual original y r=delta/k la de un período.
En a_angle/s_angle, n está en años, N=n*k y H=h*k son números de períodos;
se conserva la validación/alineación de la retícula. Cada pago discreto es
una unidad, no 1/k; la anualidad continua paga una unidad por año.
Con b=0 para immediate y b=1 para due, y
G_N(r)=sum(exp(r*j), j=0,...,N-1):

- A=exp(-r*(H+1-b))*G_N(-r).
- S=exp(b*r)*G_N(r), valorado al horizonte h+n en años.
- A continuo=exp(-delta*h)*integral_0^n exp(-delta*u) du.
- S continuo=integral_0^n exp(delta*u) du.
- Para delta>0, la perpetuidad discreta es
  exp(-delta*h)*exp(-(1-b)*r)/(1-exp(-r)); la continua,
  exp(-delta*h)/delta. Para delta<=0 no converge y se rechaza.

En los tres calendarios de préstamos, n cuenta **períodos**, de modo que
el plazo en años es n/k. No se cambia su significado para hacerlo coincidir
por nombre con el de las anualidades. Para la cuota P y saldo inicial L:

- Tipo fijo: P=L/A, con la anualidad expresada en períodos del calendario.
- Tipo variable: D_j=sum(delta_l/k, l=1,...,j), D_0=0. En immediate,
  P=L/sum(exp(-D_j), j=1,...,n); en due, usar D_(j-1).
- Reconstrucción immediate: B_j=B_(j-1)*exp(r_j)-cashflow_j.
- Reconstrucción due: B_j=(B_(j-1)-cashflow_j)*exp(r_j).
- Fondo de amortización: depósito L/G_n(r_f), con depósito al final de cada
  período e intereses del préstamo pagados por separado.

Las referencias realmente usadas son estas identidades, sumas explícitas,
integrales elementales, potencias binarias y Decimal de Python a 80 dígitos.
No se afirma consulta de Bowers, Finan u otra bibliografía inaccesible.

## B03-01 (A): tasas pequeñas, cancelación y límites de anualidades

Estado: confirmado, implementado y probado en este alcance.
a_angle y s_angle usaban umbrales absolutos 1e-12 para sustituir una tasa
por cero y restas/potencias que pierden precisión. El error depende del
producto tasa*plazo, no solo de la tasa. Además, perpetuidades positivas
por debajo del umbral se rechazaban, pese al dominio documentado.

Reproducción anterior: delta=5e-13, n=1e12, devuelve 1e12 tanto en PV como
en FV. Referencias continuas independientes:

- PV: 786938680574.7331527924009300176390931161637290256260886342.
- FV: 1297442541400.2562936973015756283271433075522014202960231502.

Se obtuvieron integrando tras el cambio u=t/1e12 y evaluando exp(1/2) en
Decimal. El PV anterior se desvía aproximadamente 27.1%; el FV, -22.9%.
Para el caso discreto con delta=5e-13, la diferencia relativa respecto de
la integral está acotada por exp(abs(delta))-1; la tolerancia 1e-12 cubre
esa cota y el redondeo, sin aceptar la desviación anterior. También se
contrasta el signo negativo y sumas explícitas de 36 pagos mensuales.

Implementación compartida privada, sin nueva función pública:
log G_N(r)=log(1-exp(-abs(r)*N))-log(1-exp(-abs(r)))+
max(r,0)*(N-1), usando expm1 y el límite exacto r=0. Para la integral se
escala por n antes de dividir por el producto tasa*plazo, evitando degradar
duraciones diminutas cuando ese producto es subnormal. Un producto infinito
en una integral decreciente se trata por su límite 1/abs(delta).

Se retienen los factores en log hasta combinar pago y factor, mediante el
helper ya existente .cash_flow_value. Se preservan ceros conocidos y NA;
un factor de unidad puede mostrar Inf o cero mientras el valor monetario
sea representable. No se oculta esa limitación de la columna de auditoría.

## B03-02 (A): saturación de la tasa anual antes de fraccionar

Estado: confirmado, implementado y probado.
Convertir fuerza a tasa efectiva y después a tasa periódica pierde la fuerza
si el equivalente anual redondea a -1 o Inf. Se reproduce con fuerzas
-800 y 800: un único pago due al origen tiene PV=1 y un único pago immediate
al horizonte tiene FV=1, aunque las fórmulas anteriores dieran NaN.

a_angle/s_angle y los dos calendarios de amortización usan ahora
.interest_basis; expm1(delta/k) determina el tipo de período. Para fuerza
800 y k=1200, ese tipo es finito aunque el equivalente anual sea Inf.
Ambos calendarios se contrastan contra tres descuentos explícitos, no
únicamente entre sí. Se conserva su exigencia de tasa periódica finita >-1.
sinking_fund_schedule conserva además su exigencia previa de equivalentes
anuales finitos >-1; no se amplió su dominio sin estudiar ese contrato.

## B03-03 (A): tolerancia monetaria usada como umbral de tasa cero

Estado: confirmado, implementado y probado.
amort_schedule y sinking_fund_schedule comparaban abs(tasa_periodo) con
tol, que está expresado en moneda. Esto mezcla unidades y hace depender
cuotas/depósitos de la tolerancia monetaria o de un cambio de moneda.

Reproducciones sobre HEAD f7588f4:

- L=1e9, 24 períodos, fuerza=5e-9, tol=1e-8: cuota L/24; queda saldo
  cercano a 62.50 en immediate y 57.50 en due.
- Fondo con la misma fuerza y tol=1e-4: excedente 57.5000013 y warning.
- No se limita a fuerzas extremas: fuerza .005, tol=.01 (un centavo) y
  24 períodos deja saldo 67677059 aproximadamente en el préstamo immediate
  y excedente 59819792 aproximadamente en el fondo.

Ahora las cuotas/depósitos usan las sumas financieras anteriores sin usar
tol para decidir si una tasa es cero. La recalculación adjust="payment"
comparte el mismo cálculo. En amort_schedule_general, los descuentos
acumulan delta_j/k en log en lugar de cumprod(1+i_period), conservando
incrementos que la suma 1+i_period puede redondear.

Los tests reconstruyen fila a fila los saldos de ambos timings con la fuerza
original, y contrastan la cuota y el depósito con sumas independientes.
Además se verificaron en R escalas monetarias 1e-9,1,1e9, escalando tol
en la misma proporción: cuotas/depósitos normalizados invariantes.
El tol público sigue siendo absoluto en moneda; no se introdujo una nueva
política relativa de detección de saldos cero.

## B03-04 (B): horizonte docente y dimensiones de interfaz

La documentación de s_angle decía «último pago» para todos los timings,
pero su fórmula due siempre valoró un período después de ese pago.
Se aclara el horizonte h+n, sin cambiar resultados ni convenciones.
También se explican los pagos de unidad frente a la intensidad continua,
el papel de k y el significado distinto de n en los préstamos.
En el fondo se documenta que m y j_m se validan aunque solo intervengan
en conversiones nominales; no se cambia su dominio aceptado.

| Función | Matemática / estabilidad en esta unidad | API y tidyverse | Homogeneidad y pendiente |
|---|---|---|---|
| a_angle | Sumas, integrales, deferimiento y perpetuidad positiva; base original y extremos probados | Vector o tibble; mutate, pipe vectorial, NA y valores monetarios comprobados | n años; k pagos/año; m nominal; firma intacta |
| s_angle | Sumas e integrales al final del plazo; ceros y extremos probados | Vector/tibble y columnas preservadas; h metadato del desplazamiento | Horizonte aclarado; la continuación corrige la explicación de perpetuidades sin añadir soporte |
| amort_schedule | Cuota, recálculo y anticipos contrastados por saldos y valores fechados | Tibble por período, principal primero; sin imponer vectorización | n períodos; tol monetario finito; prioridad de extras preservada y nombres enteros comprobados |
| amort_schedule_general | Tipos variables, callbacks y amortización negativa en ambos timings comprobados | Tibble; payment escalar/vector/función y summary conservados | Cuota por suma logarítmica; prioridad de pago regular; ledgers monetarios finitos |
| sinking_fund_schedule | Depósito, redención, déficit y excedente contrastados con flujos | Tibble de flujos auditables; firmas/columnas conservadas | j tasa del fondo; j_m su conversión; validar anual/monetario; sin redención anticipada en este contrato |
| annuity_arith | Sumas ponderadas, base original, pagos firmados y productos extremos probados en B03-05 | Vector/tibble, mutate y esquema conservados | g monetario por pago, n años; memoria lineal y pagos ya desbordados limitan el rango |
| annuity_geom | Sumas logarítmicas, i próximo a g, perpetuidades y plazos largos probados en B03-06 | Vector/tibble, mutate, NA y esquema conservados | g tasa anual, g_m independiente; no se garantiza cancelación arbitraria de exponentes extremos |

## Diff, evidencia y alcance de la primera unidad

Cinco fuentes públicas modificadas, un archivo nuevo de dos helpers privados
para sumas/integrales de anualidades, dos archivos de regresiones y cinco
Rd correspondientes. Los helpers evitan repetir la misma fórmula entre
valoración, cuotas y depósitos; no son una nueva arquitectura pública.
No se modifican parámetros, nombres, columnas, dependencias ni exportaciones.
Se compararon formals completos con HEAD para las cinco funciones: idénticos.
La matriz sigue en 101 entradas y 960 apariciones de parámetros.

test-annuity-numerical-regressions.R: 54 comprobaciones. Incluyen tasas de
ambos signos, cero, n largo, flujos explícitos, bases saturadas, perpetuidades,
pagos/NA, productos monetarios binarios, integración de spans subnormales y
grandes, salida tabular y pipes con dplyr.
test-loan-rate-regressions.R: 115 comprobaciones; reconstrucción por período,
dos tolerancias monetarias, dos timings, cuotas independientes, conversión
anual saturada con período finito y depósito sin excedente artificial.

Los fallos principales se reprodujeron sobre el código anterior antes de
editar. No se confunde tener 169 comprobaciones nuevas con haber cerrado
todos los dominios de las siete funciones. La validación conjunta final se
registra en audit-precran-check.md; la CI previa no valida esta unidad.
No hubo push, cambio de versión, publicación ni reconstrucción del manual.

Validación final: suite local completa y R CMD check del paquete instalado
aprobados. Resultado 0 ERROR, 0 WARNING, 1 NOTE (versión de desarrollo),
salida 0; ejemplos y las cuatro viñetas reconstruidas correctamente.
Quince archivos relevantes coinciden con el archivo fuente comprobado;
detalles, entorno y SHA256 en la última sección de audit-precran-check.md.

## B03-05 (A): base y productos de anualidades aritméticas

Estado: confirmado, implementado y probado en el alcance descrito.
Con C_j=P1+(j-1)*g para custom, se valoran directamente los pagos en las
fechas del contrato. Los patrones increasing/decreasing conservan sus
pagos 1,...,N y N,...,1; P1/g se ignoran en ellos, incluidos sus NA.
g es dinero por pago, no la tasa anual llamada g en annuity_geom.

Antes se anualizaba la tasa y se construían factores separados con potencias.
Fuerzas +/-800 eran rechazadas aun con cuatro pagos en 4/1600 años y todos
los valores representables. También N=1, h=1, delta=550*log(2), P1=2^1000
y g=0 daba PV=0, aunque 2^1000*2^-1100=2^-100. Un flujo custom de ceros
con deferimiento 200 y delta=-log(100) daba NaN en vez de cero.
Los fallos se reprodujeron antes de editar.

Diff: .interest_basis conserva la fuerza original; expm1(delta/k) y
exp(-delta/k) dan los campos periódicos; .cash_flow_sum valora los mismos
pagos explícitos por la base logarítmica. Se reutilizan helpers de B01/B02,
sin nueva función pública/privada ni una arquitectura adicional.
Se preserva la alineación de h*k y n*k y el horizonte h+n.

Pruebas: test-annuity-arithmetic-regressions.R, 41 comprobaciones.
Incluyen ambos signos de fuerza, tres patrones, dos timings, pagos que
cambian de signo, cero, NA, productos binarios independientes, mutate y
validaciones de m/custom. Las referencias son sumas explícitas en años,
no llamadas a pv_flow o a otra función del paquete.

Límites documentados: se sigue enumerando N pagos, con memoria O(N).
No se recupera un pago que ya desborde al generar P1+(j-1)*g, ni cancelación
extrema arbitraria entre factores diferentes. No se introduce fórmula cerrada
para esquivar esos casos sin estudiar estabilidad y compatibilidad.

## B03-06 (A): interés y crecimiento casi iguales

Estado: confirmado, implementado y probado.
Definiciones: r=delta_i/k, s=delta_g/k, d=(delta_g-delta_i)/k,
b=0 immediate/1 due, H=h*k, N=n*k y G_N(z)=sum(exp(z*j),j=0,...,N-1).

- PV=P1*exp(-r*(H+1-b))*G_N(d).
- FV=P1*exp(b*r+(N-1)*max(r,s))*G_N(-abs(d)), al horizonte h+n.
- Perpetuidad: si delta_i>delta_g, PV=P1*exp(-r*(H+1-b))/(1-exp(d)).
  Se exige esa desigualdad estricta; no una separación mínima arbitraria.

La fórmula finita se obtiene sumando los pagos P1*exp(s*j). Para FV se
invierten los índices si es necesario, anclando los exponentes en la tasa
mayor. Así se evita restar dos niveles de acumulación desbordados.
Cuando d=0, G_N(0)=N es el límite exacto de la misma suma, no una hipótesis
de igualdad basada en un umbral de 1e-12.

Antes, delta_i=.03 y delta_g=.03-1e-10, N=48, k=12, h=2 y P1=100 daba
PV inmediato 4509.1758 frente a 4509.1827 por suma explícita. El cociente
de diferencias cancelaba cifras. Para i=0, delta_g=+/-5e-13 y n=1e12,
la rama de igualdad daba 1e12 en vez de los límites por integral ya registrados
(1.2974425414002563e12 o .7869386805747332e12); su error no era pequeño.
La perpetuidad efectiva i=2^-42,g=0 se rechazaba aunque su PV=2^42.

Incluso dividir cada fuerza primero puede perder el spread: delta_i=1,
delta_g=1+2^-52,k=10,N=1e17 tiene d=2^-52/10. Restar los tipos logarítmicos
ya redondeados por período cambió el resultado a aproximadamente .59 de
la referencia. La prueba falló y se corrigió calculando el spread anual
antes de dividir. Referencia Decimal a 80 dígitos sobre entradas exactas:
334618217753837351.97066129644432653999712571332637401089174873826447.
Es exp(-.1)*(exp(N*d)-1)/(exp(d)-1). No se usó el algoritmo del paquete
como referencia. La tolerancia relativa 1e-12 admite redondeo log/exp,
pero no esa desviación de aproximadamente 41%.

Una segunda regresión detectó que restar logaritmos ya redondeados todavía
degrada tasas efectivas/nominales cercanas. Para i=.06,g=i-1e-12, la
perpetuidad efectiva daba .9999967 de 1/(i-g), y la nominal de descuento,
aproximadamente .9999944 de la identidad racional. Se reprodujeron tres
fallos antes de añadir identidades de log-ratios para familias coincidentes:

- Efectivas: D=log1p((g-i)/(1+i)).
- Nominales de interés, m común: D=m*log1p((g-i)/(m+i)).
- Nominales de descuento, m común: D=-m*log1p((i-g)/(m-i)).

Después d=D/k y la convergencia de la perpetuidad exige D<0. Para fuerzas,
D=delta_g-delta_i. Si un ratio muy separado sale del rango, se conserva
el cálculo de las dos fuerzas; no se devuelve un spread infinito artificial.
Las familias/frecuencias distintas conservan la precisión de sus conversiones
individuales, lo cual queda explícito en Rd en vez de prometer precisión
arbitraria. Otro control Decimal, con i=1/2, g=1/2+2^-52, N=1e16, da
15286352891704535.00905127023730291732030834599677392302585988391467.

Diff: dos .interest_basis (financiera y crecimiento), sumas logarítmicas del
helper existente, comparación de fuerzas originales en perpetuidad y
.cash_flow_value para combinar P1 firmado con el factor. Se recuperan
primeros pagos pequeños/grandes, cero y factores aislados fuera de rango.
El pago único no tiene exponente de crecimiento y se trata como suma de
un término. NA en un plazo finito ahora propaga NA, en lugar del error
accidental «missing value where TRUE/FALSE needed».

Pruebas: test-annuity-geometric-regressions.R, 50 comprobaciones.
Incluyen sumas explícitas con cinco spreads, dos timings, plazos largos,
tasas originales saturadas, referencias binarias, primeros pagos negativos,
perpetuidades con tasas negativas pero convergentes, NA, mutate y conversión
nominal independiente de i/m y g/g_m. Siguen rechazándose igualdad o
crecimiento mayor en perpetuidades. Los tests anteriores se conservan.
Las identidades racionales de perpetuidad se comprobaron para las tres
familias coincidentes y se añadió una referencia Decimal de plazo largo
con tasas efectivas adyacentes, junto a un caso de fallback por ratio extremo.
Dos controles de límite adicionales impiden que un denominador nominal
m+i o m-i desbordado convierta el spread en cero por una división entre Inf.
La ruta de log-ratio se usa solo con ese denominador finito; en caso contrario
se conservan las fuerzas originales. Antes del resguardo, dos pagos due
nominales con m=1e308 daban 2 en lugar de 1: el segundo aporte era despreciable
por un spread negativo enorme. Las dos regresiones fallaron y luego pasaron.

## B03-07 (B): interfaz y claridad docente

Se verificaron formals, clases y nombres de columnas contra HEAD 8dba06e
para annuity_arith, annuity_geom y s_angle: idénticos. Las dos primeras
conservan n primero, escenarios vectoriales, tidy=TRUE y valuation escalar.
mutate permite operaciones tabulares naturales sin añadir .data o aliases.
Las columnas *_factor ya incorporaban P1/importes: se mantiene ese contrato,
sin crear columnas redundantes ni renombramientos públicos.

m y g_m observados siguen validándose incluso cuando no participan en una
conversión no nominal; ahora los Rd lo explican. No se normaliza su dominio.
También se corrige la explicación pendiente de s_angle: el motivo para no
definir una perpetuidad acumulada es que no tiene fecha terminal finita.
No se sostiene que s_n diverja para todas las tasas, pues con tasa negativa
puede tener límite finito. No cambia su soporte ni su implementación.

La matriz se mantiene en 101 nombres públicos y 960 apariciones de parámetros.
No se implementa ninguna propuesta C nueva, ni se cambia versión/dependencias.
Referencias consultadas: fórmulas explícitas, Decimal 80 y código/Rd locales;
no se inventan consultas bibliográficas. Límites: precisión double y posible
cancelación de exponentes enormes con deferimientos enormes; no se promete
precisión arbitraria. Los pendientes de extras, recálculo y cancelación
anticipada se atienden en las secciones B03-08 a B03-10 siguientes.

Validación final de esta continuación: 91 comprobaciones nuevas (41+50),
suite local completa y R CMD check del paquete instalado aprobados, salida 0.
Resultado 0 ERROR, 0 WARNING, 1 NOTE por versión de desarrollo; ejemplos y
cuatro viñetas aprobados. Diez archivos relevantes coinciden con el archivo
fuente comprobado. El entorno, las ejecuciones intermedias y el SHA256
definitivo están en audit-precran-check.md. Sin nuevo push o publicación.

## B03-08 (A): amortización negativa con pagos anticipados

Estado: confirmado, implementado y probado.
Sean B el saldo inicial, I los intereses y C=P+E el cobro total de cuota y
extra. Ambos timings cumplen B_final=B+I-C. Por tanto la amortización neta
es C-I; hay amortización negativa si I-C>tol, en las mismas unidades monetarias.
En due, I=(B-C)*i_period; no puede inferirse la condición de la columna
total_principal, que conserva los pagos realizados antes del interés.

Antes, amort_schedule_general(100,2,i=.1,timing="due",payment=1) daba saldos
108.9 y 118.69, pero negative_amortization=FALSE y summary también FALSE.
Se confirmó el fallo en la tabla y el resumen antes de editar.
Ahora el flag usa I-C>tol para ambos timings. Las columnas de principal
no se redefinen y los importes no cambian. Los extras cuentan al decidir
si el pago total cubre el interés. NEWS registra el cambio de diagnóstico.

## B03-09 (A): períodos fraccionarios y tolerancias infinitas

Estado: confirmado, implementado y probado.
El calendario fijo convertía los nombres de extra_principal a integer antes
de validarlos: "2.9" se aplicaba al período 2 y "1.5" al 1. Esto mueve
un flujo a otra fecha sin autorización y puede alterar interés y plazo.
Ahora se analiza el número, se exige finitud/integridad/rango y después se
convierte. Se mantienen los nombres enteros, el agregado de duplicados y
la equivalencia con el vector denso correspondiente.

amort_schedule y sinking_fund_schedule también admitían tol=Inf. El primero
devolvía cero filas para un préstamo positivo; el segundo suprimía toda
alerta de saldo final. Se reproducen ambos casos antes del cambio. Ahora
se exige tol finito positivo, sin modificar su significado monetario ni
convertirlo en una tolerancia relativa nueva. El general ya lo validaba.

## B03-10 (A): rango del cálculo de cuota y del libro monetario

Estado: confirmado, implementado y probado en el rango documentado.
Para el modelo general, sea ell_j el log del descuento de cada pago:
-sum(delta_h/k,h=1..j) en immediate, y el mismo acumulado hasta j-1 en due.
Con a=max(ell_j), el log del factor de anualidad se calcula como
a+log(sum(exp(ell_j-a))). No se evalúan descuentos individuales desbordados.
La cuota L*exp(-log_factor) se combina con el capital mediante el helper
existente .cash_flow_value.

Antes, L=2^1000, n=400, fuerza=-2 y timing immediate daba cuota cero en el
calendario general porque algunos descuentos eran Inf. La cuota sí es
representable. Referencia Decimal a 90 dígitos:
2^1000*(1-exp(-2))/(exp(800)-1)=
3.398269980284984497553256732270649864740366220343048271008021014043376E-47.
Se contrasta también el calendario fijo, que ya conservaba esa cuota.
El factor exp(-2) corresponde a pagos al final del período, no al origen.

Si la cuota calculada de un saldo activo no cabe como número finito positivo,
se rechaza explícitamente. Por ejemplo L=1e-300,n=400,fuerza=-2,tol=1e-310
ya no devuelve un calendario de cuotas cero. Saldos considerados inactivos
por tol conservan la posibilidad previa de una tabla vacía.

Los tres calendarios rechazan filas monetarias no finitas. Antes podían
producir Inf en interés/saldo (L=1e308,i=10,payment=1), o un excedente Inf
en el fondo con un depósito demasiado grande. Se conservan las tasas
anuales de auditoría saturadas cuando el período y los importes son
representables en los dos calendarios de amortización; no se confunde
ese metadato con una columna monetaria. El fondo mantiene su requisito
previo de tasa anual finita >-1.

## Verificación independiente de anticipos, recálculo y liquidación

test-loan-prepayment-audit.R incorpora 216 comprobaciones:

- Ecuación de valor: L=sum(C_j*v_j)+B_T*v_T, con fechas j en immediate y
  j-1 en due, en tasas -.02,0,.08 y las tres políticas none/term/payment.
- Identidad de libro B_final=B_inicial+I-C por fila, no negatividad de pagos
  y saldos y C=P+E. No se afirma que total_principal due sea el cambio neto
  de saldo: se conserva su definición local antes de interés.
- Recast: después de cada período, P_siguiente por la suma explícita de
  descuentos restantes reproduce el saldo; se conserva n si no se liquida
  anticipadamente. Un payment suministrado es inicial y se recalcula después
  del primer paso incluso sin extras, tal como hacía la implementación.
- Liquidación total por anticipo: no se cobra de más y no se evalúa ningún
  callback tras extinguir la deuda. Se preservan ambas prioridades locales:
  fijo conserva el extra solicitado y reduce la cuota; general aplica primero
  la cuota regular. Con L=100,i=.1,P=20,E=1000, ambos cobran 110 en immediate
  o 100 en due, pero el reparto de columnas es distinto por contrato.
- Tipos variables: descuentos por producto explícito, resumen y saldo final
  concordantes con los flujos. Pruebas previas de callbacks y tipos se conservan.
- Fondo con j=.5,n=2,L=100: depósito 25 deja deuda 37.5; depósito 40 redime
  exactamente; depósito 75 deja excedente 87.5. Los warnings de déficit o
  excedente se conservan, y la redención interna no duplica el cobro externo.
- Regresiones de períodos fraccionarios, tol infinito, flag due, cuotas
  recuperables y rechazo de importes no representables descritas arriba.

La primera ejecución completa detectó un problema del test del fondo:
expect_warning devuelve la condición capturada; se corrigió la asignación
de la tabla dentro de la expresión evaluada. Esa ejecución no es evidencia
de cierre; se repiten suite y check con el test final. Las referencias de
valores proceden de sumas explícitas, identidades de libro y Decimal, sin
usar una llamada a otro calendario como único oráculo.

## Alcance de cierre de B03

Las siete funciones tienen ahora revisión matemática, numérica, de interfaz
y de unidades documentada, con regresiones nuevas y pruebas independientes.
Las políticas de anticipos y liquidación pendientes quedaron contrastadas.
La validación final del paquete se registra en audit-precran-check.md.

Límites que permanecen explícitos, sin dar por garantizado el rango arbitrario:

- Memoria e indexación factibles para n/N; annuity_arith enumera los pagos.
- Precisión double; cuotas y libros monetarios activos representables.
- tol monetario absoluto: al cambiar moneda debe escalarse también tol;
  los residuos dentro de ese umbral se tratan según cada contrato.
- Cancelación aritmética extrema y pagos ya fuera de rango no se recuperan
  universalmente; el spread geométrico entre convenciones distintas conserva
  los límites de las conversiones individuales.
- Tipos de retorno, parámetros, columnas y prioridades locales se mantienen.
  C02–C04 son propuestas de API separadas, no correcciones matemáticas que
  se ejecuten sin autorización. No se añade simulación, RNG, funciones o deps.

El cierre de revisión de B03 dentro de este alcance no certifica todos los
valores posibles ni el paquete completo. La siguiente revisión integral es
B04: bonos, curvas, sensibilidad e inmunización, preservando sus fixes previos.

Cierre verificado: suite local completa y 216 comprobaciones nuevas de esta
unidad aprobadas. R CMD check final: 0 ERROR, 0 WARNING, 1 NOTE por versión
de desarrollo, salida 0; ejemplos y cuatro viñetas aprobados. Se verificaron
formals, clases y nombres de columnas de los tres calendarios contra HEAD
579efdb: idénticos. La matriz conserva 101 entradas/960 parámetros.
Nueve archivos relevantes coinciden con el archivo fuente comprobado.
Entorno, SHA256 e intento intermedio en audit-precran-check.md. No se hizo
nuevo push, publicación, cambio de versión o manual.
