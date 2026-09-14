# Convexity of a general cash-flow stream

Computes the yield convexity of a general cash-flow stream at a
specified valuation time.

## Usage

``` r
convexity_cash_flow(
  cf,
  t,
  rate,
  valuation_time = 0,
  output = c("value", "audit")
)
```

## Arguments

- cf:

  Numeric vector of cash-flow amounts.

- t:

  Numeric vector of cash-flow times. Times must be expressed in the same
  units used by `rate`.

- rate:

  Effective yield per unit of time. It must be a finite numeric scalar
  greater than `-1`.

- valuation_time:

  Finite numeric scalar indicating the valuation time. Defaults to `0`.

- output:

  Character scalar indicating the returned object: `"value"` returns
  convexity as a numeric scalar; `"audit"` returns a detailed tibble.

## Value

If `output = "value"`, a numeric scalar.

If `output = "audit"`, a tibble with six columns: `time`,
`remaining_time`, `cash_flow`, `discount_factor`, `present_value`, and
`convexity_contribution`.

## Details

Let \\\tau\\ be the valuation time. Under an effective yield \\i\\, the
value of the remaining cash-flow stream is

\$\$ P\_{\tau}(i) = \sum\_{j:t_j\>\tau} C_j(1+i)^{-(t_j-\tau)}. \$\$

The convexity returned by this function is the relative second
derivative of value with respect to the effective yield:

\$\$ \mathcal{C}\_{\tau} = \frac{1}{P\_{\tau}(i)}
\frac{d^2P\_{\tau}(i)}{di^2}. \$\$

Equivalently,

\$\$ \mathcal{C}\_{\tau} = \frac{ \sum\_{j:t_j\>\tau}
(t_j-\tau)(t_j-\tau+1) C_j(1+i)^{-(t_j-\tau+2)} }{ P\_{\tau}(i) }. \$\$

Together with modified duration, this convexity gives the second-order
approximation

\$\$ \frac{\Delta P\_{\tau}}{P\_{\tau}} \approx
-D\_{\mathrm{mod},\tau}\Delta i + \frac{1}{2}\mathcal{C}\_{\tau}(\Delta
i)^2. \$\$

The function follows an ex-cash-flow convention: cash flows occurring
exactly at `valuation_time` are excluded. Therefore, the result
represents convexity immediately after any cash flow paid at that time.

For streams containing both positive and negative cash flows, convexity
remains a yield-sensitivity measure, but it may be negative and may not
have the usual interpretation associated with conventional bonds.

## See also

[`duration_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/duration_cash_flow.md)

## Examples

``` r
convexity_cash_flow(
  cf = c(100, 100, 1100),
  t = c(1, 2, 3),
  rate = 0.05
)
#> [1] 9.689578

convexity_cash_flow(
  cf = c(100, 100, 1100),
  t = c(1, 2, 3),
  rate = 0.05,
  valuation_time = 1
)
#> [1] 5.126034

convexity_cash_flow(
  cf = c(100, 100, 1100),
  t = c(1, 2, 3),
  rate = 0.05,
  output = "audit"
)
#> # A tibble: 3 × 6
#>    time remaining_time cash_flow discount_factor present_value
#>   <dbl>          <dbl>     <dbl>           <dbl>         <dbl>
#> 1     1              1       100           0.952          95.2
#> 2     2              2       100           0.907          90.7
#> 3     3              3      1100           0.864         950. 
#> # ℹ 1 more variable: convexity_contribution <dbl>
```
