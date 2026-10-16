# B01 — Tasas y factores financieros

Barrido ampliado iniciado el 16 de octubre de 2026. Objetivo acordado: 0.2.0.
Estado del bloque: **en revisión**, no cerrado. No reemplaza otros registros.

## Alcance revisado

| Función | Calidad y contrato | Resultado de esta revisión |
|---|---|---|
| standardize_interest | Centraliza cuatro convenciones; reciclaje explícito; NA documentado; compatibilidad antigua conservada | Corregidas cancelación y máscaras de NA; límite de representación extrema pendiente |
| interest_equivalents | Tibble de seis filas útil en docencia; contrato escalar justificado | Corregida cancelación de descuento nominal; documentación ahora enumera también discount_factor |
| accumulation_factor | Distingue tasa, acumulación y fuerza variable; valida intervalos y funciones | Corregida pérdida del efecto de tasas pequeñas; contraste analítico y composición de intervalos |
| discount_factor | Reutiliza validación y modelo de accumulation_factor; retorno numérico o tibble | Hereda la corrección; identidad recíproca comprobada; limitación extrema heredada |
| discount_factor_spot | Distingue descuento spot del descuento general | Corregida pérdida del efecto de tasas pequeñas; dominio y convención de m requieren seguimiento |

No se exige vectorización a interest_equivalents: su salida tabular representa
las equivalencias de un escenario. No se cambia el esquema de seis filas.

## B01-01: cancelación en conversiones

Estado: confirmado, implementado y probado.

Identidades: i_e=(1+j/m)^m-1, i_e=(1-d/m)^(-m)-1,
i_e=exp(delta)-1 y d_nom=m[1-exp(-log(1+i_e)/m)]. Cada conversión es
r+O(r^2) cerca del origen. Con r=+/-1e-20, el término de orden dos
es menor que la precisión relativa de double: el cociente equivalente/r
debe ser 1 a esa precisión.

Antes las cuatro expresiones podían dar cero. Causa: formar 1+r o restar
dos números casi iguales. Diff mínimo en standardize_interest e
interest_equivalents: combinaciones log1p/expm1 algebraicamente equivalentes.
Ocho comprobaciones de cocientes fallaron antes y pasan después. El cociente
evita que una tolerancia absoluta acepte cero como aproximación de 1e-20.

## B01-02: efecto material de una tasa pequeña perdido en el tiempo

Estado: confirmado, implementado y probado.

Identidad: (1+/-1/n)^n tiende a exp(+/-1). Con n=1e20, el error del
límite es menor que la precisión de double. Las tres rutas de factores
devolvían 1; deberían devolver exp(+/-1) y sus recíprocos.

Causa: elevar (1+i), ya redondeado a 1, a un plazo grande. Se cambia a
exp(t log1p(i)) en accumulation_factor y discount_factor_spot;
discount_factor hereda la corrección por reciprocidad. Seis comprobaciones
independientes fallaron antes y pasan después. El ejemplo es una prueba
de estabilidad numérica, no una propuesta de horizonte financiero habitual.

## B01-03: tipo de tasa faltante no se propagaba

Estado: confirmado, implementado y probado.

La documentación promete propagar faltantes. Con i_type=NA, los selectores
de familia incluían NA y if(any(...)) o las asignaciones indexadas fallaban.
Ahora un tipo faltante no selecciona ninguna conversión; la salida permanece
NA. Se mantienen los errores para tipos desconocidos y frecuencias nominales
inválidas. La prueba con tres escenarios falló antes por error de ejecución;
después pasa junto a un caso escalar adicional.

## Pruebas y compatibilidad

Archivo nuevo: tests/testthat/test-interest-audit-regressions.R.
19 comprobaciones aprobadas: ocho de equivalencias, dos de faltantes,
seis de factores y tres de integral/composición de una fuerza no constante.
La última referencia usa la primitiva .03t+.002t^2, independientemente
de la cuadratura del paquete. Suite completa testthat::test_local aprobada,
salida 0, después del cambio funcional. Rd de standardize_interest
regenerado y NEWS actualizado; no se añaden funciones, parámetros o columnas.

Se conservan dominios, convenciones y retornos. Resultados habituales pueden
diferir en los últimos bits por las fórmulas más estables. Los casos afectados
recuperan información antes perdida. No se presenta la CI previa como
validación de este nuevo código ni se declara lista una release.

## Pendientes y oportunidades

1. **Confirmado, pendiente de solución:** standardize_interest(force,-40)
   devuelve -1 por redondeo, aunque exp(-40)=4.248354e-18 es representable.
   accumulation_factor(t=1,i=-40,i_type="force") termina rechazándolo.
   Revisar una valoración en base logarítmica desde la especificación original,
   sin fingir que una tasa efectiva imposible de representar es exacta.
   Evaluar conjuntamente acumulación, descuento y consumidores B02 antes de
   elegir un helper común o una política de error. No se ha corregido aquí.
2. **Propuesto:** aclarar la distinción de dominio entre conversión de tasas
   y valoración cuando el resultado convertido desborda o redondea a -1.
3. **Propuesto:** contrastar la validación de m ignorado por familias no
   nominales entre discount_factor_spot y los demás consumidores. No relajar
   validaciones ni uniformar contratos sin verificar usos y documentación.
4. **Mejora docente propuesta:** un ejemplo integrado de equivalencias,
   acumulación por función y por fuerza, con la misma ley financiera.
   No requiere una nueva función pública. Se incorporará cuando se cierre
   el diseño de las rutas de valoración, evitando ejemplos que oculten límites.

El siguiente paso de mayor valor es el pendiente 1 con los consumidores B02,
antes de marcar B01 como cerrado. El inventario completo está en
audit-thematic-review.md.
