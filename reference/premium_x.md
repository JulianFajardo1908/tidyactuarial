# Net premium for single-life insurance by the equivalence principle

Computes the net benefit premium of a single-life insurance contract
from the equation of equivalence: \$\$
\operatorname{APV}(\text{premiums}) =
\operatorname{APV}(\text{benefits}). \$\$

## Usage

``` r
premium_x(
  lt,
  x,
  i,
  i_type = "effective",
  m = 1L,
  type = c("whole", "term", "endowment", "variable_k"),
  benefit = 1,
  n = Inf,
  h = 0L,
  k = 1L,
  frac = c("UDD", "CF", "CML", "Balducci"),
  timing = c("due", "immediate"),
  premium_start = c("issue", "deferred"),
  n_prem = NULL,
  woolhouse = c("none", "first", "second"),
  output = c("value", "summary", "audit"),
  tidy = NULL,
  check = TRUE,
  ...
)
```

## Arguments

- lt:

  A life table containing at least columns `x` and `lx`, or a
  single-life contract created with
  [`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md).

- x:

  Integer actuarial age at issue. Optional when `lt` is a single-life
  contract.

- i:

  Numeric scalar. Annual interest-rate input. Optional when `lt` is a
  single-life contract.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal interest-rate
  inputs.

- type:

  Insurance type. One of `"whole"`, `"term"`, `"endowment"`, or
  `"variable_k"`.

- benefit:

  Benefit amount. For standard products, a single nonnegative numeric
  value. For `type = "variable_k"`, a numeric vector or a function of
  time may be supplied.

- n:

  Insurance term in years. Use `Inf` for whole-life insurance.

- h:

  Nonnegative integer deferment period in years.

- k:

  Positive integer. Number of premium payments per year.

- frac:

  Fractional-age assumption. One of `"UDD"`, `"CF"`, `"CML"`, or
  `"Balducci"`.

- timing:

  Premium timing: `"due"` or `"immediate"`.

- premium_start:

  Start of premium payments: `"issue"` or `"deferred"`.

- n_prem:

  Premium-paying term in years. If finite, `n_prem * k` must be an
  integer.

- woolhouse:

  Woolhouse approximation order for the premium annuity: `"none"`,
  `"first"`, or `"second"`.

- output:

  Output level. `"value"` returns the annualized premium as a numeric
  scalar; `"summary"` returns a compact one-row executive summary;
  `"audit"` returns the components of the equivalence calculation in
  long format.

- tidy:

  Deprecated compatibility argument. `TRUE` maps to `output = "summary"`
  and `FALSE` maps to `output = "value"` when `output` is not supplied.

- check:

  Logical scalar. If `TRUE`, performs input validation.

- ...:

  Transitional compatibility for older calls using `mortality_table`,
  `age`, `rate`, `rate_type`, `insurance_type`, `term_years`,
  `deferral_years`, `payments_per_year`, `premium_timing`, and
  `premium_term_years`.

## Value

For `output = "value"`, a numeric scalar containing the annualized
premium \\P^{(k)}\\.

For `output = "summary"`, a one-row tibble with six columns: annualized
premium, premium per payment, payment frequency, APV of benefits, APV of
the premium annuity, and equivalence residual.

For `output = "audit"`, a long-format tibble containing the principal
inputs and calculated components.

## Details

For premiums payable \\k\\ times per year, the function distinguishes
between the annualized premium \\P^{(k)}\\ and the amount paid at each
installment, \\P^{(k)} / k\\.

Let \\Z\\ be the present-value random variable of benefits and let
\\Y^{(k)}\\ be the present-value random variable of a premium annuity
normalized to an annual payment rate of 1. The loss at issue is \$\$ L_0
= Z - P^{(k)}Y^{(k)}. \$\$

The equivalence principle, \\\operatorname{E}\[L_0\] = 0\\, gives \$\$
P^{(k)} = \frac{\operatorname{APV}(\text{benefits})}
{\operatorname{APV}(\text{premium annuity})}. \$\$

Because
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md)
values a k-thly annuity with payments of \\1/k\\, this quotient is the
annualized premium. The actual installment paid each fraction of the
year is \$\$ P\_{\text{per payment}} = \frac{P^{(k)}}{k}. \$\$

A contract assembled with pipes may be valued directly:


    life_contract(...) |>
      add_insurance(...) |>
      add_premium_schedule(...) |>
      premium_x(output = "summary")

Explicit arguments supplied to `premium_x()` override values stored in
the contract components.

## See also

[`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`add_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_variable_k`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`premium_gross`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`premium_gross()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md),
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
lt$lx[nrow(lt)] <- 0

# Direct calculation: annualized premium
premium_x(
  lt = lt,
  x = 40,
  i = 0.05,
  type = "term",
  benefit = 100000,
  n = 20,
  k = 12,
  n_prem = 10
)
#> [1] 5841.165

# Executive result with annualized and monthly premiums
premium_x(
  lt = lt,
  x = 40,
  i = 0.05,
  type = "term",
  benefit = 100000,
  n = 20,
  k = 12,
  n_prem = 10,
  output = "summary"
)
#> # A tibble: 1 × 6
#>   premium_annualized premium_per_payment payments_per_year apv_benefits
#>                <dbl>               <dbl>             <int>        <dbl>
#> 1              5841.                487.                12       39996.
#> # ℹ 2 more variables: apv_premium_annuity <dbl>, equivalence_residual <dbl>

# Contract assembled with pipes
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
  ) |>
  add_premium_schedule(
    k = 12,
    n_prem = 10,
    timing = "due"
  ) |>
  premium_x(output = "summary")
#> # A tibble: 1 × 6
#>   premium_annualized premium_per_payment payments_per_year apv_benefits
#>                <dbl>               <dbl>             <int>        <dbl>
#> 1              5841.                487.                12       39996.
#> # ℹ 2 more variables: apv_premium_annuity <dbl>, equivalence_residual <dbl>
```
