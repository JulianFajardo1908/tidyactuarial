# B05 — tablas de vida, mortalidad y probabilidades

## Suplemento de precisión t_px/e_x — 23 de octubre de 2026

Se retoman exclusivamente los dos defectos confirmados al cerrar B07.
Base Git 0030cef, rama audit/0.2.0-precran, versión 0.1.6.9000; se preservan
los cambios B08 sin commit. No se reabre el cierre histórico de B05.

Modelo: S(n+s)=l_(x+n)/l_x por S_(x+n)(s); CF usa p^s y área
-expm1(s*log(p))/(-log(p)); Balducci usa p/(p+s*q) y área
(p/q)*log1p(q*s/p). El complemento 1-q redondeaba p a cero cuando
l_(x+1)/l_x era pequeño: con lx=(1,1e-200), S(.5) CF era cero en vez
de 1e-100 y el área anual era cero en vez de 1/(200*log(10)).

Corrección acotada a R/t_px.R y R/e_x.R: supervivencia derivada como
cociente directo, logaritmo del cociente desde los conteos si aquel
subdesborda, denominador Balducci sin resta cancelatoria e integral
Balducci con incrementos logarítmicos estables. Se conservan firmas,
columnas, reciclado, NA, extinción, horizontes enteros y truncación de
tablas abiertas. t_px conserva px suministrado; e_x conserva su regla
previa de derivar ambos valores desde lx cuando falta alguno del par.
No se recupera información perdida en columnas px explícitas redondeadas
a cero, ni se certifican tablas con columnas actuariales incompatibles.

test-b05-single-life-precision.R: 113 comprobaciones de CF/CML/Balducci,
áreas cerradas independientes, cociente 1e-600, duraciones diminutas,
intervalos completos/parciales, columnas presentes/ausentes, UDD, NA,
extinción, retorno tidy y consumidor t_qx. Contra código previo: 61 fallos,
0 errores/advertencias y 52 aprobadas. Tras corrección: 113 aprobadas;
594 en selección relacionada. Compatibilidad: 192 objetos completos a
1e-12 y dos firmas idénticas contra HEAD. Ayudas y NEWS actualizados.
Validación integral: 7454 aprobadas tanto en fuente como instalado, sin
fallos, advertencias ni omisiones. Check 0 ERROR, 0 WARNING, una NOTE por
desarrollo; ejemplos/viñetas aprobados y 399 archivos cotejados. Suplemento
confirmado, implementado, probado y cerrado dentro de este alcance.
Evidencia definitiva y límites de entorno en audit-precran-check.md.
Artefactos en la carpeta b05-supplement de esta sesión; before.log conserva
la reproducción anterior a editar. Sin commit, push ni cambio de versión.

Primera unidad, 18 de octubre de 2026, sobre 67c2b70.
Rama audit/0.2.0-precran, DESCRIPTION 0.1.6.9000; árbol limpio al comenzar.
Se retoma el orden tras el paréntesis de visualizaciones. Se preservan
2ebf9d8 (ax), 41feac9 (fuerzas/Heligman–Pollard) y 686e2ca (probabilidades
y condicionamiento multivida). No se reinicia la auditoría ni se concilia
el informe externo original ausente. Inventario: doce funciones B05.

## Modelo y convenciones preservadas

Para una tabla anual: d_x=l_x-l_(x+1), p_x+q_x=1 y, si l_x>0,
q_x=d_x/l_x. La exposición aproximada es L_x=l_(x+1)+a_x*d_x,
por tanto m_x=q_x/[1-(1-a_x)q_x] y q_x=m_x/[1+(1-a_x)m_x].
Se conserva el arreglo histórico para ax distinto de .5 y el límite terminal
m=1/ax, incluido Inf para ax=0 cuando hay muertes con exposición cero.

