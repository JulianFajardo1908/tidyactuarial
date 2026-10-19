# B05 — tablas de vida, mortalidad y probabilidades

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

Primera unidad de B05: dos de doce funciones revisadas. No se declara cerrado
el bloque. Siguen probabilidades/supervivencia y esperanza de vida, preservando
los arreglos históricos de t_px y e_xy, además de los restantes constructores.

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
