# Build an annual commutation table (discrete ages)

The function builds annual commutation columns from `x`, `lx`, and an
interest-rate specification. The interest rate is converted internally
to an annual effective rate before constructing the discount factor.

## Usage

``` r
commutation_table(lt, i, i_type = "effective", m = 1L, check = TRUE)
```

## Arguments

- lt:

  A life table object as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).
  It must contain columns `x` and `lx`. If available, `qx` or `px` may
  also be present, but `dx` is computed robustly from successive values
  of `lx`.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

- check:

  Logical. If `TRUE`, performs basic input checks.

## Value

A tibble with columns `x`, `lx`, `dx`, `v`, `Dx`, `Nx`, `Sx`, `Cx`,
`Mx`, and `Rx`.

## Details

Constructs classical annual commutation functions \\D_x\\, \\N_x\\,
\\S_x\\, \\C_x\\, \\M_x\\, and \\R_x\\ from a life table defined at
integer ages, using compact actuarial notation.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `lt` is the life table, `i` is the interest-rate input,
`i_type` is the interest-rate type, and `m` is the conversion frequency
for nominal rates.

The annual effective rate is obtained through
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).
If \\i_e\\ denotes the annual effective rate, then \$\$v =
\frac{1}{1+i_e}.\$\$

The annual deaths are computed as \$\$d_x = l_x - l\_{x+1},\$\$ closing
the table with \\l\_{\omega+1}=0\\. The main commutation functions are
then computed as \$\$D_x = v^x l_x, \qquad C_x = v^{x+1} d_x,\$\$ with
reverse cumulative sums used to obtain \\N_x\\, \\S_x\\, \\M_x\\, and
\\R_x\\.

## Examples

``` r
lt <- data.frame(
  x = 60:65,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000)
)

commutation_table(
  lt = lt,
  i = 0.05
)
#> # A tibble: 6 × 10
#>       x     lx    dx     v    Dx     Nx     Sx     Cx    Mx     Rx
#>   <int>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl> <dbl>  <dbl>
#> 1    60 100000  1000 0.952 5354. 27423. 90450.   51.0 4048. 23116.
#> 2    61  99000  1500 0.952 5048. 22070. 63026.   72.8 3997. 19069.
#> 3    62  97500  2000 0.952 4734. 17022. 40956.   92.5 3924. 15072.
#> 4    63  95500  2500 0.952 4416. 12288. 23934.  110.  3831. 11148.
#> 5    64  93000  3000 0.952 4096.  7871. 11646.  126.  3721.  7317.
#> 6    65  90000 90000 0.952 3775.  3775.  3775. 3595.  3595.  3595.

commutation_table(
  lt = lt,
  i = 0.06,
  i_type = "nominal_interest",
  m = 12
)
#> # A tibble: 6 × 10
#>       x     lx    dx     v    Dx     Nx     Sx     Cx    Mx     Rx
#>   <int>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl> <dbl>  <dbl>
#> 1    60 100000  1000 0.942 2757. 13771. 44982.   26.0 1957. 11157.
#> 2    61  99000  1500 0.942 2571. 11014. 31211.   36.7 1931.  9200.
#> 3    62  97500  2000 0.942 2385.  8443. 20198.   46.1 1894.  7269.
#> 4    63  95500  2500 0.942 2200.  6058. 11755.   54.3 1848.  5375.
#> 5    64  93000  3000 0.942 2018.  3858.  5697.   61.3 1794.  3527.
#> 6    65  90000 90000 0.942 1840.  1840.  1840. 1733.  1733.  1733.
```
