# Auditoría de riesgo colectivo y coberturas — 2026-10-16

Rama: `audit/0.2.0-precran`. Versión comprobada: `0.1.6.9000`.
Este registro cubre los tres hallazgos reproducidos en esta revisión; no
equivale a cerrar todos los hallazgos de la auditoría externa.

## 1. Dependencia indebida de la unidad monetaria

Estado: confirmado, implementado y probado mediante regresiones.

Identidad: si las severidades se multiplican por `s > 0`, el agregado se
multiplica por `s`, conservando sus probabilidades. Para frecuencia
Binomial(2, 1/2) y severidad equiprobable en {1, 2}, la PGF es
`(1/2 + z/4 + z^2/4)^2`. Las probabilidades en {0,1,2,3,4} son
{1/4,1/4,5/16,1/8,1/16}. Cortar en 2 deja cola 3/16.

Causa raíz: la inferencia de retícula y la fusión de soportes usaban
tolerancias absolutas con un piso de una unidad monetaria. Los cortes
`max_loss` de convolución y FFT tenían el mismo problema.

Antes: con `s = 1e-16`, convolución y Panjer devolvían toda la masa en cero;
FFT rechazaba el modelo. Después: los tres métodos recuperan las cinco
masas y la cola 3/16 para escalas 1, 1e-16 y 1e16.

Diff: inferencia decimal sobre importes normalizados por una potencia de
diez, rechazo de retículas que redondeen importes positivos a cero,
comparaciones monetarias relativas al importe.

## 2. Eliminación de eventos raros con pérdida esperada material

Estado: confirmado, implementado y probado mediante regresiones.

Identidad: para N=1, P(X=1e20)=1e-20 y el resto en cero,
`E[S]=1` y `E[(S-5e19)+]=1/2`.

Causa raíz: la fusión de masas eliminaba probabilidades <= 1e-18 sin
considerar el tamaño de la pérdida ni registrar un error en momentos.
Antes: ambas expectativas eran cero. Después: son 1 y 1/2.

Diff: conservar toda masa estrictamente positiva representable. No se
introduce renormalización ni se reconstruyen probabilidades que ya hayan
sufrido underflow en un proveedor o algoritmo.

## 3. Stop-loss incorrecto con límites muy altos

Estado: confirmado, implementado y probado mediante regresiones.

Sea Z=fX exponencial con tasa r=rate/f; D el deducible efectivo, L el
límite efectivo y c el coaseguro. Para retención d, sea a=d/c.
Con deducible ordinario y a<L:

`E[(Y-d)+] = c exp(-r(D+a)) [1-exp(-r(L-a))]/r`.

Con franquicia, sea t=max(D,a), b=max(0,min(t,L)-a), w=max(0,L-t):

`E[(Y-d)+] = c exp(-rt) [b + (1-exp(-rw))/r]`.

Si a>=L, c=0 o L=0, la prima es cero. L puede ser infinito.
Las identidades se obtienen integrando la supervivencia exponencial;
`expm1` evita cancelación en capas estrechas.

Causa raíz: la cuadratura sobre [d,cL] puede no muestrear la zona donde
está la masa al ser L enorme. Con X~Exp(1), D=1, c=1, L=1e15 y d=0,
devolvía cero, frente a exp(-1)=0.3678794412. Sin límite, rechazaba la
distribución custom resultante, aunque existe fórmula cerrada.

Diff: fórmula cerrada para severidades exponenciales por pérdida creadas
con `apply_coverage()`. Pruebas independientes integran el pago sobre la
variable de pérdida original, con deducible ordinario y franquicia,
límites por debajo y por encima del deducible y límite infinito. Se
comprueban también inflación, indexación, coaseguro y TVaR en el átomo
del límite.

## 4. Desplazamiento absoluto del nivel de VaR

Estado: confirmado, implementado y probado mediante regresiones.

Identidad: `VaR_p = inf{x: F(x) >= p}`. Con masas 1/2 en 0 y 100,
el cuantil en 1/2 es 0 y en `1/2 + .Machine$double.eps` es 100.
Con masas 1e-20 en 1 y el resto en 2, los niveles 1e-20 y 2e-20
seleccionan respectivamente 1 y 2.

Causa raíz: el criterio restaba `8 * .Machine$double.eps` a todos los
niveles, incluso a probabilidades mucho menores. La validación de cola
toleraba además un exceso absoluto de 1e-12.

Antes: ambos pares de niveles devolvían el primer importe y un nivel
ligeramente superior a la masa retenida podía aceptarse. Después: las
comparaciones usan directamente las probabilidades acumuladas calculadas;
los niveles fuera de la masa retenida se rechazan.

Diff mínimo: dos comparaciones en `.risk_discrete_var()`. Las pruebas
están junto a las pruebas públicas existentes de `value_at_risk()`.

## 5. Masa omitida por frecuencia FFT interpretada como cola de pérdidas

Estado: confirmado, implementado y probado mediante regresiones.

