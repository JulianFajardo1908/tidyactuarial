# Prompt maestro para continuar tidyactuarial

## Preferencia vigente: consumo eficiente (23 de octubre de 2026)

Aplicar audit-efficient-workflow.md: lectura dirigida, regresiones locales
durante la edición y una validación integral sobre el conjunto estable,
incluidas ayudas y NEWS. No reducir los controles actuariales ni omitir
suite fuente, build/check instalado, cotejo, huella y commit de cada unidad.
Repetir controles solo por cambios, fallos o evidencia pendiente que lo
justifiquen. Completar documentación antes de construir; no revalidar por
cambiar únicamente registros excluidos del archivo fuente. No cambiar
modelo/configuración de la app ni prometer una cantidad de mensajes.
Este encabezado y el último estado B08 son la entrada rápida; consultar
historial adicional por función y necesidad, preservándolo íntegro.
Última base funcional validada: 2f40f1f; Git limpio al comenzar este ajuste
documental. Siguiente unidad actuarial: B08-06, mc_reserve, descrita abajo.

## B08-05: mc_premium/mc_loss (22 de octubre de 2026)

Base 0ed6c16, Git inicialmente limpio, rama audit/0.2.0-precran y versión
0.1.6.9000 conservadas. Se preservan numerador/denominador/frecuencia hasta
combinar importes monetarios; helper privado .mc_ratio_product, medias
subnormales y k grande válido sin overflow integer. Sin nueva decisión C,
firma, columna ni dependencia. NA por pares, grupos y unidades conservados.
q puede mostrarse 0/Inf si no cabe, sin anular cuota/flujo finitos. La
entrada annuity_scale explícita se interpreta como se recibe; para encadenar
extremos escoger una columna monetaria representable. No ampliar entrada
no finita ni inventar datos a partir de q redondeado.
228 comprobaciones nuevas; contra base: 48 fallos, 2 errores, 4 advertencias,
174 aprobadas; errores abortan otras aserciones. 146 objetos ordinarios
completos a 1e-12, dos firmas idénticas. Registro matemático y límites:
audit-monte-carlo-review.md. Evidencia/huella: audit-precran-check.md.
Artefactos b08-05: before-final.log/compatibility.R, regression-final.log y
final-definitive-tests.log son definitivos; final-tests.log es una ejecución
intermedia anterior al último borde subnormal. B08 abierto con 918 nuevas.
Se aclaran en las ayudas los retornos data.frame/tibble existentes y la
salida no agrupada de mc_premium. final-artifact/ contiene el archivo/check
definitivos después de ese ajuste; la primera construcción queda como etapa
previa. No se cambia el código funcional después de la suite fuente final.
Validación definitiva completada el 23 de octubre: 7074 aprobadas en fuente
e instalado, cero fallos/advertencias/omisiones; check 0 ERROR, 0 WARNING,
1 NOTE por desarrollo, ejemplos y cuatro viñetas aprobados. 396 archivos
verificados y huella final en audit-precran-check.md. B08-05 cerrado dentro
de su alcance y guardado en commit local; B08 completo sigue abierto.

Siguiente B08-06: mc_reserve, tasas originales y libros de flujos futuros,
conservar calendarios, antes/después de pago, vigencia, NA y prima en cada
unidad. Su motor propio mantiene T>=n en dotal puro; C18 solo autorizó
mc_insurance y no permite corregir ese borde por analogía. Conciliar el
caso concreto y solicitar autorización específica si se propone cambiarlo.
next-reserve-diagnosis.log reproduce ambos pendientes: fuerza 720 rechazada
con beneficio finito 2.032231e-13, y Z_t=100 a t=0 para T=n frente al cero
de mc_insurance después de C18. No se ha modificado mc_reserve en B08-05.
Luego summary_mc, dependencia antitética y conciliación integral B08.
Suplemento B05 t_px/e_x pendiente; B01/B02 conservan pendientes formales,
B09 integral no iniciado. Sin push, cambios de rama o versión.

## B08-04: valoración por trayectoria y C18 (22 de octubre de 2026)

Base 692477d, Git inicialmente limpio, rama audit/0.2.0-precran y versión
0.1.6.9000 conservadas. mc_annuity/mc_insurance usan tasas originales y
helpers monetarios, conservando calendarios, NA, firmas y columnas. m grande
no desborda integer; k/m se comprueban antes de coerción. Se preservan las
correcciones previas de audit-multilife-monte-carlo.md.
C18 fue autorizada expresamente: «Autorizar supervivencia estricta T>n».
Solo pure_endowment con moment_of_death pasa a T>n; temporal T<=n y mixto
se conservan, y su partición por trayectoria es exacta también en T=n.
No volver a pedir C18 para ese alcance ni extenderla a mc_reserve.
448 comprobaciones nuevas, 182 objetos ordinarios a 1e-12 y firmas idénticas.
Regresión previa: 18 fallos, 6 errores, 3 advertencias, 398 aprobadas;
errores anteriores abortan aserciones posteriores. Evidencia definitiva
before-c18-final.log, regression-c18-final.log y final-c18-tests.log en
b08-04; final-tests.log empezó antes de C18 y no certifica ese cambio.
Registro y límites: audit-monte-carlo-review.md; validación/huella:
audit-precran-check.md. B08 sigue abierto con 690 comprobaciones nuevas.
Suite fuente e instalada finales: 6846 aprobadas, cero fallos/advertencias/
omisiones. Build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo;
ejemplos y cuatro viñetas aprobados. 395 archivos cotejados y SHA256 en
audit-precran-check.md. B08-04 cerrado en su alcance documentado y guardado
en commit local; B08 completo sigue abierto.

Siguiente unidad B08-05: mc_premium/mc_loss, cociente de medias, unidades
anualizada/cuota/coeficiente, agrupación, NA y equivalencia Z-qY. Revisar
next-premium-loss-diagnosis.log: una fila con Z=1e-300,
Y=annuity_payment=1e300 debería dar cuota 1e-300 y pérdida cero; hoy da
cuota cero y pérdida 1e-300. Con escalas inversas da Inf/-Inf aunque la
cuota/flujo monetario final sea finito. Coeficiente q puede no caber en
double; separar esa limitación del valor representable de los importes.
Después seguir mc_reserve: tasas originales, libros futuros, antes/después de pago,
vigencia y su propio borde dotal T>=n (conciliar alcance antes de cambiar).
Finalmente summary_mc y dependencia antitética. Suplemento B05 t_px/e_x
pendiente, B01/B02 con pendientes formales y B09 integral sin iniciar.
No reiniciar auditoría ni cambiar versión, rama o hacer push.

