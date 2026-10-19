# Interfaz tidyverse y firmas — revisión progresiva

Objetivo 0.2.0. Clasificación: **A**, defecto matemático/computacional;
**B**, mejora compatible; **C**, cambio público pendiente de autorización.
La matriz `audit-api-signatures.md` contiene 102 entradas y 973 apariciones
de parámetros, en orden real y con defaults extraídos de formals(). A_xj
permanece como alias de insurance_xj. Las descripciones Rd transcriben
concepto, dominio y unidades cuando existen; no prueban su implementación.
B03, B04 y B05 quedan cerrados dentro de sus respectivos alcances documentados;
B06–B09 conservan pendientes de revisión integral por bloques.

Actualización B03: se abordaron a_angle, s_angle, annuity_arith, annuity_geom
y los tres calendarios de préstamos. La tabla por dimensión, unidades y pendientes
está en audit-financial-annuities-loans.md. Las siete firmas públicas y
las columnas se mantienen. La diferencia n=años en anualidades frente a
n=períodos en préstamos es contractual: se documenta, no se renombra ni
se transforma automáticamente. Los m/j_m ignorados matemáticamente pero
validados conservan su dominio. g es un incremento monetario por pago en
annuity_arith y una tasa anual de crecimiento en annuity_geom: se explica,
sin forzar nombres idénticos para conceptos diferentes. Las sumas, extremos,
NA y usos con mutate de ambas anualidades tienen evidencia nueva. Anticipos,
recálculo y liquidación ya se contrastaron por saldos y flujos independientes:
B03 queda cerrado dentro de su alcance y límites documentados. Las firmas y
columnas de los calendarios se verificaron contra HEAD 579efdb; no cambian.
Se mantiene la prioridad local de extras/cuota en cada calendario y se
explica la amortización negativa due sin redefinir columnas de principal.
No se añaden propuestas C; C02–C04 siguen separadas del cierre matemático.

Actualización B04: las cuatro funciones de calendario/precio/rendimiento e
interés corrido tienen una evaluación separada de matemática, estabilidad,
unidades, firmas y uso tidyverse en audit-bonds-curves-immunization.md.
No cambian formals ni columnas. tol de bond_ytm sigue en unidades de tasa;
tol de calendario controla alineación y tol de accrued_interest conserva
su regla de conciliación con piso monetario 1, ahora explícita en Rd.
La segunda unidad incorpora bond_book_value y bond_callable_price, con
142 comprobaciones independientes y firmas/columnas preservadas. C05 fue
autorizada e implementada: el flag de peor rescate identifica el mínimo
calculado y los empates exactos, sin reutilizar tolerancia temporal en dinero.
En esa segunda unidad aún no se daba por cerrado B04; véase el cierre posterior.

Tercera unidad B04: cinco funciones de curvas revisadas en el registro B04,
con 79 comprobaciones nuevas. Conservar bases originales recupera precisión
sin cambiar argumentos ni columnas; linear sigue sobre efectivos anuales.
Se conservan .keep, .na, formas de curvas y parámetros nodewise. No se añade
otra propuesta C ni se uniforma m. Bootstrap conserva su algoritmo triangular;
par_rate mantiene cupón firmado y métricas de reconstrucción del precio.

Actualización B04, quinta unidad: las tres funciones de inmunización/gráfico
mantienen firmas, tablas y datos i/gap. Se conservan norma sobre unidades,
posiciones cortas y variable efectiva anual de convexidad. Solo se mejora
rango, escalado previo y diagnóstico de valores no finitos/mallas inválidas.
No hay propuesta C nueva; C02–C04 no se implementaron. Ver el registro B04
para las veinte funciones, límites y continuación a B05. El check final
terminó con 0 ERROR, 0 WARNING y 1 NOTE por versión de desarrollo; B04 queda
cerrado dentro de ese alcance, sin ampliar la autorización de API.

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
| C05 | C | is_worst_case de callable identifica el mínimo calculado y sus empates exactos, sin umbral monetario derivado de tol temporal | Autorizada expresamente el 17 de octubre; implementada y probada sin cambiar firmas ni columnas |
| C06 | C | Conservar una fila de ID NA con métricas NA bajo propagate en las dos funciones de portafolio; error/drop intactos | Autorizada expresamente e implementada con 90 comprobaciones; firmas/columnas intactas |
| C07 | C | Con solo lx y close=FALSE, el intervalo terminal sin observación queda NA; se conservan probabilidades terminales suministradas y cierre TRUE | Autorizada expresamente el 18 de octubre; implementada y probada en B05 |
| C08 | C | t_Ex devuelve el APV v^t*p sin límite superior 1, también con tasas negativas | Autorizada expresamente el 18 de octubre; implementada en el cierre B05 |
| C09 | C | KM ax = (Lx-lx_next*width)/dx, tiempo vivido en años, NA si no hay muertes | Autorizada expresamente el 18 de octubre; implementada en el cierre B05 |

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

## C05: indicador de peor rescate autorizado e implementado

