# B06 — Contingencias de una vida y contratos

Objetivo 0.2.0, versión real 0.1.6.9000, rama audit/0.2.0-precran.
Inicio sobre fdd2d1f, 18 de octubre de 2026. Se conserva toda la evidencia
previa y el cierre de B03/B04/B05; este registro no reinicia la auditoría.

## Alcance y conciliación

Los catorce nombres incluyen A_xj, alias de insurance_xj. La existencia de
tests anteriores no equivale a cierre integral del bloque.

| Nombre | Evidencia conservada / siguiente revisión |
|---|---|
| apv_life_flow | Primera unidad numérica descrita abajo; quedan límites expresos |
| plot_contingent_cash_flow | Revisión 67c2b70 y 57 comprobaciones reutilizadas; sin cambios gráficos nuevos |
| annuity_x | B06-02: valoración exacta/fraccionaria, Woolhouse, límites y escenarios; C11 autorizada |
| insurance_x | B06-02: decrementos anuales, diferimiento, extinción y escenarios; C10 autorizada |
| premium_x | B06-03: equivalencia, calendario y plazo variable inferido; límites expresos |
| premium_gross | B06-03: gastos, consistencia monetaria y residuo sin piso de unidad |
| reserve_x | B06-03: flujos condicionados y recursión estable hacia atrás |
| life_contract | Especificación conserva tasa original; pendiente revisión integral con consumidores |
| add_insurance | Pendiente revisión integral del componente contractual |
| add_premium_schedule | Pendiente revisión integral de calendarios |
| annuity_multi | Tests actuariales previos; pendiente conciliación integral |
| insurance_variable_k | Tests actuariales previos; pendiente conciliación integral |
| insurance_xj | Tests actuariales previos; pendiente conciliación integral |
| A_xj | Alias; revisar junto a insurance_xj, sin duplicar función ni evidencia |

## B06-01: flujo de vida, modelo y defectos reproducidos

Para un pago contractual C_j en t_j, la contribución es
PV_j = C_j S(t_j) exp(-delta t_j). delta es log1p(i),
m log1p(i/m), -m log1p(-i/m) o la fuerza original, según i_type.
En UDD, S(k+u) = producto(p_(x+r), r=0..k-1) (1-u q_(x+k)).
No es un seguro pagadero a la muerte: son pagos contingentes a supervivencia.
Para vidas independientes, first usa producto(S_j), last usa
1-producto(1-S_j), y reversionary usa P(todos)+alpha(P(alguno)-P(todos)).
La última cantidad es un peso de beneficio, no en general una probabilidad.

Reproducciones sobre fdd2d1f en b06-life-flow-before.log:

* Fuerza +/-1000 con t=.001: se rechazaba una valoración finita porque la
  conversión anual redondeaba a -1/Inf. Se usa la base log original existente.
* El producto separado podía perder PV finito por descuento cero/Inf o por
  flujo esperado redondeado a cero. Se combinan log(abs(S))+log(descuento)
  antes del producto monetario, conservando signos y ceros conocidos.
* t=NA estaba admitido por la validación y fallaba en un if interno. Ahora
  devuelve una fila NA, sin eliminar posiciones ni alterar los otros pagos.
* Con supervivencias 1e-20 y 2e-20, last devolvía cero. Se evalúa
  -expm1(sum(log1p(-S_j))); la referencia independiente es S1+S2-S1*S2.
* t=1e10 intentaba reservar un vector de 74.5 GB. La consulta recorre como
  máximo nrow(lt) intervalos: devuelve NA si falta información; después de
  px=0 comprobado devuelve cero, incluso más allá del horizonte observado.
* Fechas infinitas y edades fuera de rango terminaban en errores internos o
  coerciones NA; m=3e9 válido se convertía innecesariamente a entero R.

