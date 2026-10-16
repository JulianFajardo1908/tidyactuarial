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

## Continuación: B01-04, base logarítmica original y consumidores B02

Estado: confirmado, implementado y probado. Resuelve el pendiente 1 anterior
y concreta la distinción de dominio del pendiente 2; las secciones previas
se conservan como registro histórico.

Sea g=log A(0,1). Desde la especificación original:

- efectiva: g=log1p(i);
- nominal de interés: g=m log1p(j/m);
- nominal de descuento: g=-m log1p(-d/m);
- fuerza: g=delta.

El helper privado .interest_basis reutiliza la validación de
standardize_interest y conserva g, además del equivalente anual habitual.
No cambia la API pública ni se fuerza ese equivalente a un valor distinto
del representable. Por ejemplo, con delta=-40, i_e sigue redondeando a -1,
pero el factor anual se obtiene de exp(-40), no de 1+i_e. La documentación
advierte que los campos de auditoría i_effective pueden contener -1 o Inf
mientras la valoración del intervalo es válida.

Se emplea la base original en interest_equivalents, accumulation_factor,
discount_factor_spot, present_value, future_value, pv_flow y fv_flow.
En las equivalencias, v=exp(-g), d=-expm1(-g), delta=g; se conservan las
seis filas y todas las columnas. Los casos nominales se contrastan con
un único periodo: j=-500,m=1000 implica factor .5; j=2000,m=1000 factor 3;
d=500,m=1000 factor 2. Fuerzas +/-800 con plazo .001 implican exp(+/-.8).

## B01-05: descuento bloqueado por acumulación recíproca desbordada

Estado: confirmado, implementado y probado.

exp(740) no es representable, pero exp(-740) sí lo es como subnormal.
Antes discount_factor exigía calcular primero la acumulación y fallaba.
Ahora un núcleo privado .interval_factor comparte la validación de los tres
modelos, pero evalúa directamente el factor solicitado. Se mantienen
las firmas públicas y los errores de acumulación no positiva o no finita.
El descuento solicitado también debe ser positivo y finito; resultados
realmente no representables se rechazan. En salida tidy, la acumulación
intermedia puede mostrar Inf o cero sin impedir un descuento representable.

Se contrasta tasa constante, integración de una fuerza constante y una
función de acumulación con a(0)=1e-200, a(1)=1e110, cuyo descuento es
1e-310 aunque la acumulación sobrepase el rango double. Las regresiones
fallaron antes y pasan después.

## B02-01: cocientes de niveles de acumulación en fv_flow

Estado: confirmado, implementado y probado.

La fórmula spot conserva su significado: FV=sum C_k exp(g_T T-g_k t_k).
El exponente se evalúa como g_T(T-t_k)+(g_T-g_k)t_k para evitar tanto
Inf/Inf y 0/0 como la resta de dos productos comunes desbordados.
Con g=1 y fechas 1000,1001, el valor es C_1 exp(1)+C_2 aunque los niveles
separados desborden. En la propia fecha de valoración, g=1e308 da factor 1.

La tolerancia existente para tasas anuales de flujos coincidentes en el
horizonte se conserva cuando esos equivalentes son representables. Si
redondean a -1 o Inf, se exige igualdad de g: dos fuerzas diferentes no
se aceptan como iguales solo porque ambas anualizaciones desborden.
La regla se documenta; no se añade un parámetro o columna de transición.

## Verificación de esta continuación

58 comprobaciones nuevas en test-interest-log-basis.R, aprobadas.
Incluyen seis especificaciones extremas y siete consumidores, equivalencias,
ratios de flujos, factores subnormales y valoraciones de tasas pequeñas.
La prueba de fuerza -40 y las primeras pruebas de flujos/equivalencias
fallaron antes de la base logarítmica; los casos de descuento y producto
desbordado en el horizonte fallaron antes del segundo ajuste.
Las pruebas existentes de acumulación y descuento también pasan.
La suite completa terminó sin fallos y salida 0 tras estos cambios.

Se añadió un ejemplo docente en accumulation_factor con la misma ley
financiera expresada como tasa, función de acumulación y fuerza. Se
implementó así la oportunidad docente sin añadir una función pública.
Roxygen regenera solo los Rd correspondientes. No se reconstruye el manual
ni se presenta la CI anterior como validación de esta continuación.

Pendiente para cerrar B01: resolver y documentar coherencia de validación
de m ignorado, y ampliar la revisión de resultados realmente desbordados
en consumidores. B02 continúa con TIR y ecuaciones de valor, sin afirmar
que el barrido integral ya terminó.
