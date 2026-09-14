# Compute portfolio duration as a market-value-weighted average

Computes portfolio duration from individual position durations using
present values, prices, or market values as weights, using compact
actuarial notation.

## Usage

``` r
portfolio_duration(
  .data = NULL,
  portfolio_id = NULL,
  P = NULL,
  D = NULL,
  col_portfolio = "portfolio_id",
  col_P = "P",
  col_D = "D",
  .out = "D_P",
  .out_value = "P_total",
  .out_n = "n_positions",
  .na = c("propagate", "error", "drop"),
  ...
)
```

## Arguments

- .data:

  A data.frame or tibble. If `NULL`, `P` and `D` must be supplied as
  vectors.

- portfolio_id:

  Optional vector of portfolio identifiers when `.data = NULL`. If
  omitted, all positions are treated as belonging to a single portfolio.

- P:

  Numeric vector of present values, prices, or market values when
  `.data = NULL`.

- D:

  Numeric vector of individual durations when `.data = NULL`.

- col_portfolio:

  Name of the portfolio identifier column. If `NULL`, all rows are
  treated as one portfolio.

- col_P:

  Name of the numeric column containing present values, prices, or
  market values.

- col_D:

  Name of the numeric column containing individual durations.

- .out:

  Name of the output column containing portfolio duration.

- .out_value:

  Name of the output column containing total portfolio value.

- .out_n:

  Name of the output column containing the number of positions used in
  the calculation.

- .na:

  NA handling policy: `"propagate"`, `"error"`, or `"drop"`.

- ...:

  Transitional compatibility for older calls using `market_value`,
  `duration`, `col_market_value`, and `col_duration`. These names are
  mapped to `P`, `D`, `col_P`, and `col_D`.

## Value

A tibble with one row per portfolio and columns for portfolio duration,
total portfolio value, and number of positions used.

## Details

This is a summarise-style tibble-first function. Each input row
represents one position, and each output row represents one portfolio.

The function does not compute individual durations from bond terms or
yields. Instead, it assumes that the input duration column already
contains valid duration measures on a common basis within each
portfolio.

The portfolio duration is computed as: \$\$D_P = \frac{\sum\_{j=1}^r P_j
D_j}{\sum\_{j=1}^r P_j}\$\$ where \\P_j\\ is the present value, price,
or market value of position \\j\\, and \\D_j\\ is its duration.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `P` denotes price, present value, or market value, and
`D` denotes duration.

The function is deliberately agnostic about the duration convention, but
all individual durations must be expressed on the same basis within each
portfolio. For example, do not mix Macaulay durations in years with
durations measured in coupon periods.

## References

Marcel B. Finan, *A Basic Course in the Theory of Interest and
Derivatives Markets: A Preparation for the Actuarial Exam FM/2*, Section
54: Macaulay and Modified Durations.

Kellison, S. G. *The Theory of Interest*, Chapter 11: Duration,
Convexity and Immunization.

## See also

[`portfolio_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md)

## Examples

``` r
# Simple example: one portfolio
portfolio_duration(
  P = c(1000, 2000, 500),
  D = c(7, 5, 10)
)
#> # A tibble: 1 × 3
#>     D_P P_total n_positions
#>   <dbl>   <dbl>       <int>
#> 1  6.29    3500           3

# Medium example: two portfolios
positions <- tibble::tibble(
  portfolio_id = c("A", "A", "B", "B"),
  P = c(1000, 2000, 1000 / 1.08^2, 1000 / 1.08^4),
  D = c(7, 5, 2, 4)
)

portfolio_duration(
  positions,
  col_portfolio = "portfolio_id",
  col_P = "P",
  col_D = "D"
)
#> # A tibble: 2 × 4
#>   portfolio_id   D_P P_total n_positions
#>   <chr>        <dbl>   <dbl>       <int>
#> 1 A             5.67   3000            2
#> 2 B             2.92   1592.           2
```
