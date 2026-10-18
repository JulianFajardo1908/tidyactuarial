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
convexidad. Permanecen 16 funciones del bloque por revisar integralmente.

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

## Continuación del bloque

Siguiente unidad: bond_book_value y bond_callable_price; luego curvas spot,
forward y par; sensibilidad por variable de derivación y nueva comprobación
de inmunización preservando arreglos anteriores. B04 no está cerrado.
