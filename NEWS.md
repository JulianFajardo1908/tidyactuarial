# tidyactuarial 0.2.0

## Bug fixes

* Corrected complete `e_xy(..., cohort = "last")` calculations to preserve
  conditioning on both lives being alive at the initial ages. Annual
  integration now uses survival from those original ages, including paths
  with only one survivor, instead of restarting both lives each year.
  Adaptive quadrature replaces the fixed trapezoid grid for both cohorts.
  Missing initial ages and zero initial survivors return `NA` consistently.
* `t_px()` now obtains integer survival directly from `lx`, including at
  the last recorded age, without requiring a next-year probability.
  An extinct attained cohort has zero survival even when its fractional
  probability is undefined. This also prevents spurious `NA` in `e_xy()`.

* Corrected `mortality_law_table("HeligmanPollard", ...)` to the classical
  eight-parameter odds model. `H` is now required; `C` is the childhood
  exponent, `D`/`E`/`F_hp` describe the accident hump, and `G`/`H` describe
  old-age mortality. Previous seven-parameter calls must be respecified;
  adding `H` to the old values is insufficient. The existing `F` alias
  denotes the same parameter as `F_hp`. Log-space evaluation avoids
  undefined probabilities when odds overflow.
* Beta-law conditional probabilities now use log upper-tail survival,
  avoiding premature `qx = 1` when survival is small.
* Mortality-law tables now compute `mx = dx / Lx` and `ex = Tx / lx`
  without artificial denominator floors. Zero-exposure positive deaths
  give `Inf`; undefined `0/0` ratios for extinct cohorts give `NaN`.

* `mortality_law_table()` now derives annual death probabilities from the
  integrated continuous force of mortality, independently of `frac`.
  This changes Gompertz, Makeham, Weibull and Logistic results and the former
  UDD/Balducci conversions. `mu_x` remains the force at integer age;
  `a_x` still controls the exposure approximation. Direct `qx` laws and
  forced terminal closure retain their existing behavior.

* Corrected `lifetable()` conversions between `mx` and `qx` for `ax != 0.5`,
  using the mean fraction of the year lived by those who die. This correction
  can change previous actuarial results; results for `ax = 0.5` are preserved.

# tidyactuarial 0.1.6

## Bug fixes

* Fixed the construction of the cumulative distribution function used by
  `simulate_lifetime()` to prevent platform-dependent numerical failures
  when floating-point accumulation produces values slightly greater than one.

* Added a regression test for the multiple-life simulation workflow using
  `simulate_lifetimes()`, `mc_multilife_status()`, and `mc_annuity()`.

* This release addresses the errors reported by CRAN on macOS ARM64.

# tidyactuarial 0.1.5

* Fixed the multiple-life Monte Carlo workflow used in the `mc_annuity()` examples.
* `simulate_lifetimes()` now constructs lifetime simulations defensively when mortality inputs contain invalid terminal values.
* `mc_multilife_status()` now uses defaults compatible with `simulate_lifetimes()`: `sim_id`, `life_id`, `Kx`, and `Tx`.
* Added a regression test for the full multiple-life simulation workflow.
