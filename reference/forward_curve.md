# Construct a forward-rate curve from spot rates

Computes the annual effective forward rates for every consecutive
interval implied by an observed spot yield curve. Unlike
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
which evaluates a selected interval, `forward_curve()` returns the
complete adjacent-interval schedule in a tidy, long-format tibble.

## Usage

``` r
forward_curve(
  .data = NULL,
  t = NULL,
  i = NULL,
  col_t = "t",
  col_i = "i",
  col_curve = NULL,
  i_type = "effective",
  m = 1L,
  include_origin = TRUE
)
```

## Arguments

- .data:

  Optional data frame or tibble containing spot maturities and rates, in
  numeric columns or corresponding list-columns.

- t:

  Numeric vector of maturities in years if `.data = NULL`.

- i:

  Numeric vector of spot rates if `.data = NULL`.

- col_t:

  Name of the maturity column in `.data`.

- col_i:

  Name of the spot-rate column in `.data`.

- col_curve:

  Optional name of a curve-identifier column in `.data`. Required to
  distinguish multiple curves stored as numeric node rows; optional for
  list-column input.

- i_type:

  Spot-rate convention: `"effective"`, `"nominal_interest"`,
  `"nominal_discount"` or `"force"`. Scalar for multiple curves, or
  scalar/nodewise for a single curve.

- m:

  Conversion frequency for nominal rates. A positive integer; scalar for
  multiple curves, or scalar/nodewise for one curve.

- include_origin:

  Logical scalar. If `TRUE` (default), include the initial interval from
  time zero when the first observed node is positive.

## Value

A tibble, with one row per forward interval and columns `curve`,
`t_start`, `t_end`, `duration`, `v_start`, `v_end`, and `f`. `f` is an
annual effective forward rate and `duration` is measured in years.

## Details

Let \\0=t_0\<t_1\<\cdots\<t_n\\ denote maturities, and let \\v(t_j)\\ be
their spot discount factors. For each consecutive interval,
\$\$(1+f\_{t\_{j-1},t_j})^{t_j-t\_{j-1}}=
\frac{v(t\_{j-1})}{v(t_j)},\$\$ so the annual effective forward rate is
\$\$f\_{t\_{j-1},t_j}=\left(
\frac{v(t\_{j-1})}{v(t_j)}\right)^{1/(t_j-t\_{j-1})}-1.\$\$ The function
evaluates log discount-factor ratios from original log spot growth
rates, retaining small rates even when reported discounts round to 1.
Equal spot log rates are preserved across intervals with a large common
origin. Discount factors are obtained from the existing
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md)
function, which standardizes the chosen interest-rate convention.
Negative spot and forward rates are supported when the discount factors
are positive and finite.

With `include_origin = TRUE`, the first interval starts at time zero and
uses the exact identity \\v(0)=1\\. A supplied zero-maturity node is
retained without duplication. With `include_origin = FALSE`, only
intervals between supplied nodes are returned.

Maturities are sorted within each curve. Repeated, nonfinite or negative
maturities, missing or nonfinite rates, and invalid discount factors are
rejected. No interpolation, extrapolation, curve fitting or forward-rate
forecast is performed. Intervals may have unequal lengths.
Spot-to-forward relationships represent no-arbitrage implications of the
supplied discount factors, not predictions of realized future rates.

Accepted input shapes are: direct numeric `t` and `i` vectors; a data
frame with numeric `t` and `i` columns (one node per row, optionally
partitioned using `col_curve`); or a data frame with `t` and `i`
list-columns (one complete curve per row), such as
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)
output. Each curve produces one or more rows. `curve` is a character
identifier: an ID from `col_curve`, or the input curve's sequential
number if no ID is supplied. If more than one curve is supplied,
`i_type` and `m` must be scalars; for a single curve they can instead
have one value per node.

## See also

[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`bootstrap_spot_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bootstrap_spot_curve.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`bootstrap_spot_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bootstrap_spot_curve.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`par_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/par_rate.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
# A forward curve for consecutive annual spot maturities.
forward_curve(t = 1:3, i = c(0.04, 0.045, 0.05))
#> # A tibble: 3 × 7
#>   curve t_start t_end duration v_start v_end      f
#>   <chr>   <dbl> <dbl>    <dbl>   <dbl> <dbl>  <dbl>
#> 1 1           0     1        1   1     0.962 0.04  
#> 2 1           1     2        1   0.962 0.916 0.0500
#> 3 1           2     3        1   0.916 0.864 0.0601

# The output of yield_curve() can be used directly in a pipe.
yield_curve(t = c(1, 2, 3), i = c(0.04, 0.045, 0.05)) |>
  forward_curve()
#> # A tibble: 3 × 7
#>   curve t_start t_end duration v_start v_end      f
#>   <chr>   <dbl> <dbl>    <dbl>   <dbl> <dbl>  <dbl>
#> 1 1           0     1        1   1     0.962 0.04  
#> 2 1           1     2        1   0.962 0.916 0.0500
#> 3 1           2     3        1   0.916 0.864 0.0601

# Multiple curves, using tidyverse-friendly list-columns.
tibble::tibble(
  scenario = c("base", "stress"),
  t = list(c(1, 2, 3), c(1, 3, 5)),
  i = list(c(0.04, 0.045, 0.05), c(0.05, 0.055, 0.06))
) |>
  forward_curve(col_curve = "scenario")
#> # A tibble: 6 × 7
#>   curve  t_start t_end duration v_start v_end      f
#>   <chr>    <dbl> <dbl>    <dbl>   <dbl> <dbl>  <dbl>
#> 1 base         0     1        1   1     0.962 0.04  
#> 2 base         1     2        1   0.962 0.916 0.0500
#> 3 base         2     3        1   0.916 0.864 0.0601
#> 4 stress       0     1        1   1     0.952 0.05  
#> 5 stress       1     3        2   0.952 0.852 0.0575
#> 6 stress       3     5        2   0.852 0.747 0.0675
```