b06-life-flow-compatibility.log reproduce además la aceptación previa de
edades duplicadas/fraccionarias, px>1, qx<0, lx creciente y px/qx contradictorios.
Ahora se rechazan explícitamente. Se validan columnas numéricas finitas o NA,
probabilidades en [0,1], lx no creciente y edades enteras únicas. Los huecos
no se interpolan: el intervalo consultado ausente queda desconocido.
Estos son defectos A de cálculo/validación; la explicación del subtotal y
convenciones de fechas/orden es documentación B. No hay propuesta estética
ni modificación C implementada en esta unidad.

## Compatibilidad, precisión y límites

Firma, clase tibble, nombres/orden/tipos de columnas y atributos conservados;
comparación ordinaria independiente con fdd2d1f en cuatro estados pasa con
tolerancia relativa 1e-12. No se agregan dependencias, helpers compartidos,
columnas, funciones o versión. La gráfica conserva su revisión previa.

Se mantiene explícitamente sum(pv, na.rm=TRUE): el atributo apv es un subtotal
de contribuciones conocidas; todas NA dan cero. pv_cum sigue cumsum en orden
de entrada, con NA posteriores a la primera contribución desconocida. Cambiar
este contrato o reordenar pagos requeriría una propuesta C y autorización.
No se restringe alpha ni se cambia el comportamiento histórico de single con
varias edades. No se unifican convenciones de horizonte con t_px/annuity_x.
La selección de mortalidad conserva prioridad px, después qx y luego lx;
se comprueba complementariedad px/qx, pero queda pendiente conciliar todos
los valores redundantes con lx y precisar la política de tablas incompletas.

El producto anual de supervivencias todavía puede subdesbordar; no se promete
recuperar una supervivencia ya redondeada a cero ni cancelaciones arbitrarias
entre contribuciones infinitas. La recuperación monetaria cubre supervivencia
representable con flujo esperado/descuento intermedios fuera de rango.
Un descuento diagnóstico cero/Inf no implica necesariamente PV cero/Inf.
plot_contingent_cash_flow sigue rechazando entradas no finitas: no se amplía
su contrato a estos diagnósticos extremos ni se revalora dentro del gráfico.

## Verificación

test-b06-life-flow.R añade 60 comprobaciones: fórmulas UDD y cuatro estados,
tasas originales, signos/rango monetario, simultaneidad/orden, NA/subtotal,
extinción/horizonte, fechas, m y validación de mortalidad. Las 24 pruebas de
apv y las 57 de gráfica anteriores se reutilizan, sin contarlas como nuevas.
Resultados globales, archivo y huella: sección B06 de audit-precran-check.md.
Los defectos reproducidos de esta unidad quedan confirmados, implementados,
probados y cerrados dentro de los límites anteriores: check final salida 0,
0 ERROR, 0 WARNING, 1 NOTE por desarrollo, con 4876 comprobaciones instaladas
aprobadas. No se confunde ese cierre con la revisión integral de apv/B06.
B06 continúa abierto; sigue annuity_x/insurance_x, luego primas/reservas y
componentes, conciliando las pruebas existentes antes de ampliar cobertura.

## B06-02: anualidades y seguros, 18 de octubre

Base ede40b7, árbol inicialmente limpio. El usuario pidió especial cuidado
con el rigor y generalidad de ambas funciones y con su falta de vectorización,
cuestionada por Claude. No se encontró el texto original de esas sugerencias;
la revisión y las reproducciones son propias, sin atribuirlas a ese informe.

### Modelo y referencias independientes

Para pagos de anualidad normalizados a una unidad anual:
a = (1/k) sum_j exp(-delta (h+j/k)) S_x(h+j/k), donde j=0..kn-1
para due y j=1..kn para immediate. El plazo exacto exige nk entero y h
permanece entero por contrato. Se usa lx entero y UDD/CF/CML/Balducci en
fracciones. Cada escenario sigue describiendo una sola vida.

