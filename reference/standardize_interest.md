# Standardize an interest rate to the annual effective rate i

Converts common interest-rate specifications to the equivalent annual
effective interest rate `i`, using compact actuarial notation.

## Usage

``` r
standardize_interest(i_type = "effective", i, m = 1, ...)
```

## Arguments

- i_type:

  Character vector indicating the interest-rate type. Must be one of
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, or
  `"force"`.

- i:

  Numeric vector of interest-rate values.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. Ignored for `"effective"` and `"force"`.

- ...:

  Transitional compatibility for older internal calls using `type = `
  and `rate = `. These names are accepted and mapped to `i_type` and
  `i`.

## Value

Numeric vector of annual effective rates. Missing values are propagated.

## Details

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` denotes the interest-rate value, `i_type` denotes
the interest-rate type, and `m` denotes the conversion frequency for
nominal rates.

The conversion formulas are:

- effective::

  \\i = i\\ (identity)

- nominal_interest::

  \\i_e = (1 + j^{(m)}/m)^m - 1\\

- nominal_discount::

  \\i_e = (1 - d^{(m)}/m)^{-m} - 1\\

- force::

  \\i_e = e^{\delta} - 1\\

Input vectors must have length 1 or a common length.

## See also

[`interest_equivalents`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`discount_factor_spot`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
# Scalar cases
standardize_interest(i_type = "nominal_interest", i = 0.18, m = 4)
#> [1] 0.1925186
standardize_interest(i_type = "nominal_discount", i = 0.10, m = 12)
#> [1] 0.1056341
standardize_interest(i_type = "force", i = 0.12)
#> [1] 0.1274969

# Vectorized case
standardize_interest(
  i_type = c("nominal_interest", "force", "effective"),
  i = c(0.06, 0.05, 0.04),
  m = c(12, 1, 1)
)
#> [1] 0.06167781 0.05127110 0.04000000

# Use inside a data pipeline
if (requireNamespace("dplyr", quietly = TRUE) &&
    requireNamespace("tibble", quietly = TRUE)) {
  portfolio <- tibble::tibble(
    policy_id = 1:3,
    i = c(0.05, 0.08, 0.10),
    i_type = c("force", "nominal_interest", "nominal_discount"),
    m = c(1, 4, 12)
  )

  dplyr::mutate(
    portfolio,
    i_effective = standardize_interest(
      i_type = i_type,
      i = i,
      m = m
    )
  )
}
#> # A tibble: 3 × 5
#>   policy_id     i i_type               m i_effective
#>       <int> <dbl> <chr>            <dbl>       <dbl>
#> 1         1  0.05 force                1      0.0513
#> 2         2  0.08 nominal_interest     4      0.0824
#> 3         3  0.1  nominal_discount    12      0.106 
```
