# Discrete convexity of a level coupon bond under a flat yield

Computes discrete convexity measures for a level coupon bond valued
under a flat yield-to-maturity assumption, using compact actuarial
notation.

## Usage

``` r
bond_convexity(
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

  Finite positive numeric scalar. Tolerance used to check maturity
  alignment with integer coupon periods, not a monetary price threshold.

- check:

  Logical scalar. If `TRUE`, performs input validation.

## Value

A one-row tibble with:

- price:

  Dirty price at the given yield.

- discrete_convexity_periods:

  Discrete convexity in coupon periods.

- discrete_convexity_years:

  Discrete convexity in years.

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
  specification. Calculations retain its original log growth; reported
  effective equivalents remain subject to numeric range.

This function follows the compact bond notation used in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `n` is the time
to maturity, `k` is the coupon frequency, `y` is the annual yield input,
and `R` is the redemption value.

Let \\j\\ be the effective yield per coupon period, \\k\\ the number of
coupon payments per year, and let cash flows \\C_r\\ occur at coupon
periods \\r = 1, \dots, N\\. With \\v = 1/(1+j)\\ and \\P = \sum_r C_r
v^r\\, the discrete convexity in coupon periods is \$\$C_p = \frac{1}{P}
\frac{\sum\_{r=1}^{N} C_r r(r+1) v^r}{(1+j)^2}.\$\$

Discrete convexity in years is \\C_p / k^2\\. This is sensitivity to the
nominal annual yield \\z=kj\\; it is generally not the relative second
derivative with respect to the annual effective yield \\i=(1+j)^k-1\\.
Before passing convexity to
[`immunize_duration_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration_convexity.md),
apply the chain rule described there or compute
[`convexity_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/convexity_cash_flow.md)
from annual cash-flow times.

This is the second-order sensitivity of the bond price to changes in the
yield per period. Together with
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
it is used in the second-order Taylor approximation of price changes.
Prices use original log yields and moments use relative present values,
avoiding monetary numerator overflow. Nonzero-term bonds require a
positive finite price and finite risk measures; changing currency alone
does not create an undefined sensitivity. Reported equivalent yields may
reach -1 or Inf by rounding while the original specification remains
usable. At zero term, the existing convention returns immediate
redemption and zero risk.

## See also

[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_cash_flows`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_book_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_ytm`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md)

Other bonds:
[`accrued_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accrued_interest.md),
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
bond_convexity(
  face = 100,
  c = 0.08,
  n = 5,
  k = 2,
  y = 0.06,
  y_type = "effective"
)
#> # A tibble: 1 × 7
#>   price discrete_convexity_periods discrete_convexity_years yield_per_period
#>   <dbl>                      <dbl>                    <dbl>            <dbl>
#> 1  109.                       83.4                     20.8           0.0296
#> # ℹ 3 more variables: yield_effective_annual <dbl>, k <int>, n_periods <int>

bond_convexity(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  y_effective_per_period = 0.03
)
#> # A tibble: 1 × 7
#>   price discrete_convexity_periods discrete_convexity_years yield_per_period
#>   <dbl>                      <dbl>                    <dbl>            <dbl>
#> 1  926.                       287.                     71.8             0.03
#> # ℹ 3 more variables: yield_effective_annual <dbl>, k <int>, n_periods <int>
```
