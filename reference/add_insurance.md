# Add an insurance benefit specification to a life contract

Adds the benefit side of a single-life insurance contract to an existing
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md)
object. This function stores the specification only; it does not
calculate an actuarial present value.

Adds the benefit side of a single-life or two-life insurance contract to
an existing
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md)
object. This function stores the specification only; it does not
calculate an actuarial present value.

## Usage

``` r
add_insurance(
  contract,
  type = c("whole", "term", "endowment", "pure_endowment", "variable_k"),
  benefit = 1,
  n = Inf,
  h = 0L,
  k = 1L,
  frac = c("UDD", "CF", "CML", "Balducci")
)

add_insurance(
  contract,
  type = c("whole", "term", "endowment", "pure_endowment", "variable_k"),
  benefit = 1,
  n = Inf,
  h = 0L,
  k = 1L,
  frac = c("UDD", "CF", "CML", "Balducci")
)
```

## Arguments

- contract:

  A `tidyact_life_contract` object.

- type:

  Insurance type. Single-life contracts support `"whole"`, `"term"`,
  `"endowment"`, and `"variable_k"`. Two-life contracts support
  `"whole"`, `"term"`, `"endowment"`, and `"pure_endowment"`.

- benefit:

  Benefit amount. For standard products, a single nonnegative numeric
  value. For single-life `type = "variable_k"`, a numeric vector or a
  function of time may be supplied.

- n:

  Insurance term in years. Use `Inf` for whole-life insurance.

- h:

  Nonnegative integer deferment period in years.

- k:

  Positive integer. Benefit frequency for single-life
  `type = "variable_k"`.

- frac:

  Fractional-age assumption: `"UDD"`, `"CF"`, `"CML"`, or `"Balducci"`.

## Value

The original contract with an `insurance` component.

The original contract with an `insurance` component.

## Details

For two-life contracts, the insurance status is inferred from
`contract$lives`: `"joint"` becomes joint-life status and
`"last_survivor"` becomes last-survivor status.

## See also

Other life-contingencies:
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
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

Other life-contingencies:
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
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

## Examples

``` r
lt <- data.frame(
  x = 40:90,
  lx = round(100000 * exp(-0.018 * (0:50)^1.35))
)

life_contract(
  lt = lt,
  lives = "single",
  x = 40,
  i = 0.05
) |>
  add_insurance(
    type = "term",
    benefit = 100000,
    n = 20
  )
#> <tidyact_life_contract>
#>   lives:  single
#>   x:      40
#>   i:      0.05
#>   i_type: effective
#>   m:      1
#>   tables: 1
```
