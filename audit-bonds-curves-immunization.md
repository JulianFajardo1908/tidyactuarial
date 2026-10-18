# B04 — bonos, curvas, sensibilidad e inmunización

Objetivo 0.2.0; DESCRIPTION conserva 0.1.6.9000. Inicio sobre 49da88a,
rama audit/0.2.0-precran, árbol limpio y dos commits locales posteriores al
push autorizado hasta 8dba06e. No se reinicia la auditoría ni se altera la
evidencia previa de inmunización en audit-consolidation.md y sus regresiones.

## Primera unidad: calendario, precio y rendimiento

Funciones examinadas: bond_cash_flows, bond_price, bond_ytm y accrued_interest.
También se examinan sus helpers privados .validate_bond_core y
.resolve_bond_yield, alojados en R/bond_book_value.R. Modificar esos helpers
no constituye una revisión integral de book value, callable, duración o
convexidad. Esta primera unidad abarca cuatro funciones; la segunda unidad
siguiente incorpora otras dos y deja 14 por revisar integralmente.

### Modelo y referencias independientes

Bonos de cupón fijo, pagos vencidos, N=n*k entero y sin períodos irregulares:
C=face*c/k y P(j)=sum(r=1..N, C*(1+j)^(-r))+R*(1+j)^(-N).
Precio en fecha de cupón, sin interés corrido. Los cupones y el rescate
permanecen en filas separadas. n=0 devuelve solo el rescate inmediato.

Con pagos no negativos y alguno positivo futuro, P es estrictamente
decreciente para j>-1, con límites infinito y cero: cada P positivo tiene
una única raíz matemática. Su representación y aproximación siguen limitadas
por double y por tol en la coordenada j. El cero cupón permite contrastar
j=expm1(log(R/P)/N) sin usar bond_price como oráculo de bond_ytm.

Tipos anuales: log crecimiento a=log1p(y), m*log1p(y/m),
-m*log1p(-y/m) o y para efectiva, nominal de interés, nominal de descuento
o fuerza, respectivamente. El descuento de un período r es exp(-r*a/k).
Las referencias ordinarias suman pagos explícitos usando tiempos en años;
los extremos usan identidades exponenciales y la raíz analítica cero cupón.
No se atribuye verificación bibliográfica o con paquetes externos a esta unidad.

Interés corrido: AI=face*c*alpha y dirty=clean+AI. Se preservan las cuatro
convenciones documentadas, incluida act/act por período de cupón, sin inferir
un calendario completo a partir de tres fechas. Los tests anteriores ya
comprueban días reales, bisiestos, 30E/360, fecha de cupón, reciclaje y pipe.

### Hallazgos A y mejoras B

| ID | Fallo reproducido / causa | Corrección mínima | Estado |
|---|---|---|---|
| B04-01 | YTM rechaza bono ordinario de 30 años con cupones semestrales: el precio en -0.999999 desborda y el bracket exige ambos valores finitos | Ecuación logarítmica equivalente, suma log-sum-exp de pagos positivos relativos a P; calendario calculado una sola vez; signos sin productos; bracket desde el double más cercano por encima de -1 y ampliación superior hasta el dominio representable | Implementado y probado por regresiones; validación global registrada en audit-precran-check.md |
| B04-02 | uniroot con maxiter=1 advierte pero devuelve una tasa no convergente | check.conv=TRUE; maxiter dentro de rango entero; tol e interval finitos; rechazar madurez redondeada a cero sin pagos futuros | Implementado y probado |
| B04-03 | 1e300 descontado dos períodos a j=1e200 devuelve 0 en vez de 1e-100; fuerza -100 a medio año devuelve NaN; fuerza 1000 devuelve 0 aunque el precio es finito; tasa 1e-16 se pierde | Helper conserva log original; bond_price usa índices period enteros y el helper monetario ya existente; no vuelve a elevar equivalentes anuales saturados | Implementado y probado |
| B04-04 | tol=Inf admite frecuencia fraccionaria; k/N fuera de rango terminan en coerciones NA o condiciones inválidas; face*c puede desbordar antes de dividir por k | Validar tol antes de usarlo, cotas de índice antes del cast; recuperar cupón con logaritmos y rechazar cupón final no representable | Implementado y probado |
| B04-05 | accrued_interest rechaza face=1e308,c=10,k=10 aunque cupón=1e308 y AI sean finitos, incluso AI=0 en fecha de cupón | Recuperación solo de productos que pierden rango; conservar el rechazo de resultados finales no finitos | Implementado y probado |