Referencia independiente: si N~Poisson(2) y cada severidad es Bernoulli(.1),
el agregado es Poisson(.2) por adelgazamiento. Su VaR al 80% es cero.
FFT con `tol=.1` omite N>4, cuya probabilidad es aproximadamente .052653.
La masa retenida en cero es aproximadamente .789, frente a la probabilidad
completa exp(-.2), aproximadamente .819. Antes se devolvía VaR=1.

Causa raíz: `tail_probability` contiene masa de frecuencias omitidas,
que puede contribuir dentro de la malla de pérdidas. No siempre es una
cola estrictamente superior al máximo importe retenido.

Corrección: si epsilon es la probabilidad de frecuencias omitidas,
`F_ret(x) <= F(x) <= F_ret(x)+epsilon`. Además, esas frecuencias producen
al menos `(n_max+1) * severity$support$lower` de pérdida. Un cuantil
candidato v queda identificado si esa cota inferior es >=v, o si la masa
retenida estrictamente antes de v más epsilon sigue siendo menor que p.
Cuando ninguna condición lo determina, se rechaza el cuantil y se indica
reducir `tol`. La cota es conservadora: no se calcula silenciosamente un
modelo diferente ni se presenta una aproximación ambigua como identificada.

Después: el ejemplo grueso rechaza el nivel .8; los niveles .7 y .9
siguen identificados y coinciden con Poisson(.2). Con `tol=1e-9`, el
nivel .8 devuelve cero. Se comprueba también el uso de una severidad
mínima positiva para identificar cuantiles afectados solo en el mismo átomo.

## 6. Adelgazamiento que elimina riesgo positivo por redondeo

Estado: confirmado, implementado y probado mediante regresiones.

Identidad: para frecuencia binomial negativa o geométrica con parámetro p,
y probabilidad q de un pago positivo, el parámetro transformado es
`p_P = p / (p + q(1-p))`. El agregado debe conservar su distribución y,
cuando existen, sus momentos al cambiar de base por pérdida a por pago.

Ejemplo: frecuencia binomial negativa con size=2 y p=.5; severidad con
probabilidad 1e-20 en 1e20 y el resto en cero. La esperanza agregada por
pérdida es 2. Antes, el parámetro adelgazado redondeaba a 1 y la esperanza
agregada por pago se convertía en cero. En geométrica, el mismo ejemplo
pasaba de esperanza 1 a cero.

Además, la expresión anterior `1/(1+q(1-p)/p)` desbordaba en la división
intermedia para p=1e-310 y q=.5, aunque p_P, aproximadamente 2e-310,
es representable.

Diff mínimo en `R/to_payment_basis.R`: usar la forma sin división
intermedia por p; rechazar explícitamente los casos de frecuencia positiva
cuyo p_P redondea a 1. En ese caso se mantiene disponible el modelo por
pérdida; no se agrega otra parametrización ni se aproxima la frecuencia.

Pruebas en `test-to-payment-basis.R`: seis comprobaciones nuevas para
las dos familias. Verifican la esperanza original, el rechazo de la
representación degenerada y el cociente p_P/p=2 en el caso diminuto
representable. Las dos clases de fallo se reprodujeron antes de corregir.

Compatibilidad: las conversiones habituales conservan su familia y esquema;
una conversión numéricamente no representable ahora falla en vez de
devolver un agregado distinto. La pérdida original no se modifica.

## Compatibilidad y validación

Se conservan argumentos y columnas públicos. Cambian los resultados
afectados descritos arriba. El campo `method` de las primas exponenciales
cubiertas pasa de `numerical_survival` a `closed_form`; TVaR hereda esta
identificación. Otros modelos custom conservan su integración existente.

Las pruebas están en `tests/testthat/test-risk-audit-regressions.R`.
Las regresiones de VaR están en `tests/testthat/test-value-at-risk.R`.
Las regresiones fallaron antes de las correcciones y pasan después.
También pasan las pruebas existentes de distribución agregada y stop-loss.
Resultado final: 48 comprobaciones nuevas aprobadas; suite completa
`testthat::test_local(reporter = "summary")` aprobada, con salida 0.
Documentación regenerada con roxygen2 y `git diff --check` sin errores.
La continuación de VaR incorpora nueve comprobaciones adicionales; sus
casos reproducidos fallaban antes y las pruebas específicas pasan después.
La suite completa volvió a pasar tras esta continuación (salida 0),
incluyendo las 18 comprobaciones de `test-value-at-risk.R` y las pruebas
existentes de TVaR, stop-loss y cambio de base por pago.
Los niveles identificables mantienen el esquema público de retorno. Los
niveles ambiguos por truncación FFT ahora generan error en lugar de devolver
el cuantil de la subdistribución retenida.

Revisión adicional del cambio de base: seis comprobaciones nuevas
aprobadas en `test-to-payment-basis.R`, que ahora contiene 45. La suite
completa volvió a finalizar sin fallos, salida 0.
`actuar` no está instalado en este entorno: la referencia independiente
usada es expansión polinómica e integración directa del pago original.
