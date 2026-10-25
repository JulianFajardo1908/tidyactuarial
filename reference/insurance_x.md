# Actuarial present value of a life insurance

Computes the actuarial present value of a discrete single-life insurance
using a life table and compact actuarial notation.

## Usage

``` r
insurance_x(
  lt,
  x,
  i,
  i_type = "effective",
  m = 1L,
  n = Inf,
  h = 0L,
  type = c("whole", "term", "endowment"),
  benefit = 1,
  tidy = FALSE,
  ...
)
```

## Arguments

- lt:

  A life table as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).
  It must contain columns `x` and `lx`.

- x:

  Integer actuarial age at issue, or a vector of scenario ages.

- i:

  Numeric annual interest-rate input, scalar or by scenario.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

- n:

  Integer insurance term in years. Required for `type = "term"` and
  `type = "endowment"`. Use `Inf` only for whole-life insurance.

- h:

  Integer deferment period in years.

- type:

  Character string. One of `"whole"`, `"term"`, or `"endowment"`.

- benefit:

  Numeric benefit amount, scalar or by scenario. A vector represents
  separate contracts, not a benefit schedule within one contract.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric APV. If `TRUE`, returns
  one tibble row per scenario with intermediate quantities.

- ...:

  Transitional compatibility for older calls using `mortality_table`,
  `age`, `rate`, `rate_type`, `term_years`, `deferral_years`,
  `insurance_type`, and `output`.

## Value

If `tidy = FALSE`, a numeric vector of actuarial present values, of
length one for a single scenario.

If `tidy = TRUE`, a tibble with one row per scenario, the main input
values, equivalent interest rate, deferral factor, pure endowment
factor, annuity-due value used in the standard identities, and APV.

## Details

The benefit is paid at the end of the year of death for whole-life and
term insurance. For endowment insurance, the same benefit is paid either
at death within the term or at the end of the term if the life survives.

Supported contracts:

- `"whole"`: whole-life insurance.

- `"term"`: n-year term insurance.

- `"endowment"`: n-year endowment insurance.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `lt` is the life table, `x` is the age at issue, `i` is
the interest-rate input, `i_type` is the interest-rate type, `m` is the
conversion frequency for nominal rates, `n` is the insurance term, and
`h` is the deferment period.

The function computes APVs directly from `lx`. For a deferred insurance,
the value at age `x + h` is multiplied by \$\$v^h\\{}\_hp_x.\$\$

For whole-life insurance, the death benefit APV at the deferred starting
age is computed over the available life-table horizon. For term and
endowment insurance, the death benefit is computed over the first `n`
years. Endowment insurance additionally includes the pure endowment
component \$\$v^n\\{}\_np_x.\$\$

**Scenarios.** `x`, `i`, `i_type`, `m`, `n`, `h`, `type`, and `benefit`
may have a common positive length; only length-one arguments recycle.
The table and `tidy` control are shared. Scenarios are paired by
position, not expanded to a Cartesian product. Missing or invalid cases
are rejected with the scenario number. Use the numeric result in
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
or request a tibble for intermediate values. Explicit interest arguments
override contract defaults.

**Valuation and scope.** For annual deaths in interval \\\[r,r+1)\\, the
unconditional payment probability is \\(l\_{x+r}-l\_{x+r+1})/l_x\\. The
benefit is discounted at \\r+1\\, not at the exact moment of death.
Decrements are formed before division, and log ratios and original
interest rates retain representable APVs when intermediate conditional
values or discount factors overflow or underflow. Intermediate
diagnostics may therefore be zero or infinite while APV is finite.
Tables require an annual age grid, nonincreasing finite `lx`, and a
positive count at issue. For compatibility the terminal count one year
beyond the table is zero, even for an open input table. Extinct tails
contribute zero. A zero-term endowment pays the benefit at time `h` on
survival; zero-term death insurance pays nothing.

Use
[`insurance_variable_k`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md)
for benefits varying by subperiod, including level benefits paid at the
end of the subperiod of death, and
[`t_Ex`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_Ex.md)
for pure endowments. Continuous death-time insurance, fractional issue
ages and time-varying interest curves require additional model
specifications and are not implied by this annual contract.

## See also

[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`reserve_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`t_Ex`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_Ex.md),
[`insurance_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
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
  x  = 60:65,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000)
)

# Whole-life insurance
insurance_x(
  lt = lt,
  x = 60,
  i = 0.06,
  type = "whole"
)
#> [1] 0.7162609

# 5-year term insurance
insurance_x(
  lt = lt,
  x = 60,
  i = 0.06,
  n = 5,
  type = "term"
)
#> [1] 0.08179638

# 5-year endowment insurance
insurance_x(
  lt = lt,
  x = 60,
  i = 0.06,
  n = 5,
  type = "endowment"
)
#> [1] 0.7543287

# Deferred whole-life insurance
insurance_x(
  lt = lt,
  x = 60,
  i = 0.06,
  h = 2,
  type = "whole"
)
#> [1] 0.693477

# Tidy output
insurance_x(
  lt = lt,
  x = 60,
  i = 0.06,
  n = 5,
  type = "term",
  tidy = TRUE
)
#> # A tibble: 1 × 23
#>       x   age     i  rate i_type   rate_type     m i_effective d_effective     n
#>   <int> <int> <dbl> <dbl> <chr>    <chr>     <int>       <dbl>       <dbl> <int>
#> 1    60    60  0.06  0.06 effecti… effective     1        0.06      0.0566     5
#> # ℹ 13 more variables: term_years <int>, h <int>, deferral_years <int>,
#> #   start_x <int>, start_age <int>, type <chr>, insurance_type <chr>,
#> #   benefit <dbl>, deferment_factor <dbl>, annuity_due_value <dbl>,
#> #   pure_endowment_factor <dbl>, value_at_start <dbl>, apv <dbl>

# Parallel single-life scenarios with a shared mortality table
insurance_x(lt, x = c(60, 61), i = 0.04, n = c(2, 3),
            type = "term", benefit = c(10000, 20000), tidy = TRUE)
#> # A tibble: 2 × 23
#>       x   age     i  rate i_type   rate_type     m i_effective d_effective     n
#>   <int> <int> <dbl> <dbl> <chr>    <chr>     <int>       <dbl>       <dbl> <int>
#> 1    60    60  0.04  0.04 effecti… effective     1        0.04      0.0385     2
#> 2    61    61  0.04  0.04 effecti… effective     1        0.04      0.0385     3
#> # ℹ 13 more variables: term_years <int>, h <int>, deferral_years <int>,
#> #   start_x <int>, start_age <int>, type <chr>, insurance_type <chr>,
#> #   benefit <dbl>, deferment_factor <dbl>, annuity_due_value <dbl>,
#> #   pure_endowment_factor <dbl>, value_at_start <dbl>, apv <dbl>
```
