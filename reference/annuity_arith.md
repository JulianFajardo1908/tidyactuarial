# Arithmetic annuity factor

Computes the actuarial present value or accumulated value factor for an
arithmetic annuity, using compact actuarial notation.

## Usage

``` r
annuity_arith(
  n,
  k = 1L,
  i,
  i_type = "effective",
  m = 1L,
  h = 0,
  timing = "immediate",
  pattern = "increasing",
  P1 = 1,
  g = 1,
  valuation = c("present", "accumulated"),
  tidy = FALSE
)
```

## Arguments

- n:

  Numeric vector of payment durations in years. Each value must be
  positive and finite.

- k:

  Positive integer vector giving the number of payments per year.

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

  Character vector. One of `"immediate"` or `"due"`.

- pattern:

  Character vector. One of `"increasing"`, `"decreasing"`, or
  `"custom"`.

- P1:

  Numeric vector. First payment for `pattern = "custom"`. Ignored for
  `"increasing"` and `"decreasing"`.

- g:

  Numeric vector. Arithmetic increment for `pattern = "custom"`. Ignored
  for `"increasing"` and `"decreasing"`.

- valuation:

  Character string. Use `"present"` for present value or `"accumulated"`
  for accumulated value at the end of the term.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric factor. If `TRUE`,
  returns a tibble with intermediate quantities.

## Value

If `tidy = FALSE`, a numeric vector of arithmetic annuity factors.

If `tidy = TRUE`, a tibble with input values, equivalent rates, period
quantities, and both present and accumulated value factors.

## Details

This function covers increasing, decreasing, and custom arithmetic
payment patterns. It replaces the more specific increasing and
decreasing annuity functions.

Supported payment patterns:

- `"increasing"`: payments \\1, 2, \ldots, N\\.

- `"decreasing"`: payments \\N, N-1, \ldots, 1\\.

- `"custom"`: payments following \\P_r = P_1 + (r - 1)g\\.

Supported timing conventions:

- `"immediate"`: payments at the end of each period.

- `"due"`: payments at the beginning of each period.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `n` is the term, `k` is the payment frequency, `i` is
the interest-rate input, `i_type` is the interest-rate type, `m` is the
conversion frequency for nominal rates, and `h` is the deferment period.

The function first converts the supplied rate to the equivalent annual
effective interest rate using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).

For each scenario, the total number of payments is \$\$N = n k.\$\$

The present value is computed by summing the discounted payment stream.
The accumulated value is computed at the end of the annuity term. Under
this convention, `h` affects the present value factor but not the
accumulated value factor.

## See also

[`a_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`s_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)

Other annuities:
[`a_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`annuity_geom()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_geom.md),
[`s_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md)

## Examples

``` r
# Increasing arithmetic annuity
annuity_arith(n = 10, i = 0.05, pattern = "increasing")
#> [1] 39.37378

# Decreasing arithmetic annuity
annuity_arith(n = 10, i = 0.05, pattern = "decreasing")
#> [1] 45.5653

# Custom arithmetic annuity
annuity_arith(
  n = 10,
  i = 0.05,
  pattern = "custom",
  P1 = 100,
  g = 25
)
#> [1] 1563.475

# Accumulated value factor
annuity_arith(
  n = 10,
  i = 0.05,
  pattern = "increasing",
  valuation = "accumulated"
)
#> [1] 64.13574

# Tibble output
annuity_arith(
  n = 10,
  i = 0.05,
  pattern = "decreasing",
  tidy = TRUE
)
#> # A tibble: 1 × 19
#>       n     k     h timing    pattern valuation i_input i_type     m i_effective
#>   <dbl> <int> <dbl> <chr>     <chr>   <chr>       <dbl> <chr>  <int>       <dbl>
#> 1    10     1     0 immediate decrea… present      0.05 effec…     1        0.05
#> # ℹ 9 more variables: i_period <dbl>, v_period <dbl>, n_periods <dbl>,
#> #   h_periods <dbl>, P1 <dbl>, g <dbl>, present_value_factor <dbl>,
#> #   accumulated_value_factor <dbl>, annuity_factor <dbl>
```
