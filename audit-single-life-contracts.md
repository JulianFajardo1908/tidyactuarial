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
| life_contract | B06-04: almacenamiento fiel, dominio de tasas y consumidores; límites expresos |
| add_insurance | B06-04: componentes, tipos, conservación y plazos positivos |
| add_premium_schedule | B06-04: grilla finita positiva y supuestos almacenados |
| annuity_multi | B06-05: pagos 1/k, extremos temporales de Woolhouse y C12 autorizada; límites expresos |
| insurance_variable_k | B06-05: masas de fallecimiento subanuales, calendario y estabilidad monetaria |
| insurance_xj | B06-05: estado activo, decrementos competidores, grilla anual y log supervivencia |
| A_xj | Identidad con insurance_xj verificada; no se duplica función ni evidencia |

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

## B06-04: especificación de contratos y componentes (19 de octubre)

Base acab741, sin repetir B06-01/02/03. Se revisan life_contract,
add_insurance y add_premium_schedule con sus consumidores existentes.
Son constructores escalares de una especificación, no motores de APV ni
escenarios vectorizados. Un beneficio variable sigue siendo un calendario.

### Modelo y alcance

La tasa almacenada debe admitir acumulación positiva: 1+i>0, 1+i/m>0 o
1-i/m>0 según sea efectiva, nominal de interés o nominal de descuento.
La fuerza puede ser cualquier real finito. No se reemplaza la tasa original
por su equivalente anual: una fuerza extrema válida puede tener equivalente
redondeado a -1/Inf y aun así producir factores de intervalos representables.
El calendario finito debe contener N=n_prem*k pagos, con N finito, entero y
positivo. La tolerancia de alineación no debe convertir un plazo positivo
en un calendario vacío. Los términos estándar positivos deben redondear a
por lo menos un año; n=0 continúa fuera del contrato de estos componentes.
C10/C11 no autorizan extender automáticamente sus propios casos cero aquí.

Libro independiente: lx=1000*.8^(x-40), seguro temporal de tres años,
h=1, beneficio 500, nominal .06 convertible semestral. Con g=2 log1p(.06/2),
B=sum(500*.8^j*.2*exp(-g*(j+1)), j=1..3). Para primas semestrales due
durante dos años, a=(1/2) sum(S(t)*exp(-g*t), t=0,.5,1,1.5), con
S(t)=.8^floor(t)*(1-.2*(t-floor(t))) bajo UDD. La prima anualizada B/a
coincide con premium_x del contrato; se contrastan también cambios explícitos
de beneficio y tasa y anualidades con nominales de frecuencia grande.

### Defectos confirmados y corrección mínima

* Coerciones as.integer convertían edades, frecuencias, plazos y diferimientos
  finitos fuera del rango integer en NA, con advertencias. Se conserva integer
  en el rango ordinario y double redondeado fuera de él, como en B06-02/03.
  Esto almacena fielmente; no promete valorar horizontes imposibles o enormes.
* life_contract aceptaba bases de acumulación no positivas, pese a anunciar
  validación de la tasa. Se reutiliza standardize_interest para el dominio,
  descartando el equivalente y preservando i/i_type/m y aliases originales.
* n_prem*k infinito y k convertido en NA causaban un if con valor ausente;
  ahora el número de pagos se comprueba antes de redondear/almacenar.
* Un plazo positivo minúsculo podía almacenarse como cero en primas y seguros
  estándar. Se rechaza expresamente, conservando términos fraccionarios
  alineados de primas y los términos variables previamente soportados.

Las reproducciones sobre acab741 están en b06-contract-storage-before.log:
12 fallos/errores y nueve advertencias;
la visualización del reporter limita los fallos detallados a diez. Los tests
ampliados definitivos añaden tasas nominales grandes y almacenamiento diferido
de funciones de beneficio, sin invocar dichas funciones al construir.

### Compatibilidad, evidencia y límites

b06-contract-storage-compatibility.log compara 72 objetos ordinarios completos
con acab741: clases, nombres, tipos, valores, aliases y tres firmas idénticos.
No se añaden campos o dependencias. Se preservan tibbles/atributos, campos
del usuario, retorno para pipes y copias sin mutar el contrato original.
El componente de primas captura frac al añadirse; no se transforma en una
herencia dinámica al reemplazar el seguro. n_prem=NULL queda sin resolver
hasta la valoración. El estado joint/last y los tipos permitidos conservan
su selección anterior; se reutilizan las pruebas multivida previas.

Clasificación A: fallos de coerción, bases inválidas y calendarios vacíos o
no finitos. B: documentación de almacenamiento, alcance y supuestos capturados.
No hay propuesta C nueva ni cambio del significado de valores válidos ordinarios.
La validación del constructor de tablas sigue siendo estructural (data.frame,
x/lx numéricos). Cada consumidor comprueba su dominio mortal, edades, horizonte,
grilla, Woolhouse y disponibilidad según su modelo; este cierre no certifica
todas las valoraciones multivida/simulación ni permite estados manipulados
arbitrariamente después de construir. No se evalúa anticipadamente benefit
funcional ni se validan aquí todos los plazos cruzados: se pueden ensamblar
componentes en cualquier orden y los argumentos explícitos pueden sustituirlos.