Las leyes continuas usan q_x=-expm1(-I_x), I_x=integral_x^(x+1) mu(s) ds.
mu_x es la fuerza puntual, no I_x. frac es interpolación posterior; no cambia
la integral. DeMoivre/Beta/Heligman–Pollard definen probabilidades directamente;
no se les aplica una conversión de fuerza ficticia. Se conserva Beta en cola
logarítmica y los ocho parámetros del modelo de odds Heligman–Pollard.

## B05-01 / C07: intervalo terminal abierto

**Confirmado, autorizado, implementado y probado.** Con solo lx=(1000,800,600)
y close=FALSE, antes se inventaba l_(omega+1)=0 y se devolvían dx=600,qx=1,
px=0,mx=2. Contradecía la documentación de intervalo abierto desconocido.
El usuario autorizó expresamente C07 en este chat antes de implementarlo.
Ahora se devuelven NA en esas cuatro magnitudes terminales. Se conservan
los dos intervalos observados, las probabilidades terminales suministradas
(incluidas las derivadas de px/mx) y close=TRUE. No se cambia la firma,
clase, columnas ni metadatos. Afecta valoraciones que dependían del cierre
implícito pese a pedir una tabla abierta; deben suministrar el dato terminal
o usar close=TRUE explícitamente. No se oculta esa incompatibilidad.

## B05-02: validación de la tabla anual

**Confirmado, implementado y probado.** Una tabla con lx=(100,90,80),
qx=(.1,1/9,1) y px=(.2,.2,0) se aceptaba con q+p distinto de uno.
Ahora se comprueba la identidad dentro de la tolerancia existente 10*tol;
se excluye el terminal forzado si close=TRUE, como en la conciliación con lx.
No se cambia la política de prioridad de fuentes ni se exige que mx secundario
ignorado tenga un significado nuevo.

is.na(NaN) es TRUE: el guard anterior dejaba pasar NaN pese a prohibirlo en
Rd. Se distingue NaN de NA; se conservan los NA permitidos. Se validan check,
close y tol antes de usarlos, escalares ax/radix antes de condicionales y
radix suministrado positivo/finito. ax queda en su dominio físico [0,1], sin
tolerar valores negativos que daban tasas centrales terminales negativas.
Las longitudes se validan antes de omega para no ocultar vectores incompatibles.

Las edades aceptadas cerca de enteros se redondean antes de truncar e indexar:
x=0:3+1e-12 y omega=2 antes truncaba a edad 1 y fallaba internamente.
Se rechazan edades fuera del rango entero de R antes de coerciones en ambos
constructores. No se añade límite artificial de tamaño o una tabla extendida.

## B05-03: estabilidad de leyes continuas y odds

**Confirmado, implementado y probado.** Para Gompertz, B=2^-1000,c=2,x=1024,
la fuerza exacta es 2^24, aunque c^x desborda. Ahora se forma log(B)+x*log(c)
antes de exponenciar. Makeham conserva el término A y evita 0*Inf con B=0.
La integral analítica sigue siendo B*c^x*expm1(log(c))/log(c), con límite
constante para c=1; se combina en log antes del producto.

Logistic (.01+.1*2^x)/(1+.5*2^x), x=1100, antes fallaba al integrar Inf/Inf;
la fuerza finita es prácticamente .2. Se evalúa la diferencia de log-sumas
del numerador y denominador, incluyendo amplitudes cero. Se mantiene la
integración numérica original y rel.tol=1e-10, no se introduce otra ley.
La primera solución logarítmica todavía perdía ~6.29e-5 relativos a edades
2^31-2 con c=1e308. La prueba adicional confirmó esa cancelación de log-sumas.
La versión final divide previamente ambos términos por exp(z) cuando z>0,
evaluando log-sumas de log(A)-max(z,0) y log(B)+min(z,0) frente al denominador
análogo; C=0 conserva directamente Makeham. Dos comprobaciones adicionales
verifican fuerza e integral contra el límite .2 sin restar grandes logaritmos.

Weibull shape=1e-8, scale=1e9, x=1e9 devolvía q=0 pese a fuerza ~1e-17.
Para x>0 se usa I=(x/scale)^shape * expm1(shape*log1p(1/x)), combinado en log.
Se trata x=0 por separado y se conserva la restricción histórica shape<1 en
el origen por fuerza infinita. Las cotas independientes de la integral entre
las fuerzas de sus extremos verifican el resultado sin repetir esa fórmula.

