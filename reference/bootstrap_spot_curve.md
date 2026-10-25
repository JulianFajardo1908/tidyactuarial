# Bootstrap a spot yield curve from instrument prices

Recovers annual effective spot rates and discount factors sequentially
from observed dirty prices and dated cash flows. Each instrument
supplies one new maturity; all its earlier positive cash flows must
occur at maturities already bootstrapped.

## Usage

``` r
bootstrap_spot_curve(
  .data,
  col_instrument = "instrument",
  col_price = "price",
  col_t = "t",
  col_cf = "cf"
)
```

## Arguments

- .data:

  Nonempty data frame with one row per priced instrument.

- col_instrument:

  Character scalar naming the unique instrument-ID column.

- col_price:

  Character scalar naming the observed dirty-price column.

- col_t:

  Character scalar naming the list-column of positive payment times in
  years.

- col_cf:

  Character scalar naming the list-column of nonnegative cash flows
  corresponding to `col_t`.

## Value

A tibble ordered by maturity, with columns `instrument`, `t`, `price`,
`known_pv`, `terminal_cf`, `v`, `i`, `repriced_price`, and
`repricing_error`. The columns `v` and `i` contain the new maturity's
discount factor and annual effective spot rate. `repricing_error` is the
model price minus the observed dirty price, in monetary units.

## Details

For instrument \\j\\, with maturity \\t_j\\, dirty price \\P_j\\, and
cash flows \\CF\_{j,k}\\, the price identity is \$\$P_j = \sum\_{k \< j}
CF\_{j,k} v(t_k) + CF\_{j,j} v(t_j).\$\$ Hence the new discount factor
is recovered exactly as \$\$v(t_j) = \frac{P_j - \sum\_{k \< j}
CF\_{j,k} v(t_k)}{CF\_{j,j}}.\$\$ The annual effective spot rate is
\$\$i\_{t_j} = v(t_j)^{-1/t_j} - 1.\$\$

Each input row represents one instrument; `t` and `cf` are list-columns.
Repeated payment times within an instrument are combined, allowing
coupon and redemption flows produced by
[`bond_cash_flows()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md).
Instruments are processed by increasing final positive-payment time, not
input row order. Zero cash flows are ignored. Duplicate final
maturities, missing earlier discount-factor nodes, zero or negative
residual prices, and nonpositive terminal cash flows are rejected.

This is exact triangular bootstrapping: it does **not** interpolate,
extrapolate, fit a curve, or estimate a least-squares solution. An
annual effective spot rate can be negative; its discount factor must be
positive. Input prices and cash flows must use the same monetary units.
Both the positive finite discount factor and its annual effective rate
above -1 must be representable. Rounded input prices can make a small
terminal residual ill-conditioned; no tolerance silently replaces a
nonpositive residual. `repricing_error` reports the recomputed
floating-point discrepancy, not an independent accuracy guarantee or a
convergence test.

## See also

[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`bond_cash_flows()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_curve.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`par_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/par_rate.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
# Recover a known 1-, 2-, and 3-year annual effective spot curve.
t <- 1:3
i <- c(0.04, 0.045, 0.05)
v <- (1 + i)^(-t)
instruments <- tibble::tibble(
  instrument = c("Zero 1Y", "Coupon 2Y", "Coupon 3Y"),
  price = c(100 * v[1],
            5 * v[1] + 105 * v[2],
            6 * v[1] + 6 * v[2] + 106 * v[3]),
  t = list(1, c(1, 2), c(1, 2, 3)),
  cf = list(100, c(5, 105), c(6, 6, 106))
)
curve <- instruments |> bootstrap_spot_curve()
curve
#> # A tibble: 3 × 9
#>   instrument     t price known_pv terminal_cf     v      i repriced_price
#>   <chr>      <dbl> <dbl>    <dbl>       <dbl> <dbl>  <dbl>          <dbl>
#> 1 Zero 1Y        1  96.2     0            100 0.962 0.0400           96.2
#> 2 Coupon 2Y      2 101.      4.81         105 0.916 0.045           101. 
#> 3 Coupon 3Y      3 103.     11.3          106 0.864 0.050           103. 
#> # ℹ 1 more variable: repricing_error <dbl>
yield_curve(t = curve$t, i = curve$i)
#> # A tibble: 1 × 4
#>   t         i         v         i_effective
#>   <list>    <list>    <list>    <list>     
#> 1 <dbl [3]> <dbl [3]> <dbl [3]> <dbl [3]>  
```