68 comprobaciones nuevas aprobadas, B06 acumula 485. Resultado definitivo de
suite, archivo fuente verificado y check instalado: audit-precran-check.md.
B06 sigue abierto: continúan annuity_multi, insurance_variable_k e
insurance_xj/A_xj; no se duplica la revisión del alias.

Estado B06-04: confirmado, implementado, probado y cerrado dentro de ese
alcance. Check final salida 0: 0 ERROR, 0 WARNING, 1 NOTE por desarrollo;
5301 comprobaciones instaladas aprobadas, ejemplos y viñetas aprobados.
Archivo fuente verificado con 378 archivos coincidentes y huella registrada.

## B06-05: anualidad multivida y seguros restantes (21 de octubre de 2026)

Base d117df3. La implementación y las pruebas de esta unidad comenzaron el
20 de octubre y sobrevivieron a la interrupción de conexión. No se reinicia
la revisión ni se repiten los arreglos de las unidades anteriores.

### Definiciones actuariales y contraste independiente

annuity_multi valora una póliza con 1-3 vidas inicialmente vivas e independientes.
Con S_j(t), el peso joint es producto S_j y el peso last es
1-producto(1-S_j). La etiqueta histórica reversionary representa
w(t)=(1-alpha)joint(t)+alpha last(t): paga uno mientras todos viven y alpha
mientras alguno pero no todos viven. No es una renta que empieza únicamente
al fallecer una vida designada; no se cambia esa definición ni se añade ese
producto distinto. Para alpha fuera de [0,1] puede ser un peso de beneficio,
no una probabilidad; se conserva su dominio real finito documentado.

Con F(t)=exp(-g*t)w(t), la renta k-thly anualizada paga 1/k y suma
F(h+j/k)/k. Due usa j=0..nk-1; immediate j=1..nk. First Woolhouse resta
(1-1/k)(F(h)-F(h+n))/2 a la renta anual due. Second resta además
(1-1/k^2)((g+eta_h)F(h)-(g+eta_(h+n))F(h+n))/12.
eta_t=-log(w(t+1)/w(t)) es una estimación anual hacia adelante de la
derivada logarítmica del peso, no una fuerza instantánea exacta conocida.
Immediate resta (F(h)-F(h+n))/k a due. Se requieren pesos positivos y datos
del año siguiente en ambos bordes para second; exact none evita esa hipótesis
de suavidad. Se advierten aproximaciones negativas; no se recortan a cero.

insurance_variable_k: cada b_j es el importe completo si la muerte ocurre
en (h+(j-1)/k,h+j/k], pagadero al final de ese subperíodo. APV=sum b_j
exp(-g*t_j)(S(t_(j-1))-S(t_j)). No se divide b_j por k y no es un seguro
pagadero al momento exacto de muerte. Un beneficio funcional se evalúa en
j/k, relativo al inicio de cobertura; probabilidades/descuento incluyen h.
Se mantienen beneficios con signo y un solo contrato por llamada; el vector
benefit es calendario, no un conjunto de pólizas.

Para un año con supervivencia p y q=1-p, desde fracciones u0 a u1:
UDD tiene masa q*(u1-u0); CF tiene p^u0*(1-p^(u1-u0)); Balducci tiene
p*q*(u1-u0)/((p+u0*q)(p+u1*q)). Se multiplica por supervivencia desde emisión
al inicio de ese año. Las diferencias lx-lx_siguiente y log/expm1 conservan
las masas sin restar supervivencias casi iguales ya redondeadas. CF/Balducci
con p=0 conservan el límite degenerado al principio del intervalo anual,
coherente con la convención fraccionaria existente; no es una fuerza finita.

insurance_xj: APV=B sum(exp(-g*(r+1)) producto(p_total desde emisión hasta
r-1) q_j(x+r), r=h..h+n-1). q_j son probabilidades dependientes de salida
desde el estado activo en competencia con las demás causas, no probabilidades
netas si las otras causas no existiesen. El importe se paga al final del año;
no se vuelve a multiplicar por supervivencia al final de ese año. Se conserva
la vectorización paralela existente con reciclaje de escalares, las columnas
tidy y A_xj como alias idéntico.

