# Interfaz tidyverse y firmas — revisión progresiva

Objetivo 0.2.0. Clasificación: **A**, defecto matemático/computacional;
**B**, mejora compatible; **C**, cambio público pendiente de autorización.
La matriz `audit-api-signatures.md` contiene 101 entradas y 959 apariciones
de parámetros, en orden real y con defaults extraídos de formals(). A_xj
permanece como alias de insurance_xj. Las descripciones Rd transcriben
concepto, dominio y unidades cuando existen; no prueban su implementación.
La semántica de B03–B09 sigue pendiente de revisión por bloques.

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
| pv_flow | Suma descontada; fechas con origen documentado | Producto corregido; cancelación entre sumandos extremos aún requiere estudio | Escalar | cf primero; calcular una suma no exige retornar un tibble | cf distingue vector de flujos; fecha/t excluyentes | Tests financieros; no agregar .data por estética |
| fv_flow | Acumulación spot al horizonte | Cocientes y productos corregidos | Escalar | cf primero; uso natural como operación de reducción | m ignorado si no nominal; dominio documentado (B); tol de horizonte no es tol de raíz | Contraste de cocientes; no uniformar todos los tol |
| irr_flow | Cero de VAN en intervalo | Invariante a moneda; signos sin productos | Tibble diagnóstico, incluso si no converge | cf primero; compatible con map sobre escenarios | m se usa para reportar tasa nominal; por eso se exige siempre | Tests de raíces conocidas; no igualar salida con irr_flow_multi |
| irr_flow_multi | Catálogo de raíces detectables | Escala monetaria y falsas raíces corregidas | Tibble de 0 o más filas | Salida tabular natural | search_interval y grid_points tienen función distinta del intervalo simple | Detección de tangencias/raíces próximas sigue heurística |
| solve_value | Ecuación escalar con extractor de resultado | Malla y Newton corregidos; unidades de diagnóstico aún se revisan | value, summary o audit | args/result permiten usar funciones tabulares sin imponer nueva forma | tol mezcla coordenada y residuo; separar parámetros es C | Tests de escala, derivadas explícitas/estimadas y límites; propuesta C01 |
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

## Propuestas públicas que no se ejecutaron

| ID | Categoría | Propuesta y compatibilidad | Estado |
|---|---|---|---|
| C01 | C | Separar explícitamente tolerancia de la incógnita y tolerancia del residuo de solve_value. Requiere definir unidades, defaults, criterio de converged y comportamiento de llamadas existentes con tol | Propuesta de diseño; no se añadieron parámetros ni se cambió el esquema de salida |
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
