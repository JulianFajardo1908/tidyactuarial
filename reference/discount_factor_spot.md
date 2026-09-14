# Spot discount factor

Computes the discount factor implied by a spot rate for a given time,
using compact actuarial notation.

## Usage

``` r
discount_factor_spot(t, i, i_type = "effective", m = 1L, tidy = FALSE)
```

## Arguments

- t:

  Numeric vector of times in years. Each value must be greater than or
  equal to 0.

- i:

  Numeric vector of spot-rate values.

- i_type:

  Character vector indicating the spot-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  spot-rate inputs.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric discount factor. If
  `TRUE`, returns a tibble with intermediate calculations.

## Value

If `tidy = FALSE`, a numeric vector of discount factors.

If `tidy = TRUE`, a tibble with input values, standardized rates, and
discount factors.

## Details

The spot rate may be supplied in FM-style notation:

- annual effective rate,

- nominal annual interest rate,

- nominal annual discount rate,

- force of interest.

Internally, the supplied spot rate is first converted to the equivalent
annual effective rate using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).
The discount factor is then computed as \$\$v(t) = (1+i)^{-t}.\$\$

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `t` denotes time, `i` denotes the spot-rate input,
`i_type` denotes the interest-rate type, and `m` denotes the conversion
frequency for nominal rates.

If \\t = 0\\, the discount factor is 1.

Input vectors must have length 1 or a common length. Missing values are
propagated.

## See also

[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`present_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
# Numeric discount factor
discount_factor_spot(
  t = 3,
  i = 0.05
)
#> [1] 0.8638376

# Vectorized example
discount_factor_spot(
  t = c(1, 2, 3),
  i = c(0.05, 0.055, 0.06)
)
#> [1] 0.9523810 0.8984524 0.8396193

# FM-style input with nominal annual interest
discount_factor_spot(
  t = 2,
  i = 0.08,
  i_type = "nominal_interest",
  m = 2
)
#> [1] 0.8548042

# Tibble output for teaching or auditing
discount_factor_spot(
  t = c(1, 2, 3),
  i = c(0.05, 0.055, 0.06),
  tidy = TRUE
)
#> # A tibble: 3 × 6
#>       t i_input i_type        m i_effective discount_factor
#>   <dbl>   <dbl> <chr>     <int>       <dbl>           <dbl>
#> 1     1   0.05  effective     1       0.05            0.952
#> 2     2   0.055 effective     1       0.055           0.898
#> 3     3   0.06  effective     1       0.06            0.840
```
