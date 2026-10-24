# B02 — Flujos y búsqueda de raíces

Continuación del barrido ampliado, 16 de octubre de 2026. Objetivo 0.2.0.
Estado vigente: **cerrado dentro del alcance documentado**, conciliado el
23 de octubre de 2026.

## Cierre formal por conciliación de evidencia existente

| Pendiente histórico | Evidencia que lo resuelve |
|---|---|
| Productos capital-factor representables pese a pérdida de rango intermedia | B02-04 y test-capital-factor-products.R: 23 comprobaciones con referencias binarias/Decimal |
| Newton dependiente de escala y unidades de tolerancia | B02-05: 13 comprobaciones; B02-08/C01 autorizada: residual_tol separado y 56 comprobaciones |
| Gráfica de flujos sin revisión propia | B02-06: 11 comprobaciones adicionales, API ggplot/pipes y dos PNG revisados |
| Cancelación de importes individualmente desbordados | B02-07: 17 comprobaciones bajo igualdad exacta del log factor |

Se conservan los ocho contratos públicos y el parámetro final residual_tol
autorizado por C01. irr_flow_multi sigue siendo un catálogo de raíces
detectables: tangencias y raíces próximas conservan los límites heurísticos
documentados. No se garantiza cancelación general entre factores distintos
ni representar resultados fuera de double. La precisión de coordenada y
el criterio residual permanecen distintos; el resultado audit informa
converged conforme al umbral documentado. No se amplían C02-C04.

Los fallos previos y oráculos independientes están registrados en las
unidades correspondientes. La revalidación de cancelación y C01 figura
en audit-precran-check.md; la última validación del suplemento B05 incluye
todas estas regresiones: 7454 aprobadas en fuente e instalado, check
0 ERROR, 0 WARNING, una NOTE por desarrollo, ejemplos/viñetas aprobados
y 399 archivos cotejados. Se reutiliza esa evidencia, sin ejecutar pruebas
nuevas ni modificar código. Sin commit, push ni cambio de versión.
Los apartados siguientes conservan la historia y sus límites; no deben
interpretarse como pendientes nuevos cuando esta conciliación los resuelve.

## B02-02: TIR dependiente de la unidad monetaria

Estado: confirmado, implementado y probado.

Para NPV(r)=sum C_k(1+r)^(-t_k) y s>0,
NPV_s(r)=s NPV(r); los ceros no cambian al multiplicar importes por s.
El flujo (-100,110) en fechas (0,1) tiene TIR .1 para cualquier s>0.
Antes irr_flow_multi con s=1 encontraba una raíz, pero con s=1e-9 o
1e-200 encontraba 101 raíces al usar 101 puntos de malla en [0,.5].
También devolvía 101 raíces para (-100,50)*1e-200 en [0,1], donde
la función es estrictamente negativa. irr_flow lanzaba un error de
uniroot en ese caso en vez de devolver su diagnóstico sin convergencia.

Causas: (1) abs(NPV)<=sqrt(tol) clasificaba cualquier importe pequeño
como cero; (2) productos de residuos usados para comparar signos sufrían
underflow. Los problemas se reprodujeron antes de modificar ambas funciones.

Diff mínimo funcional: R/irr_flow.R y R/irr_flow_multi.R.
Se escala el flujo por max(abs(cf)) solo dentro de la búsqueda. Se compara
sign() sin multiplicar residuos. En la malla se aceptan únicamente ceros
calculados exactamente, y el resto de candidatos necesita cambio de signo
y refinamiento con uniroot. Se rechaza que el escalado elimine un importe
no nulo por underflow; no se sustituye ese importe por cero silenciosamente.

Los VAN reportados se recalculan con el flujo original. No cambian nombres,
columnas, convenciones de fecha o tasa, ni la tolerancia en la coordenada
de tasa del solver. La detección sigue siendo heurística: no se promete
encontrar raíces tangenciales o muy próximas. Las raíces espurias por
residuo monetario pequeño dejan de devolverse; esto corrige resultados
anteriores. La tasa nominal derivada usa expm1/log1p, sin cambiar su significado.

Pruebas: test-irr-scale-regressions.R, 30 comprobaciones aprobadas.
Escalas 1,1e-9,1e-200,1e200; raíz única .1; ausencia de raíz en [0,1];
dos raíces .1,.2 obtenidas de la factorización
50(1+r)^2-115(1+r)+66=50(r-.1)(r-.2); VAN en unidades originales y rechazo
del escalado no representable. Los tests de TIR existentes también pasan.