La ecuación de rendimiento utiliza log(cf/P) si el cociente conserva rango
normal y log(cf)-log(P) si desborda, subdesborda o es subnormal. No se eliminan
pagos positivos pequeños al normalizar. La ecuación tiene la misma raíz y
evita desbordar el valor monetario en los extremos del bracket.

### API, unidades y experiencia tidyverse

| Función | Contrato conservado | Decisión |
|---|---|---|
| bond_cash_flows | n años; k cupones/año; c nominal anual; R monetario; tibble de calendario | Conservar filas separadas, nombres y orden. tol controla alineación entera, no dinero. Escalar por escenario; usar map/pmap cuando corresponda |
| bond_price | Precio escalar en moneda de face/R; y directo por cupón prevalece sobre y anual | Reducción escalar justificada; no añadir .data o columnas públicas. n=0 conserva retorno inmediato sin exigir rendimiento |
| bond_ytm | P sucio en fecha de cupón; tibble de una fila con price/i_period/j_nominal/i_effective_annual/k | tol sigue siendo tolerancia de uniroot en j; no inventar residual_tol. Sin convergencia se emite error en lugar de una aproximación advertida |
| accrued_interest | .data primero, columnas originales y auditables; vectores y reciclaje explícitos | Conservar fechas Date y convenciones locales. Se aclara exactamente el umbral de conciliación existente, tol*max(1,abs(clean),abs(dirty),abs(AI)) por fila, sin cambiarlo |

La precisión del rendimiento no equivale a una cota de error de precio,
especialmente cerca de -1. Cambiar ese contrato requeriría una decisión
separada de API. El piso monetario 1 de conciliación también se conserva:
no es una prueba de invariancia monetaria a escalas arbitrariamente pequeñas.
Se documenta su regla real en vez de cambiar la semántica sin autorización.

### Evidencia y límites

test-bond-valuation-audit.R incorpora 99 comprobaciones: sumas independientes,
frecuencias 1/2/12 y bono de 30 años; cero cupón y monedas 1e-250/1/1e250;
cocientes fuera de rango y subnormales; raíces negativas cercanas a -1;
dominios irrepresentables; agotamiento de iteraciones; descuentos extremos;
cuatro familias de tasa; índices/tolerancias y productos de interés corrido.
La ejecución previa sobre HEAD reprodujo los fallos; testthat detuvo el
detalle tras diez fallos. Las regresiones corregidas pasan sin advertencias.
Los resultados completos de suite/build/check se registran por separado.

Compatibilidad: no cambian formals públicos, clases, columnas, dependencias,
exportaciones ni versión. Se corrigen errores y aproximaciones silenciosas;
se endurecen entradas inválidas/no representables y la falta de convergencia.
El helper compartido también conserva con mayor precisión ip/i_annual en
otros consumidores; por eso se comprueba la suite completa, sin declarar
revisadas todas sus fórmulas. No hay funciones ni helpers nuevos.

Límites: calendario explícito O(N), requiere memoria; N<integer.max y no
implica que cualquier N permitido quepa en memoria. Precios finales fuera de
double pueden seguir siendo 0/Inf; el calendario y accrued_interest exigen
cupones/resultados auditables finitos. Equivalentes anuales de una tasa
representable pueden saturar a -1/Inf. No hay soporte nuevo de stubs,
ex-cupón, impuestos, calendarios de mercado, precio a mitad de período o
cash flows de signo mixto. check=FALSE conserva el uso interno sin validación
completa y no es garantía para entradas arbitrarias.

## Segunda unidad: valor contable y rescates opcionales

Inicio sobre 185423b. El usuario pidió continuar en orden y autorizó C05:
«Sí, mínimo calculado y empates exactos». No se interpreta esa decisión como
autorización para cambiar otros retornos, columnas o tolerancias.

### Identidades

En la fecha de cupón s, inmediatamente después del pago, el valor contable
es B_s=sum(r>s, pago_r*(1+j)^(-(r-s))). El pago_N incluye cupón y rescate.
También B_s=P*(1+j)^s-sum(r<=s, pago_r*(1+j)^(s-r)), y el movimiento del
libro es B_s=B_(s-1)*(1+j)-pago_s. Así B_0=P y B_N=0, incluso si R difiere
de face. n=t=0 es saldo cero después del rescate, distinto del precio que
representa el pago inmediato. No se uniforman esas convenciones distintas.

