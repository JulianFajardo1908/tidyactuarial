# Paréntesis de visualizaciones financieras y actuariales

18 de octubre de 2026. Base: 989b4cf, rama audit/0.2.0-precran;
DESCRIPTION 0.1.6.9000. Árbol limpio al comenzar. Petición expresa del usuario:
perfeccionar plot_cash_flow y añadir plot_contingent_cash_flow. B05 queda
pendiente; no se reinicia ni se da por concluida la auditoría integral.

## Diagnóstico y modelo antes de implementar

Se leyeron AGENTS, prompt maestro, NEWS, DESCRIPTION, estado Git y registros
de auditoría. B02-06/B02-07 ya corrigieron la valoración con base logarítmica,
productos recuperables y cancelación bajo un factor log común finito. Se
preservaron esas correcciones y sus pruebas; no se atribuyen como trabajo nuevo.

apv_life_flow devuelve una fila por pago con t/cf/surv_prob/discount/expected_cf/pv;
es el productor natural. life_contract es una especificación, no un calendario.
insurance_x/annuity_x y sus variantes devuelven APV escalar o una fila resumen:
no contienen suficientes datos para reconstruir pagos sin volver a valorar.
No se amplían sus API ni se inventan calendarios a partir de esos resúmenes.

Para un evento binario E_j y origen actuarial común:

    Importe C_j; probabilidad p_j=P(E_j);
    flujo esperado C_j*p_j; contribución APV C_j*p_j*d_j.

Supervivencia: p_j = S(t_j). Fallecimiento durante (a,b]: p_j=S(a)-S(b),
equivalente a S(a)*q(a,b). No es q(a,b) sin supervivencia previa. El descuento
se aplica a la fecha de pago: el seguro anual paga al final del año de muerte,
no al instante aleatorio T. No se añade un modelo continuo de muerte.

En reversibles, surv_prob=S_all+alpha*(S_any-S_all) es una fracción esperada,
no en general P(evento). Se añade solo el atributo contingency a apv_life_flow:
survival o weighted. La nueva gráfica rotula Expected benefit fraction; tablas
anteriores sin atributo usan Payment weight de forma conservadora. Valores,
columnas, clases, firmas y atributo apv previos no se modifican.

## Hallazgos demostrados A en plot_cash_flow

Todos confirmados antes del cambio mediante reproducción sobre 989b4cf:

* C=(-1.7e308,1.7e308), t=(0,1): label_y y límites del panel infinitos,
  por sumar padding monetario. Ahora se escalan solo coordenadas extremas;
  C y height conservan datos originales y el eje declara la potencia de diez.
* Etiquetas auto de 1e-20 mostraban 0.00; importes 1.7e308 producían cientos
  de caracteres seguidos de T. Auto/compact ahora usan notación científica
  cuando las cifras fijas ocultarían un no-cero o se exceden los sufijos.
  full conserva formato fijo explícito. label_digits se documenta en 0..50,
  el rango de formato admitido sin clamp de formatC.
* Date infinita llegaba a aggregate y fallaba con no rows to aggregate.
  Ahora hay rechazo explícito de fechas no finitas antes de convertir tiempos.
* m=2^31 válido para tasa efectiva producía advertencia de coerción a integer.
  Se conserva validación local y round sin cast innecesario; no se aplica C02.

No se cambian origen cero numérico, origen de fecha mínima ni act/365-act/360,
signos, neteo por fecha, argumentos posicionales, aliases existentes o retorno
ggplot. PV suministrado sigue siendo anotación; no se promete validarlo.

## Mejoras de presentación B y diseño de la nueva función

Las etiquetas coloreadas de texto sustituyen cajas llenas para reducir carga
visual; check_overlap omite texto que no cabe, conservando todas las flechas.
No es una corrección financiera. Para muchas fechas se documenta show_labels
FALSE. aggregate=FALSE conserva posiciones exactas; no se desplazan fechas
para separar flechas. Los mismos helpers privados de escala/etiquetas sirven
a ambas gráficas; no se modifica el helper compartido de valoración.

