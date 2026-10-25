# Par coupon rate implied by a spot yield curve

Computes the level annual coupon rate that makes a bond's time-zero
dirty price equal to its face value, using the spot discount factors at
each coupon date. Unlike
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
it does not solve for a flat yield.

## Usage

``` r
par_rate(
  .data = NULL,
  t = NULL,
  i = NULL,
  n = NULL,
  face = 100,
  k = 1L,
  R = NULL,
  i_type = "effective",
  m = 1L,
  col_t = "t",
  col_i = "i",
  tol = 1e-10
)
```

## Arguments

- .data:

  Optional data frame containing a spot curve as numeric columns, or
  multiple curves as list-columns. For pipe-friendly usage.

- t:

  Numeric vector of curve maturities (years) when `.data = NULL`.

- i:

  Numeric vector of observed spot rates when `.data = NULL`.

- n:

  Bond maturity in years. Defaults to the maximum maturity of each
  curve; may also be a scalar or one value per curve.

- face:

  Strictly positive face value; scalar or one value per curve.

- k:

  Positive integer coupon frequency per year; scalar or one value per
  curve. Coupon dates are `seq_len(n * k) / k`.

- R:

  Redemption amount, scalar or one value per curve; defaults to `face`.

- i_type:

  Spot rate type (`"effective"`, `"nominal_interest"`,
  `"nominal_discount"`, or `"force"`). Passed to
  [`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md).
  Must have length one or one value per curve node.

- m:

  Conversion frequency for nominal spot rates, passed to
  [`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md).
  Must have length one or one per curve node.

- col_t:

  Name of the spot maturity column in `.data`.

- col_i:

  Name of the spot rate column in `.data`.

- tol:

  Positive numerical tolerance for aligning coupon dates and curve
  maturities. Does not authorize interpolation.

## Value

One tibble row per curve, containing the supplied curve columns and `n`,
`face`, `k`, `R`, `annuity_factor`, `v_n`, `c_par`, `coupon_per_period`,
`repriced_price`, and `repricing_error`. The `c_par` value is the
nominal annual coupon rate as a proportion; `coupon_per_period` is its
monetary coupon amount. `repricing_error` is the reconstructed dirty
price minus the face value.

## Details

For a bond with face value \\F \> 0\\, redemption \\R\\, term \\n\\, and
\\k\\ coupon payments per year, the price equation is \$\$P = (F c/k)
\sum\_{j=1}^{nk} v(j/k) + R v(n).\$\$ Setting the dirty price \\P = F\\
and solving for the nominal annual coupon rate gives \$\$c\_{par} = k
\[F - R v(n)\] / \[F \sum\_{j=1}^{nk} v(j/k)\].\$\$ When redemption
equals face value, this reduces to \$\$c\_{par} = k \[1 - v(n)\] /
\sum\_{j=1}^{nk} v(j/k).\$\$

Spot inputs use annual effective rates by default, with \\v(t) = (1 +
i_t)^{-t}\\. Other supported interest conventions are converted using
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md).
The calculation uses only observed nodes: every coupon date must match
one curve maturity; there is no interpolation or extrapolation. Small
floating-point discrepancies within `tol` are accepted as identical
dates.

Input can be (1) numeric vectors `t` and `i`, (2) a data frame with
numeric `t` and `i` columns, such as
[`bootstrap_spot_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bootstrap_spot_curve.md)
output, or (3) a tibble with `t` and `i` list-columns, such as
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)
output. In the third form each row describes one curve, and the input
columns are retained. `n`, `face`, `k`, and `R` may be scalars or have
one value per curve. For a single curve, `n = NULL` uses the largest
observed maturity. A coupon rate can be negative when the implied
financial terms require it; the function does not impose a contractual
zero floor.

This model assumes regular coupons paid in arrears, no stub periods, no
accrued interest, and a deterministic redemption at maturity.
Calculation separates the dimensionless rate from monetary amounts and
uses the original log spot growth at maturity to retain small coupon
rates. Final amounts and the positive coupon discount sum must be
representable. `repricing_error` reports the floating-point price
discrepancy; extreme cancellation, especially with negative coupons, can
still limit precision.

## See also

[`bootstrap_spot_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bootstrap_spot_curve.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md),
[`bond_cash_flows()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`bootstrap_spot_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bootstrap_spot_curve.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_curve.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
# An annual-pay bond whose spot curve was obtained from market prices.
curve <- tibble::tibble(
  t = c(1, 2, 3),
  i = c(0.04, 0.045, 0.05)
)
curve |> par_rate(face = 100, k = 1)
#> # A tibble: 1 × 12
#>   t         i             n  face     k     R annuity_factor   v_n  c_par
#>   <list>    <list>    <dbl> <dbl> <dbl> <dbl>          <dbl> <dbl>  <dbl>
#> 1 <dbl [3]> <dbl [3]>     3   100     1   100           2.74 0.864 0.0497
#> # ℹ 3 more variables: coupon_per_period <dbl>, repriced_price <dbl>,
#> #   repricing_error <dbl>

# A two-year bond with semiannual coupons: spot nodes every six months.
par_rate(
  t = c(0.5, 1, 1.5, 2),
  i = rep(0.04, 4),
  n = 2,
  k = 2
)
#> # A tibble: 1 × 12
#>   t         i             n  face     k     R annuity_factor   v_n  c_par
#>   <list>    <list>    <dbl> <dbl> <dbl> <dbl>          <dbl> <dbl>  <dbl>
#> 1 <dbl [4]> <dbl [4]>     2   100     2   100           3.81 0.925 0.0396
#> # ℹ 3 more variables: coupon_per_period <dbl>, repriced_price <dbl>,
#> #   repricing_error <dbl>

# A one-row curve returned by yield_curve() is also accepted.
yield_curve(t = 1:3, i = c(0.04, 0.045, 0.05)) |>
  par_rate()
#> # A tibble: 1 × 14
#>   t         i     v     i_effective     n  face     k     R annuity_factor   v_n
#>   <list>    <lis> <lis> <list>      <dbl> <dbl> <dbl> <dbl>          <dbl> <dbl>
#> 1 <int [3]> <dbl> <dbl> <dbl [3]>       3   100     1   100           2.74 0.864
#> # ℹ 4 more variables: c_par <dbl>, coupon_per_period <dbl>,
#> #   repriced_price <dbl>, repricing_error <dbl>
```
