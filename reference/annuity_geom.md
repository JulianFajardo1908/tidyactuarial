# Geometric annuity factor

Computes the actuarial present value or accumulated value factor for a
geometric annuity, using compact actuarial notation.

## Usage

``` r
annuity_geom(
  n = NULL,
  k = 1L,
  i,
  i_type = "effective",
  m = 1L,
  g = 0,
  g_type = "effective",
  g_m = 1L,
  h = 0,
  timing = "immediate",
  P1 = 1,
  perpetuity = FALSE,
  valuation = c("present", "accumulated"),
  tidy = FALSE
)
```

## Arguments

- n:

  Numeric vector of payment durations in years. Ignored only when
  `perpetuity = TRUE` and `valuation = "present"`. Otherwise, each value
  must be positive and finite.

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
  interest-rate inputs. Ignored for `"effective"` and `"force"`.

- g:

  Numeric vector of annual growth-rate values for the payments.

- g_type:

  Character vector indicating the growth-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- g_m:

  Positive integer vector giving the conversion frequency for nominal
  growth-rate inputs. Ignored for `"effective"` and `"force"`.

- h:

  Numeric vector of deferment times in years. Must be greater than or
  equal to 0. For present values, the deferment discounts the payment
  block. For accumulated values, it is recorded but does not change the
  factor under the adopted terminal-horizon convention.

- timing:

  Character vector. One of `"immediate"` or `"due"`.

- P1:

  Numeric vector giving the first payment of the geometric sequence.

- perpetuity:

  Logical vector. If `TRUE`, computes the geometric perpetuity present
  value. Perpetuities are not supported for `valuation = "accumulated"`.

- valuation:

  Character string. Use `"present"` for present value or `"accumulated"`
  for accumulated value at the end of the term.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric factor. If `TRUE`,
  returns a tibble with intermediate quantities.

## Value

If `tidy = FALSE`, a numeric vector.

If `tidy = TRUE`, a tibble with input values, equivalent rates, period
quantities, and both present and accumulated value factors.

## Details

This function covers finite geometric annuities and geometric
perpetuities.

Supported timing conventions:

- `"immediate"`: payments at the end of each period.

- `"due"`: payments at the beginning of each period.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `n` is the term, `k` is the payment frequency, `i` is
the interest-rate input, `i_type` is the interest-rate type, `m` is the
conversion frequency for nominal interest rates, `g` is the growth-rate
input, `g_type` is the growth-rate type, `g_m` is the conversion
frequency for nominal growth rates, `h` is the deferment period, and
`P1` is the first payment.

Let \\i_p\\ be the effective interest rate per payment period, \\g_p\\
the effective growth rate per payment period, and \\v_p =
(1+i_p)^{-1}\\.

For a finite geometric annuity-immediate with \\N\\ payment periods:
\$\$ ga_N = \sum\_{r=1}^{N}\frac{(1+g_p)^{r-1}}{(1+i_p)^r} \$\$

If \\i_p \neq g_p\\, then \$\$ ga_N =
\frac{1-\left(\frac{1+g_p}{1+i_p}\right)^N}{i_p-g_p}. \$\$

The accumulated value factor is computed at the standard terminal
horizon: \$\$ gs_N = \sum\_{r=1}^{N}(1+g_p)^{r-1}(1+i_p)^{N-r}. \$\$

For annuities-due, the corresponding immediate factor is multiplied by
\\1+i_p\\.

## See also

[`a_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`s_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md),
[`annuity_arith`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_arith.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)

Other annuities:
[`a_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`annuity_arith()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_arith.md),
[`s_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md)

## Examples

``` r
# Present value of a geometric annuity
annuity_geom(
  n = 10,
  i = 0.05,
  g = 0.02,
  valuation = "present"
)
#> [1] 8.388106

# Accumulated value of a geometric annuity
annuity_geom(
  n = 10,
  i = 0.05,
  g = 0.02,
  valuation = "accumulated"
)
#> [1] 13.66334

# Nominal interest and nominal growth
annuity_geom(
  n = 10,
  k = 12,
  i = 0.06,
  i_type = "nominal_interest",
  m = 12,
  g = 0.024,
  g_type = "nominal_interest",
  g_m = 12
)
#> [1] 100.4824

# Tibble output
annuity_geom(
  n = 10,
  i = 0.05,
  g = 0.02,
  tidy = TRUE
)
#> # A tibble: 1 × 23
#>       n     k     h timing    perpetuity valuation i_input i_type      m g_input
#>   <dbl> <int> <dbl> <chr>     <lgl>      <chr>       <dbl> <chr>   <int>   <dbl>
#> 1    10     1     0 immediate FALSE      present      0.05 effect…     1    0.02
#> # ℹ 13 more variables: g_type <chr>, g_m <int>, i_effective <dbl>,
#> #   g_effective <dbl>, i_period <dbl>, g_period <dbl>, v_period <dbl>,
#> #   n_periods <dbl>, h_periods <dbl>, P1 <dbl>, present_value_factor <dbl>,
#> #   accumulated_value_factor <dbl>, annuity_factor <dbl>
```
