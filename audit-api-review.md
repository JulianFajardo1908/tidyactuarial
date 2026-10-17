# Interfaz tidyverse y firmas — revisión progresiva

Objetivo 0.2.0. Clasificación: **A**, defecto matemático/computacional;
**B**, mejora compatible; **C**, cambio público pendiente de autorización.
La matriz `audit-api-signatures.md` contiene 101 entradas y 960 apariciones
de parámetros, en orden real y con defaults extraídos de formals(). A_xj
permanece como alias de insurance_xj. Las descripciones Rd transcriben
concepto, dominio y unidades cuando existen; no prueban su implementación.
La semántica de B03 se revisa progresivamente; B04–B09 conservan pendientes
de revisión integral por bloques.

Actualización B03: se abordaron a_angle, s_angle, annuity_arith, annuity_geom
y los tres calendarios de préstamos. La tabla por dimensión, unidades y pendientes
está en audit-financial-annuities-loans.md. Las siete firmas públicas y
las columnas se mantienen. La diferencia n=años en anualidades frente a
n=períodos en préstamos es contractual: se documenta, no se renombra ni
se transforma automáticamente. Los m/j_m ignorados matemáticamente pero
validados conservan su dominio. g es un incremento monetario por pago en
annuity_arith y una tasa anual de crecimiento en annuity_geom: se explica,
sin forzar nombres idénticos para conceptos diferentes. Las sumas, extremos,
NA y usos con mutate de ambas anualidades tienen evidencia nueva; quedan
extras/cancelación y otros extremos de préstamos antes de cerrar B03.
No se añaden nuevas propuestas C en esta unidad.

## B01/B02: evaluación separada por dimensión

Las referencias de exactitud y estabilidad se desarrollan en
`audit-interest-foundations.md` y `audit-cash-flow-roots.md`. Esta tabla
separa criterios de interfaz y evita duplicar las derivaciones.

| Función | Matemática | Estabilidad numérica | API / retorno | Tidyverse | Parámetros / homogeneidad | Evidencia y pendiente |
|---|---|---|---|---|---|---|
| standardize_interest | Cuatro equivalencias explícitas | Cancelación corregida; límites de representación documentados | Vector; aliases antiguos preservados | Adecuada en mutate con argumentos nombrados | i_type primero; m ignorado en familias no nominales | Tests de equivalencias y NA; orden alternativo es C |
| interest_equivalents | Tabla de equivalencias de un escenario | Conserva fuerza original y equivalencias representables | Tibble de seis filas; escalar por contrato | Uso con map/pmap; no requiere vectorización universal | m es necesario incluso para entrada efectiva porque determina filas nominales | Tests independientes; no igualar su dominio de m al de un mero factor |
| accumulation_factor | Tres especificaciones financieras | Base logarítmica y dominio del resultado explícitos | Vector o tibble | Natural dentro de mutate; s primero no es un error | s,t definen intervalo; i/a/delta excluyentes | Tests de composición e integral; no reordenar t/s sin aprobación |
| discount_factor | Reciprocidad matemática de la ley | Descuento directo aunque la acumulación desborde | Vector o tibble con mismas columnas | Uso equivalente a accumulation_factor | Misma firma de intervalo | Prueba subnormal; preservar validación del factor solicitado |
| discount_factor_spot | Descuento de un spot asociado al plazo | Conserva base original | Vector o tibble | Vectorización de escenarios explícita | m observado se valida para todas las familias; se aclara en Rd (B) | Tests de extremos; uniformar validación sería C |
| present_value | C exp(-gt) | Producto firmado recuperado; NA conservados | Vector o tibble | C primero admite pipe vectorial; mutate con nombres | C es capital; t no es una columna en esta función | Potencias binarias y referencia Decimal; retorno preservado |
| future_value | C exp(gt) | Igual criterio de productos | Vector o tibble | Contrato vectorial paralelo a present_value | Misma firma que present_value; m documentado con su validación real (B) | Signos, cero, faltantes y extremos comprobados |
| pv_flow | Suma descontada; fechas con origen documentado | Producto corregido; cancelación extrema bajo factor común recuperada | Escalar | cf primero; calcular una suma no exige retornar un tibble | cf distingue vector de flujos; fecha/t excluyentes | Tests financieros; cancelación con factores distintos sigue limitada |
| fv_flow | Acumulación spot al horizonte | Cocientes, productos y cancelación extrema bajo factor común corregidos | Escalar | cf primero; uso natural como operación de reducción | m ignorado si no nominal; dominio documentado (B); tol de horizonte no es tol de raíz | Contraste de cocientes; no uniformar todos los tol |
| irr_flow | Cero de VAN en intervalo | Invariante a moneda; signos sin productos | Tibble diagnóstico, incluso si no converge | cf primero; compatible con map sobre escenarios | m se usa para reportar tasa nominal; por eso se exige siempre | Tests de raíces conocidas; no igualar salida con irr_flow_multi |
| irr_flow_multi | Catálogo de raíces detectables | Escala monetaria y falsas raíces corregidas | Tibble de 0 o más filas | Salida tabular natural | search_interval y grid_points tienen función distinta del intervalo simple | Detección de tangencias/raíces próximas sigue heurística |
| solve_value | Ecuación escalar con extractor de resultado | Malla, Newton y umbral residual explícito comprobados | value, summary o audit | args/result permiten usar funciones tabulares sin imponer nueva forma | tol de coordenada y residual_tol de resultado; C01 autorizada | 56 pruebas nuevas de tolerancias; se preservan las columnas |
| plot_cash_flow | Representación firmada; PV con la misma ley | PV estable; agregados no representables rechazados | ggplot modificable | .data primero; bare names y strings; probado con pipe | C para gráfico, cf en reductores; renombrar sería C | 11 tests nuevos, tests previos y dos PNG revisados |