## B08-03: motor lx y valoración de wrappers (22 de octubre de 2026)

Base f87706e, Git limpio al iniciar, rama audit/0.2.0-precran y versión
0.1.6.9000 conservadas. simulate_annuity_x/simulate_insurance_x retienen
log supervivencia desde lx y tasas originales; valoración monetaria estable,
sin atajo de tasa pequeña. Validación de rangos/horizonte/tablas antes de
coerción/muestreo. No cambian firmas, columnas, calendario ni censura.
90 comprobaciones nuevas pasan; contra base: 11 fallos, 9 errores,
10 advertencias, 62 aprobadas (errores abortan aserciones posteriores).
172 objetos ordinarios completos coinciden a 1e-12 y dos firmas idénticas.
Registro matemático y límites double: audit-monte-carlo-review.md.
Evidencia final y huella: audit-precran-check.md; artefactos b08-03.
Suite fuente e instalada: 6398 aprobadas, cero fallos/advertencias/omisiones.
Build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo; ejemplos y
cuatro viñetas aprobados, 394 archivos verificados. B08-03 cerrado en su
alcance documentado y guardado en commit local; B08 completo sigue abierto.

Siguiente unidad B08-04: mc_annuity/mc_insurance, tasas originales y libros
de flujos por trayectoria, conservando validación K/T y calendarios previos.
next-valuators-diagnosis.log reproduce rechazo de fuerza 720 aunque los
flujos independientes sean finitos (seguro 2.032231e-13, renta 4.508027e143).
Después mc_premium/mc_loss, mc_reserve y summary_mc, incluidos NA, estados
y error estándar con antitéticos. B08 sigue abierto con 242 comprobaciones
nuevas acumuladas. El suplemento B05 t_px/e_x continúa pendiente. B01/B02
mantienen pendientes formales y B09 integral aún no se ha iniciado. No
reiniciar bloques cerrados, ampliar C13-C17, cambiar versión ni hacer push.

## B08-02: estados multivida y C17 (22 de octubre de 2026)

Base 9a7b441, misma rama y versión. C17 fue autorizada expresamente por el
usuario y se implementó: mc_multilife_status exige floor(T)==K después de
la comprobación/redondeo entero de K; tol no relaja el intervalo de T.
No se repara T. Se evita overflow integer en K_status grande y se aclara
el error de col_sim que colisiona con campos de salida. No se agregan
columnas ni cambian firmas, alias, NA o agrupación de vidas válidas.
58 comprobaciones nuevas y 60 objetos completos válidos idénticos a base;
regresión previa: 16 fallos, un error, dos advertencias y 35 aprobadas.
Registro: audit-monte-carlo-review.md; evidencia final: audit-precran-check.md.
Suite fuente final: 6308 aprobadas, cero fallos/advertencias/omisiones.
Suite instalada también 6308, sin fallos/advertencias/omisiones; build/check
salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo. Ejemplos y cuatro
viñetas aprobados; 393 fuentes verificadas y huella registrada. B08-02
cerrado en su alcance; C17 implementada y probada, no volver a solicitarla.
B08 completo sigue abierto, con 152 comprobaciones nuevas acumuladas.

B08 sigue abierto. Seguir simulate_annuity_x/simulate_insurance_x y su
motor lx privado; next-lx-engine-diagnosis.log de B08-01 confirma pérdida
de razón 1e-600 y T=0 erróneo bajo CML. Luego valorar pagos/seguros/primas/
pérdidas/reservas por trayectoria y resúmenes, con estados/NA y antitéticos.
El suplemento B05 t_px/e_x sigue pendiente, sin confundirlo con B08.
Artefactos b08-02 de la misma sesión; sin push, versión ni dependencias.

## B08-01: generadores de vidas (22 de octubre de 2026)

El usuario pidió pasar a B08. Base c7a0d29, rama audit/0.2.0-precran,
Git inicialmente limpio y versión 0.1.6.9000 preservada. El suplemento
B05 t_px/e_x sigue confirmado y pendiente; no se descarta por cambiar orden.
Se corrigen fracciones CML/Balducci anuladas por p<=tol, exposición lx
dependiente del radix y cancelación en q=1-l_next/l. Validación de tol/
edades/n_sim antes de coerción y death_age sin overflow; q=1 conserva
fracción cero y los sorteos/semillas conservan sus convenciones previas.
94 comprobaciones nuevas; 78 resultados ordinarios completos a 1e-12 y
dos firmas idénticas. Registro principal: audit-monte-carlo-review.md.
Validación final: audit-precran-check.md. No hay nueva decisión C ni versión.
Suite fuente/instalada final: 6250 aprobadas, cero fallos/advertencias/
omisiones; build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo.
Ejemplos y cuatro viñetas aprobados; 392 fuentes verificadas y huella
registrada. B08-01 cerrado en su alcance puntual, B08 completo abierto.

B08 sigue abierto en sus once nombres. Seguir mc_multilife_status y el
motor lx privado de simulate_annuity_x/simulate_insurance_x; este último
no usa automáticamente los generadores corregidos. next-status-diagnosis.log
reproduce un par aceptado por el estado y rechazado por mc_insurance en
T=K+1. Conciliar el contrato tol antes de cambiar ese dominio público;
no se corrigió por analogía. Después seguir pagos, seguros, primas/pérdidas,
reservas por trayectoria y resúmenes, incluidos RNG/antitéticos y NA.
Conservar audit-multilife-monte-carlo.md y sus regresiones anteriores.
El usuario autorizó expresamente C17 («Autorizar la coherencia exacta K/T»)
el 22 de octubre durante esta validación: exigir el intervalo exacto de
T tras la comprobación entera de K, sin reparar trayectorias. Aplicarla en
la siguiente unidad sin volver a pedir autorización. No implementada en el
snapshot B08-01. next-lx-engine-diagnosis.log confirma otro defecto A
pendiente del motor lx: razón anual 1e-600 se pierde y genera T=0 bajo CML.
Artefactos nuevos: b08-01 en la sesión del 21 de octubre, con trabajo
fechado el 22. Sin push/publicación ni nuevas dependencias.

## B07-06: conciliación de los seis nombres (21 de octubre de 2026)

