# Compute portfolio convexity as a market-value-weighted average

Computes portfolio convexity from individual position convexities using
present values or market values as weights, using compact actuarial
notation.

## Usage

``` r
portfolio_convexity(
  .data = NULL,
  portfolio_id = NULL,
  P = NULL,
  C = NULL,
  col_portfolio = "portfolio_id",
  col_P = "P",
  col_C = "C",
  .out = "C_P",
  .out_value = "P_total",
  .out_n = "n_positions",
  .na = c("propagate", "error", "drop"),
  ...
)
```

## Arguments

- .data:

  A data.frame or tibble. If `NULL`, `P` and `C` must be supplied as
  vectors.

- portfolio_id:

  Optional vector of portfolio identifiers when `.data = NULL`. If
  omitted, all positions are treated as belonging to a single portfolio.

- P:

  Numeric vector of present values, prices, or market values when
  `.data = NULL`.

- C:

  Numeric vector of individual convexities when `.data = NULL`.

- col_portfolio:

  Name of the portfolio identifier column. If `NULL`, all rows are
  treated as one portfolio.

- col_P:

  Name of the numeric column containing present values, prices, or
  market values.

- col_C:

  Name of the numeric column containing individual convexities.

- .out:

  Name of the output column containing portfolio convexity.

- .out_value:

  Name of the output column containing total portfolio value.

- .out_n:

  Name of the output column containing the number of positions used in
  the calculation.

- .na:

  NA handling policy: `"propagate"`, `"error"`, or `"drop"`.

- ...:

  Transitional compatibility for older calls using `market_value`,
  `convexity`, `col_market_value`, and `col_convexity`. These names are
  mapped to `P`, `C`, `col_P`, and `col_C`.

## Value

A tibble with one row per portfolio and columns for portfolio convexity,
total portfolio value, and number of positions used.

## Details

This is a summarise-style tibble-first function. Each input row
represents one position, and each output row represents one portfolio.

The function does not compute individual convexities from bond terms or
yields. Instead, it assumes that the input convexity column already
contains valid convexity measures on a common basis within each
portfolio.

The portfolio convexity is computed as: \$\$C_P = \frac{\sum\_{j=1}^r
P_j C_j}{\sum\_{j=1}^r P_j}\$\$ where \\P_j\\ is the present value or
market value of position \\j\\, and \\C_j\\ is its convexity.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `P` denotes price, present value, or market value, and
`C` denotes convexity.

The function is deliberately agnostic about the convexity convention,
but all individual convexities must be expressed on the same basis
within each portfolio. For example, do not mix convexities measured in
coupon periods with convexities measured in years.

## References

Marcel B. Finan, *A Basic Course in the Theory of Interest and
Derivatives Markets: A Preparation for the Actuarial Exam FM/2*, Section
55: Redington Immunization and Convexity.

Kellison, S. G. *The Theory of Interest*, Chapter 11: Duration,
Convexity and Immunization.

## See also

[`portfolio_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
# Simple example: one portfolio
portfolio_convexity(
  P = c(1000, 2000, 500),
  C = c(20, 12, 35)
)
#> # A tibble: 1 × 3
#>     C_P P_total n_positions
#>   <dbl>   <dbl>       <int>
#> 1  17.6    3500           3

# Medium example: two portfolios
positions <- tibble::tibble(
  portfolio_id = c("A", "A", "B", "B"),
  P = c(1000, 2000, 1000 / 1.08^2, 1000 / 1.08^4),
  C = c(20, 12, 6, 18)
)

portfolio_convexity(
  positions,
  col_portfolio = "portfolio_id",
  col_P = "P",
  col_C = "C"
)
#> # A tibble: 2 × 4
#>   portfolio_id   C_P P_total n_positions
#>   <chr>        <dbl>   <dbl>       <int>
#> 1 A             14.7   3000            2
#> 2 B             11.5   1592.           2
```
