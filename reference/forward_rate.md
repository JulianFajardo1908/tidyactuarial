# Compute an implied forward rate from a discrete spot curve

Returns the annual effective forward rate implied between two maturities
from a discrete yield curve stored in tibble-first format, using compact
actuarial notation.

## Usage

``` r
forward_rate(
  .data = NULL,
  t = NULL,
  i = NULL,
  t_start = NULL,
  t_end = NULL,
  col_t = "t",
  col_i = "i",
  col_t_start = "t_start",
  col_t_end = "t_end",
  i_type = "effective",
  m = 1L,
  method = c("exact", "linear"),
  plot = FALSE,
  .out = "f",
  .out_plot = "forward_rate_plot",
  .keep = c("all", "used", "none"),
  .na = c("propagate", "error", "drop")
)
```

## Arguments

- .data:

  A data.frame or tibble. If `NULL`, `t`, `i`, `t_start`, and `t_end`
  must be supplied.

- t:

  Numeric vector of maturities in years when `.data = NULL`.

- i:

  Numeric vector of spot-rate values when `.data = NULL`.

- t_start:

  Numeric scalar giving the start maturity when `.data = NULL`.

- t_end:

  Numeric scalar giving the end maturity when `.data = NULL`.

- col_t:

  Name of the list-column containing maturities.

- col_i:

  Name of the list-column containing spot rates.

- col_t_start:

  Name of the numeric column containing the start maturity.

- col_t_end:

  Name of the numeric column containing the end maturity.

- i_type:

  Character vector indicating the spot-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`. May have length 1 or the same length as each curve.

- m:

  Positive integer vector giving the conversion frequency for nominal
  spot rates. May have length 1 or the same length as each curve.

- method:

  Spot extraction method: `"exact"` or `"linear"`.

- plot:

  Logical; if `TRUE`, adds a list-column of `ggplot2` objects.

- .out:

  Name of the output column containing the forward rate.

- .out_plot:

  Name of the output list-column containing `ggplot2` objects. Used only
  if `plot = TRUE`.

- .keep:

  One of `"all"`, `"used"`, or `"none"`.

- .na:

  NA handling policy: `"propagate"`, `"error"`, or `"drop"`.

## Value

A tibble. By default it returns the original columns plus a new numeric
column named by `.out`. If `plot = TRUE`, it also adds a list-column
named by `.out_plot` containing `ggplot2` objects.

## Details

Each row is treated as one curve. For tibble input, `col_t` and `col_i`
must be list-columns of equal-length numeric vectors, and `col_t_start`
and `col_t_end` must be numeric columns giving the forward interval for
each row.

The implied forward rate is computed from the standardized annual
effective spot curve through:
\$\$(1+i_1)^{t_1}(1+f)^{t_2-t_1}=(1+i_2)^{t_2}\$\$ so that
\$\$f\_{t_1,t_2} =
\left(\frac{(1+i_2)^{t_2}}{(1+i_1)^{t_1}}\right)^{1/(t_2-t_1)} - 1.\$\$

Two extraction methods are supported for the spot rates:

- `"exact"`: requires that `t_start` and `t_end` match curve nodes.

- `"linear"`: uses linear interpolation between adjacent nodes.

No extrapolation is performed outside the observed maturity range.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `t` denotes maturity, `i` denotes the spot rate,
`i_type` denotes the interest-rate type, and `m` denotes the conversion
frequency for nominal spot rates. The output column `f` denotes the
implied annual effective forward rate.

Spot-rate inputs are converted to annual effective form using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)
before interpolation and forward-rate calculation.

## References

Marcel B. Finan, *A Basic Course in the Theory of Interest and
Derivatives Markets: A Preparation for the Actuarial Exam FM/2*, Section
53: The Term Structure of Interest Rates and Yield Curves.

Kellison, S. G. *The Theory of Interest*, Chapter 10: The Term Structure
of Interest Rates.

## See also

[`yield_curve`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md),
[`discount_factor_spot`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

## Examples

``` r
# Simple example: exact forward rate
forward_rate(
  t = c(1, 2, 3, 4, 5),
  i = c(0.040, 0.045, 0.048, 0.050, 0.051),
  t_start = 2,
  t_end = 5
)
#> # A tibble: 1 × 7
#>   t         i         t_start t_end      f i_start i_end
#>   <list>    <list>      <dbl> <dbl>  <dbl>   <dbl> <dbl>
#> 1 <dbl [5]> <dbl [5]>       2     5 0.0550   0.045 0.051

# Interpolated forward rates for multiple curves
curves <- tibble::tibble(
  curve_id = c("A", "B"),
  t = list(c(1, 2, 3, 5), c(1, 3, 5, 7)),
  i = list(c(0.04, 0.05, 0.055, 0.06),
           c(0.03, 0.035, 0.04, 0.045)),
  t_start = c(2, 2),
  t_end = c(4, 6)
)

forward_rate(
  curves,
  method = "linear",
  plot = TRUE
)
#> # A tibble: 2 × 9
#>   curve_id t         i     t_start t_end      f i_start  i_end forward_rate_plot
#>   <chr>    <list>    <lis>   <dbl> <dbl>  <dbl>   <dbl>  <dbl> <list>           
#> 1 A        <dbl [4]> <dbl>       2     4 0.0651  0.05   0.0575 <ggplt2::>       
#> 2 B        <dbl [4]> <dbl>       2     6 0.0475  0.0325 0.0425 <ggplt2::>       

# Nominal annual spot rates convertible semiannually
forward_rate(
  t = c(1, 2, 3),
  i = c(0.05, 0.055, 0.06),
  i_type = "nominal_interest",
  m = 2,
  t_start = 1,
  t_end = 3
)
#> # A tibble: 1 × 7
#>   t         i         t_start t_end      f i_start  i_end
#>   <list>    <list>      <dbl> <dbl>  <dbl>   <dbl>  <dbl>
#> 1 <dbl [3]> <dbl [3]>       1     3 0.0661  0.0506 0.0609
```