Para seguro anual nivelado, los fallecimientos incondicionales del intervalo
[h+r,h+r+1) son (l_(x+h+r)-l_(x+h+r+1))/l_x; la contribución es el beneficio
por esa probabilidad, descontado a h+r+1. El dotal añade beneficio por
S_x(h+n) exp(-delta(h+n)). Se comprueban sumas explícitas de pagos y
A_(h,n) + d a_due_(h,n) = E_h - E_(h+n), también a interés cero/negativo.
Las diferencias de lx se calculan antes de dividir: no se forma 1-l1/l0
para recuperar un decremento raro. Las tasas originales y cocientes log de
conteos retienen valores representables; se valora directamente desde emisión
para evitar multiplicar un factor de diferimiento cero/Inf por otro valor
condicional Inf/cero. Diagnósticos intermedios pueden perder rango sin que
lo pierda la APV final. No se promete representación del resultado infinito.

Woolhouse conserva sus órdenes y normalización. Para mortalidad de fuerza mu
constante y fuerza financiera delta, a=mu+delta: anual anticipada
(1-exp(-an))/(1-exp(-a)), primera corrección (k-1)/(2k)(1-exp(-an)),
segunda (k²-1)/(12k²) a(1-exp(-an)). Esa expansión independiente contrasta
ambos órdenes y el paso due/immediate; no se usa otra llamada al algoritmo
como único oráculo. Se retiene 1-E mediante expm1 y la resta de fuerzas
comunes antes del producto. No se confunde esta aproximación de fuerzas
de borde a partir de probabilidades anuales con una fuerza continua conocida.

### Defectos A y correcciones

* Conversión anual -1/Inf rechazaba fuerzas válidas; productos separados
  perdían pagos finitos. Se reutiliza la base log original y valor monetario.
* lx=(1e16,1e16-2,0) sobreestimaba aproximadamente 11% la mortalidad del
  primer intervalo por cancelación; ahora usa el decremento de dos individuos.
* lx=(100,0,0,0) hacía fallar seguros completos y anualidades fraccionarias
  al pedir probabilidades condicionadas en cohortes ya extinguidas. Las
  contribuciones conocidas nulas son cero; no se divide por una cohorte cero.
* insurance_x(contract,i=.1,i_type=effective) podía usar fuerza del contrato
  pese al override explícito. Se distingue argumento omitido de default
  explícito, también para m; no se modifican contratos almacenados.
* Se rechazan tablas vacías, lx crecientes, mallas no anuales, edades sin lx
  positivo y enteros fuera de rango antes de valorar. Se conserva m grande
  válido sin coerción NA y se acota el número de pagos antes de secuenciar.
  Las sumas de edades se realizan sin overflow entero intermedio.
* Woolhouse de segundo orden sustituía -log(0) por cero. Ahora exige
  supervivencia positiva en los bordes cuya fuerza usa, con indicación de
  usar none. Una aproximación negativa se advierte, sin recortarla a cero;
  un resultado indefinido se rechaza. El método exacto conserva los límites
  UDD/CF/Balducci de intervalos con supervivencia cero.

Regresiones previas: b06-annuity-insurance-before.log; el log
b06-woolhouse-before.log reproduce ausencia de advertencia/rechazo adecuados.
Las primeras correcciones y sus tests no reinician los de B05 ni de primas.

### Extensión B solicitada: escenarios paralelos

Ambas funciones admiten vectores de argumentos de escenario con longitud
común positiva; solo se recicla longitud uno. lt y tidy se comparten.
Anualidad: x/i/i_type/m/n/h/k/timing/woolhouse/frac. Seguro:
x/i/i_type/m/n/h/type/benefit. No hay producto cartesiano ni combinación de
vidas; benefit vectorial son pólizas distintas, no una secuencia de pagos.
Retorno numérico compatible con mutate, o tibble por filas en el orden dado.
Los errores identifican el escenario y no devuelven resultados parciales;
no se introduce una política nueva de NA. NULL de n/frac en anualidades
conserva su significado escalar. Los selectores explícitos vectoriales ahora
designan escenarios; los defaults omitidos siguen eligiendo el primero.

