# B08 — simulación de vidas y Monte Carlo

## Inicio y alcance (22 de octubre de 2026)

El usuario pidió pasar a B08. Base c7a0d29, Git inicialmente limpio,
rama audit/0.2.0-precran y versión 0.1.6.9000 verificadas. B07 conserva su
cierre documentado. El suplemento B05 t_px/e_x sigue confirmado y pendiente;
cambiar el orden de trabajo no lo corrige ni lo elimina. Se preserva el
registro anterior audit-multilife-monte-carlo.md y sus regresiones de RNG,
fracciones CML, vidas faltantes, calendarios y coherencia K/T.

| Nombre | Modelo/contrato a conciliar | Estado actual |
|---|---|---|
| simulate_lifetime | PMF anual de K y fracción condicional de muerte; tabla qx | B08-01: precisión y validación puntual corregidas/probadas; revisión integral abierta |
| simulate_lifetimes | Vidas independientes; una corriente RNG por llamada; precedencia qx/px/lx | B08-01: radix/decrementos y validación puntual corregidos/probados; revisión integral abierta |
| mc_multilife_status | Min/max de K y T; mismos identificadores de vidas por simulación | Pendiente; incompatibilidad de borde reproducida abajo |
| simulate_annuity_x | Valor presente de pagos por trayectoria; motor lx propio | Pendiente de revisión integral; no usa automáticamente el generador corregido |
| simulate_insurance_x | Seguro anual por trayectoria; motor lx propio | Pendiente de revisión integral |
| mc_annuity | Pagos elegibles por trayectoria, garantías, diferimientos y NA | Pendiente; preservar correcciones previas |
| mc_insurance | Evento y momento del beneficio por trayectoria | Pendiente; preservar validación K/T previa |
| mc_premium | Cociente de medias de pares Z,Y; prima anualizada/cuota | Pendiente de revisión integral |
| mc_loss | Z menos prima en la unidad de Y | Pendiente de revisión integral |
| mc_reserve | Flujos futuros por trayectoria; antes/después de pago; vigencia | Pendiente; preservar calendarios y NA ya corregidos |
| summary_mc | Momentos, error estándar, cuantiles y colas empíricas | Pendiente; preservar TVaR empírica ya corregida |

## B08-01 — fundamentos de los dos generadores

### Identidades y diagnóstico independiente

Desde la edad inicial x: P(K=k)=[producto de j<k de (1-q_j)]q_k.
Si la tabla no agota la distribución, conditional normaliza estas masas
por la probabilidad de muerte observada y advierte; error rechaza. Se
preservan ambos modos y el umbral existente de reconocimiento de truncación.

Condicionalmente al año de muerte, S=T-K tiene las distribuciones:

* UDD: F(s)=s.
* CML, p=1-q>0: F(s)=(1-p^s)/q; S=log1p(-U*q)/log1p(-q).
* Balducci, p>0: F(s)=s/(p+q*s); S=U*p/(1-U*q).

Antes se reemplazaba S por cero en CML/Balducci cuando p<=tol, incluso
si p era positivo. Con q=1-1e-11 y tol=1e-10, todas las fracciones eran
cero, pero sus CDF no devolvían los uniformes de la semilla 42. Es un
defecto A del modelo, no una propuesta de nueva distribución. Se cambia
la condición de degeneración a p==0 y se conserva exactamente la
convención de fracción cero para q==1 en CML/Balducci. La corrección CML
previa con q diminuto, basada en log1p(-q), permanece intacta.

La exposición positiva en lx es lx>0, independiente del radix. Antes
positive_rows usaba lx>tol: multiplicar (100,80,40,0) por 1e-100 podía
rechazar la tabla. Se elimina ese umbral absoluto. Se deriva q como
(l_y-l_(y+1))/l_y, evitando cancelación en 1-l_(y+1)/l_y. Por ejemplo,
lx=(1e16,1e16-2) implica q=2e-16; la resta de la razón redondeada daba
otro decremento. No se añade cierre, extrapolación ni una fila terminal.

Se valida tol antes de usarlo y edades iniciales/de tabla antes de
as.integer, evitando advertencias y NA por coerción. Un n_sim positivo
que redondearía a cero se rechaza. death_age=x+K+1 se calcula sin overflow
entero, conservando integer ordinario y double solo cuando hace falta.
Se preservan las firmas, nombres/orden de columnas, aliases, métodos,
precedencia qx/px/lx y la política de tolerancia ya existente para qx/px.
No se certifica aún todo su dominio ni se uniforman otras funciones MC.