Heligman–Pollard con A=1 y (x+B)^C desbordado evaluaba 0*Inf en log y daba
NaN. Se respeta 1^z=1: su log-componente infantil es cero. No cambian
parametrización, aliases, dominios o significado de los componentes restantes.

## Evidencia y contrato público

test-life-table-foundations-audit.R añade **62 comprobaciones**. El log
b05-foundations-before.log reproduce fallos sobre el código previo. Las
validaciones añadidas después se contrastaron también evaluando las funciones
de HEAD previo: aceptaban longitud incompatible, radix NaN y ax=-1e-12.
Las referencias nuevas usan conteos de supervivencia, potencias binarias,
límites constantes de Logistic y cotas de integración de Weibull. Pasó
la suite completa local sin fallos ni advertencias, salida 0; log
b05-foundations-final-tests.log en artefactos. El log preliminar
b05-foundations-tests.log corresponde al código previo al último ajuste de
Logistic; b05-validation-before.log reproduce los controles tardíos. Las regresiones previas de exposición,
integración, Beta, ocho parámetros y consumidores permanecen en la suite.

Las dos firmas se compararon mediante formals con 67c2b70 y coinciden.
lifetable conserva clase lifetable/tibble, columnas x/lx/dx/qx/px/mx y atributos;
mortality_law_table conserva sus doce columnas y frac=NA para leyes directas.
Sin funciones, helpers compartidos, dependencias ni versión nuevos. Se
regeneraron solo los dos Rd afectados y la matriz de API (102 nombres,
973 apariciones de parámetros, ninguna sin descripción).

Interfaz: resultados tabulares para consumidores y mutate/select; argumentos
vectoriales x/lx/qx/px/mx frente a parámetros escalares de ley. Se conservan
ax frente a a_x, radix frente a l0, defaults frac distintos y aliases históricos;
no se implementan C02–C04 ni se fuerza una entrada .data universal.

Build/check final y huella del archivo fuente: audit-precran-check.md.
La versión definitiva terminó con 0 ERROR, 0 WARNING, 1 NOTE por versión de
desarrollo, salida 0; ejemplos, suite instalada y cuatro viñetas aprobados.
Los hallazgos de esta unidad y C07 quedan cerrados dentro del alcance indicado.

## Límites y continuación

Estado registrado en d50c212: dos de doce funciones revisadas; el bloque
seguía abierto. La conciliación posterior de las diez funciones restantes
y el cierre documentado se encuentran en la sección siguiente.

No se cambia la política NA/prioridad salvo NaN prohibido y C07; check=FALSE
no certifica datos ni supuestos. No se normalizan datos incompatibles. Las
filas posteriores a omega se descartan antes de construir los intervalos,
como antes: no se reutiliza una fila descartada como observación terminal.
Para retener ese intervalo, incluir su edad final en la tabla o proporcionar
la probabilidad terminal. Cambiar esa política de truncación requiere una
revisión explícita, no está incluido en C07.
Las
columnas siguen limitadas por double y el rango entero de edades: probabilidades
tan pequeñas que 1-q redondea a 1 pueden conservar q y dx positivos sin que
la resta de supervivientes recupere ese dígito; no se promete exactitud arbitraria.
Las fuerzas puntuales deben seguir siendo representables con check=TRUE.
Las exposiciones con a_x son aproximaciones de intervalos; Tx/ex de una tabla
finita no se anuncian como integrales continuas de toda la vida. Se conserva
la política de cohortes extintas y ratios indefinidos.

No se amplía ahora el dominio de omega de DeMoivre ni se cambia su redondeo;
ese contrato debe estudiarse junto a límites de tablas antes de ampliarlo.
No se atribuye contraste con paquetes externos/bibliografía no ejecutado.
Sin push, publicación, cambio de versión o cierre de CI/R mínimo actuales.