Referencias contrastadas para el modelo, sin atribuirles nuestras convenciones
de API: [notas SOA de Hardy/Dickson/Waters, sección 3](https://www.soa.org/globalassets/assets/files/edu/edu-2012-spring-mlc-studynotes.pdf)
distinguen decrementos dependientes e independientes;
[implementación del autor de actuarialmath, Woolhouse](https://actuarialmath.readthedocs.io/en/latest/_modules/actuarialmath/woolhouse.html)
construye la renta temporal por diferencia entre valores en ambos extremos.
La prueba propia usa identidades analíticas, no importa esos programas ni
supone que su estimación de fuerza coincida con la nuestra.

### Defectos demostrados, cambios y aprobación

b06-remaining-diagnosis.log reproduce sobre d117df3: para lx=(100,80,60,40,20),
i=0, n=1, k=2 y due, annuity_multi none daba 1 y first .75 frente a .95
bajo UDD. none ignoraba k; Woolhouse omitía el borde final de la renta temporal.
C12 fue autorizada expresamente: se añade frac al final, se calcula la grilla
real y se corrigen ambos bordes. Las firmas posicionales anteriores permanecen.

El mismo log reproduce insurance_variable_k con lx=1e16 y lx_siguiente=1e16-2,
beneficio 1e16 e i=0: devolvía 2.220446 en vez de 2. Se reemplaza la resta de
supervivencias por masas de intervalo directas. Se conserva la tasa log original
y el producto monetario combinado, incluyendo ceros y supervivencia subdesbordada.
Se validan grillas finitas, edades, tabla no creciente y horizonte, y se reconoce
el atributo CML como CF. n/h siguen admitiendo términos fraccionarios alineados.

insurance_xj aceptaba edades 40,42 como dos intervalos consecutivos (APV .44
en el ejemplo) y columnas de supervivencia como causa. Ahora rechaza esos
datos incompatibles, verifica probabilidades seleccionadas y totales, controles
y longitudes vacías; conserva enteros grandes sin coerción NA cuando proceda.
Supervivencia acumulada y descuento se combinan en log para recuperar APV
representable, en lugar de multiplicar un cero intermedio por un beneficio.

Se añade un único helper privado compartido, utils-life-payment-basis.R,
para validar la tabla anual y evaluar supervivencia/muerte fraccionaria en
annuity_multi e insurance_variable_k. Reutiliza los helpers monetarios y de
interés existentes; no se refactorizan consumidores ajenos ni se añaden
dependencias, aliases o columnas públicas.

### Pruebas, compatibilidad y límites

153 comprobaciones nuevas: 91 en test-b06-annuity-multi.R y 62 en
test-b06-remaining-insurance.R. Pruebas independientes de 1-3 vidas, estados,
timing, tres interpolaciones, h/n, Woolhouse con fuerza constante, vida inmortal,
beneficios variables con signo/funcionales, decrementos competidores, suma de
causas, escenarios, ceros, tasas extremas y subdesbordamiento. Los fallos previos
están en b06-annuity-multi-before.log y b06-remaining-insurance-before.log.
La suite fuente completa quedó aprobada antes de la interrupción:
b06-remaining-final-tests.log. El check instalado definitivo se registra en
audit-precran-check.md y no se sustituye por esa ejecución preliminar.

b06-remaining-compatibility.log verifica 62 casos ordinarios completos con la
base: valores a tolerancia 1e-12, clases/nombres/esquemas conservados. Dos
firmas idénticas; annuity_multi conserva todos sus formals anteriores y añade
solo frac al final. Identidad de A_xj verificada. Inventario: 102 nombres
públicos y 974 apariciones de parámetros, cero descripciones ausentes.

Límites preservados: horizonte conservador de annuity_multi basado en menor
omega y mayor edad (puede truncar tablas distintas más de lo necesario);
edades enteras y 1-3 vidas independientes; n entero para annuity_multi;
Woolhouse aproximado y con fronteras soportadas. No se declara dependencia
estocástica entre vidas, productos continuos, renta revertida pura ni máxima
generalidad. insurance_variable_k requiere horizonte registrado y no inventa
un último año; no vectoriza escenarios. insurance_xj whole sobre tabla abierta
es un APV truncado al horizonte disponible: solo es vida entera completa si
no quedan activos después de la última fila. p_total y la causa seleccionada
son la base; no se certifican todas las columnas redundantes de cohortes.
No se promete cancelación arbitraria de infinitos ni valores fuera del rango
double. B06 acumula 638 comprobaciones nuevas; se conserva evidencia anterior.

Conciliación adicional de borde en b06-terminal-support-before.log: t_px
establece supervivencia cero más allá de omega aun con qx terminal suministrada.
La versión anterior de insurance_variable_k convertía esa truncación en masa
de muerte al cruzar omega. La validación actual rechaza esa cobertura; no
extiende automáticamente el horizonte con la probabilidad terminal. Una
valoración que use un intervalo terminal adicional sería una ampliación de
modelo a diseñar explícitamente, no una regresión de almacenamiento o de C07.

Estado B06-05: confirmado, implementado, probado y cerrado dentro del alcance
anterior. Archivo fuente verificado (381 archivos), check final salida 0:
0 ERROR, 0 WARNING, 1 NOTE por versión de desarrollo; 5454 comprobaciones
instaladas aprobadas, 0 fallos/advertencias/omisiones. Ejemplos y viñetas
aprobados. Huella y entorno en audit-precran-check.md.

B06 queda cerrado dentro del alcance y límites documentados de sus 14 nombres
públicos (incluido el alias A_xj), con 638 comprobaciones nuevas en cinco
unidades, además de evidencia previa reutilizada. Esto no certifica máxima
generalidad ni reemplaza B07: siguen las funciones multivida no revisadas
integralmente, respetando sus correcciones anteriores y sus estados condicionantes.
