# Level annuity accumulation factor s-angle-n

Computes the actuarial accumulation factor for a level annuity using
compact actuarial notation.

## Usage

``` r
s_angle(
  n,
  k = 1L,
  i,
  i_type = "effective",
  m = 1L,
  h = 0,
  timing = "immediate",
  payment = 1,
  tidy = FALSE
)
```

## Arguments

- n:

  Numeric vector of payment durations in years. Each value must be
  positive and finite.

- k:

  Positive integer vector giving the number of discrete payments per
  year. Ignored for continuous annuities.

- i:

  Numeric vector of interest-rate values.

- i_type:

  Character vector indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. Ignored for `"effective"` and `"force"`.

- h:

  Numeric vector of deferment times in years. Must be greater than or
  equal to 0. Under the adopted horizon convention, this is metadata
  only for accumulation factors.

- timing:

  Character vector. One of `"immediate"`, `"due"`, or `"continuous"`.

- payment:

  Numeric vector of level payment amounts. Used only when `tidy = TRUE`
  to report the corresponding future value. The accumulation factor
  itself is always computed for unit payments.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric accumulation factor. If
  `TRUE`, returns a tibble with intermediate calculations.

## Value

If `tidy = FALSE`, a numeric vector of accumulation factors.

If `tidy = TRUE`, a tibble with input values, equivalent rates,
accumulation factors, payment amounts, and future values.

## Details

Supported timing conventions:

- `"immediate"`: annuity-immediate with discrete payments.

- `"due"`: annuity-due with discrete payments.

- `"continuous"`: continuous annuity.

For discrete annuities, `k` is the number of payments per year, so
payments are made every \\1/k\\ year. The function returns the
accumulation factor, assuming a unit payment at each payment time.

Horizon convention: the future value is measured at the time of the last
payment. Under this convention, a pure deferment that shifts the entire
payment block forward in time does not change the accumulation factor
when the payment pattern is otherwise unchanged. Therefore, `h` is
recorded and validated, but it does not modify the factor.

The future value of a perpetuity diverges, so perpetuities are not
supported in `s_angle()`.

This function follows the compact actuarial notation used throughout
`tidyactuarial`:

- `n`: annuity term;

- `k`: payment frequency;

- `i`: interest rate;

- `i_type`: interest-rate type;

- `m`: conversion frequency for nominal rates;

- `h`: deferment period.

The function first converts the supplied rate to the equivalent annual
effective interest rate using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).

For finite discrete annuities: \$\$s\_{\overline{n\|}} = \frac{(1+i)^n -
1}{i}\$\$

For due annuities: \$\$\ddot{s}\_{\overline{n\|}} =
(1+i)s\_{\overline{n\|}}\$\$

For continuous annuities: \$\$\bar{s}\_{\overline{n\|}} =
\frac{e^{\delta n} - 1}{\delta}\$\$

Input vectors must have length 1 or a common length. Missing values are
propagated.

## See also

[`a_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`future_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md)

Other annuities:
[`a_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`annuity_arith()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_arith.md),
[`annuity_geom()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_geom.md)

## Examples

``` r
# Numeric accumulation factor
s_angle(n = 10, i = 0.05)
#> [1] 12.57789

# Nominal interest converted monthly, with monthly payments
s_angle(
  n = 10,
  i = 0.06,
  i_type = "nominal_interest",
  m = 12,
  k = 12
)
#> [1] 163.8793

# Continuous annuity
s_angle(
  n = 15,
  i = 0.04,
  i_type = "force",
  timing = "continuous"
)
#> [1] 20.55297

# Tibble output for teaching or auditing
s_angle(
  n = 10,
  i = 0.05,
  payment = 1000,
  tidy = TRUE
)
#> # A tibble: 1 × 16
#>       n     k     h timing    i_input i_type       m i_effective  delta i_period
#>   <dbl> <int> <dbl> <chr>       <dbl> <chr>    <int>       <dbl>  <dbl>    <dbl>
#> 1    10     1     0 immediate    0.05 effecti…     1        0.05 0.0488   0.0500
#> # ℹ 6 more variables: v_period <dbl>, n_periods <dbl>, h_periods <dbl>,
#> #   accumulation_factor <dbl>, payment <dbl>, future_value <dbl>

# Vectorized example
s_angle(
  n = c(5, 10, 20),
  k = c(1, 12, 1),
  i = c(0.05, 0.06, 0.04),
  i_type = c("effective", "nominal_interest", "force"),
  m = c(1, 12, 1),
  h = c(0, 2, 3),
  timing = c("immediate", "due", "continuous")
)
#> [1]   5.525631 164.698744  30.638523
```