El pequeño helper de escenarios reutiliza motores escalares, sin nuevos
parámetros, exports, clases o dependencias. El segundo helper conserva el
cociente de conteos en log cuando su división subdesborda. Ambos se comparten
solo entre estas dos funciones. Es vectorización de interfaz por escenarios,
no una promesa de ejecución matricial, paralela o más rápida en portafolios.

### C10 y C11: autorizadas antes de implementar

El usuario aprobó expresamente ambas decisiones en este turno. C10 corrige
insurance_x(type=endowment,n=0): paga benefit E_h, no cero; term n=0 conserva
cero. C11 mantiene APV=0 en anualidad vacía, devuelve pure_endowment_factor=1
y añade annuity_value_at_start=0 en su posición ordinaria. Esto uniforma la
fila vacía al combinar escenarios. El log b06-scenarios-c10-c11-before.log
reproduce las ocho aserciones fallidas antes de aplicar ambas decisiones.

### Generalidad actuarial y alcance

| Necesidad de una vida | Soporte y límite explícito |
|---|---|
| Vida entera/temporal, diferimiento, tasas positivas/cero/negativas | Ambas, dentro del horizonte de su tabla y rango representable |
| Pagos de anualidad anticipados/vencidos, anuales o k veces por año | Exactos con las tres hipótesis fraccionarias; CML equivale a CF; Woolhouse aproximado separado |
| Seguro nivelado de vida entera/temporal/dotal | insurance_x: muerte durante el año, pago al final de ese año |
| Beneficios variables o al final de subperíodos | insurance_variable_k ya tiene ese modelo; su revisión integral B06 sigue pendiente |
| Dotal puro o pagos arbitrarios de supervivencia | t_Ex y apv_life_flow tienen contratos propios; no se agregan aliases ni tipos redundantes |
| Momento exacto de muerte, anualidad continua, edad o diferimiento fraccionario general, curvas de interés | No se simulan con el contrato anual; requieren especificar interpolación, integración y nueva API antes de ampliarlas |

Se conserva el cierre implícito l_(omega+1)=0 de estos dos consumidores,
incluso con lt abierta. C07 cambió el constructor, no autorizó reinterpretar
todos sus consumidores. La generalización futura debería decidir ese horizonte
de forma expresa y coordinar premiums/reserves/contratos; no se inventa cola.
No se declara máxima generalidad matemática ni revisión externa conciliada.

### Evidencia y continuidad

74 comprobaciones nuevas matemáticas/validación y 44 de escenarios/C10/C11:
118 en esta unidad, 178 nuevas acumuladas en B06 contando la unidad apv.
Se mantienen todas las pruebas previas de anualidades, seguros, SOA, primas
y reservas. b06-annuity-insurance-compatibility.log compara 60 casos ordinarios
con ede40b7: mismas firmas, clases, columnas, tipos y valores con tolerancia
relativa 1e-12. C10/C11 se contrastan aparte; no se disimula su incompatibilidad.
Las pruebas incluyen mutate, contratos, entradas antiguas de seguro, tasas
nominales/de fuerza, pesos firmados, simultaneidad de escenarios, reciclaje
estricto, NA y cuadros auditables. Referencia de suite, check y archivo final:
audit-precran-check.md. Defectos de esta unidad confirmados, implementados,
probados y cerrados dentro de sus modelos y límites: check final salida 0,
0 ERROR, 0 WARNING, 1 NOTE por desarrollo; 4994 comprobaciones instaladas
aprobadas, ejemplos y viñetas aprobados. C10/C11 cerradas en su alcance
autorizado. B06 sigue abierto; continuar primas y reservas, luego
componentes y modelos restantes, conservando estas correcciones.

## B06-03: primas y reservas, 19 de octubre de 2026

Base 576c9a1, árbol limpio al iniciar. Se conservan C10/C11 y la revisión
anterior de anualidades/seguros. No se han modificado firmas, columnas,
dependencias, versión ni estados condicionantes de contratos. Se concilian
las pruebas v2 anteriores con referencias independientes, sin presentarlas
como nuevas ni interpretar este paso como cierre integral de B06.