Base 4b0948e; rama audit/0.2.0-precran y versión 0.1.6.9000 conservadas,
Git limpio al iniciar. t_pxy y e_xy usan supervivencia observada lx en log;
e_xy complete integra analíticamente cada intervalo UDD/CF/Balducci. Se
corrige pérdida de supervivencia anual diminuta y áreas que la cuadratura
omitía. No cambian firmas, columnas, estados, cero/NA ni truncación; C13-C16
siguen limitadas a lo autorizado. 189 comprobaciones nuevas, 138 resultados
ordinarios completos a 1e-12, seis firmas idénticas; inventario 102/974.
Suite fuente definitiva: 6156 aprobadas, sin fallos/advertencias/omisiones.
Suite instalada también 6156, sin fallos/advertencias/omisiones. Build/check
salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo; ejemplos y cuatro
viñetas aprobados. Archivo de 391 fuentes verificado y huella registrada.
B07-06 y B07 cerrados dentro del alcance/límites de sus seis nombres;
702 comprobaciones nuevas acumuladas desde B06. El suplemento B05 siguiente
sigue pendiente y no se presenta como resuelto por el cierre B07.
Fórmulas, libros independientes, estados y límites: audit-multilife-contingencies.md.
Validación de archivo/check final: audit-precran-check.md.

La conciliación detectó un nuevo defecto A en t_px/e_x con lx=(1,1e-200):
CF a medio año devuelve cero frente a 1e-100, y esperanza de un año cero
frente a 1/(200*log(10)). Confirmado por single-life-followup.log, todavía
sin implementar en esas dos funciones. La base B07 ya evita ese complemento.
Siguiente paso de mayor valor: suplemento B05 para t_px/e_x, incluyendo
consumidores/identidades y contratos de columnas/NA/horizonte; después B08.
No tratar este defecto como límite actuarial ni como corregido por analogía.
Conservar toda la evidencia de B05/B06 y los límites históricos del cierre.

Artefactos nuevos en b07-06 de la sesión del 21 de octubre. El primer libro
de test omitió timing="due" en annuity_xy; initial-ledger-timing-tests.log
se conserva como evidencia intermedia, no como suite final. before-final.log
definitivo reproduce 74 fallos y 115 aprobadas contra 4b0948e. Sin versión,
push/publicación, nuevas dependencias o ampliación de las decisiones C.

## B07-05: primas y reservas (21 de octubre de 2026)

Base c126ccb, misma rama audit/0.2.0-precran y versión 0.1.6.9000; Git
inicialmente limpio. Se corrigió el dotal puro diagnosticado en B07-04:
premium_xy/reserve_xy valoran B exp(-g(h+n))S(h+n) directamente mediante
helper privado compartido, sin restar endowment-term. Se mantiene la mezcla
desde emisión para beneficios diferidos y el condicionamiento de reserva
en AMBAS vidas vivas en t. No inferir un estado 10/01 por status=last.

Recursión joint ahora hacia atrás con la misma identidad; last conserva
11/10/01. Ambas usan decrementos lx directos y log interest original, sin
ampliar restricciones h=0,k=1,due,issue. P=0 omite exactamente el componente
de primas, incluso si el factor unitario desbordaría. Validación de tablas,
grillas y coerciones grandes reforzada, con firmas y columnas preservadas.

C16 autorizada expresamente antes de implementar: la reserva prospectiva
incluye la cuota vencida programada exactamente en t y la última cuota en
madurez si corresponde. P sigue anualizada y la cuota es P/k. No se cambia
la aproximación de los pagos futuros ni se amplía la recursión. Ver propuesta
y aprobación en audit-api-review.md, pruebas/fórmulas en
audit-multilife-contingencies.md B07-05.

142 comprobaciones nuevas; suite fuente final 5967 aprobadas, sin fallos/
advertencias/omisiones. 136 resultados ordinarios completos a 1e-12 y dos
firmas idénticas. La suite inicial 5965 y su tar se preservan como borrador
anterior al fix de prima cero; no usarlos como validación del código final.
Archivo final de 390 fuentes verificado. Resultado definitivo y huella en
audit-precran-check.md. B07 sigue abierto: conciliar seis funciones, sus
horizontes/estados/límites, extremos de t_pxy/e_xy y equivalencia con APV fuera
de rango antes de declarar cierre integral. Sin nuevas dependencias, versión,
push/publicación ni extensión de autorizaciones anteriores.
Validación definitiva B07-05: 5967 comprobaciones fuente/instaladas aprobadas,
0 fallos/advertencias/omisiones; build/check salida 0, 0 ERROR, 0 WARNING,
1 NOTE por desarrollo. Ejemplos y cuatro viñetas aprobados; 390 fuentes
verificadas y huella registrada. B07-05 cerrado en su alcance; B07 sigue
abierto para conciliación integral. No repetir el diagnóstico del dotal puro
como pendiente: está corregido y probado en ambos consumidores.

## B07-04: anualidades/reversiones (21 de octubre de 2026)

Base 61fa813, rama y versión 0.1.6.9000 verificadas, Git inicialmente limpio.
annuity_xy combina probabilidades de 11/10/01 con beneficios firmados en log,
usando decrementos acumulados/fraccionarios directos para las reversiones.
Se preservan tasas originales y valores monetarios representables; se comprueba
coherencia anual de tablas y grillas finitas/representables. Firma y columnas
intactas, sin dependencias nuevas. C15 fue autorizada expresamente antes de
implementar: second exige pesos positivos y el año siguiente en ambos bordes,
sin inventar fuerza cero; none/first conservan sus calendarios. Aproximaciones
negativas advierten sin recorte. No extender la aprobación a estados de pago
arbitrarios ni a otras funciones. Ver audit-api-review.md.

95 comprobaciones nuevas y 72 resultados tidy ordinarios completos a 1e-12;
firma idéntica a base. Evidencia y fórmulas en audit-multilife-contingencies.md.
El probe de cohorte extinguida prueba NaN previo frente a cero corregido.
Resultado definitivo de suite/build/check y archivo: audit-precran-check.md.
Se conserva la truncación de cada marginal abierta más allá de su última
edad, incluyendo su efecto en estados last/reversiones; está documentada como
límite, no como mortalidad observada. C13 del seguro no la cambia por analogía.
B07 sigue abierto: continuar premium_xy y reserve_xy (equivalencia, importe
por cuota frente a prima anualizada, dotal puro por diferencia, fraccionamiento
extremo y estados condicionantes). Mantener las 46 conexiones de B07-03 y
la recursión 11/10/01 ya corregida. No push/publicación ni cambio de versión.
Diagnóstico preparado para B07-05: con lx=(1e16,2,0), i=0, joint, n=1,
beneficio 1e16 y primas anuales due, premium_xy pure_endowment devuelve cero
frente a 4e-16 por supervivencia directa. Confirmado, pendiente de corrección;
no se incluye como cerrado en B07-04. Reproducción next-premium-diagnosis.log
en b07-04. Empezar por eliminar esa resta para el dotal puro, contrastando
también reserve_xy y conservando firmas/columnas.
Validación final B07-04: 5825 comprobaciones fuente/instaladas aprobadas,
0 fallos/advertencias/omisiones; build/check salida 0, 0 ERROR, 0 WARNING,
1 NOTE por desarrollo. Ejemplos y cuatro viñetas aprobados; archivo de 389
fuentes verificado y huella registrada. B07-04 cerrado en ese alcance,
B07 abierto. La hipótesis confirmada de primas continúa pendiente en B07-05.