### RNG y comprobaciones

Con seed se conserva/restaura .Random.seed; sin seed se avanza la corriente
del llamador. simulate_lifetimes inicializa una sola semilla para toda la
llamada y no la reinicia por vida. No se cambian cantidad, orden ni tipo
de sorteos. Los pares antitéticos introducen dependencia entre filas;
esta unidad no certifica el error estándar genérico bajo esos pares.

test-b08-lifetime-foundations.R añade 94 comprobaciones: CDF condicional
contra uniformes reconstruidos independientemente, métodos inverse/
multinomial/antithetic y tamaño impar; invariancia al radix para tres
escalas y tres fracciones; decremento pequeño; validación/coerción; masas
anuales explícitas; coherencia K=floor(T); restauración con semilla
presente/ausente, después de error en una vida posterior y consumo sin
semilla. No se usa aproximación estadística para decidir los regresores.

Contra c7a0d29, el archivo definitivo reproduce nueve fallos, cinco errores
y dos advertencias, con 35 comprobaciones ya aprobadas. Algunos errores
originales abortan bloques antes de completar sus aserciones; no se cuentan
las no ejecutadas como aprobadas. Tras el fix pasan las 94. 78 resultados
ordinarios COMPLETOS concuerdan a 1e-12 y las dos firmas son idénticas.

Artefactos: C:/Users/LENOVO/.codex/visualizations/2026/10/21/01a15fe2-c4db-7852-8822-b6e54b77fef0/b08-01/.
before.log y after.log son la regresión inicial de 73 comprobaciones;
after-final.log/before-final.log contienen el archivo definitivo de 94 y
la compatibilidad. final-tests.log y build/check/snapshot son la evidencia
de paquete final, registrada en audit-precran-check.md. Sin nueva dependencia,
versión, push/publicación ni extensión de decisiones C previas.

B08-01 confirmado, implementado, probado y cerrado dentro del alcance
puntual anterior. Suite fuente/instalada: 6250 aprobadas, cero fallos/
advertencias/omisiones. Build/check salida 0, 0 ERROR, 0 WARNING, 1 NOTE
por desarrollo. Ejemplos y cuatro viñetas aprobados; 392 fuentes verificadas.
Entorno, archivo y huella en audit-precran-check.md. B08 completo sigue abierto.

### Continuación y límites

B08 permanece abierto; este subconjunto no cierra sus once nombres. Sigue
mc_multilife_status y el motor .simulate_lifetime_inverse_lx de los dos
wrappers simulate_*_x, luego valoración por trayectoria y resúmenes. No
asumir que corregir simulate_lifetime cambia el otro motor lx.

next-status-diagnosis.log confirma un borde pendiente: dos vidas con
K=(0,2),T=(1,2.5) pasan la tolerancia de mc_multilife_status y generan
K_status=0,T_status=1; mc_insurance rechaza después ese par por incumplir
K<=T<K+1. No está corregido aquí. Se debe conciliar el significado público
de tol antes de cambiar su dominio, además de revisar almacenamiento y
columnas de identificadores. No trasladar automáticamente la aprobación
de otros bordes. El defecto B05 t_px/e_x sigue separado y pendiente.

Actualización de decisión: C17 fue propuesta concretamente en
audit-api-review.md y el usuario autorizó «la coherencia exacta K/T» el
22 de octubre. Aplicar en la siguiente unidad, sin pedir de nuevo; el
snapshot B08-01 todavía no modifica mc_multilife_status.

next-lx-engine-diagnosis.log reproduce además simulate_annuity_x con
lx=(1e300,1e-300), CML, n=1,k=1000: devuelve T=0 y cero pagos en todas
las cinco trayectorias de semilla 42. La fuerza es 600*log(10), finita;
su fracción de vida no es cero casi seguramente. Se pierde la razón
anual antes de aplicar log. Defecto A confirmado pendiente del motor lx,
sin corregir en B08-01. No confundirlo con el soporte de p>0 recuperado
desde qx en el primer generador, ni prometer recuperación de información
que ya se haya redondeado en una conversión qx/px.
