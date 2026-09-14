# Equivalent interest rates in FM actuarial notation

Converts a single interest-rate specification into equivalent actuarial
rates for the same conversion frequency `m`.

## Usage

``` r
interest_equivalents(
  i_type = c("effective", "nominal_interest", "nominal_discount", "force"),
  i,
  m = 1L
)
```

## Arguments

- i_type:

  Character string indicating the input interest-rate type. Must be one
  of `"effective"`, `"nominal_interest"`, `"nominal_discount"`, or
  `"force"`.

- i:

  Numeric scalar giving the interest-rate value.

- m:

  Positive integer scalar giving the conversion frequency for nominal
  rates.

## Value

A tibble with columns:

- family:

  Rate family: `"effective"`, `"discount"`, `"force"`,
  `"nominal_interest"`, or `"nominal_discount"`.

- notation:

  Actuarial notation for the equivalent rate.

- m:

  Conversion frequency used for nominal rates.

- description:

  Human-readable description.

- value:

  Equivalent rate value.

## Details

Internally, the supplied rate is first converted to the annual effective
interest rate \\i\\ using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` denotes the interest-rate value, `i_type` denotes
the type of interest rate, and `m` denotes the conversion frequency for
nominal rates.

Given the annual effective interest rate \\i\\, the equivalents are:

- Effective discount rate::

  \\d = i/(1+i)\\

- Discount factor::

  \\v = 1/(1+i)\\

- Force of interest::

  \\\delta = \ln(1+i)\\

- Nominal interest::

  \\j^{(m)} = m\[(1+i)^{1/m} - 1\]\\

- Nominal discount::

  \\d^{(m)} = m\[1 - (1+i)^{-1/m}\]\\

## See also

[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`discount_factor_spot`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
interest_equivalents(i_type = "nominal_interest", i = 0.18, m = 4)
#> # A tibble: 6 × 5
#>   family           notation     m description                              value
#>   <chr>            <chr>    <int> <chr>                                    <dbl>
#> 1 effective        i           NA effective annual interest rate           0.193
#> 2 discount         d           NA effective annual discount rate           0.161
#> 3 discount_factor  v           NA annual discount factor                   0.839
#> 4 force            delta       NA force of interest                        0.176
#> 5 nominal_interest j^(4)        4 nominal annual interest rate convertibl… 0.180
#> 6 nominal_discount d^(4)        4 nominal annual discount rate convertibl… 0.172
interest_equivalents(i_type = "nominal_discount", i = 0.10, m = 12)
#> # A tibble: 6 × 5
#>   family           notation     m description                              value
#>   <chr>            <chr>    <int> <chr>                                    <dbl>
#> 1 effective        i           NA effective annual interest rate          0.106 
#> 2 discount         d           NA effective annual discount rate          0.0955
#> 3 discount_factor  v           NA annual discount factor                  0.904 
#> 4 force            delta       NA force of interest                       0.100 
#> 5 nominal_interest j^(12)      12 nominal annual interest rate convertib… 0.101 
#> 6 nominal_discount d^(12)      12 nominal annual discount rate convertib… 0.1000
interest_equivalents(i_type = "force", i = 0.12)
#> # A tibble: 6 × 5
#>   family           notation     m description                              value
#>   <chr>            <chr>    <int> <chr>                                    <dbl>
#> 1 effective        i           NA effective annual interest rate           0.127
#> 2 discount         d           NA effective annual discount rate           0.113
#> 3 discount_factor  v           NA annual discount factor                   0.887
#> 4 force            delta       NA force of interest                        0.12 
#> 5 nominal_interest j^(1)        1 nominal annual interest rate convertibl… 0.127
#> 6 nominal_discount d^(1)        1 nominal annual discount rate convertibl… 0.113
interest_equivalents(i_type = "effective", i = 0.08)
#> # A tibble: 6 × 5
#>   family           notation     m description                              value
#>   <chr>            <chr>    <int> <chr>                                    <dbl>
#> 1 effective        i           NA effective annual interest rate          0.08  
#> 2 discount         d           NA effective annual discount rate          0.0741
#> 3 discount_factor  v           NA annual discount factor                  0.926 
#> 4 force            delta       NA force of interest                       0.0770
#> 5 nominal_interest j^(1)        1 nominal annual interest rate convertib… 0.08  
#> 6 nominal_discount d^(1)        1 nominal annual discount rate convertib… 0.0741

# Batch use with purrr
if (requireNamespace("purrr", quietly = TRUE) &&
    requireNamespace("tibble", quietly = TRUE)) {
  cases <- tibble::tibble(
    i_type = c("effective", "force"),
    i = c(0.08, 0.12),
    m = c(1, 1)
  )

  purrr::pmap(cases, interest_equivalents)
}
#> [[1]]
#> # A tibble: 6 × 5
#>   family           notation     m description                              value
#>   <chr>            <chr>    <int> <chr>                                    <dbl>
#> 1 effective        i           NA effective annual interest rate          0.08  
#> 2 discount         d           NA effective annual discount rate          0.0741
#> 3 discount_factor  v           NA annual discount factor                  0.926 
#> 4 force            delta       NA force of interest                       0.0770
#> 5 nominal_interest j^(1)        1 nominal annual interest rate convertib… 0.08  
#> 6 nominal_discount d^(1)        1 nominal annual discount rate convertib… 0.0741
#> 
#> [[2]]
#> # A tibble: 6 × 5
#>   family           notation     m description                              value
#>   <chr>            <chr>    <int> <chr>                                    <dbl>
#> 1 effective        i           NA effective annual interest rate           0.127
#> 2 discount         d           NA effective annual discount rate           0.113
#> 3 discount_factor  v           NA annual discount factor                   0.887
#> 4 force            delta       NA force of interest                        0.12 
#> 5 nominal_interest j^(1)        1 nominal annual interest rate convertibl… 0.127
#> 6 nominal_discount d^(1)        1 nominal annual discount rate convertibl… 0.113
#> 
```