## B02-03: residuos pequeños confundidos con raíces en solve_value

Estado: confirmado, implementado y probado.

La ecuación s(x-1.137)=0 tiene una única raíz 1.137 para s>0.
Con s=1e-12 o 1e-200, method="uniroot", multiple="all" e intervalo [0,2],
solve_value devolvía antes los 401 puntos de su malla. Además,
s(x+1)=0 no tiene raíz en [0,2], pero se informaban 401 raíces.
Cinco comprobaciones fallaron antes de corregir.

Causa: la detección de candidatos de malla usaba abs(residual)<=tol y
omitía refinar intervalos con esos residuos, aunque no fueran ceros.
Diff funcional: dos comparaciones en R/solve_value_v3.R, más documentación.
La malla ahora acepta solo ceros calculados y conserva los cambios de signo
para refinarlos. No se alteran los parámetros, la política de múltiples
raíces, la expansión de intervalos o el criterio residual de Newton.

Pruebas: test-solve-value-grid-roots.R, siete comprobaciones aprobadas;
también pasan las 18 comprobaciones existentes de solve_value.
Raíces tangenciales pueden requerir un punto inicial apropiado para Newton;
el cambio no convierte la malla en una garantía de detección exhaustiva.

## Calidad, mejoras y pendientes del bloque

- present_value, future_value, pv_flow y fv_flow: revisión numérica y
  correcciones de base logarítmica detalladas en audit-interest-foundations.md.
- irr_flow y irr_flow_multi: se preservan sus retornos distintos, apropiados
  para diagnóstico de una raíz y catálogo de raíces detectables.
- solve_value: la selección de resultado y sus salidas de auditoría aportan
  valor; se conserva su API. Sigue pendiente revisar por separado las
  unidades de tol en el criterio residual de Newton y en converged.
  No se asume que el arreglo de detección de malla cierre esa revisión.
- plot_cash_flow: pendiente de revisión específica de representación y datos;
  las correcciones de valoración no prueban su calidad gráfica.
- Pendiente: importes cuya multiplicación por un factor desborda aunque
  el producto final pudiera ser representable al combinar logaritmos.
  No se afirma resolver todo el rango numérico de double en esta entrega.

Se actualizaron NEWS y los Rd afectados. Las referencias matemáticas se
obtienen por ecuaciones lineales, factorización y escalado positivo, no de
otra llamada al mismo buscador. No se añadieron dependencias o funciones
públicas. La CI anterior corresponde a un commit previo y no valida estos
cambios nuevos; no se publica una release ni se reconstruye el manual.

## Validación conjunta final de esta continuación

La suite completa testthat::test_local(reporter="summary") terminó sin
fallos, salida 0, con todas las correcciones anteriores presentes.
95 comprobaciones nuevas aprobadas en los tres archivos de regresiones:
58 de base logarítmica/factores, 30 de TIR y siete de solve_value.
Roxygen regeneró únicamente los Rd afectados; git diff --check sin errores.
El primer grupo se guardó en el commit local a6ac3dd. No se repitió aún
R CMD check ni CI para estos cambios y no se equipara esta suite con ellos.

Siguiente paso: terminar el análisis de tolerancias de Newton y de los
productos capital-factor, completar plot_cash_flow y resolver el pendiente
de validación de m en B01 antes de cerrar ambos bloques o pasar a B03.

## B02-04 (A): productos capital-factor

Estado: confirmado, implementado y probado.
V=C exp(g)=sign(C) exp(log(abs(C))+g) cuando C no es cero. Se conserva
la multiplicación directa ordinaria y se usa la segunda expresión si el
factor separado pierde rango o precisión. Un cero conocido sigue siendo
cero; NA no se transforma en cero.

Antes, 2^-1000 por 2^1100 daba Inf en lugar de 2^100, y 2^1000 por
2^-1100 daba cero en lugar de 2^-100; signos negativos fallaban igual.
Se reprodujeron 20 fallos de producto/cero. Un caso adicional con factor
subnormal, 2^1000 exp(-740), producía un cociente 1.0026 frente a 1.
La referencia Decimal de Python a 80 dígitos es
4.4882708347358573677923533961594e-21. La tolerancia relativa 2e-12
contempla error log/exp y suma de logaritmos de magnitud cercana a 700,
sin aceptar la pérdida observada de aproximadamente .26%.