## Conciliación de cierre de las doce funciones (18 de octubre)

El usuario pidió cerrar la revisión después de aclarar que existían pruebas
anteriores. Se inspeccionó implementación, documentación y pruebas de las diez
funciones restantes. Se reutilizó esa evidencia y se añadieron solo regresiones
para vacíos reproducidos, sin presentar las pruebas previas como trabajo nuevo.
Base de esta unidad: d50c212. Se preservan las correcciones históricas.

| Función | Modelo/evidencia previa conciliada | Aporte específico al cierre |
|---|---|---|
| lifetable | Identidades lx/dx/qx/px/mx y pruebas de exposición ax; d50c212 | C07 y 62 comprobaciones compartidas con mortality_law_table, ya verificadas |
| mortality_law_table | Integración independiente de fuerzas, leyes directas, Beta/HP y límites; d50c212 | Misma unidad anterior; no se repite su implementación |
| t_px | test-survival-death-probabilities y test-e-xy-regressions: cocientes enteros, extinción, interpolación y reciclado | Controles/edades anuales y NA de cohortes seguros; se preservan los arreglos enteros/extintos |
| t_qx | test-survival-death-probabilities: complementos, fracciones y salida tidy | Pérdidas fraccionarias pequeñas calculadas antes de complementar supervivencia |
| t_Ex | test-life-expectancy-endowment: descuento, nominales, tiempo cero y columnas | C08 autorizada, base original log y frecuencias grandes sin coerción NA |
| e_x | test-life-expectancy-endowment y test-e-xy-regressions: sumas, integrales, inclusión-exclusión y fracciones | Integrales pequeñas y cohortes extintas/desconocidas sin errores o NaN espurios |
| commutation_table | test-commutation-table: seis funciones clásicas, sumas y Mx=lx a tasa cero | Productos de descuento originales y validación de tabla anual/monotonicidad |
| md_table | test-multiple-decrement-table: suma de causas, cohortes y cierres | Rechazo de nombres que sobrescribían causas/totales; controles/radix finitos |
| lt_tau | test-multiple-decrement-probabilities: mismo lx/q_total/p_total y supervivencia | Sin cambio funcional: delegación revisada; radix debe suministrarse en ... |
| t_qxj | test-multiple-decrement-probabilities: enumeración entera, proporciones de causas y cola fraccionaria | CF pequeña estable y control de horizontes no finitos/índices |
| km_lifetable | test-kaplan-meier-actuarial: producto manual, Greenwood, entrada demorada y exposiciones | C09 autorizada; escala de radix, límites cero y colas/intervalos de confianza |
| plot_km | test-plot-km: lista/tabla, nombres personalizados, banda escalonada y edición | Orden cronológico, validación de probabilidades/bandas y QA visual |

### Defectos reproducidos e identidades de la segunda unidad

**B05-04, C08 autorizada.** El dotal es E(t)=p(t)*exp(-g*t), no una
probabilidad. Con supervivencia uno y i=-.5, E(1)=2; el código devolvía 1.
El usuario autorizó quitar ese cap. Se usa la base log original y el producto
estable existente, sin cambiar argumentos/columnas. El caso binario p=2^-1000,
g=-1100*log(2), t=1 devuelve 2^100, aunque el factor separado desborda.
La columna i_effective sigue siendo diagnóstica y puede saturarse; no se usa
para valorar. nEx no se limita ni se normaliza. Grandes m válidos conservan
almacenamiento double cuando no caben en integer; casos ordinarios mantienen
el tipo previo. No se aplica la política global C02.

**B05-05.** Para t=k+s, q(t)=q(k)+p(k)*q_frac(s). Formar q_frac antes de
restar de uno conserva pérdidas ~1e-20 que antes eran cero. UDD usa s*q;
CF usa -expm1(s*log(p)), con log1p(-q) en probabilidades pequeñas; Balducci
usa s*q/(p+s*q). El componente entero sigue los conteos observados, el horizonte
sigue delegado a t_px y se respetan edades redondeadas dentro de tol.
t_qxj aplica el mismo incremento CF a su proporción causal existente.
No se cambia la hipótesis de proporciones de causas constantes durante el año.