plot_contingent_cash_flow(.data, view=...) consume la tabla valorizada con pipe.
También acepta t/cf/probability/discount/event; event identifica survival,
death_interval, certain o weighted. Requiere probabilidad incondicional
explícita para intervalos; no resta filas arbitrarias de una tabla. El importe
esperado y pv suministrados se conservan tras validar identidades (tolerancia
relativa 1e-10, sin piso monetario absoluto). Si faltan, se forman con productos
logarítmicos de factores dados. No se recalculan mortalidad, tasa ni fechas.
Los atributos APV/cumulados cacheados no determinan el total de una tabla filtrada.

Cuatro paneles con escalas verticales propias separan dinero y probabilidades;
view permite cada magnitud individual. Paleta financiera coherente, segundo
panel azul y símbolos por evento. Datos largos tibble, retorno ggplot editable.
Se conserva cada pago simultáneo sin sumar probabilidades. Fechas y t originales
del productor quedan intactos, incluida su base actual days/365.25. No se unifica
esa base con los day_count distintos del gráfico financiero.

## Pruebas, compatibilidad y revisión visual

test-cash-flow-visualization.R: 19 comprobaciones nuevas; las expectativas de
geometría/etiquetas, fecha infinita y solapamientos fallaron antes del cambio.
El caso m quedó comprobado tras corregir el error de fecha que interrumpía el
test inicial; la advertencia previa también se reprodujo por llamada directa.
test-plot-contingent-cash-flow.R: 57 comprobaciones nuevas. Total nuevo: 76.
Referencias independientes: probabilidades desde l=(1000,800,600,300,0),
sumas de C*p/(1+i)^t, eventos de muerte .2/.2/.3 frente a q=.2/.25/.5,
UDD/fechas conservadas y estados independientes all/any/reversionary.
Se contrastan sumas con insurance_x y annuity_x como control adicional,
sin usar esos consumidores como único oráculo. Incluye signos, tiempo cero,
pagos simultáneos, pesos cero, moneda extrema, NA, eventos inválidos y datos
inconsistentes. Las pruebas financieras previas siguen incluidas.

Las firmas de plot_cash_flow y apv_life_flow se compararon con 989b4cf y no
cambian. Sin dependencias nuevas, cambios de versión ni otras API existentes
modificadas. Se añade un nombre público autorizado: 102 nombres en total
(101 funciones y A_xj), 973 apariciones de parámetros documentadas.

Se generaron e inspeccionaron los siete PNG de 1650x825/1650x1200 y sus
exportaciones PDF vectoriales en el directorio de artefactos de la conversación,
subcarpeta cash-flow-visualizations: financial, dense_dates, annuity, death,
reversionary, simultaneous y extreme. Ejes, leyendas, etiquetas y títulos
son legibles, sin recortes; los eventos simultáneos se distinguen por símbolo
y extremo. Script reproducible: inst/examples/cash-flow-visualizations.R.

Suite completa local aprobada, salida 0, sin fallos ni advertencias. Build y
check definitivos aprobados: 0 ERROR, 0 WARNING, 1 NOTE por versión de
desarrollo, salida 0. Pasaron ejemplos, pruebas instaladas y cuatro viñetas.
Los hallazgos A y la nueva función quedan implementados, probados y cerrados
dentro del alcance descrito. La huella del archivo fuente y el entorno se
registran en audit-precran-check.md; B05/B06 no quedan cerrados por ello.

## Límites

No es una auditoría integral de apv_life_flow, que queda pendiente en B06;
no se cambia su modelo UDD, política NA, acumulados o anualización. La gráfica
rechaza sus filas faltantes/no finitas o identidades incompatibles en lugar
de presentar un APV parcial silencioso. Tablas sin procedencia no permiten
certificar que los pesos sean probabilidades ni que compartan estado inicial:
en tablas explícitas el usuario declara evento/origen/unidad. No se evalúa
dependencia multivida ni se calculan probabilidades nuevas en el gráfico.
La escala numérica es de presentación; no promete recuperar valores fuera
del rango double, resolver cancelación arbitraria ni hacer legible cualquier
densidad en todo tamaño de exportación. Flechas/puntos coincidentes pueden
superponerse; no se alteran importes o fechas para impedirlo.
Sin push, publicación, manual nuevo ni cambio de versión.