## B07-03: seguros por estados y conexiones (21 de octubre de 2026)

Base 161cc3b, Git limpio y versión 0.1.6.9000. El usuario reordenó B07:
insurance_xy por estados, después relaciones con anualidades incluidas las
reversionarias, primas anuales/fraccionarias y reservas bivariadas. Respetar
ese orden y todas las correcciones previas. insurance_xy suma ahora masas
anuales disjuntas de primer/segundo fallecimiento desde emisión, con tasa
original log y producto monetario estable. Mantiene esquema y una póliza
por llamada. No invoca annuity_xy como motor: sus identidades son contraste.

C13 y C14 autorizadas expresamente: whole exige mortalidad observada hasta
extinción del estado, sin convertir saldo de tabla abierta en pago terminal;
endowment n=0 paga beneficio descontado si el estado sobrevive a h. Term n=0
sigue cero. No añadir pure_endowment ni estados iniciales 10/01 a la API:
esas extensiones no forman parte de estas aprobaciones. Ver audit-api-review.md.

188 comprobaciones nuevas: 142 seguros/estados/bordes/extremos y 46 relaciones
independientes con anualidades, reversiones designadas, primas k=1/2 y reservas
prospectivas/recursivas según soporte. Suite fuente 5730 aprobadas, sin
fallos/advertencias/omisiones. 36 resultados ordinarios completos concuerdan
con base a 1e-12 y firma intacta. Archivo de 387 fuentes verificado; resultado
definitivo del check en audit-precran-check.md. Detalles matemáticos y límites
en audit-multilife-contingencies.md B07-03. B07 permanece abierto: continuar
annuity_xy (beneficios por estados/reversionarias, pagos/Woolhouse/extremos),
luego premium_xy y reserve_xy, sin confundir comprobaciones cruzadas ordinarias
con cierre integral. Dotal puro por diferencia sigue pendiente de estabilidad
propia; también precisión extrema de t_pxy/e_xy. Sin push/publicación ni versión.
Validación final B07-03: suite fuente/instalada 5730 aprobadas, 0 fallos/
advertencias/omisiones; build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por
desarrollo. Ejemplos y cuatro viñetas aprobados, 387 fuentes verificadas y
huella registrada. B07-03 cerrado en su alcance; B07 sigue abierto.

## B07-02: dominio de probabilidades y esperanzas (21 de octubre de 2026)

Base 6969b2d, rama audit/0.2.0-precran y versión 0.1.6.9000 verificadas,
Git inicialmente limpio. t_pxy/e_xy validan ahora la base anual de edades,
lx y px/qx antes de llamar al motor marginal. Se corrigen controles inválidos
y coerción de edades fuera del rango integer; se conservan las convenciones
propias de t=0, NA inicial y truncación. Ver audit-multilife-contingencies.md:
62 comprobaciones nuevas, 48 resultados ordinarios completos idénticos y dos
firmas preservadas. Validación final en audit-precran-check.md. Sin decisión C
nueva, dependencias o cambio de versión. B07 sigue abierto: quedan precisión
extrema de supervivencia/cuadratura y revisión integral de annuity_xy,
insurance_xy, premium_xy y reserve_xy. No confundir el cierre de dominio
con un cierre integral de esas funciones. Preservar todos los condicionamientos
previos y B07-01. No push/publicación.
Validación final B07-02: 5542 comprobaciones fuente/instaladas aprobadas,
0 fallos/advertencias/omisiones; check salida 0, 0 ERROR, 0 WARNING, 1 NOTE
por desarrollo. Ejemplos y cuatro viñetas aprobados, 384 fuentes verificadas
y huella registrada. B07-02 cerrado para dominio anual y controles; B07 sigue
abierto. Próxima revisión: precisión extrema de t_pxy/e_xy y valoración
por estados/pagos/Woolhouse de annuity_xy, seguida de insurance_xy.

## B07-01: herencia CML (21 de octubre de 2026)

Base 11eeb49 verificada, rama audit/0.2.0-precran, Git inicialmente limpio y
versión 0.1.6.9000. Se inicia B07 sin reabrir B06: t_pxy/e_xy ignoraban el
atributo CML y usaban UDD. Se normaliza CML a CF, también antes de comparar
dos tablas. Ver audit-multilife-contingencies.md: 26 comprobaciones analíticas
nuevas, 15 fallos reproducidos contra la base. Firmas y columnas preservadas,
sin decisión C nueva. Validación definitiva en audit-precran-check.md.
B07-01 cerrado en ese alcance: suite fuente/instalada 5480 aprobadas,
check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo; ejemplos y cuatro
viñetas aprobados. Archivo de 382 fuentes verificado y huella registrada.
B07 sigue abierto: continuar dominio, controles, bordes y precisión de
t_pxy/e_xy, luego anualidades/seguros, primas y reservas. Preservar los
condicionamientos ya corregidos de e_xy, insurance_xy y reserve_xy. No extender
esta corrección a otros consumidores ni declarar revisadas estas dos funciones
en su totalidad. Sin push/publicación ni cambio de versión.

## B06-05: anualidad multivida y seguros restantes (21 de octubre de 2026)

