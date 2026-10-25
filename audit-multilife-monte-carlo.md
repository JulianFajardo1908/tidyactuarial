# Reservas multivida y Monte Carlo — 2026-10-16

Rama: `audit/0.2.0-precran`; versión: `0.1.6.9000`.
Registro de los hallazgos reproducidos en este bloque, sin declarar cerrada
la totalidad de la auditoría externa.

## 1. Recursión de reservas de último superviviente

Estado: confirmado, implementado y probado con referencias independientes.

Convención preservada: `reserve_xy()` valora desde el estado de ambas vidas
vivas en la duración t, con mortalidades independientes. `status="last"`
identifica la prestación al segundo fallecimiento; no identifica cuál vida
permanece viva. La API no recibe un estado observado de superviviente único.

Sean V11, V10 y V01 las reservas antes de prima de los estados de ambas
vidas vivas, solo x y solo y. Sean px, py las supervivencias anuales,
qx=1-px, qy=1-py, v=1/(1+i), P_t la prima pagadera y B_t la prestación
por fallecimiento del estado asegurado durante el año. Entonces:

```
V11_t = v [px py V11_(t+1) + px qy V10_(t+1)
           + qx py V01_(t+1) + qx qy B_t] - P_t
V10_t = v [px V10_(t+1) + qx B_t] - P_t
V01_t = v [py V01_(t+1) + qy B_t] - P_t
```

Para dotal puro B_t=0. Al vencimiento, el estado superviviente recibe el
beneficio en dotales y dotales puros; la reserva terminal es cero para
temporal y vida entera bajo el horizonte de tablas cerradas.

Causa raíz: la recursión escalar usaba la continuidad de último
superviviente como si todos los contratos que continúan volvieran al
estado de ambas vidas vivas. Tras el primer fallecimiento, ese supuesto
es falso y altera las reservas posteriores al inicio.

Ejemplo independiente: edades 60, tablas lx=(100,80,40,10,0) y
ly=(100,50,30,5,0), i=.05, temporal a tres años, beneficio 100 y prima
anual anticipada 10 durante tres años. En t=(0,1,2):

| Método | t=0 | t=1 | t=2 |
|---|---:|---:|---:|
| Recursivo anterior | 52.29348882410 | 61.56462585034 | 68.92857142857 |
| Suma independiente y corrección | 52.29348882410 | 54.71655328798 | 49.52380952381 |

La referencia suma probabilidades de fallecimiento anual y supervivencia
desde las edades de valoración, obtenidas directamente de lx y ly:
`s_j = px_j + py_j - px_j py_j`. No invoca `insurance_xy()` ni
`annuity_xy()` para construir los valores esperados.

Diff: nueva rama de recursión hacia atrás para último superviviente en
`R/reserve_xy.R`. La recursión conjunta existente se conserva. Se rechaza
la falta de información anual necesaria en lugar de imputar mortalidad.
Se explicita el estado condicionante en la documentación.

Pruebas: `tests/testthat/test-reserve-xy-state-regressions.R`, cuatro
tipos de seguro, dos plazos de primas y tres duraciones. Las reservas
prospectivas y recursivas se contrastan con la misma referencia independiente.
Las cuatro regresiones recursivas iniciales fallaron antes y pasaron después.

## 2. Simulación CML con mortalidad diminuta

Estado: confirmado, implementado y probado mediante regresión.

Para q=P(muerte durante el año), la fracción S del año de muerte bajo
fuerza constante tiene CDF condicional
`F(s) = [1-(1-q)^s]/q`. Su inversa es
`S = log1p(-U q) / log1p(-q)`. Cuando q tiende a cero, S tiende a U.

Causa raíz: `log(1-q)` se evaluaba después de formar `1-q`; para q=1e-20,
ese número redondea a 1. El cociente resultaba infinito y el recorte numérico
posterior convertía las fracciones simuladas en ceros.

Antes: doce fracciones idénticamente cero en una tabla de un año con
q=1e-20 y condicionamiento explícito por truncación. Después: coinciden
con los uniformes correspondientes de la semilla 42, como predice el
límite uniforme a precisión de máquina.

