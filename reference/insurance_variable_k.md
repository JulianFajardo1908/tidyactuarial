# Actuarial present value of a life insurance with variable k-thly benefits

Computes the actuarial present value of a life insurance where the death
benefit may vary by subperiod and is payable at the end of the subperiod
of death, using compact actuarial notation.

## Usage

``` r
insurance_variable_k(
  lt,
  x,
  i,
  benefit,
  n = NULL,
  h = 0,
  k = 12,
  i_type = "effective",
  m = 1L,
  frac,
  tidy = FALSE,
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- lt:

  A life table object or data frame containing at least columns `x` and
  `lx`.

- x:

  Integer actuarial age at issue.

- i:

  Annual interest-rate input.

- benefit:

  Numeric vector of benefits by subperiod, or a function of time
  returning the benefit at time \\t\\.

- n:

  Optional term in years. If `NULL`, the term is inferred from the
  length of `benefit` when `benefit` is numeric. If `benefit` is a
  function, `n` must be supplied.

- h:

  Nonnegative deferment period in years. Default is `0`.

- k:

  Positive integer. Number of subperiods per year. Default is `12`.

- i_type:

  Character vector indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  interest-rate inputs. Ignored for `"effective"` and `"force"`.

- frac:

  Fractional-age assumption used in survival probabilities: `"UDD"`,
  `"CF"`, `"CML"`, or `"Balducci"`. If not specified and `lt` carries a
  `frac` attribute, that value is used.

- tidy:

  Logical. If `TRUE`, returns a one-row tibble.

- check:

  Logical. If `TRUE`, performs basic input checks.

- tol:

  Numeric tolerance used for integer-grid checks.

## Value

A numeric actuarial present value, or a one-row tibble if `tidy = TRUE`.

## Details

This function is useful for level, increasing, decreasing, and
credit-style life insurance benefits when benefits are specified at a
subannual frequency.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `lt` is the life table, `x` is the age at issue, `i` is
the interest-rate input, `i_type` is the interest-rate type, `m` is the
conversion frequency for nominal rates, `n` is the term, `h` is the
deferment period, and `k` is the number of subperiods per year.

Let \\k\\ be the number of subperiods per year and \\N = nk\\ the total
number of subperiods in the insurance term. With deferment \\h\\, the
actuarial present value at age \\x\\ is: \$\$ APV = \sum\_{j=1}^{N}
v^{h + j/k} b_j \left({}\_{h + (j-1)/k}p_x - {}\_{h + j/k}p_x\right).
\$\$

Here \\b_j\\ is the benefit payable if death occurs in subperiod \\j\\,
and \\v = (1+i_e)^{-1}\\, where \\i_e\\ is the annual effective interest
rate equivalent to the input `i`, `i_type`, and `m`.

If `benefit` is numeric of length 1, it is recycled to all subperiods.
If it is numeric with length greater than 1, its length must equal \\n
k\\. If `benefit` is a function, it is evaluated at the end of each
subperiod, at times \\1/k, 2/k, \ldots, n\\.

Fractional survival probabilities are computed via
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
under the selected fractional-age assumption.

## See also

[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md)
for level-benefit life insurance,
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md)
for life annuity APVs,
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
for survival probabilities.

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
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
  x  = 60:66,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000, 86000)
)

# Monthly insurance with increasing benefits
insurance_variable_k(
  lt = lt,
  x = 60,
  i = 0.05,
  benefit = seq(100, 1200, length.out = 12),
  n = 1,
  k = 12
)
#> [1] 6.283901

# Credit-style insurance with declining outstanding balance
balance <- function(t) 2000 * exp(-0.3 * t)

insurance_variable_k(
  lt = lt,
  x = 60,
  i = 0.05,
  benefit = balance,
  n = 1,
  k = 12
)
#> [1] 16.64039

# Level benefit with annual payments
insurance_variable_k(
  lt = lt,
  x = 60,
  i = 0.05,
  benefit = 1,
  n = 5,
  k = 1
)
#> [1] 0.08447935

# 2-year deferred, 3-year term with monthly varying benefits
insurance_variable_k(
  lt = lt,
  x = 60,
  i = 0.05,
  benefit = rep(1000, 36),
  n = 3,
  h = 2,
  k = 12
)
#> [1] 62.74365

# Nominal annual interest convertible monthly
insurance_variable_k(
  lt = lt,
  x = 60,
  i = 0.06,
  i_type = "nominal_interest",
  m = 12,
  benefit = rep(1000, 12),
  n = 1,
  k = 12
)
#> [1] 9.682443

# Tidy output
insurance_variable_k(
  lt = lt,
  x = 60,
  i = 0.05,
  benefit = rep(1000, 12),
  n = 1,
  k = 12,
  tidy = TRUE
)
#> # A tibble: 1 × 10
#>       x     h     n     k     i i_type        m i_effective frac    apv
#>   <int> <dbl> <dbl> <int> <dbl> <chr>     <int>       <dbl> <chr> <dbl>
#> 1    60     0     1    12  0.05 effective     1        0.05 UDD    9.74
```