Base d117df3. Se retoma el trabajo guardado antes de la interrupción de red;
no reiniciar. annuity_multi implementa C12 autorizada expresamente el 20 de
octubre: frac al final, pagos reales 1/k y ambos extremos de Woolhouse temporal.
Se conserva el significado histórico joint-and-survivor de reversionary y el
horizonte conservador. insurance_variable_k usa masas directas de fallecimiento
subanual; insurance_xj conserva estado activo frente a todas las causas y
usa log supervivencia/descuento. Ver audit-single-life-contracts.md B06-05:
ecuaciones, referencias, ejemplos reproducidos y límites, sin máxima generalidad.
Un helper privado compartido; sin nuevas dependencias ni versión. Dos firmas
idénticas y una ampliada al final por C12; A_xj idéntico a insurance_xj.
153 comprobaciones nuevas y suite fuente completa aprobadas antes del corte;
62 comparaciones ordinarias a tolerancia 1e-12. B06 acumula 638 nuevas.
Inventario 102 nombres y 974 apariciones de parámetros, sin descripciones
faltantes. El cierre definitivo y check instalado están en audit-precran-check.md.
Después de validar/cerrar B06, seguir B07 (multivida), preservando los arreglos
previos y audit-multilife-monte-carlo.md; no confundir esta revisión de
annuity_multi con el cierre del conjunto multivida. B01/B02 mantienen su
estado formal de revisión pendiente. No push/publicación ni cambio de versión.
Validación definitiva 21 de octubre: archivo verificado (381 archivos), check
salida 0, 0 ERROR, 0 WARNING, 1 NOTE por desarrollo; 5454 comprobaciones
instaladas aprobadas, ejemplos y viñetas aprobados. Huella/entorno en
audit-precran-check.md. B06-05 y B06 (14 nombres) quedan cerrados dentro de
sus alcances/límites documentados, 638 comprobaciones nuevas acumuladas.
El usuario autorizó guardar el commit local tras verificar. Continúa B07;
no reiniciar B06 ni dar por revisadas todas las valoraciones multivida por
la sola conciliación de annuity_multi.

## B06-04: contratos y componentes (19 de octubre de 2026)

Base acab741: life_contract, add_insurance y add_premium_schedule revisadas
con consumidores y evidencia previa. Se preservan entradas enteras grandes
sin coerción NA, se valida el dominio financiero de la tasa original y se
rechazan calendarios desbordados/vacíos por redondeo. No se convierte la tasa
almacenada ni se alteran campos/aliases o hipótesis frac capturadas al añadir.
68 comprobaciones nuevas y 72 objetos ordinarios idénticos al commit base;
B06 acumula 485 nuevas. Suite local completa aprobada; resultado definitivo
de check/archivo en audit-precran-check.md. Ver audit-single-life-contracts.md
B06-04 para matemática y límites: constructor estructural, restricciones de
cada valoración, términos positivos y componentes ensamblables en cualquier
orden. No hay decisión C nueva, dependencias o cambio de versión.
Continúan annuity_multi, insurance_variable_k e insurance_xj/A_xj. B06 sigue
abierto; no reiniciar unidades cerradas ni confundir almacenamiento fiel con
validación integral de todos los modelos multivida/simulación. Sin push.
Validación final B06-04: check salida 0, 0 ERROR, 0 WARNING, 1 NOTE por
desarrollo; 5301 comprobaciones instaladas aprobadas, ejemplos y viñetas
aprobados. Archivo verificado precran-b06-contract-storage (378 archivos);
huella/entorno en audit-precran-check.md. Unidad cerrada en ese alcance.

## B06-03: primas y reservas (19 de octubre de 2026)

Base 576c9a1: premium_x, premium_gross y reserve_x conciliadas con pruebas
previas y libros independientes. Se corrige plazo variable inferido y su
límite de primas; se aceptan términos variables fraccionarios ya soportados
por el productor. Prima comercial: consistencia monetaria relativa sin piso,
cargas representables y residuo honesto cuando G/P redondean iguales.
Reserva recursiva: misma identidad hacia atrás, condición final prospectiva
en cohorte soportada, tasa original y probabilidades directas de lx, sin
forzar reservas cero ni atravesar estados extinguidos no solicitados.
Ver audit-single-life-contracts.md B06-03 y resultado final/archivo en
audit-precran-check.md. 239 comprobaciones nuevas; B06 acumula 417 nuevas.
Tres firmas/esquemas preservados; sin decisión C nueva, dependencias o versión.
Se mantienen límites de horizonte, primas due, scalar-contract y componentes
no finitos documentados. Continúan life_contract, add_insurance y
add_premium_schedule, y después las valoraciones B06 restantes. No reiniciar
la auditoría ni atribuir estos cambios a un informe externo no proporcionado.
Validación final B06-03: 0 ERROR, 0 WARNING, 1 NOTE por desarrollo; 5233
comprobaciones instaladas aprobadas, ejemplos/viñetas aprobados. Archivo
precran-b06-premiums-reserves verificado (377 archivos); huella y entorno
en audit-precran-check.md. Sin push/publicación ni cambio de versión.

## B06-02: anualidades y seguros (18 de octubre)

El usuario pidió especial cuidado con generalidad y vectorización de
annuity_x/insurance_x. Se añade vectorización paralela de escenarios con
reciclaje solo de longitud uno, lt/tidy compartidos, resultado numérico para
mutate o tibble por filas, sin cambiar firmas ni añadir dependencias.
Tasas originales y cocientes log mantienen APV representables; decrementos de
lx evitan cancelación, extinción y overrides explícitos quedan corregidos.
Woolhouse explicita límites y advierte aproximaciones negativas. C10 y C11
fueron autorizadas expresamente: dotal n=0 paga benefit E_h; anualidad vacía
con APV=0 tiene factor dotal uno y la columna ordinaria annuity_value_at_start.
Ver audit-single-life-contracts.md B06-02 para fórmula, compatibilidad,
generalidad, 118 comprobaciones nuevas y límites. B06 acumula 178 nuevas;
no se presenta como máxima generalidad ni como revisión externa conciliada.
Se conserva el horizonte implícito cerrado de estos consumidores: no confundir
con C07. Seguros subanuales variables ya tienen insurance_variable_k, pendiente
de revisión; muerte exacta/continuos/edades fraccionarias requieren otro diseño.
Continuar primas y reservas, luego componentes y modelos restantes, sin rehacer
esta unidad. Leer primero el resultado B06-02 en audit-precran-check.md.
Validación final: check 0 ERROR, 0 WARNING, 1 NOTE por desarrollo y 4994
comprobaciones instaladas aprobadas; ejemplos/viñetas aprobados. Archivo
precran-b06-annuity-insurance verificado (376 archivos); huella en el registro.

## Continuación B06 (18 de octubre de 2026)

Sobre fdd2d1f se inició B06 con apv_life_flow: tasas log originales,
producto monetario combinado, supervivencia last sin cancelación, tiempos NA,
consulta de horizonte acotada y validaciones de mortalidad/fechas/enteros.
Ver audit-single-life-contracts.md: 60 comprobaciones nuevas, conciliación
de catorce nombres y límites explícitos. Se conserva la política histórica
del subtotal apv ante NA; no tratarlo como valoración completa si faltan pagos.
No se cambia la gráfica contingente ya revisada ni se cuenta como nueva.
B06 sigue abierto; continuar annuity_x/insurance_x y luego primas/reservas
y contratos. Leer la validación B06 final de audit-precran-check.md antes
de ampliar trabajo. No repetir como pendientes los arreglos descritos aquí.
Validación final B06: check 0 ERROR, 0 WARNING, 1 NOTE por desarrollo;
4876 comprobaciones instaladas aprobadas, ejemplos y viñetas aprobados.
Archivo verificado: precran-b06-life-flow; huella en audit-precran-check.md.

