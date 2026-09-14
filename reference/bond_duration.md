# Macaulay and modified duration of a level coupon bond under a flat yield

Computes Macaulay duration and modified-duration measures for a level
coupon bond valued under a flat yield-to-maturity assumption, using
compact actuarial notation.

## Usage

``` r
bond_duration(
  face,
  c,
  n,
  k = 1L,
  y_effective_per_period = NULL,
  y = NULL,
  y_type = "effective",
  y_m = 1L,
  R = NULL,
  tol = 1e-10,
  check = TRUE
)
```

## Arguments

- face:

  Numeric scalar. Face value of the bond.

- c:

  Numeric scalar. Annual coupon rate as a proportion.

- n:

  Numeric scalar. Time to maturity in years.

- k:

  Positive integer. Number of coupon payments per year.

- y_effective_per_period:

  Optional numeric scalar. Effective yield per coupon period.

- y:

  Optional numeric scalar. Annual yield rate value.

- y_type:

  Character string indicating the annual yield type: `"effective"`,
  `"nominal_interest"`, `"nominal_discount"`, or `"force"`.

- y_m:

  Positive integer. Conversion frequency for nominal annual yields.

- R:

  Numeric scalar. Redemption value at maturity. If `NULL`, defaults to
  `face`.

- tol:

  Numeric scalar. Tolerance used to check maturity alignment.

- check:

  Logical scalar. If `TRUE`, performs input validation.

## Value

A one-row tibble with:

- price:

  Dirty price at the given yield.

- macaulay_duration_periods:

  Macaulay duration in coupon periods.

- macaulay_duration_years:

  Macaulay duration in years.

- modified_duration_periods_j:

  Modified duration with respect to the effective yield per coupon
  period, expressed in coupon periods.

- modified_duration_years_i:

  Modified duration with respect to the annual effective yield,
  expressed in years.

- yield_per_period:

  Effective yield per coupon period.

- yield_effective_annual:

  Annual effective yield.

- k:

  Coupon frequency.

- n_periods:

  Total number of coupon periods.

## Details

Assumptions:

- Coupons are paid in arrears at regular intervals.

- `n * k` must be an integer.

- Stub periods are not supported.

- Valuation is at a coupon date with no accrued interest.

- A single flat yield is used to discount all cash flows.

Yield input conventions:

- If `y_effective_per_period` is supplied, it is interpreted as the
  effective yield per coupon period.

- Otherwise, `y`, `y_type`, and `y_m` define an annual yield
  specification, which is converted first to annual effective yield and
  then to effective yield per coupon period.

This function follows the compact bond notation used in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `n` is the time
to maturity, `k` is the coupon frequency, `y` is the annual yield input,
and `R` is the redemption value.

Let \\j\\ be the effective yield per coupon period, \\k\\ the number of
coupon payments per year, and let cash flows \\C_r\\ occur at coupon
periods \\r = 1, \dots, N\\. With \\v = 1/(1+j)\\ and \\P = \sum_r C_r
v^r\\:

Macaulay duration in coupon periods: \$\$D_p = \frac{\sum\_{r=1}^{N} r
C_r v^r}{P}.\$\$

Macaulay duration in years is \\D = D_p / k\\.

Modified duration with respect to \\j\\, in coupon periods, is \\D^\*\_j
= D_p / (1 + j)\\.

Modified duration with respect to the annual effective rate \\i\\, in
years, is \\D^\*\_i = D / (1 + i)\\, where \\i = (1+j)^k - 1\\.

Modified duration measures the first-order sensitivity of the bond price
to yield changes. Together with
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
it forms the second-order Taylor approximation of price changes.

## See also

[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_cash_flows`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_book_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_ytm`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
bond_duration(
  face = 100,
  c = 0.08,
  n = 5,
  k = 2,
  y = 0.06,
  y_type = "effective"
)
#> # A tibble: 1 × 9
#>   price macaulay_duration_periods macaulay_duration_years modified_duration_pe…¹
#>   <dbl>                     <dbl>                   <dbl>                  <dbl>
#> 1  109.                      8.51                    4.26                   8.27
#> # ℹ abbreviated name: ¹​modified_duration_periods_j
#> # ℹ 5 more variables: modified_duration_years_i <dbl>, yield_per_period <dbl>,
#> #   yield_effective_annual <dbl>, k <int>, n_periods <int>

bond_duration(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  y_effective_per_period = 0.03
)
#> # A tibble: 1 × 9
#>   price macaulay_duration_periods macaulay_duration_years modified_duration_pe…¹
#>   <dbl>                     <dbl>                   <dbl>                  <dbl>
#> 1  926.                      15.8                    7.89                   15.3
#> # ℹ abbreviated name: ¹​modified_duration_periods_j
#> # ℹ 5 more variables: modified_duration_years_i <dbl>, yield_per_period <dbl>,
#> #   yield_effective_annual <dbl>, k <int>, n_periods <int>
```