## Convenciones examinadas: m no tiene el mismo papel en todos los casos

| Familia | Papel de m y validación actual | Decisión de esta unidad |
|---|---|---|
| standardize_interest; factores de intervalo con i | Frecuencia de conversión; se exige entero positivo en conversiones nominales | Mantener el dominio local |
| interest_equivalents; irr_flow; irr_flow_multi | Frecuencia de salida de equivalencias nominales; se exige incluso si la entrada no es nominal | Diferencia justificada, no inconsistencia matemática |
| discount_factor_spot; present_value; future_value; pv_flow | m observado validado aunque no intervenga en una familia no nominal | Aclaración documental B; no alterar errores existentes |
| fv_flow | La conversión no nominal ignora m | Aclaración documental B; no imponer el dominio de otra función |
| plot_cash_flow | Se valida si se suministra i; no hay conversión sin i | Mantener contrato y validación existentes |

Por tanto, el pendiente de m queda **analizado y documentado**; no se aplica
una normalización mecánica. La eventual modificación del dominio de las
familias donde m no afecta el cálculo requiere decisión C. No se cambia
el significado actuarial de m ni se lo confunde con la frecuencia de pagos k.

## Propuestas públicas y autorización

| ID | Categoría | Propuesta y compatibilidad | Estado |
|---|---|---|---|
| C01 | C | Separar tolerancia de incógnita y residuo de solve_value; diseño detallado debajo | Autorizada expresamente por el usuario el 16 de octubre; implementada y probada, sin cambiar columnas |
| C02 | C | Elegir una política común para m no nominal en consumidores financieros. Ignorarlo o exigirlo globalmente cambia el dominio aceptado y los errores | Pendiente de decisión; las diferencias actuales quedan documentadas |
| C03 | C | Reordenar i/i_type o s/t para favorecer cierto pipe posicional | No recomendado como cambio automático: rompe llamadas posicionales y no hace falta para mutate/pmap |
| C04 | C | Unificar C/cf, .data o tidy/output en todo el paquete | No ejecutar en bloque; los contratos y tipos de operación son distintos. Revisar solo propuestas concretas por familia |

## Mejoras compatibles y categorías A realizadas

- B: matriz y glosario basados en código/Rd reales; aclaraciones de m;
  ejemplos de pipe y modificaciones ggplot comprobados, sin nuevos aliases.