## Paréntesis solicitado: visualizaciones financieras y contingentes

El 18 de octubre de 2026 el usuario pidió perfeccionar plot_cash_flow y crear
plot_contingent_cash_flow, con documentación, pruebas matemáticas y gráficos.
Ver audit-cash-flow-visualizations.md para alcance, evidencia y validación.
Esta adición pública está autorizada por esa petición. La matriz pasa a 102
nombres (101 funciones y A_xj), con 973 apariciones de parámetros. No se
modifican firmas existentes ni la versión, ni se hace push/publicación.
El paréntesis quedó cerrado en 67c2b70. B05 se retoma el 18 de octubre:
lifetable y mortality_law_table, con 62 comprobaciones nuevas; ver
audit-life-tables-mortality.md y la validación final en audit-precran-check.md.
C07 fue autorizada expresamente e implementada: con solo lx y close=FALSE,
el intervalo terminal desconocido se devuelve NA; probabilidades terminales
suministradas y tablas cerradas se conservan. El usuario pidió cerrar la conciliación B05: las doce funciones tienen ahora
matriz de evidencia en audit-life-tables-mortality.md; 139 comprobaciones nuevas
entre las dos unidades. C08 (dotal sin cap de uno) y C09 (ax KM como años vividos)
fueron autorizadas expresamente. B05 queda cerrado dentro del alcance y límites documentados: 12/12 funciones,
139 comprobaciones nuevas y check final 0 ERROR, 0 WARNING, 1 NOTE por versión
de desarrollo. La huella/entorno están en audit-precran-check.md. Sigue B06.
B04 conserva su cierre dentro del alcance documentado. No reiniciar la auditoría.

## Actualización de dirección acordada con el usuario

El 16 de octubre de 2026 el usuario pidió un barrido crítico de **todas las
funciones por bloques temáticos**, incluyendo oportunidades de mejora
justificadas. Se acordó objetivo **0.2.0** y decidir sobre **1.0.0 al cerrar
el barrido**. El manual es provisional; la publicación no es la prioridad.
No cambiar DESCRIPTION a versión de release todavía.

Actualización posterior del usuario: incorporar explícitamente exactitud
matemática, experiencia tidyverse y auditoría de firmas. Consultar
`audit-api-signatures.md` (101 firmas y parámetros documentados) y
`audit-api-review.md` (evaluación B01/B02 y propuestas A/B/C). No implementar
cambios de API C sin autorización. No hacer push, publicaciones, cambios
de versión ni operaciones destructivas de Git durante este barrido.

Continuación posterior: C01 fue autorizada expresamente por el usuario e
implementada: solve_value añade residual_tol=tol al final, conserva los
argumentos posicionales y usa ese umbral en Newton y converged, sin piso
oculto. C02–C04 siguen sin autorización/implementación. Se recuperó además
cancelación extrema con factor logarítmico común en pv_flow, fv_flow y
plot_cash_flow; factores distintos no tienen esa garantía. Consultar las
secciones B02-07/B02-08 de audit-cash-flow-roots.md y la última validación
de audit-precran-check.md antes de retomar. La matriz actual tiene 101
entradas y 960 apariciones de parámetros. No repetir estos pendientes
como si siguieran sin estudiar.

B03 ya está iniciado: audit-financial-annuities-loans.md recoge la primera
unidad de a_angle, s_angle y los tres calendarios de préstamos. Se corrigieron
tasas pequeñas, saturación anual y el uso de tol monetario para clasificar
tasas como cero; firmas y columnas intactas. La continuación B03-05/B03-07
ya aborda annuity_arith/annuity_geom: productos ponderados, i próximo a g,
spread calculado antes de conversión periódica y perpetuidades convergentes.
Se conserva la interfaz. B03-08/B03-10 ya verifican extras, recálculo y
cancelación anticipada, y corrigen el flag de amortización negativa due,
nombres fraccionarios de anticipos, tol infinito y rango monetario.
**B03 cerrado dentro del alcance documentado**, con 216 comprobaciones nuevas,
suite completa y R CMD check final aprobados. No repetir esos pendientes.
Consultar el registro y su sección de límites antes de ampliar ese alcance.
B04 ya iniciado: audit-bonds-curves-immunization.md registra la primera unidad
de bond_cash_flows, bond_price, bond_ytm y accrued_interest. Se corrigieron
brackets de bonos largos, descuento y conversión de tasas fuera de rango,
productos de cupón e interés corrido, índices y convergencia del rendimiento.
Las 99 comprobaciones nuevas y la validación global están documentadas;
consultar audit-precran-check.md para su resultado y alcance exactos.
La segunda unidad ya revisa bond_book_value y bond_callable_price, conserva
descuentos originales y valida los períodos de rescate; añade 142 comprobaciones.
El usuario autorizó C05: is_worst_case señala el mínimo calculado y todos sus
empates exactos; no se usa tol temporal como umbral monetario. Ver el registro
B04 y audit-api-review.md. La tercera unidad revisa yield_curve, forward_rate,
forward_curve, bootstrap_spot_curve y par_rate, con 79 comprobaciones nuevas:
descuento y forwards desde base original, tasa par independiente de moneda,
NA con extremos incompletos y posiciones de gráficos, y sistema triangular.
Bootstrap conserva su algoritmo; no hay decisión C nueva. Consultar los
resultados exactos de validación global en audit-precran-check.md.
La cuarta unidad ya revisa duración/convexidad de flujos, bonos y portafolios:
253 comprobaciones nuevas, contribuciones relativas, medias ponderadas sin
productos monetarios desbordados, base log de bonos y tol solo de calendario.
Firmas/columnas intactas. C06 fue autorizada expresamente e implementada:
se conserva fila ID NA con métricas NA bajo propagate en los dos portafolios;
drop/error intactos. Ver audit-api-review.md y la validación global vigente.
La quinta unidad ya revisa immunize_duration, immunize_duration_convexity y
plot_immunization_gap, con 113 comprobaciones nuevas y QA visual de dos PNG.
Se preservó el helper SVD y el mínimo de norma sobre unidades: se anticipa
el escalado a los productos monetarios, se retiene la base log de pasivos y
se calcula el gap como flujos firmados, con malla válida sobre -1. Las veinte
funciones B04 quedan cerradas dentro del alcance y límites documentados, con
686 comprobaciones nuevas y check final 0 ERROR, 0 WARNING, 1 NOTE por versión
de desarrollo. Consultar el registro B04 y el archivo verificado/huella en
audit-precran-check.md. Siguen B05, tablas de vida,
mortalidad y probabilidades: lifetable y mortality_law_table primero, sin
reiniciar ni presentar como nuevos los arreglos previos.

