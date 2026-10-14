# AGENTS.md — tidyactuarial

## Identidad y estado
- Paquete R de matemática financiera, contingencias de vida y teoría actuarial del riesgo, orientado a docencia y aplicación profesional.
- Referencia estable: CRAN 0.1.6. Rama de desarrollo prevista para 0.2.0: 0.1.6.9000; verificar siempre el `DESCRIPTION` real.
- Objetivo inmediato: estabilizar 0.2.0 antes de CRAN. Existe una auditoría externa con al menos 16 hallazgos; cada hallazgo es una hipótesis de trabajo hasta su reproducción sobre la rama actual.
- El núcleo del paquete usa herramientas tidyverse, resultados claros y convenciones actuariales expresas. No es un wrapper genérico de `actuar`.

## Diseño de API
- Matemática actuarial primero: explicar modelo y notación antes de programarlo.
- Una idea actuarial principal por función; S3 ligero donde aporta valor, sin sobreingeniería.
- Pipe-friendly cuando tenga sentido y tibbles para resultados tabulares/auditables; escalares cuando la operación así lo requiera. No exigir vectorización universal.
- Respetar las convenciones locales documentadas de `n`, `k`, `m`, `i_type`, `h`, `frac`, `timing`, y tipos de retorno; no uniformarlas sin estudiar impacto de compatibilidad.
- Preservar nombres y columnas públicos. Si cambia el significado de un resultado, registrar esa modificación y crear pruebas.
- No agregar alias, columnas redundantes ni parámetros de transición para resolver un problema pequeño si hay una vía más clara.

## Verificación actuarial
- Tablas de vida: identidades entre `lx`, `dx`, `qx`, `px`, `mx`, `Lx`, `ax`; monotonicidad y edades consistentes; validar sin ocultar datos incompatibles.
- Leyes de mortalidad: derivar `q_x=1-exp(-integral_x^(x+1) mu(s) ds)` a partir de una fuerza continua conocida; diferenciar esta integración de una hipótesis de interpolación fraccionaria.
- Contingencias: contrastar anualidades, seguros, primas y reservas con identidades exactas y referencias independientes (por ejemplo `lifecontingencies` cuando la parametrización coincida).
- Teoría del riesgo: especificaciones frecuencia/severidad, momentos, discretización, Panjer/FFT, colas, VaR/TVaR y stop-loss; documentar el tratamiento de masa residual y error numérico; contrastar `actuar` donde corresponda.
- Sensibilidad financiera: distinguir duración y convexidad según variable de derivación y tasa usada; probar inmunización ante perturbaciones de tasa.
- Multivida: explicitar supuestos de independencia y estado condicionante de cada valoración; no inferir el estado a partir de una única etiqueta sin comprobarlo.
- Simulación: controlar semillas y consistencia de outputs encadenados; preservar el estado RNG cuando el contrato lo exija.

## Auditoría pre-CRAN
- Orden sugerido: 1) `lifetable`, `mortality_law_table`, `e_xy` y tablas; 2) inmunización; 3) riesgo colectivo y coberturas; 4) reservas multivida y Monte Carlo; 5) documentación/CI/release.
- No dar por corregido un hallazgo solo por escribir código. Estados: confirmado, propuesto, implementado, probado, cerrado.
- Cada corrección requiere un test que falle antes y pase después cuando sea reproducible.
- No cambiar la rama principal ni hacer envío a CRAN sin autorización explícita.

## Entrega de cada hallazgo
- Presentar identidad o referencia matemática, causa raíz, diff mínimo, tests independientes, resultados observados e impacto sobre versiones anteriores.