**B05-06.** CF integra s*(-expm1(-a*s)/(a*s)), a=-log(p), con límite s;
Balducci integra s*log1p(z)/z, z=q*s/p, con límite s y tratamiento de cola.
Antes los cocientes daban cero para horizontes pequeños. En cohortes extintas
se anulan contribuciones posteriores antes de multiplicar por probabilidades
indefinidas: UDD de (100,0,0,0) integra .5 y CF/Balducci integran cero,
en lugar de NA. Las cuentas desconocidas propagan NA sin indexaciones inválidas.
Se conservan los horizontes, modelos y pruebas multivida anteriores.

**B05-07.** D_x=l_x*exp(-g*x), C_x=d_x*exp(-g*(x+1)); convertir primero
una fuerza grande a i_effective impedía productos representables. El producto
binario 2^1000*2^-1100=2^-100 es el oráculo nuevo. Se conserva el cierre
l_(omega+1)=0 de este constructor, incluso para metadatos abiertos del input.
No se redefine el significado de M/N/S/R ni el exponente de las edades.

**B05-08.** En md_table, una causa d_a podía ser sobrescrita al generar el
decremento de q_a, corrompiendo después otras causas. Ahora se rechazan
colisiones con totales, edad y columnas derivadas; se mantiene make.unique
entre nombres derivados que no sobrescriben datos. El control incluye nombres
finales tras make.unique y age_col, para evitar colisiones indirectas con
edades o causas ya presentes. Los conteos, tolerancias
y sumas de causas válidas conservan su contrato. No se inventa una conversión
de causas dependientes a fuerzas independientes.

**B05-09, C09 autorizada.** En la tabla KM, L=width*l_next+ax*d, de donde
ax=(L-width*l_next)/d es tiempo vivido en años. El código anterior devolvía
su complemento temporal. C09 fue autorizada antes de implementarse. UDD
conserva width/2; CF/Balducci se corrigen y usan sus límites estables cerca
de q=0. Sin muertes, ax sigue NA.

Las exposiciones se forman con factores de supervivencia normalizados antes
de aplicar radix y width. El umbral monetario 1e-12 y el piso de supervivencia
1e-16 alteraban CF/Balducci al cambiar radix; lx*lx_next también desbordaba.
Se retiraron esos pisos: pruebas con radix=1e-250/1000/1e250 y width=2
contrastan L por integración independiente de la supervivencia interpolada.
Un extremo de supervivencia exactamente cero tiene integral CF/Balducci cero,
ax=0 y mx=Inf si hay muertes; las cohortes extintas conservan ratios indefinidos.
Las probabilidades q/p se forman desde los estimadores S de los extremos,
conservando p positivo aun cuando 1-q redondea a cero.

Se calcula seS=S*sqrt(Greenwood) antes de que S^2 pierda rango y el error
log-log como sqrt(Greenwood)/abs(log(S)), sin piso artificial de S. El oráculo
con 600 eventos y entrada demorada mantiene siempre n_risk=2,d=1: S=2^-600,
G=300. Verifica error estándar e intervalos de confianza y exposición CF.
Los intervalos en S=0/1 siguen NA; no se inventan límites en esas fronteras.

### Verificación de cierre y compatibilidad

Segunda unidad: **77 comprobaciones nuevas** en test-b05-closure.R; B05
acumula **139 nuevas** en las dos unidades. Las 170 comprobaciones enfocadas
previas de supervivencia, esperanza, conmutación, KM y decrementos se conservaron
y aprobaron; no se cuentan como nuevas. Logs b05-closure-before.log y
b05-closure-additional-before.log y b05-names-before.log reproducen los fallos; el segundo usa
funciones obtenidas de d50c212, sin alterar el checkout. El log intermedio
b05-closure-tests.log detectó pérdida de precisión subnormal en una integral
CF; fue corregida. b05-closure-compatibility.log acredita los 75 focos finales
y las diez firmas/clases/nombres/tipos ordinarios frente a d50c212. Dos
casos suplementarios de colisión de nombres completan los 77 focos en
b05-closure-focused-final.log; el check final incluye ese archivo actualizado.
La suite local global se registra en b05-closure-final-tests.log; el chequeo
instalado del archivo definitivo es la referencia final de entrega.

