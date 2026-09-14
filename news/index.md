# Changelog

## tidyactuarial 0.1.6

CRAN release: 2026-07-27

### Bug fixes

- Fixed the construction of the cumulative distribution function used by
  [`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md)
  to prevent platform-dependent numerical failures when floating-point
  accumulation produces values slightly greater than one.

- Added a regression test for the multiple-life simulation workflow
  using
  [`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
  [`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
  and
  [`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md).

- This release addresses the errors reported by CRAN on macOS ARM64.

## tidyactuarial 0.1.5

CRAN release: 2026-07-27

- Fixed the multiple-life Monte Carlo workflow used in the
  [`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md)
  examples.
- [`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md)
  now constructs lifetime simulations defensively when mortality inputs
  contain invalid terminal values.
- [`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md)
  now uses defaults compatible with
  [`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md):
  `sim_id`, `life_id`, `Kx`, and `Tx`.
- Added a regression test for the full multiple-life simulation
  workflow.