El usuario aprobó expresamente «Sí, mínimo calculado y empates exactos».
bond_callable_price(tidy=TRUE) ahora define is_worst_case por igualdad con
el mínimo de price_at_target_yield, incluyendo todas las filas empatadas
exactamente en el cálculo. La antigua diferencia absoluta <=sqrt(tol)
mezclaba tolerancia de calendario y dinero, por lo que al cambiar de moneda
se marcaban escenarios claramente diferentes. No se añade tolerancia de
precio ni argumento nuevo. No cambian precio escalar, firmas ni columnas;
un escenario próximo pero no idéntico puede pasar de TRUE a FALSE.
Se comprueba el indicador con escalas, empates exactos y precios cercanos.
No se promete recuperar empates matemáticos ocultos por redondeo o precios
finales fuera de representación. C02–C04 siguen pendientes sin implementar.

## C06: identificadores faltantes en portafolios, autorizada e implementada

Reproducción: portfolio_duration(P=c(100,200),D=c(2,4),
portfolio_id=c("a",NA_character_)) devuelve solo la posición de a, sin advertir,
aunque .na=propagate. portfolio_convexity tiene el mismo split que elimina NA.
El diseño aprobado conserva al final una fila con identificador NA y sensibilidad,
P_total y n_positions NA. Esto no asigna esas posiciones a un portafolio
conocido ni calcula un falso agregado. drop conservaría la advertencia y
eliminación; error conservaría el rechazo. No cambiarían argumentos/columnas.
El usuario respondió «Sí, conservar la fila NA como se propone». Se implementó
esa regla tras su autorización, con fila NA al final, separada de etiquetas
literales "NA". Se conservan tipos de identificador de texto, numéricos y
factores. Noventa comprobaciones cubren mezcla de IDs, todos faltantes,
entrada directa/tidy, nombres personalizados y las tres políticas NA.
Las 163 comprobaciones numéricas independientes llevan esta unidad a 253.
Suite completa y build/check final aprobados (0 ERROR, 0 WARNING, 1 NOTE
de versión de desarrollo). C06 queda cerrada dentro del alcance autorizado;
no habilita C02–C04 ni otros cambios públicos.


## Paréntesis autorizado de visualizaciones (18 de octubre de 2026)

Se añade plot_contingent_cash_flow por petición expresa del usuario; .data
primero y retorno ggplot con datos tibble. Las firmas de plot_cash_flow y
apv_life_flow conservan formals frente a 989b4cf; solo se añade el atributo
contingency al resultado de apv_life_flow, sin cambiar columnas/cálculos.
El atributo distingue supervivencia de fracción esperada reversible; cuando
falta, el gráfico usa Payment weight para evitar inferir una probabilidad.
La nueva entrada usa cf como el productor apv_life_flow; el gráfico financiero
conserva C. Los parámetros gráficos compartidos tienen iguales nombres,
defaults (salvo tamaño de texto adaptado a paneles) y significado.
No se implementan C02–C04. El límite documentado label_digits=0..50 evita
coerción/clamping de formatC; full sigue disponible para formato fijo explícito.
Ver audit-cash-flow-visualizations.md para matemática, defectos A frente a
mejoras visuales B y los límites del nuevo contrato.


## B05, primera unidad y C07 autorizada

lifetable y mortality_law_table conservan firmas, clases, nombres/orden de
columnas y atributos. C07 cambia explícitamente el significado del extremo
abierto: falta l_(omega+1), por tanto dx/qx/px/mx terminales son NA si no se
suministra una probabilidad. No se cambia close=TRUE ni el terminal con dato.
Se rechazan datos contradictorios/NaN y controles inválidos en vez de ocultarlos.
Las bases ax/a_x, frac y radix/l0 siguen teniendo contratos locales distintos:
no se añaden aliases, vectorización, columnas ni interfaz .data universal.
La salida tibble permite continuar con mutate/select y consumidores actuariales;
las funciones no reciben una tabla como primer argumento por diseño actual.
Ver audit-life-tables-mortality.md para matemática, precisión y límites. C02–C04
siguen sin implementar. Inventario estable: 102 nombres, 973 parámetros.
La validación final aprobó suite completa y R CMD check (0 ERROR, 0 WARNING,
1 NOTE por desarrollo). C07 queda cerrada dentro de ese alcance autorizado;
no cierra B05 ni modifica políticas de otros constructores.


## Cierre B05: C08/C09 y compatibilidad

El usuario autorizó C08 y C09 antes de implementar los cambios semánticos.
El valor del dotal puro puede superar uno con interés negativo; el resto de
columnas y el orden de argumentos se conservan. ax de KM mide años vividos,
no el tiempo perdido ni una fracción adimensional de intervalos no unitarios.
Las diez firmas restantes se compararon con d50c212; clases, nombres y tipos
de columnas ordinarias conservados. Para m mayor que el rango entero de R,
t_Ex usa almacenamiento double en esa columna, evitando la coerción anterior
que producía NA; los casos ordinarios conservan el tipo integer previo.
C02–C04 siguen sin implementar. Se preservan convenciones locales de horizonte,
frac, radix, clases y retorno escalar/tabular; ver matriz de conciliación B05.

Cierre C08/C09 y B05: doce funciones conciliadas y check final 0 ERROR,
0 WARNING, 1 NOTE por desarrollo. Se preservan las firmas; 139 comprobaciones
nuevas entre ambas unidades. Ver matriz de evidencia y límites de
audit-life-tables-mortality.md; el cierre no implica cambios globales de API.
