# Actuarial present value of a two-life insurance

Computes the actuarial present value of a discrete two-life insurance
with benefit payable at the end of the year of the triggering death,
assuming independent future lifetimes and using compact actuarial
notation.

## Usage

``` r
insurance_xy(
  lt,
  x = NULL,
  y = NULL,
  i = NULL,
  i_type = "effective",
  m = 1L,
  type = c("whole", "term", "endowment"),
  status = c("joint", "last"),
  n = Inf,
  h = 0L,
  benefit = 1,
  frac,
  tidy = FALSE,
  ...
)
```

## Arguments

- lt:

  A life table, a list of two life tables `list(lt_x, lt_y)`, or a
  `tidyact_life_contract` object created by
  [`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md).
  Each life table must contain columns `x` and `lx`.

- x:

  Integer actuarial age for the first life.

- y:

  Integer actuarial age for the second life.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

- type:

  Character string. One of `"whole"`, `"term"`, or `"endowment"`.

- status:

  Character string. Use `"joint"` for first-death insurance or `"last"`
  for second-death insurance.

- n:

  Term in years. Required as finite for term and endowment insurance.
  Use `Inf` for whole-life insurance.

- h:

  Nonnegative integer deferment period in years.

- benefit:

  Numeric scalar. Insurance benefit.

- frac:

  Fractional-age assumption used in two-life survival probabilities. One
  of `"UDD"`, `"CF"`, `"CML"`, or `"Balducci"`.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric APV. If `TRUE`, returns
  a one-row tibble.

- ...:

  Transitional compatibility for older calls using `mortality_table`,
  `age_x`, `age_y`, `rate`, `rate_type`, `insurance_type`, `cohort`,
  `term_years`, `deferment_years`, and `output`.

## Value

If `tidy = FALSE`, a numeric scalar.

If `tidy = TRUE`, a one-row tibble with input values, standardized
interest rate, deferment factor, unit APV, and APV.

## Details

Supported contracts:

- `"whole"`: whole-life two-life insurance.

- `"term"`: n-year two-life term insurance.

- `"endowment"`: n-year two-life endowment insurance.

The `status` argument determines the two-life status:

- `status = "joint"`: first-death insurance, based on the joint-life
  status.

- `status = "last"`: second-death insurance, based on the last-survivor
  status.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `lt` is the life table input, `x` and `y` are the two
actuarial ages, `i` is the interest-rate input, `i_type` is the
interest-rate type, `m` is the conversion frequency for nominal rates,
`n` is the insurance term, and `h` is the deferment period.

Both lives are alive at issue (state 11). Internal states 10 and 01 mean
only x or only y is alive; 00 is absorbing. The API does not take an
observed single-survivor initial state. In a joint-life contract,
leaving 11 triggers the first-death benefit once. A last-survivor
contract continues through 10 or 01 and pays on entering 00. Both deaths
within one annual interval trigger one benefit, payable at the end of
that year.

Valuation sums discounted annual transition masses from the issue ages;
it does not subtract rounded annuity values. With marginal survival Sx,
Sy, cumulative death Qx, Qy, and interval death masses Dx, Dy, the
first-death mass in (t,t+1\] is Dx(t) Sy(t) + Sx(t+1) Dy(t); the
second-death mass is Dx(t) Qy(t) + Qx(t) Dy(t) + Dx(t) Dy(t). Counts
supply the decrements directly. Original log interest and monetary
amounts are combined before exponentiating when necessary. The annual
payment model is independent of fractional interpolation; frac is
retained as an audit assumption.

The following fully discrete identities remain checks on the result:

For a whole-life contract: \$\$A = 1 - d \ddot{a}.\$\$

For an n-year term insurance: \$\$A^1\_{:\overline{n}\|} = 1 -
d\ddot{a}\_{:\overline{n}\|} - v^n\\{}\_np.\$\$

For an n-year endowment insurance: \$\$A\_{:\overline{n}\|} = 1 -
d\ddot{a}\_{:\overline{n}\|}.\$\$

Whole-life valuation requires observed mortality through extinction of
the selected status: at least one marginal must reach zero within the
joint horizon, and both must reach zero for last-survivor insurance. An
open table cannot imply a terminal death or maturity benefit. Use an
explicit term or endowment for the observed horizon, or extend the
table. No missing annual interval of an open marginal table is
extrapolated. A zero-term endowment pays benefit at h if the status
survives; a zero-term term insurance has no death coverage and pays
zero. Annual tables must satisfy the consistency requirements of
[`t_pxy`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md),
and issue ages must have positive lx. One call values one contract, not
scenarios.

A deferred insurance retains survival probabilities from the issue ages.
Its continuation value conditional on the selected status surviving to
`h` is multiplied by the deferment factor \$\$v^h\\{}\_hp\_{xy}\$\$ for
the selected two-life status. For last-survivor insurance, this
conditioning includes paths with only one survivor at `h`; it does not
restart both lives at deferred ages. In tidy output, `annuity_due_value`
is the annuity at time `h` conditional on that status surviving to `h`,
and `survival_to_maturity`, when reported, uses the same conditioning.

## See also

[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`t_pxy`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
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
  x = 60:110,
  lx = seq(100000, 0, length.out = 51)
)

insurance_xy(
  lt = lt,
  x = 60,
  y = 62,
  i = 0.06,
  type = "whole",
  status = "joint"
)
#> [1] 0.455826

insurance_xy(
  lt = lt,
  x = 60,
  y = 62,
  i = 0.06,
  type = "term",
  status = "last",
  n = 10,
  tidy = TRUE
)
#> # A tibble: 1 × 26
#>       x     y age_x age_y     i  rate i_type    rate_type     m i_effective
#>   <int> <int> <int> <int> <dbl> <dbl> <chr>     <chr>     <int>       <dbl>
#> 1    60    62    60    62  0.06  0.06 effective effective     1        0.06
#> # ℹ 16 more variables: d_effective <dbl>, type <chr>, insurance_type <chr>,
#> #   status <chr>, cohort <chr>, n <int>, term_years <int>, h <int>,
#> #   deferment_years <int>, benefit <dbl>, frac <chr>, deferment_factor <dbl>,
#> #   annuity_due_value <dbl>, survival_to_maturity <dbl>, unit_apv <dbl>,
#> #   apv <dbl>

lt |>
  life_contract(lives = "joint", x = 60, y = 62, i = 0.06) |>
  insurance_xy(
    type = "term",
    n = 4,
    status = "joint"
  )
#> [1] 0.1359268
```
