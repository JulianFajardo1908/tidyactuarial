# SOA Illustrative Life Table

This dataset is intended for reproducible examples, internal validation,
and benchmark tests for life-contingency functions such as
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`reserve_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
and
[`reserve_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md).

## Usage

``` r
soa08lt
```

## Format

A tibble with one row per integer age and the following columns:

- x:

  Integer actuarial age.

- lx:

  Number of lives surviving to exact age `x`.

- dx:

  Number of deaths between exact ages `x` and `x + 1`.

- qx:

  One-year probability of death between exact ages `x` and `x + 1`.

- px:

  One-year probability of survival from exact age `x` to `x + 1`.

## Source

Society of Actuaries illustrative life table, commonly referenced in
Bowers et al. (1997), *Actuarial Mathematics*, Appendix 2A.

## Details

A tidy version of the Society of Actuaries illustrative life table
commonly used in life-contingencies examples and benchmark calculations.

The table is included as a convenient benchmark table for actuarial
calculations. The build script in `data-raw/soa08lt.R` constructs this
tidy dataset from the SOA illustrative actuarial table object
distributed in the `lifecontingencies` package.

The column names already follow the compact actuarial notation used in
`tidyactuarial`: `x` for age, `lx` for lives, `dx` for deaths, `qx` for
one-year death probability, and `px` for one-year survival probability.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*. Second edition. Society of
Actuaries.

Spedicato, G. A. (2013). The `lifecontingencies` package: performing
financial and actuarial mathematics calculations in R.

## Examples

``` r
data(soa08lt)
head(soa08lt)
#> # A tibble: 6 × 5
#>       x      lx     dx       qx    px
#>   <int>   <dbl>  <dbl>    <dbl> <dbl>
#> 1     0 100000  2042.  0.0204   0.980
#> 2     1  97958.  132.  0.00134  0.999
#> 3     2  97826.  120.  0.00122  0.999
#> 4     3  97707.  110.  0.00112  0.999
#> 5     4  97597.  102.  0.00104  0.999
#> 6     5  97495.   95.3 0.000977 0.999

annuity_x(
  lt = soa08lt,
  x = 65,
  i = 0.06,
  timing = "due"
)
#> [1] 9.896928
```