Se generó e inspeccionó b05-km-closure.png (1350x750), con PDF vectorial,
en artefactos. Curva y banda escalonadas, ejes/título legibles y sin recortes;
la banda no imputa los límites estadísticamente indefinidos. No se añadieron
funciones, dependencias, columnas ni versión. Matriz: 102 nombres públicos,
973 apariciones de parámetros documentadas; C02–C04 no implementadas.

B05 queda **cerrado dentro del alcance documentado: 12/12 funciones**.
R CMD build/check definitivos: 0 ERROR, 0 WARNING, 1 NOTE por versión de
desarrollo, salida 0. Pasaron ejemplos, suite instalada y cuatro viñetas.
La huella y entorno del archivo construido están en audit-precran-check.md.
El cierre corresponde al código final con 77 regresiones nuevas de esta unidad;
precran-b05-closure es evidencia preliminar, reemplazada por
precran-b05-closure-final después de completar las guardas de nombres.

### Alcance del cierre integral de B05

La revisión cubre los doce nombres públicos y sus modelos documentados,
con datos de entrada actuarialmente válidos; check=FALSE no certifica datos.
No se afirma perfección, conciliación del informe externo ausente ni cierre
de otros bloques. La configuración de CI anterior no valida estos cambios;
R mínimo y validación remota quedan pendientes para release.

Se preserva la convención de t_px/t_qx/t_Ex/e_x hasta la última edad observada,
incluidas tablas abiertas. Ese truncamiento no prueba que la cola biológica
sea cero. Conmutación tiene cierre terminal propio; no se uniforma. Los KM
mantienen su estimador constante más allá del último dato y el riesgo con
entrada <= evento (convención inclusiva conservada). Su tabla de intervalos
usa interpolación de extremos para L, no la integral de la escalera KM.
Una clase lifetable con intervalos no anuales no convierte por sí sola ese
objeto a una tabla anual: las funciones anuales ahora rechazan mallas irregulares
con check=TRUE. Para usar todo el horizonte KM hay que incluir los extremos
observados necesarios en la conversión. No se añaden extrapolaciones ni clases.

Los datos de tiempo/entrada no finitos omitidos por KM producen ahora una
advertencia; no se esconden pérdidas de filas. La probabilidad por causa usa
los decrementos del productor md_table y proporciones intranuales fijas.
No se sustituye ese modelo por independencia de causas. Fuera del rango
double, los agregados o tasas diagnósticas pueden no ser representables;
no se normalizan o capan para obtener un valor aparente. Se conservan los
límites de la primera unidad y los contratos locales de NA/radix/frac.

Siguiente bloque: B06, contingencias de una vida
y contratos, preservando la función gráfica contingente ya revisada.

### Suplemento pendiente detectado en B07-06 (21 de octubre de 2026)

El cierre histórico anterior se conserva con su evidencia, pero hay un nuevo
defecto A confirmado en extremos de t_px/e_x. Con tabla x=60:61 y
lx=(1,1e-200), CF, t_px(60,.5) devuelve cero frente a 1e-100;
e_x(60,t=1,type="complete") devuelve cero frente a 1/(200*log(10)).
Reconstruir p como 1-q desde decrementos redondeados elimina supervivencia
observada positiva. Evidencia con aserciones: b07-06/single-life-followup.log
en los artefactos del 21 de octubre. Confirmado, pendiente de implementación
y regresión propia; no se presenta como límite biológico ni como arreglado.
Resolver este suplemento antes de B08, preservando precedencia/contratos de
columnas, NA, tablas terminales y las correcciones anteriores de B05.
