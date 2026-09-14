# Duration-based immunization with multiple assets

Computes asset weights that duration-immunize a stream of liabilities
using two or more assets, using compact actuarial notation.

## Usage

``` r
immunize_duration(L, t, P, D, i, i_type = "effective", m = 1L)
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

- PV_A:

  Present value of the immunized asset portfolio.

- D_A:

  Macaulay duration of the asset portfolio.

- n_assets:

  Number of assets used.

## Details

The method enforces:

1.  present value of assets = present value of liabilities;

2.  Macaulay duration of assets = Macaulay duration of liabilities.

For exactly two assets, a closed-form solution is used. For three or
more assets, a minimum-norm solution is computed by linear algebra.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `L` denotes liabilities, `t` denotes payment times, `P`
denotes asset prices or present values, `D` denotes asset durations, `i`
denotes the interest rate, `i_type` denotes the interest-rate type, and
`m` denotes the conversion frequency for nominal rates.

Let \\PV_L\\ and \\D_L\\ be the present value and Macaulay duration of
the liability stream at yield \\i\\. Let \\P_j\\ and \\D_j\\ be the
price and duration of asset \\j\\. The weights \\w_j\\ are chosen so
that:

\$\$\sum_j w_j P_j = PV_L\$\$

and

\$\$ \frac{\sum_j w_j P_j D_j}{\sum_j w_j P_j} = D_L. \$\$

For two assets, the closed-form solution is:

\$\$ w_1 = \frac{PV_L(D_L - D_2)}{P_1(D_1 - D_2)}, \qquad w_2 =
\frac{PV_L - w_1 P_1}{P_2}. \$\$

For three or more assets, the minimum-norm solution of the linear system
\\Aw = b\\ is computed, where \\A\\ is a \\2 \times r\\ matrix with rows

\$\$(P_1,\ldots,P_r)\$\$

and

\$\$(P_1D_1,\ldots,P_rD_r),\$\$

and

\$\$b = (PV_L, PV_LD_L)^T.\$\$

## See also

[`immunize_duration_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration_convexity.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md)

Other immunization:
[`immunize_duration_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration_convexity.md),
[`plot_immunization_gap()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_immunization_gap.md)

## Examples

``` r
# Two-asset immunization
immunize_duration(
  L = c(5000, 8000),
  t = c(3, 7),
  P = c(100, 200),
  D = c(3, 7),
  i = 0.05
)
#> # A tibble: 2 × 6
#>       w   PV_L   D_L   PV_A   D_A n_assets
#>   <dbl>  <dbl> <dbl>  <dbl> <dbl>    <int>
#> 1  43.2 10005.  5.27 10005.  5.27        2
#> 2  28.4 10005.  5.27 10005.  5.27        2

# Three-asset immunization: minimum-norm solution
immunize_duration(
  L = c(5000, 8000),
  t = c(3, 7),
  P = c(100, 150, 200),
  D = c(2, 5, 8),
  i = 0.05
)
#> # A tibble: 3 × 6
#>       w   PV_L   D_L   PV_A   D_A n_assets
#>   <dbl>  <dbl> <dbl>  <dbl> <dbl>    <int>
#> 1  25.9 10005.  5.27 10005.  5.27        3
#> 2  26.0 10005.  5.27 10005.  5.27        3
#> 3  17.5 10005.  5.27 10005.  5.27        3

# Nominal annual interest rate convertible monthly
immunize_duration(
  L = c(5000, 8000),
  t = c(3, 7),
  P = c(100, 200),
  D = c(3, 7),
  i = 0.06,
  i_type = "nominal_interest",
  m = 12
)
#> # A tibble: 2 × 6
#>       w  PV_L   D_L  PV_A   D_A n_assets
#>   <dbl> <dbl> <dbl> <dbl> <dbl>    <int>
#> 1  41.8 9440.  5.23 9440.  5.23        2
#> 2  26.3 9440.  5.23 9440.  5.23        2
```
