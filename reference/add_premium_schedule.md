# Add a contingent premium-payment schedule to a life contract

Adds the premium-payment side of a single-life or two-life insurance
contract. The schedule defines when premiums are payable while the
selected life status is in force. This function stores the specification
only.

## Usage

``` r
add_premium_schedule(
  contract,
  k = 1L,
  timing = c("due", "immediate"),
  premium_start = c("issue", "deferred"),
  n_prem = NULL,
  woolhouse = c("none", "first", "second"),
  frac = NULL
)
```

## Arguments

- contract:

  A \`tidyact_life_contract\` object.

- k:

  Positive integer. Number of premium payments per year.

- timing:

  Timing of premium payments: \`"due"\` or \`"immediate"\`.

- premium_start:

  Start of premium payments: \`"issue"\` or \`"deferred"\`.

- n_prem:

  Premium-paying term in years. Use \`NULL\` to infer the term from the
  insurance component. A fractional value is allowed when \`n_prem \*
  k\` is an integer.

- woolhouse:

  Woolhouse approximation order: \`"none"\`, \`"first"\`, or
  \`"second"\`.

- frac:

  Fractional-age assumption. If \`NULL\`, the insurance component's
  assumption is used when available; otherwise \`"UDD"\`.

## Value

The original contract with a \`premium_schedule\` component.

## Details

The fractional-age assumption is resolved when this component is added:
later replacement of the insurance component does not change this stored
assumption. \`n_prem = NULL\` remains unresolved until valuation. Finite
schedules must contain a finite, positive whole number of payments.
Large integer-valued frequencies are stored as doubles when needed.

## See also

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`premium_gross()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md),
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md),
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)