- A: productos capital-factor, convergencia de Newton, cálculo de PV en el
  gráfico y rechazo de resúmenes no representables. Las reproducciones,
  derivaciones y pruebas están en los registros matemáticos de B01/B02.

No se afirma haber consultado Bowers o Finan para esta unidad. Las
referencias efectivamente usadas son las fórmulas explícitas del modelo,
factorización, potencias binarias y un cálculo Decimal a 80 dígitos, junto
al código y la documentación locales. No se inventa verificación bibliográfica.

No se han aprobado íntegramente los 101 nombres por extraer sus firmas.
La matriz es la base de la revisión semántica progresiva, no su sustituto.

## C01: diseño autorizado e implementado

Decisión aprobada: conservar `tol = 1e-10` para la precisión de la incógnita y
añadir `residual_tol = tol` **al final** de la firma, después de `output`.
El usuario autorizó expresamente «Sí, implementar C01 como está propuesto».
La firma y la implementación se actualizaron únicamente en ese alcance.

- `tol`: número finito positivo. Conserva su uso en uniroot (precisión de
  la coordenada conforme a ese método), en la corrección relativa de Newton
  `abs(dx) <= tol * max(1, abs(x))`, y en la identificación de raíces
  duplicadas. No se promete que esas tres operaciones sean idénticas.
- `residual_tol`: número finito positivo, en las unidades del resultado
  seleccionado de `fn`, no en las unidades de la incógnita. Newton exige
  también `abs(fn(x)-target) <= residual_tol`; se conserva la aceptación
  inmediata de un cero calculado.
- `converged` en audit debe exigir finalización válida del buscador y el
  mismo umbral residual explícito. Se elimina el piso oculto
  `sqrt(.Machine$double.eps)` del diagnóstico. El buscador por intervalos
  debe comprobar su finalización, no inferirla solo del residuo devuelto.
- Se conservan nombres, orden de todos los argumentos existentes, columnas
  y los tres tipos de salida. Se conserva el error de Newton sin convergencia.
  Para los candidatos de uniroot, `value` y `summary` seguirían devolviendo
  la aproximación; `audit` explicitaría si cumple el residuo solicitado.
  No se cambia ese comportamiento de retorno sin una decisión separada.

Ejemplo de unidades: al resolver un plazo en años para obtener un valor en
pesos, `tol` controla la precisión temporal del método y `residual_tol`
el error monetario admitido. Si se cambia de pesos a centavos multiplicando
`fn` y `target` por 100, se multiplica también `residual_tol` por 100 y
se conserva `tol`. No se autoescala por target: un target cero no determina
una escala adecuada y los términos pueden tener fuerte cancelación.

Compatibilidad: las llamadas posicionales existentes conservan su asignación
y el default de Newton conserva el umbral residual anterior. El campo
`converged` podría pasar de TRUE a FALSE para un residuo entre `tol` y el
antiguo piso de aproximadamente 1.49e-8. Este cambio semántico debe registrarse
en NEWS y probarse; por eso se solicitó y obtuvo autorización C, en vez de
tratarlo como una corrección documental automática.

Pruebas ejecutadas en test-solve-value-tolerances.R: escalas del resultado
1, 1e-12 y 1e12 con tolerancia residual escalada; raíz y target cero;
derivadas explícita y estimada; equivalencia entre tol omitido/nombrado;
llamadas posicionales; residuo por encima y debajo del umbral, y agotamiento
de iteraciones de uniroot. La precisión de x y el residuo se verificaron
con referencias independientes, no únicamente con `converged`.
Las 56 comprobaciones nuevas y las 38 anteriores de solve_value pasan.
Las propuestas C02–C04 permanecen sin implementar.

Compatibilidad adicional comprobada sobre HEAD y el código nuevo: la
abreviatura parcial `res=` antes seleccionaba `result` y ahora es ambigua
con `residual_tol` según el matching de R. Usar `result=` completo conserva
el extractor (se reprodujo una solución 2 antes y después). No se añaden
aliases para sostener abreviaturas parciales. La garantía posicional
descrita arriba se mantiene; no se promete preservar esas abreviaturas.