Diff mínimo: reemplazar `log(px_death)` por `log1p(-q_death)` en
`R/simulate_lifetime.R`. No se cambia la secuencia ni el número de sorteos.
Prueba en `tests/testthat/test-simulate_lifetime-v2.R`; verifica además
la advertencia de truncación y la restauración del estado RNG del llamador.

## 3. Vidas faltantes convertidas en anualidades de valor cero

Estado: confirmado, implementado y probado mediante regresiones.

Una vida desconocida no determina la variable de valor presente
`Y = c sum_j v^t_j I(vida elegible en t_j)`. La excepción es una anualidad
cierta, cuyo calendario no depende de la supervivencia.

Causa raíz: los helpers de calendario devolvían una secuencia vacía para
K o T faltante; la suma de esa secuencia se interpretaba como cero pagos
y valor presente cero. Esto confundía información desconocida con una
trayectoria conocida sin pagos y podía sesgar resúmenes posteriores.

Corrección en `R/mc_annuity.R`: propagar NA al valor presente y al número
de pagos cuando falta la vida requerida por la base usada: K para pagos
anuales, T para pagos fraccionarios. La anualidad cierta conserva su
tratamiento independiente de la vida.

Pruebas en `test-mc_annuity-v2.R`: antes, cuatro comprobaciones de NA
fallaban (valor y conteo anual/fraccionario); después pasan. La prueba
existente de anualidad cierta con vidas faltantes también se conserva.

## 4. Desplazamiento de pagos fraccionarios próximos al fallecimiento

Estado: confirmado, implementado y probado mediante regresiones.

Convenciones locales preservadas: en la base fraccionaria, las anualidades
anticipadas usan fechas `t_j < T` y las vencidas fechas `t_j <= T`.
No se cambia la base anual, que se define directamente mediante K.

Para pagos trimestrales unitarios, sin interés y con
`T = (1e-10, .25-1e-10, .25, .25+1e-10)`, los conteos exactos son:

| Calendario | Antes | Después y referencia |
|---|---|---|
| Anticipado | (0,1,1,1) | (1,1,1,2) |
| Vencido | (0,1,1,1) | (0,0,1,1) |

Causa raíz: un epsilon absoluto aplicado a T o T/intervalo desplazaba la
frontera de supervivencia. Corrección: comparar las fechas de la retícula
con el T disponible, conservando la inclusión o exclusión del extremo.

El helper de calendario se comparte con `mc_reserve()` y la simulación
de anualidades fraccionarias. Se comprueba que a duración cero la base
de primas de reserva coincide con la anualidad, y que el saldo coincide
con beneficio menos las primas de esos flujos conocidos.

## 5. Garantía anulada por fallecimiento inicial

Estado: confirmado, implementado y probado mediante regresiones.

Identidad: una garantía de un año con cuatro pagos trimestrales unitarios
debe pagar cuatro unidades a interés cero incluso si T=0.

Causa raíz: el calendario anticipado devolvía una secuencia vacía al no
encontrar ninguna fecha contingente anterior al fallecimiento, antes de
aplicar la garantía. Antes: conteo y valor cero. Después: cuatro pagos y
valor cuatro. También se verifica la modalidad vencida, que ya daba
cuatro. La salida temprana ahora exceptúa la modalidad garantizada.

## 6. Trayectorias incompatibles aceptadas por valoraciones Monte Carlo

Estado: confirmado, implementado y probado mediante regresiones.

Identidad: la vida curtata es `K=floor(T)`, por tanto K debe ser entero
no negativo y los pares observados deben cumplir `K <= T < K+1`.
Ambas columnas son representaciones de una misma trayectoria, no dos
fechas de muerte independientes que se pueden escoger por conveniencia.

Ejemplo reproducido: con K=1, T=4.2 y beneficio 100, un temporal de dos
años pagaba 100 usando fin de año y cero usando momento de muerte.
La diferencia no se debía al descuento: se probó a interés cero. En la
reserva a duración dos, la misma trayectoria figuraba vigente por T y
con un beneficio de fin de año determinado por el K incompatible.
Con K=1.5 se aceptaba incluso un pago de fin de año en la fecha 2.5.

Causa raíz: los consumidores verificaban tipos numéricos y algunos signos,
pero no la integridad de K, finitud de los valores observados ni la
compatibilidad del par. La función multivida ya verificaba pares, pero
las valoraciones también aceptan datos suministrados directamente.

