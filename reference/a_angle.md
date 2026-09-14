# Level annuity factor a-angle-n

Computes the actuarial present value factor for a level annuity using
compact actuarial notation.

## Usage

``` r
a_angle(
  n = NULL,
  k = 1L,
  i,
  i_type = "effective",
  m = 1L,
  h = 0,
  timing = "immediate",
  perpetuity = FALSE,
  payment = 1,
  tidy = FALSE
)
```

## Arguments

- n:

  Numeric vector of payment durations in years. Ignored when
  `perpetuity = TRUE`. If `perpetuity = FALSE`, each value must be
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
  equal to 0.

- timing:

  Character vector. One of `"immediate"`, `"due"`, or `"continuous"`.

- perpetuity:

  Logical vector. If `TRUE`, computes the perpetuity factor.

- payment:

  Numeric vector of level payment amounts. Used only when `tidy = TRUE`
  to report the corresponding present value. The annuity factor itself
  is always computed for unit payments.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric annuity factor. If
  `TRUE`, returns a tibble with intermediate calculations.

## Value

If `tidy = FALSE`, a numeric vector of annuity factors.

If `tidy = TRUE`, a tibble with input values, equivalent rates, annuity
factors, payment amounts, and present values.

## Details

Supported timing conventions:

- `"immediate"`: annuity-immediate with discrete payments.

- `"due"`: annuity-due with discrete payments.

- `"continuous"`: continuous annuity.

For discrete annuities, `k` is the number of payments per year, so
payments are made every \\1/k\\ year. The function returns the annuity
factor, assuming a unit payment at each payment time.

Deferment is supported through `h`. For discrete annuities, the
deferment must align with the payment grid, that is, \\hk\\ must be an
integer.

If `perpetuity = TRUE`, the infinite-term annuity factor is returned.

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

For finite discrete annuities: \$\$a\_{\overline{n\|}} = \frac{1 -
v^n}{i}\$\$

For due annuities: \$\$\ddot{a}\_{\overline{n\|}} =
(1+i)a\_{\overline{n\|}}\$\$

For continuous annuities: \$\$\bar{a}\_{\overline{n\|}} = \frac{1 -
e^{-\delta n}}{\delta}\$\$

Input vectors must have length 1 or a common length. Missing values are
propagated.

## See also

[`s_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`present_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md)

Other annuities:
[`annuity_arith()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_arith.md),
[`annuity_geom()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_geom.md),
[`s_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md)

## Examples

``` r
# Numeric annuity factor
a_angle(n = 10, i = 0.05)
#> [1] 7.721735

# Nominal interest converted monthly, with monthly payments
a_angle(
  n = 10,
  i = 0.06,
  i_type = "nominal_interest",
  m = 12,
  k = 12
)
#> [1] 90.07345

# Continuous annuity
a_angle(
  n = 15,
  i = 0.04,
  i_type = "force",
  timing = "continuous"
)
#> [1] 11.27971

# Tibble output for teaching or auditing
a_angle(
  n = 10,
  i = 0.05,
  payment = 1000,
  tidy = TRUE
)
#> # A tibble: 1 × 17
#>       n     k     h timing    perpetuity i_input i_type     m i_effective  delta
#>   <dbl> <int> <dbl> <chr>     <lgl>        <dbl> <chr>  <int>       <dbl>  <dbl>
#> 1    10     1     0 immediate FALSE         0.05 effec…     1        0.05 0.0488
#> # ℹ 7 more variables: i_period <dbl>, v_period <dbl>, n_periods <dbl>,
#> #   h_periods <dbl>, annuity_factor <dbl>, payment <dbl>, present_value <dbl>

# Vectorized example
a_angle(
  n = c(5, 10, 20),
  k = c(1, 12, 1),
  i = c(0.05, 0.06, 0.04),
  i_type = c("effective", "nominal_interest", "force"),
  m = c(1, 12, 1),
  h = c(0, 0, 2),
  timing = c("immediate", "immediate", "continuous"),
  perpetuity = c(FALSE, FALSE, FALSE)
)
#> [1]  4.329477 90.073453 12.708336
```
