# Prompt maestro para continuar tidyactuarial

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