Hubo autorización puntual posterior para subir los diez commits acumulados:
el push hasta 8dba06e a origin/audit/0.2.0-precran se realizó y verificó.
No interpretar ese respaldo como autorización para subir automáticamente
unidades futuras, cambiar la rama principal o publicar una versión.

Consultar primero `audit-thematic-review.md` (inventario completo de los
101 nombres públicos) y `audit-interest-foundations.md` (B01 iniciado y
con pendientes), además de los registros anteriores.
Para la continuación numérica de B01 y las TIR/ecuaciones de B02, consultar
también `audit-cash-flow-roots.md`; no dar por cerrados ambos bloques.
La CI y el manual con índice ya se ejecutaron; los detalles están en `audit-ci-minimum-r.md` y
`audit-manual-index.md`. Sus resultados corresponden al código que indican;
no validan automáticamente cambios posteriores. El resto de este prompt
conserva el relevo histórico inicial y debe leerse con esa salvedad.

Quiero que continúes trabajando conmigo en mejorar, corregir, editar y
perfeccionar mi paquete R `tidyactuarial`. Estamos estabilizando la versión
0.2.0 mediante una auditoría actuarial y técnica previa a CRAN. Trabaja con
autonomía en las tareas necesarias, pero conserva el alcance y la trazabilidad
de cada cambio. Comunícate en español claro y cercano.

## 1. Ubicación y estado de partida

- Repositorio: `C:/Users/LENOVO/tidyactuarial_MASTER/tidyactuarial`.
- Rama comprobada el 16 de octubre de 2026: `audit/0.2.0-precran`.
- Versión real comprobada en DESCRIPTION: `0.1.6.9000`.
- Referencia estable indicada en AGENTS.md: CRAN 0.1.6.
- Último commit comprobado: `686e2ca` — Preserve initial conditioning in
  two-life expectancy.
- Hay numerosos cambios de auditoría **locales y sin commit**, incluidos
  archivos nuevos de pruebas y helpers. Son trabajo que debe preservarse.

Verifica estos datos al comenzar: son una fotografía del relevo, no una
garantía de que el repositorio no haya cambiado después.

Usa este mismo checkout. Un worktree nuevo no contendrá automáticamente los
cambios sin commit. No resetees, limpies, reviertas, descartes ni sobrescribas
el trabajo existente para obtener un árbol limpio. Identifica cualquier
cambio ajeno antes de editar o agrupar commits. No cambies la rama principal,
hagas push, merges, publicaciones, cambio de versión de release o envío a
CRAN sin autorización explícita.

## 2. Lectura inicial obligatoria

Lee primero los archivos actuales del repositorio:

1. `AGENTS.md`: contiene las reglas actuariales y de diseño de API.
2. `DESCRIPTION`, `NEWS.md`, `.Rbuildignore` y el estado/diff de Git.
3. `audit-risk-coverage.md`.
4. `audit-multilife-monte-carlo.md`.
5. `audit-precran-check.md`, incluida su sección de revalidación más reciente.

Los registros anteriores contienen fórmulas, causas raíz, ejemplos antes y
después, pruebas e impacto de compatibilidad. Consúltalos en vez de confiar
solo en este resumen. No des por correcta una solución previa sin comprender
su modelo y verificar su alcance.

Existe referencia a una auditoría externa de al menos 16 hallazgos, pero su
informe original no se proporcionó en el chat anterior. No inventes su lista,
numeración ni correspondencia con los hallazgos descubiertos aquí. Su ausencia
no impide avanzar en verificaciones independientes, pero sí impide declarar
conciliada o cerrada toda esa auditoría externa.

## 3. Forma de trabajar y límites de los cambios

- Matemática actuarial primero: identifica el modelo, la identidad y el estado
  condicionante antes de cambiar código.
- Reproduce cada supuesto fallo sobre la rama actual. Distingue confirmado,
  propuesto, implementado, probado y cerrado.
- Para un fallo reproducible, demuestra una prueba que falle antes y pase
  después. Usa referencias independientes: sumas explícitas, enumeración,
  integración de la variable original o identidades exactas. Evita que la
  referencia sea otra llamada al mismo algoritmo que intentas comprobar.
- Contrasta con `actuar` o `lifecontingencies` cuando estén disponibles y las
  parametrizaciones coincidan. No los conviertas en el núcleo del paquete.
- Haz el diff mínimo necesario. Me preocupa que la auditoría modifique muchos
  archivos sin necesidad: distingue los cambios nuevos de los acumulados y
  explica qué archivo funcional exige cada prueba y documento relacionado.
- Conserva nombres, columnas y convenciones públicas de n, k, m, h, frac,
  i_type, timing y tipos de retorno. No uniformes funciones con contratos
  distintos sin estudiar su significado y compatibilidad.
- No agregues aliases, columnas duplicadas, parámetros de transición,
  dependencias o abstracciones grandes para resolver problemas pequeños.
- No ocultes datos incompatibles, colas omitidas o límites de precisión
  mediante normalizaciones, redondeos o sustituciones silenciosas.
- Preserva semillas y estado RNG cuando lo prometa el contrato.
- Actualiza NEWS y documentación roxygen/Rd cuando corresponda. No edites
  masivamente documentos generados que no necesiten cambios.
- Ejecuta las pruebas pertinentes y los checks requeridos. No repitas una
  suite ya aprobada sin cambios nuevos o un motivo concreto.
- Trabaja hasta dejar cada corrección implementada y comprobada. No pidas
  confirmación para inspecciones o correcciones rutinarias ya autorizadas.
  Pregunta cuando una decisión cambie materialmente la API o el objetivo.

## 4. Trabajo realizado que debes preservar

### Correcciones ya guardadas en commits

- `2ebf9d8`: conversiones de lifetable entre mx y qx con ax distinto de 0.5.
- `41feac9`: probabilidades de leyes de mortalidad, integración de fuerzas
  continuas y modelo clásico Heligman–Pollard de ocho parámetros.
- `686e2ca`: condicionamiento inicial en e_xy de último superviviente y
  tratamiento de extremos/extinción en t_px.

