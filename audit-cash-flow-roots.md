# B02 — Flujos y búsqueda de raíces

Continuación del barrido ampliado, 16 de octubre de 2026. Objetivo 0.2.0.
Estado del bloque: en revisión; no cerrado.

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