Para rescate opcional en u, el escenario paga cupones en r=1..u*k y además
call_R en u. La madurez se añade con R. El precio máximo compatible con un
rendimiento objetivo en todos los escenarios es min_u P_u(j), porque cada
precio es decreciente en j si tiene pagos positivos. El caso de todos los
pagos cero produce precio cero, pero no identifica una TIR. Este cálculo
no es una valoración de opción con tasas estocásticas y no garantiza una
rentabilidad reinvertida hasta la madurez original tras rescate anticipado.

### Hallazgos y decisión de API

| ID | Evidencia previa y causa | Cambio | Estado |
|---|---|---|---|
| B04-06 | book value devolvía NaN con fuerza -100 y perdía precios finitos con tasa extrema; el helper de tasa retenía el log pero la fórmula volvía a potencias de ip | Usar períodos almacenados y .cash_flow_sum con log original de los pagos restantes; mantener salida cero después de vencimiento | Implementado y probado |
| B04-07 | callable con fuerza -100 abortaba por ip=-1; con fuerza 1000 y k=1 abortaba por ip=Inf aun teniendo un precio finito de rescate | Pasar a bond_price los argumentos originales de rendimiento; conservar prioridad explícita del rendimiento directo y equivalentes informativos | Implementado y probado |
| B04-08 | Contadores fuera de rango emitían coerciones NA; fechas como 1 y 1+1e-12 se admitían como rescates distintos en el mismo período, y 1e-12 se convertía en rescate inmediato | Comprobar N antes del cast; validar unicidad e interioridad del período de rescate una vez alineado | Implementado y probado |
| C05 / B04-09 | Tres precios distintos aparecían todos como peor caso al reducir la escala monetaria, por usar sqrt(tol) de calendario como umbral de dinero | is_worst_case = precio_calculado == mínimo_calculado, incluidos empates exactos; decisión pública autorizada expresamente | Implementado y probado |

La salida tidy de book value preserva orden y duplicados de t; el escalar
vectorial sirve dentro de mutate sin agregar interfaz .data. Callable conserva
filas ordenadas por t, identificación original de escenario y emparejamiento
call_t/call_R. Conserva precio escalar o tibble según tidy. c sigue siendo
cupón nominal anual, n/t/call_t están en años, k es frecuencia de pago y y_m
es frecuencia de conversión del rendimiento. tol no mide dinero ni define
empates. No se añaden funciones, argumentos, columnas, aliases o dependencias.

### Pruebas, compatibilidad y límites

test-bond-book-callable-audit.R añade 142 comprobaciones: frecuencias 1/2/4,
tasas negativas/cero/positivas, tres identidades de libro independientes,
orden y duplicados, fecha posterior a cada pago y madurez, tabla vacía,
cuatro familias de rendimiento, extremos y tasas pequeñas, mutate, rescates
desordenados con importes asociados, cupones hasta fecha de ejercicio,
prioridad del rendimiento directo, escalas 1e-12/1/1e12, empates exactos y
precios próximos que no son empates, períodos inválidos sin coerción NA.

La ejecución previa sobre 185423b está en b04-book-callable-before.log en el
directorio de artefactos; reproduce errores de valoración, flags y coerción.
Se corrigió una referencia de prueba de prioridad: el mínimo era el escenario
a un año, 105/1.04, no el precio a dos años. No fue una corrección de código.
Las 142 comprobaciones finales pasan sin advertencias. La validación global
se registra en audit-precran-check.md, separada de la primera unidad.

Impacto: firmas, clases y columnas intactas. C05 puede reducir los indicadores
TRUE entre escenarios próximos que antes se aceptaban por un umbral fijo;
es la modificación semántica aprobada. Fechas que se convierten en el mismo
cupón o en un extremo inválido se rechazan en lugar de valorar silenciosamente
otro escenario. Extremos monetarios recuperables reciben valores corregidos.
Las dos firmas y los nombres/clases de columnas tidy se compararon
directamente con 185423b y coinciden. El inventario sigue en 101 nombres
públicos y 960 apariciones de parámetros, sin descripciones Rd faltantes.
Suite completa, build y check del paquete instalado aprobados: 0 ERROR,
0 WARNING y 1 NOTE de versión de desarrollo, salida 0. La segunda unidad
queda cerrada dentro de los límites siguientes; ver artefactos y SHA256
en audit-precran-check.md. Ambas unidades suman 241 comprobaciones nuevas.

