# Auditoría: consumo y evidencia

Preferencia del usuario, 23 de octubre de 2026: minimizar consumo sin
sacrificar formalidad ni confiabilidad. Se mantienen AGENTS.md, el prompt
maestro, las autorizaciones específicas y las validaciones de cada unidad.

## Lectura y alcance

- Verificar Git, rama, DESCRIPTION e instrucciones aplicables al iniciar.
- Leer el encabezado actual de audit-continuation-prompt.md y los registros
  de las funciones afectadas. Consultar el historial adicional por necesidad;
  no releer ni volcar todos los registros en cada unidad. No borrar historia.
- Usar rg y fragmentos pertinentes de implementación, consumidores, ayudas y
  pruebas. Leer el archivo completo cuando haga falta para comprenderlo.
- Trabajar una unidad coherente y acotada. Conservar hallazgos de otras
  funciones en el registro de continuación; no implementarlos por analogía.
- No cambiar modelo, razonamiento, velocidad o preferencias de la app sin
  autorización. No crear agentes ni automatizaciones para ahorrar consumo.

## Antes de la validación integral

1. Especificar modelo, unidades, estado condicionante y oráculo independiente.
   Preparar una matriz breve de modalidades, bordes, NA, rango numérico,
   metadatos, encadenamiento y tipos de retorno. Evitar combinaciones repetidas
   sin una interacción que justifique probarlas.
2. Reproducir cada defecto sobre la base real y conservar evidencia previa.
   Resolver las decisiones C mediante propuesta concreta y autorización;
   mientras tanto avanzar en tareas independientes.
3. Implementar el diff acotado. Durante la iteración ejecutar las regresiones
   afectadas y las de consumidores pertinentes. Corregir primero los fallos
   locales; no iniciar la suite completa mientras el cambio siga incompleto.
4. Completar ayuda pública, ejemplos afectados, NEWS y registros matemáticos.
   Comprobar firmas, columnas, clases, compatibilidad ordinaria y límites.
   Regenerar roxygen y revisar el diff antes de lanzar la fase final.

## Validación final, una vez por conjunto estable

- Ejecutar la suite completa sobre las fuentes finales y el inventario.
- Construir el archivo fuente final y ejecutar R CMD check --as-cran
  --no-manual. Conservar pruebas instaladas, ejemplos y viñetas. El check
  instalado es una comprobación distinta; no sustituye la suite fuente.
- Verificar fuentes/pruebas/Rd/NEWS/NAMESPACE/DESCRIPTION del archivo contra
  el checkout y registrar SHA256, entorno, resultados y límites reales.
- Si aparece un fallo o un cambio posterior, repetir las verificaciones
  que ese cambio invalide. Un cambio en el contenido del paquete invalida
  su archivo anterior: reconstruir, comprobar y cotejar el archivo nuevo.
  No reutilizar un resultado anterior como prueba de código nuevo.
- Actualizar registros excluidos por .Rbuildignore con los resultados reales;
  esas actualizaciones documentales no requieren otro build/check si no
  cambia el contenido empaquetado. Guardar el commit local y verificar Git.
- No repetir suite/build/check por rutina cuando ya certifican exactamente
  el mismo contenido. No hacer verificaciones exhaustivas de versiones
  intermedias por comodidad; tampoco omitir las finales para ahorrar.

## Herramientas y comunicación

- Conservar las salidas extensas en archivos; mostrar únicamente resultados,
  errores y fragmentos necesarios. Reutilizar scripts locales comprobados.
- Agrupar lecturas independientes y usar las sesiones de procesos largas.
  Espaciar comprobaciones de progreso; no sondear a intervalos de segundos.
- Comunicar avances breves, centrados en hallazgos y decisiones, respetando
  la frecuencia exigida por la sesión. Evitar repetir el plan o todo el
  historial. El cierre incluye resultado, evidencia, límites, commit y
  siguiente unidad.
- Mantener el encabezado de continuación como punto de entrada actualizado.
  No exigir al usuario pegar la historia completa en cada mensaje.
- El consumo de la cuenta es agregado y variable. No prometer un número de
  mensajes ni atribuir porcentajes a esta tarea sin evidencia por tarea.
  Consultar el cupo cuando ayude a una decisión, no en cada operación.

Esta política cambia la organización del trabajo, no el estándar actuarial,
los requisitos de aprobación, las pruebas obligatorias ni la trazabilidad.