### Ecuaciones e identidades

Prima neta anualizada: P=B/a, con a=sum_j S(t_j) exp(-delta t_j)/k.
El pago de cada fecha es P/k. El libro independiente enumera fechas desde
emisión o diferimiento, n_prem entero o alineado con k, y probabilidades
UDD. Se contrastan tasas negativas/cero/positivas y frecuencias 1/4.

Prima comercial: G a=P a+alpha G/k+beta G a+gamma k a. Por tanto
G=(P+k gamma)/D, D=(1-beta)-alpha/(ka)>0. alpha es adquisición al inicio,
beta proporción de cada prima y gamma gasto monetario en cada fecha de prima,
con su contingencia de supervivencia. No se añaden gastos en fechas distintas.
Los libros independientes enumeran estas cuatro APVs para k=1/4/12 y monedas
1e-100/1/1e100. No se usa premium_x como único oráculo de gastos.

Reserva antes de la prima: V_t=B_t-P a_t, condicionada a estar vivo en x+t.
Para primas anuales, (V_t+P_t)(1+i)=p_(x+t)V_(t+1)+q_(x+t)b_(t+1).
La forma equivalente hacia atrás es
V_t=exp(-delta)[p_(x+t)V_(t+1)+q_(x+t)b_(t+1)]-P_t.
El libro independiente cuenta lx sobrevivientes y decrementos desde cada
fecha; en dotales incluye pago al vencimiento. Se contrastan inicio de primas
en emisión/diferimiento, pagos trimestrales, términos de prima fraccionarios,
temporales/dotales y límites de vida entera. No se confunde P anualizada con P/k.

### Hallazgos confirmados e implementación

* premium_x admitía primas posteriores a una cobertura variable inferida de
  su vector, porque n=Inf ocultaba el plazo finito real. Ahora usa longitud
  del beneficio/k_benefit para límite de primas y audit insurance_term_years.
  El default sigue infiriendo ese plazo; no se añade un parámetro. Los plazos
  variables explícitos fraccionarios delegan su alineación al productor;
  los seguros estándar conservan n entero. La revisión integral de
  insurance_variable_k y sus límites numéricos sigue pendiente.
* Se validan check lógico, edades/diferimientos fuera de rango y overflow
  de n_prem*k antes del redondeo. m grande válido no se convierte a NA.
* premium_gross comparaba dinero con tol*max(1,P), aceptando inconsistencia
  de unidades al expresar primas pequeñas. Ahora compara relativamente
  al máximo de los dos importes, sin piso monetario; valida el pago almacenado
  y la frecuencia seleccionada incluso si k se suministra explícitamente.
  Se conserva la prioridad de nombres preferidos/legados, no se promete
  conciliación de todas las columnas redundantes que el usuario pueda añadir.
* alpha/(ka) perdía adquisición al desbordarse ka. Se usa la base log cuando
  hace falta recuperar ese cociente. Las cargas se calculan desde gastos
  originales: P beta/D + alpha P/(kaD) + k gamma/D, conservando términos
  representables aunque la participación intermedia o G-P redondeen a cero.
* El residuo comercial conserva gastos monetarios realmente calculados.
  Se netean G-P antes de a; si aparecen Inf-Inf se agrupan los términos con
  factor a antes de restar adquisición. No se sustituye el residuo por cero
  ni se pierde beta/alpha solo porque D redondee a uno. Por ejemplo P=1e20,
  beta=1e-20, a=k=1 da carga aproximada 1 y residuo aproximado -1 cuando
  el G representable coincide con P. Es un diagnóstico de redondeo, no una
  promesa falsa de equivalencia exacta de las cifras ya redondeadas.
* La recursión hacia adelante de reserve_x amplificaba error por 1/p.
  Con p=.01, i=.1 y prima 90 por beneficio 100, todas las reservas de un
  temporal son cero por identidad; la anterior acababa con errores de
  millones tras diez pasos. Ahora se evalúa la misma identidad hacia atrás,
  con tasas originales y probabilidades/decrementos directos de lx.