Los precios finales irrepresentables todavía pueden redondearse a cero o Inf;
los flags de C05 comparan los precios calculados, no una precisión arbitraria
ni empates matemáticos ocultos por double. Una equivalencia informativa -1/Inf
no sustituye la especificación original. El calendario explícito sigue O(N)
y requiere memoria. No se añade tratamiento entre cupones, stubs, riesgo de
crédito, opción estocástica ni modificación de convenciones de interés corrido.

## Tercera unidad: spot, forwards, bootstrap y cupón par

Inicio sobre a5d8948, árbol limpio y cuatro commits locales sin push. Funciones:
yield_curve, forward_rate, forward_curve, bootstrap_spot_curve y par_rate.
Se preservan firmas, unidades, nombres y forma de las salidas; no hay decisión
nueva de API C. C05 se conserva tal como fue autorizada.

### Modelo y contrastes independientes

Sea a(t) la acumulación logarítmica anual del spot original:
log1p(i), m*log1p(i/m), -m*log1p(-i/m) o la fuerza. Entonces
v(t)=exp(-t*a(t)) y log1p(f(s,t))=[t*a(t)-s*a(s)]/(t-s).
Se evalúa esta última expresión como a(t)+s*[a(t)-a(s)]/(t-s), evitando
potencias desbordadas y preservando curvas planas con un origen grande.
Desde s=0, la expresión es a(t). La composición por intervalos se contrasta
con el descuento acumulado independiente. No se exige monotonía de descuentos
cuando las tasas pueden ser negativas.

forward_rate(method="linear") sigue interpolando tasas efectivas anuales,
no log descuentos ni fuerzas. Su cálculo del forward posterior es logarítmico,
pero su modelo de interpolación permanece intacto. No hay extrapolación nueva.
forward_curve ordena los nodos y sus convenciones conjuntas, incluye origen
solo cuando se pide y conserva sus límites de factores/forwards representables.

Para cupón par: A=sum(v_j), z=log(R/F)+log(v_N) y b=1-exp(z).
Así c=k*b/A y C=F*b/A. Se calculan el signo y logaritmo de b con expm1:
para z<=0, log(abs(b))=log(-expm1(z)); para z>0,
log(abs(b))=z+log(-expm1(-z)). Esto evita multiplicar F por A antes de
dividir y evita cancelar 1-v_N con tasas pequeñas. R=0 y b=0 conservan
sus límites exactos. El log de v_N usa el spot original; los factores y A
reportados siguen en double y la discrepancia de repricing se conserva.

Bootstrap usa el sistema triangular P_j=sum(CF_jk*v_k), despejando el
nuevo factor de un residuo positivo y su pago terminal. La referencia nueva
construye precios por multiplicación matricial con descuentos conocidos,
reordena instrumentos, separa pagos terminales y escala la moneda. Se
contrasta recuperación de v, tasa, precio reconstruido y encadenamiento con
par_rate y forward_curve. No se modificó su algoritmo al no aparecer un
defecto adicional en esos contrastes.

### Hallazgos y correcciones

| ID | Reproducción y causa | Cambio mínimo | Estado |
|---|---|---|---|
| B04-10 | yield_curve rechaza fuerza -100 aunque descuentos a .01/.02 sean exp(1)/exp(2); también pierde spots pequeños al volver a 1+i | Conservar base original y equivalentes informativos; descuento exponencial directo | Implementado y probado |
| B04-11 | forward_rate en curva plana 10% entre años 10000/20000 devuelve NaN por Inf/Inf; forward_curve devuelve 0 para spots 1e-20 y pierde precisión con origen 1e12 | Fórmula logarítmica con spread de crecimiento y origen común; exact usa base original, linear conserva interpolación efectiva | Implementado y probado |
| B04-12 | Con plot=TRUE, asignar [[fila]]<-NULL elimina una posición y puede reciclar un gráfico de otra curva; inicio NA con fin conocido produce error lógico antes de propagar | Asignación [fila]<-list(NULL) preserva longitud; comparación de extremos solo si ambos conocidos | Implementado y probado |
| B04-13 | par_rate con face=1e308, dos años al 5%, da cupón cero y error de precio -9.30e306 por denominador F*A desbordado; spots +/-1e-20 dan cupón cero | Fórmula adimensional y logaritmos firmados de 1-exp(z); productos monetarios con helpers existentes | Implementado y probado |

