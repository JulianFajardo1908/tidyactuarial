# Net premium for two-life insurance by the equivalence principle

Computes the net benefit premium for a joint-life or last-survivor
insurance contract.

## Usage

``` r
premium_xy(
  lt,
  x = NULL,
  y = NULL,
  i = NULL,
  i_type = "effective",
  m = 1L,
  type = c("whole", "term", "endowment", "pure_endowment"),
  benefit = 1,
  n = Inf,
  h = 0L,
  k = 1L,
  frac = c("UDD", "CF", "CML", "Balducci"),
  timing = c("due", "immediate"),
  premium_start = c("issue", "deferred"),
  n_prem = NULL,
  status = c("joint", "last"),
  woolhouse = c("none", "first", "second"),
  output = c("value", "summary", "audit", "table"),
  tidy = NULL,
  check = TRUE,
  tol = 1e-10,
  ...
)
```

## Arguments

- lt:

  A life table, a list of two life tables `list(lt_x, lt_y)`, or a
  two-life contract created with
  [`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md).

- x:

  Integer actuarial age for the first life. Optional for a
  `life_contract`.

- y:

  Integer actuarial age for the second life. Optional for a
  `life_contract`.

- i:

  Numeric scalar. Annual interest-rate input. Optional for a
  `life_contract`.

- i_type:

  Interest-rate type: `"effective"`, `"nominal_interest"`,
  `"nominal_discount"`, or `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates.

- type:

  Insurance type: `"whole"`, `"term"`, `"endowment"`, or
  `"pure_endowment"`.

- benefit:

  Nonnegative insurance benefit.

- n:

  Insurance term in years after deferment. Use `Inf` for whole-life
  insurance.

- h:

  Nonnegative integer deferment period in years.

- k:

  Positive integer. Number of premium payments per year.

- frac:

  Fractional-age assumption: `"UDD"`, `"CF"`, `"CML"`, or `"Balducci"`.

- timing:

  Premium timing: `"due"` or `"immediate"`.

- premium_start:

  Start of premiums: `"issue"` or `"deferred"`.

- n_prem:

  Premium-paying term in years. A fractional value is permitted when
  `n_prem * k` is an integer.

- status:

  Two-life status: `"joint"` or `"last"`. For a `life_contract`, the
  value is inferred from `lives` unless supplied explicitly.

- woolhouse:

  Woolhouse approximation order for the premium annuity: `"none"`,
  `"first"`, or `"second"`.

- output:

  Output level. `"value"` returns the annualized premium; `"summary"`
  returns a compact one-row result; `"audit"` returns the equivalence
  components in long format. `"table"` is accepted as a deprecated alias
  for `"summary"`.

- tidy:

  Deprecated compatibility argument. `TRUE` maps to `output = "summary"`
  and `FALSE` to `output = "value"`.

- check:

  Logical scalar. If `TRUE`, validates inputs.

- tol:

  Numeric tolerance for integer-grid checks.

- ...:

  Transitional compatibility for older calls using `mortality_table`,
  `age_x`, `age_y`, `rate`, `rate_type`, `insurance_type`, `term_years`,
  `deferment_years`, `payments_per_year`, `premium_timing`,
  `premium_term_years`, and `cohort`.

## Value

For `output = "value"`, a numeric scalar containing the annualized
premium \\P^{(k)}\\.

For `output = "summary"`, a one-row tibble with six columns: annualized
premium, premium per payment, payment frequency, APV of benefits, APV of
the premium annuity, and equivalence residual.

For `output = "audit"`, a long-format tibble.

## Details

For premiums payable \\k\\ times per year, the function distinguishes
between the annualized premium \\P^{(k)}\\ and the amount paid at each
installment, \\P^{(k)} / k\\.

Let \\Z\\ denote the present-value random variable of the two-life
insurance benefit and let \\Y^{(k)}\\ denote the present value of the
contingent premium annuity normalized to an annual payment rate of 1.
The loss at issue is \$\$ L_0 = Z - P^{(k)}Y^{(k)}. \$\$

The equivalence principle gives \$\$ P^{(k)} =
\frac{\operatorname{APV}(\text{benefits})}
{\operatorname{APV}(\text{premium annuity})}. \$\$

Since
[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md)
assigns amount \\1/k\\ to each k-thly payment, this quotient is the
annualized premium. The installment is \$\$ P\_{\text{per payment}} =
\frac{P^{(k)}}{k}. \$\$

Standard whole-life, term, and endowment benefits are valued through
[`insurance_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md).
A pure endowment is obtained as the difference between the corresponding
endowment and term insurance values.

A contract assembled with pipes may be valued directly:


    life_contract(...) |>
      add_insurance(...) |>
      add_premium_schedule(...) |>
      premium_xy(output = "summary")

Explicit arguments supplied to `premium_xy()` override values stored in
the contract components.

## See also

[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`insurance_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`reserve_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
[`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`add_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md)

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
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md),
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)

## Examples

``` r
lt <- data.frame(
  x = 40:100,
  lx = round(100000 * exp(-0.012 * (0:60)^1.35))
)
lt$lx[nrow(lt)] <- 0

premium_xy(
  lt = lt,
  x = 60,
  y = 62,
  i = 0.05,
  type = "term",
  status = "joint",
  benefit = 100000,
  n = 20,
  k = 12,
  n_prem = 10,
  output = "summary"
)
#> # A tibble: 1 × 6
#>   premium_annualized premium_per_payment payments_per_year apv_benefits
#>                <dbl>               <dbl>             <int>        <dbl>
#> 1             11955.                996.                12       63020.
#> # ℹ 2 more variables: apv_premium_annuity <dbl>, equivalence_residual <dbl>

life_contract(
  lt = lt,
  lives = "joint",
  x = 60,
  y = 62,
  i = 0.05
) |>
  add_insurance(
    type = "term",
    benefit = 100000,
    n = 20
  ) |>
  add_premium_schedule(
    k = 12,
    n_prem = 10
  ) |>
  premium_xy(output = "summary")
#> # A tibble: 1 × 6
#>   premium_annualized premium_per_payment payments_per_year apv_benefits
#>                <dbl>               <dbl>             <int>        <dbl>
#> 1             11955.                996.                12       63020.
#> # ℹ 2 more variables: apv_premium_annuity <dbl>, equivalence_residual <dbl>
```
