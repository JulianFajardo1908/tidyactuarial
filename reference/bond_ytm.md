# Yield to maturity of a level coupon bond

Computes the yield to maturity (YTM) of a level coupon bond given its
observed dirty price at time 0, using compact actuarial notation.

## Usage

``` r
bond_ytm(
  P,
  face,
  c,
  n,
  k = 1L,
  R = NULL,
  interval = NULL,
  tol = 1e-12,
  maxiter = 1000,
  check = TRUE
)
```

## Arguments

- P:

  Numeric scalar. Observed dirty price of the bond at time 0.

- face:

  Numeric scalar. Face value of the bond.

- c:

  Numeric scalar. Annual coupon rate as a proportion.

- n:

  Numeric scalar. Time to maturity in years. Must be strictly positive.

- k:

  Positive integer. Number of coupon payments per year.

- R:

  Numeric scalar. Redemption value at maturity. If `NULL`, defaults to
  `face`.

- interval:

  Optional numeric vector of length 2 giving a bracket for the effective
  yield per coupon period.

- tol:

  Numeric scalar. Tolerance passed to
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- maxiter:

  Positive integer. Maximum number of iterations passed to
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- check:

  Logical scalar. If `TRUE`, performs basic input checks.

## Value

A one-row tibble with columns:

- price:

  Input dirty price.

- i_period:

  Effective yield per coupon period.

- j_nominal:

  Nominal annual yield convertible `k` times per year (=
  `k * i_period`). When `k = 2`, this is the bond-equivalent yield.

- i_effective_annual:

  Annual effective yield.

- k:

  Coupon frequency.

## Details

The YTM is solved first as the effective yield per coupon period and
then reported together with common annual equivalents.

Assumptions:

- Coupons are paid in arrears at regular intervals.

- Price is observed at a coupon date (no accrued interest).

- `n * k` must be an integer.

- Stub periods are not supported.

This function follows the compact bond notation used in `tidyactuarial`:
`P` is the observed dirty price, `face` is the face value, `c` is the
annual coupon rate, `n` is the time to maturity, `k` is the coupon
frequency, and `R` is the redemption value.

The effective yield per coupon period \\j\\ is the solution to \$\$P =
\sum\_{r=1}^{N} C_r (1+j)^{-r}.\$\$

The root is found numerically using
[`uniroot`](https://rdrr.io/r/stats/uniroot.html). If no `interval` is
supplied, the function automatically brackets the root starting from
\\(-0.999999, 0.10)\\ and progressively widens the upper bound until a
sign change is detected.

From the per-period yield, the annual equivalents are: \$\$j^{(k)} = k
j, \qquad i = (1 + j)^k - 1.\$\$

## See also

[`bond_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_cash_flows`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_callable_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
bond_ytm(
  P = 100,
  face = 100,
  c = 0.06,
  n = 5,
  k = 1
)
#> # A tibble: 1 × 5
#>   price i_period j_nominal i_effective_annual     k
#>   <dbl>    <dbl>     <dbl>              <dbl> <int>
#> 1   100   0.0600    0.0600             0.0600     1

bond_ytm(
  P = 950,
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2
)
#> # A tibble: 1 × 5
#>   price i_period j_nominal i_effective_annual     k
#>   <dbl>    <dbl>     <dbl>              <dbl> <int>
#> 1   950   0.0283    0.0566             0.0574     2
```
