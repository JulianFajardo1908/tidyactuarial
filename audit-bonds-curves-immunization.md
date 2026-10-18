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

## Continuación del bloque

Siguiente unidad: curvas spot, forward y par; después sensibilidad por variable
de derivación y nueva comprobación de inmunización preservando arreglos
anteriores. Se han revisado seis de las veinte funciones de B04; no está cerrado.