Evidencia previa: b04-curves-before.log reproduce los fallos antes de editar;
testthat limita su detalle tras diez fallos. La reproducción directa de par
también mostró c_par=0 y repricing_error=-9.30e306. Se corrigió una referencia
de prueba: la tasa efectiva de fuerza 1e-12 es expm1(1e-12), no exactamente
1e-12. Ese ajuste del oráculo no fue una corrección funcional.

### API, tidyverse y límites

| Función | Contrato y unidades conservados | Evaluación |
|---|---|---|
| yield_curve | Un escenario por fila con t/i list-columns; v e i_effective como vectores en listas; t en años | Pipe conserva ID y .keep; NA de curva se propaga por fila, con NULL como gráfico de esa fila |
| forward_rate | Una tasa anual efectiva por intervalo y fila; i_start/i_end efectivos; exact o linear | .data y nombres personalizados se conservan; interpolación sigue efectiva anual; se conserva .na error/drop/propagate |
| forward_curve | Una fila por intervalo consecutivo, curve character y descuentos de extremos | Admite nodos largos, listas y múltiples IDs con orden documentado; m/i_type nodewise siguen al nodo al ordenar |
| bootstrap_spot_curve | Una fila por instrumento y nuevo plazo, precios/cf monetarios y t en años | Pipe triangular sin interpolación; agrupa cupones/rescate simultáneos, ignora ceros y conserva IDs/métricas de repricing |
| par_rate | Una fila por curva, c_par nominal anual y coupon_per_period monetario | Conserva metadatos de listas y parámetros escalares/por curva; admite cupón negativo si lo exige la ecuación, sin piso cero |

No se añaden funciones ni helpers, dependencias, exportaciones o parámetros.
Las cinco firmas, clases de retorno y nombres/clases de columnas se compararon
con a5d8948 y coinciden; el cuerpo ejecutable de bootstrap también coincide
(comparación sin atributos de referencias a líneas de fuente). Evidencia en
b04-curves-compatibility.log. Se mantienen 101 nombres públicos y 960
apariciones de parámetros, sin descripciones Rd faltantes.
Se documenta un dominio recuperado en yield_curve y forward_rate exact:
el equivalente efectivo puede ser -1/Inf por representación, aunque la
especificación original finita permita calcular factores/forwards. Linear
requiere equivalentes efectivos finitos >-1 para interpolarlos. forward_curve
y par_rate mantienen sus validaciones de descuentos positivos finitos;
forward_curve sigue rechazando forwards no representables >-1. No se impone
una nueva política común de m: C02–C04 permanecen separadas y sin implementar.

Finales fuera de double pueden ser 0/Inf en yield_curve o forward_rate;
las columnas de equivalentes pueden saturarse. En todos los modelos los
datos ya redondeados y spreads de spots muy próximos limitan la precisión.
La mejora del origen común no promete precisión arbitraria para cualquier
cancelación entre grandes spots distintos. par_rate todavía puede perder
precisión cuando pagos positivos y negativos grandes se cancelan; no se
oculta repricing_error ni se promete un umbral monetario nuevo.

Bootstrap conserva su dominio de factor y equivalente representables: no
estima nodos ausentes, no ajusta precios negativos/residuos no positivos y no
inventa factores ante falta de resolución. Su repricing_error es diagnóstico,
no una validación independiente. Un sistema casi singular o un residuo pequeño
respecto del precio puede ser inestable incluso con repricing cercano a cero.
No hay tolerancia nueva ni contraste bibliográfico/externo atribuido a esta unidad.

test-curves-numerical-audit.R añade 79 comprobaciones: bases pequeñas y
extremas, curva plana y no plana, origen grande, interpolación efectiva,
composición, tipos nodewise, escalas monetarias, tres políticas NA, espacios
NULL de gráficos, sistema triangular independiente y flujos encadenados.
Los resultados de suite/build/check se registran en audit-precran-check.md.
Las tres unidades B04 acumulan 320 comprobaciones nuevas.
La suite y el paquete instalado pasaron: 0 ERROR, 0 WARNING y 1 NOTE de
versión de desarrollo, salida 0; también ejemplos y las cuatro viñetas.
La tercera unidad y B04-10/B04-13 quedan cerrados dentro del alcance y
límites descritos; bootstrap queda contrastado sin modificación de algoritmo.

## Continuación del bloque

Se han revisado once de las veinte funciones de B04. Siguen duración y
convexidad de flujos, bonos y portafolios, y después inmunización y su gráfico,
preservando los arreglos previos. B04 no está cerrado.
