# Barrido temático integral — objetivo 0.2.0

Acuerdo explícito: objetivo **0.2.0**; evaluar **1.0.0 al cerrar el barrido**.
La versión de desarrollo continúa en `0.1.6.9000`. El manual es provisional.
El barrido amplía la auditoría anterior y conserva todos sus hallazgos.

## Método

Por función: modelo, supuestos, identidades independientes, dominio, extremos,
precisión, NA y RNG; contrato público, claridad docente y mantenimiento. Helpers
y métodos S3 se revisan con sus consumidores. Cada corrección requiere fallo
previo y prueba posterior. Estados: confirmado, propuesto, implementado, probado
y cerrado. Las mejoras deben aportar valor verificable; no se añaden funciones
por cantidad ni se uniforman convenciones diferentes sin estudiar su impacto.
Las decisiones materiales de API se consultan antes de implementarse.

## Bloques

| Bloque | Tema | Nombres públicos | Estado |
|---|---|---:|---|
| B01 | Tasas y factores financieros | 5 | En revisión; ver audit-interest-foundations.md |
| B02 | Flujos y ecuaciones de valor | 8 | En revisión; ver audit-cash-flow-roots.md y audit-interest-foundations.md |
| B03 | Anualidades financieras y préstamos | 7 | Pendiente de revisión integral; preservar evidencia previa |
| B04 | Bonos, curvas, sensibilidad e inmunización | 20 | Pendiente de revisión integral; preservar evidencia previa |
| B05 | Tablas, mortalidad y probabilidades | 12 | Pendiente de revisión integral; preservar evidencia previa |
| B06 | Contingencias de una vida y contratos | 13 | Pendiente de revisión integral; preservar evidencia previa |
| B07 | Contingencias multivida | 6 | Pendiente de revisión integral; preservar evidencia previa |
| B08 | Simulación de vidas y Monte Carlo | 11 | Pendiente de revisión integral; preservar evidencia previa |
| B09 | Riesgo colectivo, coberturas y colas | 19 | Pendiente de revisión integral; preservar evidencia previa |

101 nombres asignados exactamente una vez: 100 funciones y el alias A_xj.
B01 se inicia por su uso transversal. La existencia de correcciones previas
en otros bloques no implica su cierre integral. La CI aprobada anteriormente
corresponde al código previo a las nuevas correcciones B01.

## Inventario completo

Las llamadas directas en tests se detectan estáticamente. Su presencia no
demuestra cobertura de ramas ni incluye llamadas indirectas.

