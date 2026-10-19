# B06 — Contingencias de una vida y contratos

Objetivo 0.2.0, versión real 0.1.6.9000, rama audit/0.2.0-precran.
Inicio sobre fdd2d1f, 18 de octubre de 2026. Se conserva toda la evidencia
previa y el cierre de B03/B04/B05; este registro no reinicia la auditoría.

## Alcance y conciliación

Los catorce nombres incluyen A_xj, alias de insurance_xj. La existencia de
tests anteriores no equivale a cierre integral del bloque.

| Nombre | Evidencia conservada / siguiente revisión |
|---|---|
| apv_life_flow | Primera unidad numérica descrita abajo; quedan límites expresos |
| plot_contingent_cash_flow | Revisión 67c2b70 y 57 comprobaciones reutilizadas; sin cambios gráficos nuevos |
| annuity_x | Tests anuales/fraccionarios previos; sigue revisión de descuento, horizontes y Woolhouse |
| insurance_x | Tests SOA/primas/reservas previos; sigue conciliación de pagos al final del intervalo |
| premium_x | Tests v2 e identidades previas; pendiente conciliación integral |
| premium_gross | Tests v2 previos; pendiente conciliación integral de gastos y normalización |
| reserve_x | Tests v2 previos; pendiente conciliación prospectiva/retrospectiva |
| life_contract | Especificación conserva tasa original; pendiente revisión integral con consumidores |
| add_insurance | Pendiente revisión integral del componente contractual |
| add_premium_schedule | Pendiente revisión integral de calendarios |
| annuity_multi | Tests actuariales previos; pendiente conciliación integral |
| insurance_variable_k | Tests actuariales previos; pendiente conciliación integral |
| insurance_xj | Tests actuariales previos; pendiente conciliación integral |
| A_xj | Alias; revisar junto a insurance_xj, sin duplicar función ni evidencia |

## B06-01: flujo de vida, modelo y defectos reproducidos

Para un pago contractual C_j en t_j, la contribución es
PV_j = C_j S(t_j) exp(-delta t_j). delta es log1p(i),
m log1p(i/m), -m log1p(-i/m) o la fuerza original, según i_type.
En UDD, S(k+u) = producto(p_(x+r), r=0..k-1) (1-u q_(x+k)).
No es un seguro pagadero a la muerte: son pagos contingentes a supervivencia.
Para vidas independientes, first usa producto(S_j), last usa
1-producto(1-S_j), y reversionary usa P(todos)+alpha(P(alguno)-P(todos)).
La última cantidad es un peso de beneficio, no en general una probabilidad.

Reproducciones sobre fdd2d1f en b06-life-flow-before.log:

* Fuerza +/-1000 con t=.001: se rechazaba una valoración finita porque la
  conversión anual redondeaba a -1/Inf. Se usa la base log original existente.
* El producto separado podía perder PV finito por descuento cero/Inf o por
  flujo esperado redondeado a cero. Se combinan log(abs(S))+log(descuento)
  antes del producto monetario, conservando signos y ceros conocidos.
* t=NA estaba admitido por la validación y fallaba en un if interno. Ahora
  devuelve una fila NA, sin eliminar posiciones ni alterar los otros pagos.
* Con supervivencias 1e-20 y 2e-20, last devolvía cero. Se evalúa
  -expm1(sum(log1p(-S_j))); la referencia independiente es S1+S2-S1*S2.
* t=1e10 intentaba reservar un vector de 74.5 GB. La consulta recorre como
  máximo nrow(lt) intervalos: devuelve NA si falta información; después de
  px=0 comprobado devuelve cero, incluso más allá del horizonte observado.
* Fechas infinitas y edades fuera de rango terminaban en errores internos o
  coerciones NA; m=3e9 válido se convertía innecesariamente a entero R.

b06-life-flow-compatibility.log reproduce además la aceptación previa de
edades duplicadas/fraccionarias, px>1, qx<0, lx creciente y px/qx contradictorios.
Ahora se rechazan explícitamente. Se validan columnas numéricas finitas o NA,
probabilidades en [0,1], lx no creciente y edades enteras únicas. Los huecos
no se interpolan: el intervalo consultado ausente queda desconocido.
Estos son defectos A de cálculo/validación; la explicación del subtotal y
convenciones de fechas/orden es documentación B. No hay propuesta estética
ni modificación C implementada en esta unidad.

## Compatibilidad, precisión y límites

Firma, clase tibble, nombres/orden/tipos de columnas y atributos conservados;
comparación ordinaria independiente con fdd2d1f en cuatro estados pasa con
tolerancia relativa 1e-12. No se agregan dependencias, helpers compartidos,
columnas, funciones o versión. La gráfica conserva su revisión previa.

Se mantiene explícitamente sum(pv, na.rm=TRUE): el atributo apv es un subtotal
de contribuciones conocidas; todas NA dan cero. pv_cum sigue cumsum en orden
de entrada, con NA posteriores a la primera contribución desconocida. Cambiar
este contrato o reordenar pagos requeriría una propuesta C y autorización.
No se restringe alpha ni se cambia el comportamiento histórico de single con
varias edades. No se unifican convenciones de horizonte con t_px/annuity_x.
La selección de mortalidad conserva prioridad px, después qx y luego lx;
se comprueba complementariedad px/qx, pero queda pendiente conciliar todos
los valores redundantes con lx y precisar la política de tablas incompletas.

El producto anual de supervivencias todavía puede subdesbordar; no se promete
recuperar una supervivencia ya redondeada a cero ni cancelaciones arbitrarias
entre contribuciones infinitas. La recuperación monetaria cubre supervivencia
representable con flujo esperado/descuento intermedios fuera de rango.
Un descuento diagnóstico cero/Inf no implica necesariamente PV cero/Inf.
plot_contingent_cash_flow sigue rechazando entradas no finitas: no se amplía
su contrato a estos diagnósticos extremos ni se revalora dentro del gráfico.

## Verificación

test-b06-life-flow.R añade 60 comprobaciones: fórmulas UDD y cuatro estados,
tasas originales, signos/rango monetario, simultaneidad/orden, NA/subtotal,
extinción/horizonte, fechas, m y validación de mortalidad. Las 24 pruebas de
apv y las 57 de gráfica anteriores se reutilizan, sin contarlas como nuevas.
Resultados globales, archivo y huella: sección B06 de audit-precran-check.md.
Los defectos reproducidos de esta unidad quedan confirmados, implementados,
probados y cerrados dentro de los límites anteriores: check final salida 0,
0 ERROR, 0 WARNING, 1 NOTE por desarrollo, con 4876 comprobaciones instaladas
aprobadas. No se confunde ese cierre con la revisión integral de apv/B06.
B06 continúa abierto; sigue annuity_x/insurance_x, luego primas/reservas y
componentes, conciliando las pruebas existentes antes de ampliar cobertura.
