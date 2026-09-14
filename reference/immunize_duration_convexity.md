# Duration and convexity immunization with multiple assets

Computes asset weights that immunize a stream of liabilities using three
or more assets, enforcing:

1.  present value of assets = present value of liabilities;

2.  Macaulay duration of assets = Macaulay duration of liabilities;

3.  convexity of assets = convexity of liabilities.

## Usage

``` r
immunize_duration_convexity(L, t, P, D, C, i, i_type = "effective", m = 1L)
```

## Arguments

- L:

  Numeric vector with liability payments.

- t:

  Numeric vector of the same length as `L`, giving the times at which
  each liability payment occurs.

- P:

  Numeric vector with present values or prices of the immunizing assets,
  evaluated on the same yield basis.

- D:

  Numeric vector with the Macaulay duration of each asset, expressed in
  the same time units as `t`.

- C:

  Numeric vector with the discrete convexity of each asset, expressed in
  the same time units as `t`.

- i:

  Numeric scalar. Interest-rate input used to discount the liabilities.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

## Value

A tibble with:

- w:

  Numeric vector of asset weights or units.

- PV_L:

  Present value of the liabilities.

- D_L:

  Macaulay duration of the liabilities.

- C_L:

  Discrete convexity of the liabilities.

- PV_A:

  Present value of the asset portfolio.

- D_A:

  Macaulay duration of the asset portfolio.

- C_A:

  Discrete convexity of the asset portfolio.

- n_assets:

  Number of assets used.

## Details

For exactly three assets, the system is solved directly. For four or
more assets, a minimum-norm solution is computed by linear algebra.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `L` denotes liabilities, `t` denotes payment times, `P`
denotes asset prices or present values, `D` denotes asset durations, `C`
denotes asset convexities, `i` denotes the interest rate, `i_type`
denotes the interest-rate type, and `m` denotes the conversion frequency
for nominal rates.

Let \\PV_L\\, \\D_L\\, and \\C_L\\ be the present value, Macaulay
duration, and discrete convexity of the liability stream at yield \\i\\.
The discrete convexity of the liabilities is computed as: \$\$ C_L =
\frac{\sum_t L_t\\t(t+1)\\v^{t+2}}{PV_L}, \$\$ where \\v = 1/(1+i)\\
after converting `i` to the equivalent effective rate.

The weights \\w_j\\ satisfy the \\3 \times r\\ system \\Aw = b\\, where
the rows of \\A\\ are \$\$(P_1,\ldots,P_r),\$\$
\$\$(P_1D_1,\ldots,P_rD_r),\$\$ and \$\$(P_1C_1,\ldots,P_rC_r),\$\$ and
\$\$ b = (PV_L,\\ PV_LD_L,\\ PV_LC_L)^T. \$\$

For three assets, the system is square and solved directly. For four or
more assets, the minimum-norm solution \$\$ w = A^T(AA^T)^{-1}b \$\$ is
computed.

## See also

[`immunize_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md)

Other immunization:
[`immunize_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration.md),
[`plot_immunization_gap()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_immunization_gap.md)

## Examples

``` r
# Three-asset immunization
immunize_duration_convexity(
  L = c(5000, 8000, 10000),
  t = c(3, 5, 7),
  P = c(100, 150, 200),
  D = c(2, 5, 8),
  C = c(6, 30, 72),
  i = 0.05
)
#> # A tibble: 3 × 8
#>         w   PV_L   D_L   C_L   PV_A   D_A   C_A n_assets
#>     <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>    <int>
#> 1 -16.8   17694.  5.32  32.7 17694.  5.32  32.7        3
#> 2 128.    17694.  5.32  32.7 17694.  5.32  32.7        3
#> 3   0.869 17694.  5.32  32.7 17694.  5.32  32.7        3

# Four-asset immunization: minimum-norm solution
immunize_duration_convexity(
  L = c(5000, 8000, 10000),
  t = c(3, 5, 7),
  P = c(100, 120, 150, 200),
  D = c(2, 4, 6, 8),
  C = c(6, 20, 42, 72),
  i = 0.05
)
#> # A tibble: 4 × 8
#>        w   PV_L   D_L   C_L   PV_A   D_A   C_A n_assets
#>    <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>    <int>
#> 1 -19.5  17694.  5.32  32.7 17694.  5.32  32.7        4
#> 2  66.7  17694.  5.32  32.7 17694.  5.32  32.7        4
#> 3  90.7  17694.  5.32  32.7 17694.  5.32  32.7        4
#> 4  -9.80 17694.  5.32  32.7 17694.  5.32  32.7        4

# Nominal annual interest rate convertible monthly
immunize_duration_convexity(
  L = c(5000, 8000, 10000),
  t = c(3, 5, 7),
  P = c(100, 150, 200),
  D = c(2, 5, 8),
  C = c(6, 30, 72),
  i = 0.06,
  i_type = "nominal_interest",
  m = 12
)
#> # A tibble: 3 × 8
#>        w   PV_L   D_L   C_L   PV_A   D_A   C_A n_assets
#>    <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>    <int>
#> 1 -21.5  16687.  5.29  31.7 16687.  5.29  31.7        3
#> 2 129.   16687.  5.29  31.7 16687.  5.29  31.7        3
#> 3  -2.74 16687.  5.29  31.7 16687.  5.29  31.7        3
```
