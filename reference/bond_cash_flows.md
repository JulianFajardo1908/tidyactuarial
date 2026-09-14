# Cash flow structure of a level coupon bond

Builds the cash-flow schedule of a level coupon bond with constant
coupon rate and a single redemption payment at maturity, using compact
actuarial notation.

## Usage

``` r
bond_cash_flows(face, c, n, k = 1L, R = NULL, tol = 1e-10, check = TRUE)
```

## Arguments

- face:

  Numeric scalar. Face value of the bond.

- c:

  Numeric scalar. Annual coupon rate.

- n:

  Numeric scalar. Years to maturity.

- k:

  Positive integer. Number of coupon payments per year.

- R:

  Numeric scalar. Redemption value. If `NULL`, it is set equal to
  `face`.

- tol:

  Numeric scalar. Tolerance.

- check:

  Logical scalar. Input validation.

## Value

A tibble with the bond cash-flow schedule. The main actuarial columns
are `t` for payment time and `cf` for cash flow.

## Details

This function follows the compact bond notation used in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `n` is the term
to maturity, `k` is the number of coupon payments per year, and `R` is
the redemption value.

Stub periods are not supported; therefore, `n * k` must be an integer.

## Examples

``` r
bond_cash_flows(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  R = 1000
)
#> # A tibble: 21 × 5
#>    cashflow_id period     t    cf type  
#>          <int>  <int> <dbl> <dbl> <chr> 
#>  1           1      1   0.5    25 coupon
#>  2           2      2   1      25 coupon
#>  3           3      3   1.5    25 coupon
#>  4           4      4   2      25 coupon
#>  5           5      5   2.5    25 coupon
#>  6           6      6   3      25 coupon
#>  7           7      7   3.5    25 coupon
#>  8           8      8   4      25 coupon
#>  9           9      9   4.5    25 coupon
#> 10          10     10   5      25 coupon
#> # ℹ 11 more rows
```