Diff: helper privado .cash_flow_value en standardize_interest.R y llamadas
en present_value, future_value, pv_flow, fv_flow y plot_cash_flow. Su uso
compartido responde al mismo defecto en cinco consumidores; no agrega
API pública. No resuelve sumas con cancelación entre términos que sean
individualmente no representables. test-capital-factor-products.R:
23 comprobaciones aprobadas, con referencias binarias y Decimal independientes.

## B02-05 (A): convergencia Newton y unidades del residuo

Estado: confirmado, implementado y probado en este alcance.
La corrección dx=f/f' es invariante al escalado positivo conjunto de f y
f'. Antes, f=s(x-2), start=0 y s=1e-12 o 1e-200 aceptaba x=0 aunque
la raíz es 2. Para f=s(x+1) en [0,2] aceptaba cero sin raíz admisible.
Tres comprobaciones fallaron antes de corregir.

Ahora se acepta un cero calculado, o se exigen residuo <=tol y corrección
<=tol max(1,abs(x)). La derivada se rechaza por cero, no por un umbral
absoluto dependiente de unidades. Un paso recortado en el límite no se
confunde con una corrección pequeña y el estancamiento se informa como
no convergencia. No cambian firma, parámetros, columnas o output. Una
falsa convergencia anterior puede pasar al error de no convergencia
previsto por el método. test-solve-value-newton-scale.R: 13 comprobaciones
en escalas 1,1e-12,1e-200,1e200, con derivada explícita/estimada y un
problema sin raíz admisible. Los tests existentes también pasan.
La propuesta de separar tolerancias y el diagnóstico general converged
de otros métodos sigue siendo C01; no se agregan parámetros sin aprobación.

## B02-06 (A/B): matemática e interfaz de plot_cash_flow

La gráfica todavía usaba una anualización/potencia anterior a B01 y
rechazaba una fuerza cuyo valor final era representable. Ahora comparte
base financiera y producto estable. Se conserva t numérico negativo con
origen cero y fechas con origen en la más temprana. Un PV inferido o un
importe agregado no finito causa error explícito. Los tres casos fallaron
antes del cambio. No se renombra C/cf ni se añaden aliases.

Se comprobaron .data primero, pipes con columnas desnudas y strings,
agregación, clase Date y edición del ggplot con +labs. Pasan 11 pruebas
nuevas en test-plot-cash-flow-audit.R y las 14 existentes. Se renderizaron
y revisaron cash-flow-numeric.png y cash-flow-dated.png en el área de
visualizaciones de esta conversación. No se afirma revisión de todos los
estilos o magnitudes posibles.

## Interfaz, compatibilidad y evidencia conjunta

- Las ocho firmas exportadas en archivos modificados coinciden con HEAD
  al inicio de la unidad, con defaults y orden. A_xj sigue siendo el alias
  de insurance_xj. Se conservan los 101 nombres públicos.
- B: aclaraciones documentales de m, matriz de firmas y ejemplos de uso
  comprobados. Sus papeles diferentes se explican en audit-api-review.md.
- C: tolerancias separadas, dominios de m, renombramientos y reordenamientos
  quedan propuestos, no implementados. Ningún campo público nuevo.
- Referencias independientes: identidades, potencias binarias y Decimal;
  no se afirma haber consultado bibliografía externa inaccesible.

47 comprobaciones nuevas específicas y suite completa aprobadas, salida 0.
Roxygen regeneró solo los Rd afectados. El resultado de construcción y
R CMD check de este código se registra en audit-precran-check.md. La CI
previa no valida automáticamente esta unidad. No se publica una release.

## B02-07 (A): cancelación de términos desbordados con factor común

Estado: confirmado, implementado y probado en el alcance descrito.
Identidad independiente: si un grupo comparte el factor exp(g), entonces
sum(C_j exp(g)) = exp(g) sum(C_j). Es válido netear los capitales antes de
valorar. Se exige igualdad exacta del log factor finito, no proximidad de
tasas, igualdad de etiquetas redondeadas ni igualdad de fechas solamente.

