# Duration of a general cash-flow stream

Computes the Macaulay or modified duration of a general cash-flow stream
at a specified valuation time.

## Usage

``` r
duration_cash_flow(
  cf,
  t,
  rate,
  valuation_time = 0,
  duration = c("macaulay", "modified"),
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

- duration:

  Character scalar indicating the duration measure: `"macaulay"` or
  `"modified"`.

- output:

  Character scalar indicating the returned object: `"value"` returns the
  selected duration as a numeric scalar; `"audit"` returns a detailed
  tibble.

## Value

If `output = "value"`, a numeric scalar.

If `output = "audit"`, a tibble with six columns: `time`,
`remaining_time`, `cash_flow`, `discount_factor`, `present_value`, and
`duration_contribution`.

## Details

Let \\\tau\\ be the valuation time. Under an effective yield \\i\\, the
value of the remaining cash-flow stream is

\$\$ P\_{\tau} = \sum\_{j:t_j\>\tau} C_j(1+i)^{-(t_j-\tau)}. \$\$

The Macaulay duration measured from \\\tau\\ is

\$\$ D\_{\mathrm{Mac},\tau} = \frac{ \sum\_{j:t_j\>\tau}
(t_j-\tau)C_j(1+i)^{-(t_j-\tau)} }{ P\_{\tau} }. \$\$

The modified duration with respect to the effective yield is

\$\$ D\_{\mathrm{mod},\tau} = \frac{D\_{\mathrm{Mac},\tau}}{1+i}. \$\$

The function follows an ex-cash-flow convention: cash flows occurring
exactly at `valuation_time` are excluded. Therefore, the result
represents duration immediately after any cash flow paid at that time.

For streams containing both positive and negative cash flows, duration
remains a yield-sensitivity measure, but it may not have the usual
interpretation as a weighted-average payment time.

## Examples

``` r
duration_cash_flow(
  cf = c(100, 100, 1100),
  t = c(1, 2, 3),
  rate = 0.05
)
#> [1] 2.752519

duration_cash_flow(
  cf = c(100, 100, 1100),
  t = c(1, 2, 3),
  rate = 0.05,
  duration = "modified"
)
#> [1] 2.621446

duration_cash_flow(
  cf = c(100, 100, 1100),
  t = c(1, 2, 3),
  rate = 0.05,
  valuation_time = 1,
  output = "audit"
)
#> # A tibble: 2 × 6
#>    time remaining_time cash_flow discount_factor present_value
#>   <dbl>          <dbl>     <dbl>           <dbl>         <dbl>
#> 1     2              1       100           0.952          95.2
#> 2     3              2      1100           0.907         998. 
#> # ℹ 1 more variable: duration_contribution <dbl>
```
