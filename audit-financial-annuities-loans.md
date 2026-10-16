# B03 — anualidades financieras y préstamos

Rama audit/0.2.0-precran; versión 0.1.6.9000; objetivo 0.2.0.
Continuación del barrido, sin reiniciar B01/B02 ni la auditoría previa.
Esta unidad aborda a_angle, s_angle, amort_schedule,
amort_schedule_general y sinking_fund_schedule. No cierra todavía B03:
annuity_arith y annuity_geom requieren revisión integral propia.

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
| s_angle | Sumas e integrales al final del plazo; ceros y extremos probados | Vector/tibble y columnas preservadas; h metadato del desplazamiento | Horizonte aclarado; queda pulir la afirmación general sobre divergencia de perpetuidades con tasas negativas, sin añadir soporte |
| amort_schedule | Cuota fija y recalculada con misma fórmula estable; reconstrucción de saldo | Tibble por período, principal primero; sin imponer vectorización | n períodos; tol monetario; políticas de extras y casos de escala extrema aún requieren barrido específico |
| amort_schedule_general | Cuota descontada con log crecimiento acumulado; período representable | Tibble; payment escalar/vector/función conservado | i por período es especificación anual, no spot de horizonte; eventos y límites de magnitud pendientes |
| sinking_fund_schedule | Depósito y saldo final con tipo no nulo; moneda escalada | Tibble de flujos auditables; firmas/columnas conservadas | j tasa del fondo; j_m su conversión; preservar validación anual, revisar calendarios extremos después |
| annuity_arith | Aún pendiente de revisión integral | Preservar contrato existente | Próxima unidad: sumas ponderadas y límites |
| annuity_geom | Aún pendiente de revisión integral | Preservar contrato existente | Próxima unidad: i cercano a g, convergencia y plazos largos |

## Diff, evidencia y alcance de cierre

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