Antes, cf=(2^1000,-2^1000,7), t=(1,1,0), fuerza=-100 daba NaN en pv_flow
en lugar de 7. El caso equivalente de fv_flow y la gráfica también fallaban.
La causa es Inf + (-Inf) después de valorar separadamente. Otro ejemplo:
(2^1000 - (2^1000 - 2^948)) * 2^50 = 2^998, con todos los capitales y
la referencia expresados mediante potencias binarias exactas.
Se reprodujeron 12 fallos antes de cambiar el helper y sus consumidores.

Diff mínimo: helper privado .cash_flow_sum en standardize_interest.R y
una llamada en pv_flow, fv_flow y plot_cash_flow. Si la suma ordinaria es
finita se conserva. De lo contrario se netean los grupos recuperables;
si su capital neto desborda se conservan los términos originales. Esto evita
estropear, por ejemplo, dos capitales 2^1023 descontados por 1/4: su suma
original desborda pero su PV=2^1022 es representable. No hay nueva API,
dependencia, columna ni cambio en validaciones de importes del gráfico.

test-cash-flow-cancellation.R: 17 comprobaciones aprobadas. Cubren
permutaciones, saldo residual, cero exacto, signos, spots distintos con el
mismo log factor, un saldo binario grande y un agregado descontado finito.
El gráfico obtiene y muestra PV=7. La interfaz ggplot y los reductores
escalares se conservan; esta corrección no necesita una capa tidy nueva.

Límite explícito en los Rd: esta recuperación no cubre cancelación de
términos individualmente desbordados con factores distintos. Un resultado
NaN de ese caso no se convierte en cero. No se afirma sumación exacta
arbitraria ni recuperación general de cantidades inferiores al rango double.

## B02-08 (C01 autorizada): tolerancias separadas en solve_value

Estado: propuesto, autorizado expresamente por el usuario, implementado y
probado. El diseño y el impacto están en audit-api-review.md, sección C01.
La autorización fue «Sí, implementar C01 como está propuesto».

Fundamento: f(x)-target tiene unidades del resultado; dx tiene unidades de
la incógnita. Un cambio monetario de escala s>0 conserva la raíz y requiere
escalar también la tolerancia residual por s, no la precisión de x.
Antes, f(x)=1e5(x^2-2), intervalo [1,2], tol=1e-14 y scan_points=3 daba
residuo 4.44e-11 y converged=TRUE por un piso oculto cercano a 1.49e-8.
También uniroot devolvía un candidato tras agotar una sola iteración,
emitiendo un warning. Ambos comportamientos se reprodujeron antes del cambio.

Diff: residual_tol=tol al final de la firma, validación finita positiva,
dos comparaciones residuales de Newton y el diagnóstico final. tol conserva
sus usos de coordenada y agrupación. uniroot usa check.conv=TRUE para no
presentar un buscador agotado como finalizado. No se alteran las columnas.
Newton mantiene error si falla. value/summary conservan el candidato
bracketed que cumple precisión de coordenada; audit indica por separado si
cumple el umbral residual. No se añade otra política de retorno implícita.

test-solve-value-tolerances.R: 56 comprobaciones nuevas aprobadas, además
de las 38 anteriores de solve_value. Referencia de raíz sqrt(2), escalas
1,1e-12,1e12 con target escalado, derivadas explícita y estimada, tolerancia
por encima/debajo del residuo observado, cero exacto, ocho entradas inválidas,
agotamiento de iteraciones y equivalencia de llamadas posicionales/nominadas.
Las comparaciones comprueban solución y residuo, no solo converged.

Compatibilidad: los quince argumentos anteriores mantienen orden y defaults;
residual_tol añade una aparición a la matriz (960, con 101 nombres públicos).
El default de Newton conserva su umbral anterior, pero converged puede pasar
de TRUE a FALSE al eliminar el piso oculto. Uniroot agotado causa error en
vez de warning con candidato. NEWS y Rd explican estos cambios autorizados.
C02–C04 continúan sin implementar. La validación final se registra aparte
en audit-precran-check.md; no se atribuye a la CI histórica.

La suite local completa pasó después de ambas correcciones, salida 0.
Hay 73 comprobaciones nuevas en esta unidad (17 de cancelación y 56 de
tolerancias). Se verificaron por AST/formals las cinco firmas públicas en
archivos modificados: solo solve_value añade el parámetro final autorizado.
Los trece archivos funcionales, de tests, NEWS, NAMESPACE y Rd relevantes
coinciden con el archivo fuente de validación tras normalizar saltos de
línea; DESCRIPTION conserva la versión de desarrollo. git diff --check pasa.
