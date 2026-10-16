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