* No se obtiene p como 1-q: p muy pequeño representable ya no se convierte
  en cero por cancelación. q se obtiene de (l0-l1)/l0, conservando pérdidas
  pequeñas. Se reutilizan los helpers log/monetarios existentes, sin nuevos.
* La condición final se obtiene prospectivamente en la última cohorte positiva
  dentro del horizonte, no se impone cero. Esto conserva la obligación final
  de vida entera. No se recorren cohortes extinguidas no solicitadas; los
  pagos formales al vencimiento conservan su convención. Cero de prima con
  factor diagnóstico infinito produce APV de primas cero, no NaN.

### Evidencia, compatibilidad y límites

b06-premiums-reserves-before.log reproduce 18 fallos/5 advertencias sobre la
base original con 191 comprobaciones ya aprobadas. La revisión adicional del
residuo provisional está en b06-gross-residual-before.log: casos de cargo
monetario no nulo con G-P o una participación redondeados a cero. El log
b06-premium-periods-before.log reproduce errores internos por n_prem*k infinito.
Los 212 focos iniciales pasaron; se ampliaron luego calendarios y límites.
La validación definitiva y el archivo fuente se registran en audit-precran-check.md;
los logs preliminares no sustituyen b06-premiums-reserves-final-tests.log.

b06-premiums-reserves-compatibility.log compara 42 casos ordinarios/salidas
con 576c9a1: tres firmas, clases, nombres y tipos conservados; valores con
tolerancia relativa 1e-12. El residuo comercial cuya aritmética se corrige se
verifica por escala monetaria separadamente, no por igualdad binaria histórica.
Los cambios son A numéricos/de validación y B de documentación/extensión de
plazo variable ya soportado por su productor; no hay decisión C nueva.

Se preserva la interfaz escalar de contratos/primas; t sigue siendo un vector
de duraciones de una póliza y benefit variable una secuencia de prestaciones,
no un vector de escenarios. No se fuerza vectorización universal ni se cambia
output/tidy o el orden de argumentos. La familia permite pipes y tablas de
auditoría; distintas pólizas requieren llamadas separadas. Las funciones de
anualidades/seguros ya vectorizadas conservan su ampliación previa.

El horizonte de vida entera en reserve_x sigue siendo la última edad con lx
positivo; la condición de borde puede incluir el último año implícito del
seguro. El horizonte finito debe estar soportado por edades registradas.
Una reserva intermedia pedida sobre una cohorte extinguida sigue siendo
indefinida; no se introduce una política nueva de NA ni de estado observado.
Recursión: k=1 y primas due; prospectiva: k-thly due. Se mantienen estos
contratos locales sin uniformarlos automáticamente con otros consumidores.

premium_x sigue exigiendo factor de prima finito y positivo; no se recupera
un cociente arbitrario de APVs infinitas. La cobertura variable conserva
limitaciones de su productor pendiente de revisión. No se prometen cancelación
general de infinitos, cargas fuera de rango ni precisión absoluta exacta de
residuos en monedas enormes. Woolhouse conserva sus límites de B06-02.
No se refactorizan componentes ni se añaden probabilidades/colas inventadas.

Estado de esta unidad: hallazgos confirmados, implementados, probados y
cerrados dentro de los modelos/límites anteriores. 239 comprobaciones nuevas
aprobadas, suite local completa aprobada y archivo verificado con 377 archivos
de código/pruebas/Rd/ejemplo/NEWS/NAMESPACE iguales al checkout. Check final
salida 0: 0 ERROR, 0 WARNING, 1 NOTE por desarrollo; 5233 comprobaciones
instaladas aprobadas, ejemplos y viñetas aprobados. B06 acumula 417 nuevas.

B06 continúa abierto: siguen life_contract, add_insurance y
add_premium_schedule, y luego las valoraciones restantes de este bloque.