| Bloque | Nombre | Fuente | Tests con llamada directa |
|---|---|---|---|
| B01 | `accumulation_factor` | `R/s_angle.R` | `test-accumulation_factor.R`, `test-interest-audit-regressions.R`, `test-interest-log-basis.R` |
| B01 | `discount_factor` | `R/mc_reserve.R` | `test-discount_factor.R`, `test-interest-audit-regressions.R`, `test-interest-log-basis.R` |
| B01 | `discount_factor_spot` | `R/discount_factor_spot.R` | `test-discount-factor-spot-finance.R`, `test-discount_factor.R`, `test-interest-audit-regressions.R`, `test-par-rate.R` |
| B01 | `interest_equivalents` | `R/interest_equivalents.R` | `test-interest-audit-regressions.R`, `test-interest-conversions.R`, `test-interest-log-basis.R` |
| B01 | `standardize_interest` | `R/standardize_interest.R` | `test-flow-valuation.R`, `test-interest-audit-regressions.R`, `test-interest-conversions.R`, `test-time-value-basics.R` |
| B02 | `future_value` | `R/s_angle.R` | `test-interest-log-basis.R`, `test-time-value-basics.R` |
| B02 | `fv_flow` | `R/fv_flow.R` | `test-flow-valuation.R`, `test-interest-log-basis.R` |
| B02 | `irr_flow` | `R/irr_flow.R` | `test-irr-flow.R`, `test-irr-scale-regressions.R` |
| B02 | `irr_flow_multi` | `R/irr_flow_multi.R` | `test-irr-flow.R`, `test-irr-scale-regressions.R` |
| B02 | `plot_cash_flow` | `R/plot_cash_flow.R` | `test-plot_cash_flow.R` |
| B02 | `present_value` | `R/simulate_life_mc.R` | `test-interest-log-basis.R`, `test-time-value-basics.R` |
| B02 | `pv_flow` | `R/pv_flow.R` | `test-flow-valuation.R`, `test-interest-log-basis.R` |
| B02 | `solve_value` | `R/solve_value_v3.R` | `test-solve-value-grid-roots.R`, `test-solve_value_v2.R` |
| B03 | `a_angle` | `R/a_angle.R` | `test-annuity-level-finance.R`, `test-solve_value_v2.R` |
| B03 | `amort_schedule` | `R/amort_schedule.R` | `test-amort_schedule_general.R`, `test-loan-schedules-finance.R` |
| B03 | `amort_schedule_general` | `R/amort_schedule_general.R` | `test-amort_schedule_general.R` |
| B03 | `annuity_arith` | `R/annuity_arith.R` | `test-annuity-varying-finance.R` |
| B03 | `annuity_geom` | `R/annuity_geom.R` | `test-annuity-varying-finance.R` |
| B03 | `s_angle` | `R/s_angle.R` | `test-annuity-level-finance.R` |
| B03 | `sinking_fund_schedule` | `R/sinking_fund_schedule.R` | `test-loan-schedules-finance.R` |
| B04 | `accrued_interest` | `R/accrued_interest.R` | `test-accrued-interest.R` |
| B04 | `bond_book_value` | `R/bond_book_value.R` | `test-bond-book-callable-finance.R` |
| B04 | `bond_callable_price` | `R/bond_callable_price.R` | `test-bond-book-callable-finance.R` |
| B04 | `bond_cash_flows` | `R/bond_cash_flow.R` | `test-accrued-interest.R`, `test-bond-pricing-finance.R`, `test-bootstrap-spot-curve.R`, `test-immunization-regressions.R`, `test-par-rate.R` |
| B04 | `bond_convexity` | `R/bond_convexity.R` | `test-bond-risk-finance.R`, `test-immunization-regressions.R` |
| B04 | `bond_duration` | `R/bond_duration.R` | `test-bond-risk-finance.R`, `test-immunization-regressions.R` |
| B04 | `bond_price` | `R/bond_price.R` | `test-bond-pricing-finance.R` |
| B04 | `bond_ytm` | `R/bond_ytm.R` | `test-bond-pricing-finance.R` |
| B04 | `bootstrap_spot_curve` | `R/bootstrap_spot_curve.R` | `test-bootstrap-spot-curve.R`, `test-forward-curve.R`, `test-par-rate.R` |
| B04 | `convexity_cash_flow` | `R/convexity_cash_flow.R` | `test-convexity_cash_flow.R`, `test-immunization-regressions.R`, `test-plot_cash_flow.R` |
| B04 | `duration_cash_flow` | `R/duration_cash_flow.R` | `test-convexity_cash_flow.R`, `test-duration_cash_flow.R` |
| B04 | `forward_curve` | `R/forward_curve.R` | `test-forward-curve.R` |
| B04 | `forward_rate` | `R/forward_rate.R` | `test-bootstrap-spot-curve.R`, `test-forward-curve.R`, `test-forward-rate-finance.R` |
| B04 | `immunize_duration` | `R/inmunize_duration.R` | `test-immunization-finance.R`, `test-immunization-regressions.R` |
| B04 | `immunize_duration_convexity` | `R/inmunize_duration_convexity.R` | `test-immunization-finance.R`, `test-immunization-regressions.R` |
| B04 | `par_rate` | `R/par_rate.R` | `test-par-rate.R` |
| B04 | `plot_immunization_gap` | `R/plot_inmunization_gap.R` | `test-immunization-finance.R` |
| B04 | `portfolio_convexity` | `R/portfolio_convexity.R` | `test-portfolio-risk-finance.R` |
| B04 | `portfolio_duration` | `R/portfolio_duration.R` | `test-portfolio-risk-finance.R` |
| B04 | `yield_curve` | `R/yield_curve.R` | `test-bootstrap-spot-curve.R`, `test-forward-curve.R`, `test-par-rate.R`, `test-yield-curve-finance.R` |
| B05 | `commutation_table` | `R/conmutation_table.R` | `test-commutation-table.R` |
| B05 | `e_x` | `R/e_x.R` | `test-e-xy-regressions.R`, `test-life-expectancy-endowment.R`, `test-lifetable-ax.R`, `test-multilife-survival-expectancy.R` |
| B05 | `km_lifetable` | `R/km_lifetable.R` | `test-kaplan-meier-actuarial.R`, `test-plot-km.R` |
| B05 | `lifetable` | `R/lifetable.R` | `test-annuity-multi-actuarial.R`, `test-annuity-xy-state-benefits.R`, `test-commutation-table.R`, `test-e-xy-regressions.R`, `test-final-public-integration.R`, `test-insurance-variable-k-actuarial.R`, `test-insurance-xy-identities.R`, `test-life-expectancy-endowment.R`, `test-lifetable-ax.R`, `test-lifetable-core.R`, `test-multilife-survival-expectancy.R`, `test-survival-death-probabilities.R` |
| B05 | `lt_tau` | `R/lt_tau.R` | `test-multiple-decrement-probabilities.R` |
| B05 | `md_table` | `R/md_table.R` | `test-final-public-integration.R`, `test-insurance-xj-actuarial.R`, `test-multiple-decrement-probabilities.R`, `test-multiple-decrement-table.R` |
| B05 | `mortality_law_table` | `R/mortality_law_table.R` | `test-mortality-integrated-force.R`, `test-mortality-law-regressions.R`, `test-mortality-laws-actuarial.R`, `test-smoke.R` |
| B05 | `plot_km` | `R/plot_km.R` | `test-plot-km.R` |
| B05 | `t_Ex` | `R/t_Ex.R` | `test-life-expectancy-endowment.R` |
| B05 | `t_px` | `R/t_px.R` | `test-annuity-multi-actuarial.R`, `test-annuity-xy-state-benefits.R`, `test-annuity_xy-v2.R`, `test-e-xy-regressions.R`, `test-lifetable-ax.R`, `test-multilife-survival-expectancy.R`, `test-multiple-decrement-probabilities.R`, `test-survival-death-probabilities.R` |
| B05 | `t_qx` | `R/t_qx.R` | `test-survival-death-probabilities.R` |
| B05 | `t_qxj` | `R/t_qxj.R` | `test-multiple-decrement-probabilities.R` |
| B06 | `A_xj` | `R/insurance_xj.R` | `test-final-public-integration.R` |
| B06 | `add_insurance` | `R/contract_components.R` | `test-contract-components-consolidation.R`, `test-contract_components-xy.R`, `test-premium_gross-v2.R`, `test-premium_x-v2.R`, `test-premium_xy-v2.R`, `test-reserve_x-v2.R`, `test-reserve_xy-two-tables.R`, `test-reserve_xy-v2.R` |
| B06 | `add_premium_schedule` | `R/contract_components.R` | `test-contract-components-consolidation.R`, `test-contract_components-xy.R`, `test-premium_gross-v2.R`, `test-premium_x-v2.R`, `test-premium_xy-v2.R`, `test-reserve_x-v2.R`, `test-reserve_xy-two-tables.R`, `test-reserve_xy-v2.R` |
| B06 | `annuity_multi` | `R/annuity_multi.R` | `test-annuity-multi-actuarial.R` |
| B06 | `annuity_x` | `R/annuity_x.R` | `test-annuity_x-fractional.R`, `test-annuity_x.R`, `test-lifetable-ax.R`, `test-premium_x-v2.R`, `test-reserve_x-v2.R`, `test-soa08lt.R` |
| B06 | `apv_life_flow` | `R/apv_life_flow.R` | `test-apv-life-flow-actuarial.R` |
| B06 | `insurance_variable_k` | `R/insurance_variable_k.R` | `test-insurance-variable-k-actuarial.R` |
| B06 | `insurance_x` | `R/insurance_x.R` | `test-lifetable-ax.R`, `test-premium_x-v2.R`, `test-reserve_x-v2.R`, `test-soa08lt.R` |
| B06 | `insurance_xj` | `R/insurance_xj.R` | `test-final-public-integration.R`, `test-insurance-xj-actuarial.R` |
| B06 | `life_contract` | `R/life_contract.R` | `test-annuity_x.R`, `test-annuity_xy-v2.R`, `test-contract-components-consolidation.R`, `test-contract_components-xy.R`, `test-life_contract.R`, `test-premium_gross-v2.R`, `test-premium_x-v2.R`, `test-premium_xy-v2.R`, `test-reserve_x-v2.R`, `test-reserve_xy-two-tables.R`, `test-reserve_xy-v2.R` |
| B06 | `premium_gross` | `R/premium_gross.R` | `test-premium_gross-v2.R` |
| B06 | `premium_x` | `R/premium_x.R` | `test-lifetable-ax.R`, `test-premium_gross-v2.R`, `test-premium_x-v2.R`, `test-reserve_x-v2.R` |
| B06 | `reserve_x` | `R/reserve_x.R` | `test-reserve_x-v2.R` |
| B07 | `annuity_xy` | `R/annuity_xy.R` | `test-annuity-multi-actuarial.R`, `test-annuity-xy-state-benefits.R`, `test-annuity_xy-v2.R`, `test-insurance-xy-identities.R`, `test-premium_xy-v2.R`, `test-reserve_xy-v2.R`, `test-soa08lt.R` |
| B07 | `e_xy` | `R/e_xy.R` | `test-e-xy-regressions.R`, `test-multilife-survival-expectancy.R` |
| B07 | `insurance_xy` | `R/insurance_xy.R` | `test-insurance-xy-deferred-conditioning.R`, `test-insurance-xy-identities.R`, `test-premium_xy-v2.R`, `test-reserve_xy-v2.R` |
| B07 | `premium_xy` | `R/premium_xy.R` | `test-premium_gross-v2.R`, `test-premium_xy-v2.R`, `test-reserve_xy-v2.R`, `test-smoke.R` |
| B07 | `reserve_xy` | `R/reserve_xy.R` | `test-reserve-xy-state-regressions.R`, `test-reserve_xy-two-tables.R`, `test-reserve_xy-v2.R` |
| B07 | `t_pxy` | `R/t_pxy.R` | `test-insurance-xy-identities.R`, `test-multilife-survival-expectancy.R` |
| B08 | `mc_annuity` | `R/mc_annuity.R` | `test-cran-multilife-workflow.R`, `test-mc-lifetime-consistency.R`, `test-mc_annuity-v2.R` |
| B08 | `mc_insurance` | `R/mc_insurance.R` | `test-mc-lifetime-consistency.R`, `test-mc_insurance-v2.R` |
| B08 | `mc_loss` | `R/mc_loss.R` | `test-mc_loss-v2.R`, `test-mc_premium-v2.R` |
| B08 | `mc_multilife_status` | `R/mc_multilife_status.R` | `test-cran-multilife-workflow.R`, `test-mc_multilife_status-v2.R` |
| B08 | `mc_premium` | `R/mc_premium.R` | `test-mc_premium-v2.R` |
| B08 | `mc_reserve` | `R/mc_reserve.R` | `test-mc-lifetime-consistency.R`, `test-mc_annuity-v2.R`, `test-mc_reserve_v2.R` |
| B08 | `simulate_annuity_x` | `R/simulate_life_mc.R` | `test-final-public-integration.R`, `test-simulate_life_mc-v2.R` |
| B08 | `simulate_insurance_x` | `R/simulate_life_mc.R` | `test-final-public-integration.R`, `test-simulate_life_mc-v2.R` |
| B08 | `simulate_lifetime` | `R/simulate_lifetime.R` | `test-cran-multilife-workflow.R`, `test-simulate_lifetime-v2.R` |
| B08 | `simulate_lifetimes` | `R/simulate_lifetimes.R` | `test-cran-multilife-workflow.R`, `test-simulate_lifetimes-v2.R` |
| B08 | `summary_mc` | `R/summary_mc.R` | `test-final-public-integration.R`, `test-summary-mc-final.R`, `test-summary-mc-tvar-regression.R` |
| B09 | `aggregate_distribution` | `R/aggregate-distribution.R` | `test-aggregate-distribution.R`, `test-risk-audit-regressions.R`, `test-to-payment-basis.R`, `test-value-at-risk.R` |
| B09 | `aggregate_moments` | `R/aggregate-moments.R` | `test-aggregate-distribution.R`, `test-aggregate-moments.R`, `test-simulate-aggregate.R`, `test-to-payment-basis.R` |
| B09 | `apply_coverage` | `R/apply_coverage.R` | `test-apply-coverage.R`, `test-risk-audit-regressions.R`, `test-simulate-aggregate.R`, `test-simulate-severity.R`, `test-stop-loss-premium.R`, `test-tail-value-at-risk.R`, `test-to-payment-basis.R` |
| B09 | `collective_risk_spec` | `R/collective-risk-spec.R` | `test-aggregate-distribution.R`, `test-aggregate-moments.R`, `test-apply-coverage.R`, `test-collective-risk-spec.R`, `test-risk-audit-regressions.R`, `test-simulate-aggregate.R`, `test-to-payment-basis.R`, `test-value-at-risk.R` |
| B09 | `coverage_spec` | `R/coverage_spec.R` | `test-apply-coverage.R`, `test-coverage-spec.R`, `test-risk-audit-regressions.R`, `test-simulate-aggregate.R`, `test-simulate-severity.R`, `test-stop-loss-premium.R`, `test-tail-value-at-risk.R`, `test-to-payment-basis.R` |
| B09 | `discretize_severity` | `R/discretize-severity.R` | `test-aggregate-distribution.R`, `test-discretize-severity.R` |
| B09 | `distribution_convolution` | `R/distribution-convolution.R` | `test-distribution-convolution.R` |
| B09 | `distribution_moments` | `R/distribution_moments.R` | `test-aggregate-moments.R`, `test-apply-coverage.R`, `test-discretize-severity.R`, `test-distribution-moments.R`, `test-to-payment-basis.R` |
| B09 | `empirical_frequency` | `R/empirical-frequency.R` | `test-aggregate-distribution.R`, `test-aggregate-moments.R`, `test-collective-risk-spec.R`, `test-distribution-moments.R`, `test-empirical-frequency.R`, `test-simulate-frequency.R`, `test-to-payment-basis.R` |
| B09 | `empirical_severity` | `R/empirical-severity.R` | `test-aggregate-moments.R`, `test-collective-risk-spec.R`, `test-discretize-severity.R`, `test-distribution-moments.R`, `test-empirical-severity.R`, `test-simulate-severity.R` |
| B09 | `frequency_spec` | `R/frequency-spec.R` | `test-aggregate-distribution.R`, `test-aggregate-moments.R`, `test-apply-coverage.R`, `test-collective-risk-spec.R`, `test-discretize-severity.R`, `test-distribution-convolution.R`, `test-distribution-moments.R`, `test-frequency-spec.R`, `test-risk-audit-regressions.R`, `test-simulate-aggregate.R`, `test-simulate-frequency.R`, `test-to-payment-basis.R`, `test-value-at-risk.R` |
| B09 | `severity_spec` | `R/severity-spec.R` | `test-aggregate-distribution.R`, `test-aggregate-moments.R`, `test-apply-coverage.R`, `test-collective-risk-spec.R`, `test-discretize-severity.R`, `test-distribution-convolution.R`, `test-distribution-moments.R`, `test-risk-audit-regressions.R`, `test-severity-spec.R`, `test-simulate-aggregate.R`, `test-simulate-severity.R`, `test-stop-loss-premium.R`, `test-tail-value-at-risk.R`, `test-to-payment-basis.R`, `test-value-at-risk.R` |
| B09 | `simulate_aggregate` | `R/simulate_aggregate.R` | `test-simulate-aggregate.R`, `test-value-at-risk.R` |
| B09 | `simulate_frequency` | `R/simulate_frequency.R` | `test-simulate-frequency.R` |
| B09 | `simulate_severity` | `R/simulate_severity.R` | `test-simulate-severity.R` |
| B09 | `stop_loss_premium` | `R/stop_loss_premium.R` | `test-risk-audit-regressions.R`, `test-stop-loss-premium.R` |
| B09 | `tail_value_at_risk` | `R/tail_value_at_risk.R` | `test-risk-audit-regressions.R`, `test-summary-mc-tvar-regression.R`, `test-tail-value-at-risk.R` |
| B09 | `to_payment_basis` | `R/to_payment_basis.R` | `test-simulate-aggregate.R`, `test-to-payment-basis.R` |
| B09 | `value_at_risk` | `R/value_at_risk.R` | `test-summary-mc-tvar-regression.R`, `test-value-at-risk.R` |

## Criterios para considerar 1.0.0

- Todos los bloques revisados, con evidencia y pendientes explícitos.
- API y convenciones defendibles; incompatibilidades documentadas.
- Identidades y extremos materiales contrastados de forma independiente.
- Flujos docentes reproducibles y documentación consistente.
- Revalidación local y CI sobre el código final.
- Decisión expresa del usuario al cerrar el barrido. El número de cambios
  o funciones no determina por sí solo una versión 1.0.0.