Diff: un validador interno compartido en `R/mc-utils.R`, invocado desde
`mc_insurance()`, `mc_annuity()` y `mc_reserve()` después de resolver
las columnas de vida. Las anualidades ciertas no usan esta validación
porque sus pagos no dependen de la vida. No se redondean ni reparan
trayectorias inconsistentes. NA continúa siendo información faltante,
y un K faltante no invalida un T conocido para una operación que solo
requiere ese T.

Pruebas en `tests/testthat/test-mc-lifetime-consistency.R`: seis entradas
inválidas por cada uno de los tres consumidores, incluyendo ambos lados
del intervalo y su extremo superior exacto. Los 18 rechazos esperados
fallaban antes y pasan después. Otras cinco comprobaciones contrastan
valores y NA válidos y la independencia de la anualidad cierta.

## 7. Retícula fraccionaria diferida anclada en la emisión

Estado: confirmado, implementado y probado mediante regresiones.

Modelo: con diferimiento h y frecuencia k, las fechas son h+j/k
(j=0,1,... para anticipadas y j=1,2,... para vencidas), sujetas al
plazo del contrato y a las convenciones de supervivencia documentadas.
La API Monte Carlo permite h fraccionario; no debe confundirse con el
diferimiento entero de otras funciones de valoración determinista.

Causa raíz: el último índice elegible se calculaba desde T/(1/k), sobre
una retícula anclada en cero. Luego se generaban pagos desde h. Si h no
era múltiplo de 1/k, se combinaban dos retículas distintas y se perdían
pagos. Ejemplo: h=.125, k=4, T=.2, anualidad anticipada; el pago en .125
es elegible, pero antes el conteo era cero.

Corrección mínima en el helper compartido de `R/mc_annuity.R`: calcular
los índices respecto de T-h y reconstruir las fechas sumando h. Para
calendarios no diferidos, el origen sigue siendo cero.

Referencia independiente: enumeración explícita de las fechas .125,
.375 y .625, con interés .05, fallecimientos antes, en y después de los
pagos, anualidades diferidas vitalicias y temporales, anticipadas y
vencidas. Ocho comprobaciones vectoriales fallaron antes y pasan después;
incluyen su uso como base de primas en `mc_reserve()`.

No se cambian argumentos ni columnas ni se exige que h*k sea entero.

## Compatibilidad

No cambian argumentos ni columnas públicas. Cambian las reservas recursivas
de último superviviente afectadas y las fracciones CML en casos donde la
resta previa perdía precisión. La valoración prospectiva conserva su
convención de ambas vidas vivas. No se añade una API para valorar desde
un estado observado con una sola vida superviviente.
La continuación sobre anualidades modifica solo `R/mc_annuity.R` como
código funcional, además de su documentación, pruebas y este registro.
Se preservan los nombres de columnas y los extremos exactos del calendario;
las vidas faltantes ahora producen NA en vez de cero y los casos de borde
afectados recuperan los pagos definidos por sus contratos.

## Validación final

19 comprobaciones nuevas aprobadas: 16 de reservas por estados y tres de
simulación CML, advertencia y RNG. La suite completa
`testthat::test_local(reporter="summary")` terminó sin fallos, salida 0.
También se regeneró la documentación con roxygen2 y `git diff --check`
terminó sin errores. Cambios locales, todavía sin commit.

Continuación de anualidades: 12 comprobaciones adicionales aprobadas
(28 en total en `test-mc_annuity-v2.R`). La suite completa volvió a pasar
tras estas correcciones, sin fallos y con salida 0. Documentación
regenerada y diff verificado. Los cambios funcionales de esta continuación
quedan en un solo archivo, `R/mc_annuity.R`.

Continuación de consistencia de vidas: 23 comprobaciones nuevas aprobadas
en `test-mc-lifetime-consistency.R`. La suite completa volvió a finalizar
sin fallos, salida 0. Documentación de los tres consumidores regenerada
y `git diff --check` sin errores. Los casos válidos conservan argumentos,
columnas y resultados; las trayectorias imposibles ahora se rechazan.

Revisión adicional de calendarios diferidos: ocho comprobaciones nuevas
aprobadas en `test-mc_annuity-v2.R`, que ahora contiene 36. La suite
completa volvió a finalizar sin fallos, salida 0.