### Correcciones posteriores locales, aún sin commit

**Inmunización:** validaciones relativas a escala monetaria, solución estable
por SVD para sistemas con más activos que restricciones y documentación sobre
la variable de derivación de convexidad. Incluye `R/utils-immunization.R` y
`tests/testthat/test-immunization-regressions.R`. Se preservaron los significados
públicos de las columnas de bonos. Pasaron 31 comprobaciones nuevas al cerrar
ese paso y la suite completa.

**Riesgo y coberturas:** consulta los seis hallazgos de
`audit-risk-coverage.md`. Incluyen escala monetaria de retículas y fusiones,
conservación de masas raras, stop-loss exponencial cubierto, fronteras de VaR,
ambigüedad por truncación de frecuencias FFT y estabilidad del adelgazamiento
binomial negativo/geométrico. La masa omitida de FFT no es necesariamente una
cola superior de pérdidas. Los cuantiles ambiguos se rechazan, sin renormalizar.

**Reservas y Monte Carlo:** consulta los siete hallazgos de
`audit-multilife-monte-carlo.md`. Incluyen recursión de tres estados para último
superviviente, log1p en simulación CML, propagación de NA, fechas fraccionarias,
garantías tras muerte inicial, validación compartida de K/T y calendarios
diferidos anclados en h. `reserve_xy()` conserva la convención de ambas vidas
vivas en la fecha de valoración; no recibe un estado observado de una sola
vida superviviente. No interpretes `status="last"` como si identificara esa vida.

**Empaquetado:** `.Rbuildignore` ahora excluye `AGENTS.md` y `audit-*.md` del
archivo fuente. Los registros siguen en el repositorio. Se verificó que las
pruebas nuevas sí permanezcan en el paquete.

## 5. Última revisión adicional y resultados

Los dos cambios funcionales más recientes están en:

- `R/mc_annuity.R`: la retícula de pagos fraccionarios diferidos usa h como
  origen. La referencia enumera fechas explícitas con h=.125 y k=4 y también
  comprueba su uso en la base de primas de mc_reserve.
- `R/to_payment_basis.R`: para binomial negativa y geométrica se calcula
  p_P=p/(p+q(1-p)), evitando desbordamiento intermedio. Si una frecuencia de
  pagos positiva solo puede codificarse como prob=1 por redondeo, se rechaza
  la conversión y se conserva disponible el modelo por pérdida. No se añadió
  otra parametrización ni se devolvió un agregado degenerado silenciosamente.

Pasaron 14 comprobaciones nuevas y la suite completa. Después se repitieron
construcción, chequeo del paquete instalado y compilación del manual sin índice:

```
R CMD build --no-manual tidyactuarial
R CMD check --as-cran --no-manual tidyactuarial_0.1.6.9000.tar.gz
```

Resultado más reciente: **0 ERROR, 0 WARNING, 1 NOTE**, salida 0. La NOTE es
`Version contains large components (0.1.6.9000)` por la versión de desarrollo.
Pasaron ejemplos, pruebas instaladas y construcción/reconstrucción de las
cuatro viñetas. Esto no prueba ausencia de todos los errores actuariales.

Artefactos de la verificación más reciente:
`C:/Users/LENOVO/.codex/visualizations/2026/10/16/01a1466f-8f29-7903-ba68-1548e4e4b63e/precran-followup/`.
El informe es `tidyactuarial.Rcheck/00check.log`.
SHA256 del archivo fuente: `2A246DFEBDA17E78604FCC99553FDCFE1F9F16FE4B858768D0E729BA47B5F4FA`.

## 6. Entorno y límites de esa validación

- PowerShell y R 4.6.1 en Windows 11.
- Rscript: `C:/Program Files/R/R-4.6.1/bin/Rscript.exe`.
- Biblioteca: `C:/Users/LENOVO/AppData/Local/R/win-library/4.6`.
- Pandoc: `C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools`.
  Configurar RSTUDIO_PANDOC ayuda a rmarkdown; incluirlo en PATH es necesario
  para otras comprobaciones de R.
- En el aislamiento, file.access(...,4) devolvía -1 incluso para archivos
  legibles, haciendo que R CMD check declarara ausentes las dependencias.
  La validación correcta se ejecutó fuera del aislamiento mediante los
  mecanismos de permisos disponibles. No debilites validaciones del paquete
  para ocultar ese problema del entorno.
- El lanzador rcmdcheck/pkgbuild exigía Rtools antes de comenzar. Se usó
  R CMD build/check directamente sobre una copia del código en el área de
  verificación, sin modificar el checkout para sortear ese requisito.
- El manual PDF compiló con `R CMD Rd2pdf --quiet --no-preview --no-index`.
  Falta makeindex en TinyTeX para completar la modalidad con índice.
- Se usó `_R_CHECK_CRAN_INCOMING_REMOTE_=false`. No se validó la revisión
  remota de recepción de CRAN.
- La matriz de CI configura R release en Ubuntu, Windows y macOS. Se revisó
  su configuración, pero no se ejecutó remotamente. Tampoco se probó R 4.1,
  la versión mínima declarada. `actuar` no estaba instalado.

## 7. Próximas prioridades

1. Consolidar el estado actual: revisar el diff acumulado y organizar grupos
   coherentes de cambios y commits locales, preservando todos los archivos
   nuevos necesarios. No asumir que el árbol limpio sea un requisito previo.
2. Revisar los pendientes concretos de los registros y el informe externo
   original si aparece. No declarar cerrada la auditoría completa por haber
   pasado R CMD check.
3. Buscar fallos adicionales de manera dirigida y con criterio de materialidad:
   estados multivida, identidades entre valoraciones, límites y colas,
   discretización, momentos, simulación y compatibilidad documentada.
   No refactorizar ni añadir funcionalidades solo por mantener actividad.
4. Preparar validación de CI y compatibilidad con R mínimo, además del manual
   con índice y comprobaciones remotas antes de una publicación.
5. Como mejora docente atractiva, considerar una viñeta reproducible de valores
   exactos frente a Monte Carlo con error de simulación e identidades de control.
   Esa viñeta fue sugerida; **todavía no se creó**.

Al comenzar, verifica el estado y lee los registros. Dame una síntesis breve
de qué está probado, qué sigue pendiente y cuál es el siguiente paso de mayor
valor. Después continúa con trabajo concreto dentro del alcance autorizado.
En cada entrega explica problema matemático, causa, diff mínimo, pruebas y
resultados, compatibilidad y estado de Git. No vuelvas a empezar la auditoría
desde cero ni presentes como nuevas las correcciones ya documentadas.
