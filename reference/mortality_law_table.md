# Generate a tidy life table from a theoretical mortality law

Creates a tidy life table with one row per integer age from a parametric
mortality law, using compact actuarial notation.

## Usage

``` r
mortality_law_table(
  law = c("Exponential", "Gompertz", "Makeham", "Weibull", "Logistic", "DeMoivre",
    "Beta", "HeligmanPollard"),
  x_min,
  x_max,
  ...,
  params = NULL,
  frac = c("CF", "UDD", "Balducci", "CML"),
  l0 = 1e+05,
  close = TRUE,
  a_x = 0.5,
  check = TRUE,
  tol = 1e-10,
  radix = NULL,
  ax = NULL
)
```

## Arguments

- law:

  Character. Mortality law. One of `"Exponential"`, `"Gompertz"`,
  `"Makeham"`, `"Weibull"`, `"Logistic"`, `"DeMoivre"`, `"Beta"`, or
  `"HeligmanPollard"`.

- x_min:

  Integer. Minimum age, inclusive.

- x_max:

  Integer. Maximum age, inclusive. Must satisfy `x_min < x_max`.

- ...:

  Named law parameters. These values override `params`. Placing `...`
  before arguments such as `close` and `check` avoids partial-matching
  conflicts with the Gompertz and Makeham parameter `c`.

- params:

  Named list of law parameters, or `NULL`.

- frac:

  Character. Within-year interpolation label, independent of the annual
  probability calculation. One of `"CF"`, `"UDD"`, `"Balducci"`, or
  `"CML"`. `"CML"` is treated as `"CF"`.

- l0:

  Numeric scalar. Initial radix, that is, the starting value
  \\l\_{x_min}\\.

- close:

  Logical. If `TRUE`, forces the last age to close.

- a_x:

  Numeric scalar. Average fraction of the year lived by those dying
  between age \\x\\ and \\x+1\\. Default is `0.5`. Exposure uses \\L_x =
  l\_{x+1} + a_x d_x\\; this is an approximation controlled by `a_x`,
  not an integration of continuous survival.

- check:

  Logical. If `TRUE`, performs strict input validation.

- tol:

  Numeric tolerance used in checks.

- radix:

  Deprecated. Use `l0`.

- ax:

  Deprecated. Use `a_x`.

## Value

A tibble with columns `x`, `law`, `frac`, `mu_x`, `qx`, `px`, `lx`,
`dx`, `Lx`, `Tx`, `ex`, and `mx`.

## Details

The output follows tidyactuarial conventions and includes columns such
as `x`, `qx`, `px`, `lx`, `dx`, `Lx`, `Tx`, `ex`, and `mx`.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `x` denotes age, `l0` denotes the starting radix, `a_x`
denotes the average fraction of the year lived by those dying during the
age interval, `qx` denotes the one-year death probability, and
`px = 1 - qx`. Ratios use their actual denominators: `mx = dx / Lx` and
`ex = Tx / lx`. Positive deaths with zero exposure give infinite `mx`;
extinct cohorts with zero numerators and denominators give `NaN` for
these undefined ratios.

Heligman-Pollard follows the eight-parameter odds specification in
Heligman and Pollard (1980), section 2.1, equation (1),
[doi:10.1017/S0020268100040257](https://doi.org/10.1017/S0020268100040257)
. Earlier seven-parameter calls must be respecified: the previous
implementation omitted the childhood exponent and assigned different
meanings to `C` through `G`.

The parameter `F_hp` is used for the Heligman-Pollard law instead of
`F`, because `F` is historically associated with `FALSE` in R and should
not be promoted in a CRAN-facing API. The old name `F` is still accepted
as a transitional alias.

## Supported laws

- **Exponential**: \\\mu_x = \lambda\\.

- **Gompertz**: \\\mu_x = Bc^x\\.

- **Makeham**: \\\mu_x = A + Bc^x\\.

- **Weibull**: \\\mu_x = (shape/scale)(x/scale)^{shape-1}\\.

- **Logistic**: \\\mu_x = (A + Bc^x)/(1 + Cc^x)\\.

- **DeMoivre**: finite lifetime law with \\q_x = 1/(\omega - x)\\ for
  \\x \< \omega\\.

- **Beta**: scaled lifetime model \\X/\omega \sim Beta(\alpha,\beta)\\.

- **HeligmanPollard**: eight-parameter odds model \\q_x/p_x =
  A^{(x+B)^C} + D\exp(-E(\log x-\log F)^2) + GH^x\\, with `F_hp`
  denoting \\F\\.

## Law parameters

Parameters for the selected law are supplied either through `...` or
through the named list `params`. Direct parameters supplied through
`...` override values in `params`.

Required parameters:

- `"Exponential"`: `lambda`.

- `"Gompertz"`: `B`, `c`.

- `"Makeham"`: `A`, `B`, `c`.

- `"Weibull"`: `shape`, `scale`. Transitional aliases `k` and `lambda`
  are accepted.

- `"Logistic"`: `A`, `B`, `c`, `C`.

- `"DeMoivre"`: `omega`.

- `"Beta"`: `alpha`, `beta`, `omega`.

- `"HeligmanPollard"`: `A`, `B`, `C`, `D`, `E`, `F_hp`, `G`, and `H`.
  `A`, `B`, `D`, and `G` must be nonnegative; `C`, `E`, `F_hp`, and `H`
  must be positive. At least one of `A`, `D`, or `G` must be positive.
  Ages must be at least 1. Transitional alias `F` is accepted and mapped
  to `F_hp`.

## Converting mu(x) to qx

For laws defined by a force of mortality \\\mu_x\\, the one-year death
probability is \\q_x = 1 - \exp(-\int_x^{x+1}\mu(s)\\ds)\\,
independently of `frac`. The column `mu_x` contains the force evaluated
at age \\x\\, not its annual integral. Exponential, Gompertz, Makeham
and Weibull use analytic integrals; Logistic uses numerical integration
with relative tolerance `1e-10`. The `frac` label records a within-year
interpolation convention; it does not replace integration of the
continuous law. Force products and Logistic ratios use logarithmic
evaluation to avoid intermediate power overflow; Weibull annual
increments use `log1p/expm1` instead of subtracting nearly equal
cumulative hazards.

## Direct qx laws

`"DeMoivre"`, `"Beta"`, and `"HeligmanPollard"` define `qx` directly.
For these laws, `frac` is not used to derive `qx`.

## Closure

If `close = TRUE`, the last age is forced to close the table by setting
`qx[x_max] = 1` and `px[x_max] = 0`.

## See also

[`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md),
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md),
[`e_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_xy.md)

## Examples

``` r
mortality_law_table("Exponential", 0, 110, lambda = 0.01)
#> # A tibble: 111 × 12
#>        x law         frac   mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>       <chr> <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     0 Exponential CF     0.01 0.00995 0.990 100000   995. 99502. 6.69e6  66.9
#>  2     1 Exponential CF     0.01 0.00995 0.990  99005.  985. 98512. 6.59e6  66.5
#>  3     2 Exponential CF     0.01 0.00995 0.990  98020.  975. 97532. 6.49e6  66.2
#>  4     3 Exponential CF     0.01 0.00995 0.990  97045.  966. 96562. 6.39e6  65.9
#>  5     4 Exponential CF     0.01 0.00995 0.990  96079.  956. 95601. 6.30e6  65.5
#>  6     5 Exponential CF     0.01 0.00995 0.990  95123.  946. 94650. 6.20e6  65.2
#>  7     6 Exponential CF     0.01 0.00995 0.990  94176.  937. 93708. 6.11e6  64.8
#>  8     7 Exponential CF     0.01 0.00995 0.990  93239.  928. 92776. 6.01e6  64.5
#>  9     8 Exponential CF     0.01 0.00995 0.990  92312.  919. 91852. 5.92e6  64.1
#> 10     9 Exponential CF     0.01 0.00995 0.990  91393.  909. 90938. 5.83e6  63.8
#> # ℹ 101 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table("Gompertz", 0, 110, B = 1e-5, c = 1.08)
#> # A tibble: 111 × 12
#>        x law      frac      mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>    <chr>    <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     0 Gompertz CF     1   e-5 1.04e-5 1.000 100000   1.04 99999. 1.03e7 103. 
#>  2     1 Gompertz CF     1.08e-5 1.12e-5 1.000  99999.  1.12 99998. 1.02e7 102. 
#>  3     2 Gompertz CF     1.17e-5 1.21e-5 1.000  99998.  1.21 99997. 1.01e7 101. 
#>  4     3 Gompertz CF     1.26e-5 1.31e-5 1.000  99997.  1.31 99996. 1.00e7 100. 
#>  5     4 Gompertz CF     1.36e-5 1.41e-5 1.000  99995.  1.41 99995. 9.93e6  99.4
#>  6     5 Gompertz CF     1.47e-5 1.53e-5 1.000  99994.  1.53 99993. 9.83e6  98.4
#>  7     6 Gompertz CF     1.59e-5 1.65e-5 1.000  99992.  1.65 99992. 9.74e6  97.4
#>  8     7 Gompertz CF     1.71e-5 1.78e-5 1.000  99991.  1.78 99990. 9.64e6  96.4
#>  9     8 Gompertz CF     1.85e-5 1.92e-5 1.000  99989.  1.92 99988. 9.54e6  95.4
#> 10     9 Gompertz CF     2.00e-5 2.08e-5 1.000  99987.  2.08 99986. 9.44e6  94.4
#> # ℹ 101 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table("Makeham", 0, 110, A = 5e-4, B = 1e-6, c = 1.10)
#> # A tibble: 111 × 12
#>        x law     frac      mu_x       qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>   <chr>    <dbl>    <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     0 Makeham CF    0.000501 0.000501 0.999 100000   50.1 99975. 1.04e7 104. 
#>  2     1 Makeham CF    0.000501 0.000501 0.999  99950.  50.1 99925. 1.03e7 103. 
#>  3     2 Makeham CF    0.000501 0.000501 0.999  99900.  50.1 99875. 1.02e7 102. 
#>  4     3 Makeham CF    0.000501 0.000501 0.999  99850.  50.1 99825. 1.01e7 101. 
#>  5     4 Makeham CF    0.000501 0.000501 0.999  99800.  50.0 99775. 9.99e6 100. 
#>  6     5 Makeham CF    0.000502 0.000502 0.999  99750.  50.0 99725. 9.89e6  99.2
#>  7     6 Makeham CF    0.000502 0.000502 0.999  99700.  50.0 99675. 9.79e6  98.2
#>  8     7 Makeham CF    0.000502 0.000502 0.999  99650.  50.0 99625. 9.69e6  97.3
#>  9     8 Makeham CF    0.000502 0.000502 0.999  99600.  50.0 99575. 9.59e6  96.3
#> 10     9 Makeham CF    0.000502 0.000502 0.999  99550.  50.0 99525. 9.50e6  95.4
#> # ℹ 101 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table("Weibull", 1, 110, shape = 2.5, scale = 90)
#> # A tibble: 110 × 12
#>        x law     frac      mu_x      qx    px      lx     dx     Lx     Tx    ex
#>    <int> <chr>   <chr>    <dbl>   <dbl> <dbl>   <dbl>  <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 Weibull CF     3.25e-5 6.06e-5 1.000 100000    6.06 99997. 7.49e6  74.9
#>  2     2 Weibull CF     9.20e-5 1.29e-4 1.000  99994.  12.9  99987. 7.39e6  73.9
#>  3     3 Weibull CF     1.69e-4 2.14e-4 1.000  99981.  21.4  99970. 7.29e6  72.9
#>  4     4 Weibull CF     2.60e-4 3.11e-4 1.000  99960.  31.1  99944. 7.19e6  71.9
#>  5     5 Weibull CF     3.64e-4 4.20e-4 1.000  99929.  42.0  99908. 7.09e6  71.0
#>  6     6 Weibull CF     4.78e-4 5.39e-4 0.999  99887.  53.9  99860. 6.99e6  70.0
#>  7     7 Weibull CF     6.03e-4 6.68e-4 0.999  99833.  66.7  99799. 6.89e6  69.0
#>  8     8 Weibull CF     7.36e-4 8.06e-4 0.999  99766.  80.4  99726. 6.79e6  68.1
#>  9     9 Weibull CF     8.78e-4 9.52e-4 0.999  99686.  94.9  99638. 6.69e6  67.1
#> 10    10 Weibull CF     1.03e-3 1.11e-3 0.999  99591. 110.   99536. 6.59e6  66.2
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table(
  "Logistic",
  0, 110,
  A = 1e-4,
  B = 1e-6,
  c = 1.10,
  C = 1e-3
)
#> # A tibble: 111 × 12
#>        x law      frac      mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>    <chr>    <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     0 Logistic CF    0.000101 1.01e-4 1.000 100000   10.1 99995. 1.09e7  109.
#>  2     1 Logistic CF    0.000101 1.01e-4 1.000  99990.  10.1 99985. 1.08e7  108.
#>  3     2 Logistic CF    0.000101 1.01e-4 1.000  99980.  10.1 99975. 1.07e7  107.
#>  4     3 Logistic CF    0.000101 1.01e-4 1.000  99970.  10.1 99965. 1.06e7  106.
#>  5     4 Logistic CF    0.000101 1.01e-4 1.000  99960.  10.1 99955. 1.05e7  105.
#>  6     5 Logistic CF    0.000101 1.02e-4 1.000  99949.  10.1 99944. 1.04e7  104.
#>  7     6 Logistic CF    0.000102 1.02e-4 1.000  99939.  10.2 99934. 1.03e7  103.
#>  8     7 Logistic CF    0.000102 1.02e-4 1.000  99929.  10.2 99924. 1.02e7  102.
#>  9     8 Logistic CF    0.000102 1.02e-4 1.000  99919.  10.2 99914. 1.01e7  101.
#> 10     9 Logistic CF    0.000102 1.02e-4 1.000  99909.  10.2 99904. 1.00e7  100.
#> # ℹ 101 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table("DeMoivre", 0, 100, omega = 100)
#> # A tibble: 101 × 12
#>        x law     frac   mu_x     qx    px     lx    dx    Lx     Tx    ex     mx
#>    <int> <chr>   <chr> <dbl>  <dbl> <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl>  <dbl>
#>  1     0 DeMoiv… NA       NA 0.01   0.99  100000  1000 99500 5   e6  50   0.0101
#>  2     1 DeMoiv… NA       NA 0.0101 0.990  99000  1000 98500 4.90e6  49.5 0.0102
#>  3     2 DeMoiv… NA       NA 0.0102 0.990  98000  1000 97500 4.80e6  49   0.0103
#>  4     3 DeMoiv… NA       NA 0.0103 0.990  97000  1000 96500 4.70e6  48.5 0.0104
#>  5     4 DeMoiv… NA       NA 0.0104 0.990  96000  1000 95500 4.61e6  48   0.0105
#>  6     5 DeMoiv… NA       NA 0.0105 0.989  95000  1000 94500 4.51e6  47.5 0.0106
#>  7     6 DeMoiv… NA       NA 0.0106 0.989  94000  1000 93500 4.42e6  47   0.0107
#>  8     7 DeMoiv… NA       NA 0.0108 0.989  93000  1000 92500 4.32e6  46.5 0.0108
#>  9     8 DeMoiv… NA       NA 0.0109 0.989  92000  1000 91500 4.23e6  46   0.0109
#> 10     9 DeMoiv… NA       NA 0.0110 0.989  91000  1000 90500 4.14e6  45.5 0.0110
#> # ℹ 91 more rows

mortality_law_table("Beta", 0, 100, alpha = 2, beta = 5, omega = 101)
#> # A tibble: 101 × 12
#>        x law   frac   mu_x      qx    px      lx    dx     Lx       Tx    ex
#>    <int> <chr> <chr> <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>    <dbl> <dbl>
#>  1     0 Beta  NA       NA 0.00143 0.999 100000   143. 99928. 2885714.  28.9
#>  2     1 Beta  NA       NA 0.00415 0.996  99857.  415. 99649. 2785786.  27.9
#>  3     2 Beta  NA       NA 0.00668 0.993  99442.  664. 99110. 2686136.  27.0
#>  4     3 Beta  NA       NA 0.00904 0.991  98778.  893. 98331. 2587026.  26.2
#>  5     4 Beta  NA       NA 0.0113  0.989  97885. 1102. 97334. 2488695.  25.4
#>  6     5 Beta  NA       NA 0.0134  0.987  96783. 1292. 96137. 2391361.  24.7
#>  7     6 Beta  NA       NA 0.0153  0.985  95491. 1464. 94759. 2295224.  24.0
#>  8     7 Beta  NA       NA 0.0172  0.983  94026. 1619. 93217. 2200466.  23.4
#>  9     8 Beta  NA       NA 0.0190  0.981  92407. 1758. 91528. 2107249.  22.8
#> 10     9 Beta  NA       NA 0.0208  0.979  90649. 1881. 89708. 2015721.  22.2
#> # ℹ 91 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table(
  "HeligmanPollard",
  1, 110,
  A = 0.0002,
  B = 0.1,
  C = 0.3,
  D = 0.03,
  E = 10,
  F_hp = 20,
  G = 0.00005,
  H = 1.08
)
#> # A tibble: 110 × 12
#>        x law         frac   mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>       <chr> <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 HeligmanPo… NA       NA 2.10e-4 1.000 100000  21.0  99989. 6.81e6  68.1
#>  2     2 HeligmanPo… NA       NA 8.22e-5 1.000  99979.  8.22 99975. 6.71e6  67.1
#>  3     3 HeligmanPo… NA       NA 6.94e-5 1.000  99971.  6.94 99967. 6.61e6  66.1
#>  4     4 HeligmanPo… NA       NA 7.03e-5 1.000  99964.  7.02 99960. 6.51e6  65.2
#>  5     5 HeligmanPo… NA       NA 7.44e-5 1.000  99957.  7.44 99953. 6.41e6  64.2
#>  6     6 HeligmanPo… NA       NA 7.98e-5 1.000  99949.  7.97 99945. 6.31e6  63.2
#>  7     7 HeligmanPo… NA       NA 8.64e-5 1.000  99941.  8.63 99937. 6.21e6  62.2
#>  8     8 HeligmanPo… NA       NA 9.94e-5 1.000  99933.  9.94 99928. 6.11e6  61.2
#>  9     9 HeligmanPo… NA       NA 1.51e-4 1.000  99923. 15.1  99915. 6.01e6  60.2
#> 10    10 HeligmanPo… NA       NA 3.54e-4 1.000  99908. 35.3  99890. 5.91e6  59.2
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>

# Transitional compatibility with older names
mortality_law_table("Weibull", 1, 110, k = 2.5, lambda = 90)
#> # A tibble: 110 × 12
#>        x law     frac      mu_x      qx    px      lx     dx     Lx     Tx    ex
#>    <int> <chr>   <chr>    <dbl>   <dbl> <dbl>   <dbl>  <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 Weibull CF     3.25e-5 6.06e-5 1.000 100000    6.06 99997. 7.49e6  74.9
#>  2     2 Weibull CF     9.20e-5 1.29e-4 1.000  99994.  12.9  99987. 7.39e6  73.9
#>  3     3 Weibull CF     1.69e-4 2.14e-4 1.000  99981.  21.4  99970. 7.29e6  72.9
#>  4     4 Weibull CF     2.60e-4 3.11e-4 1.000  99960.  31.1  99944. 7.19e6  71.9
#>  5     5 Weibull CF     3.64e-4 4.20e-4 1.000  99929.  42.0  99908. 7.09e6  71.0
#>  6     6 Weibull CF     4.78e-4 5.39e-4 0.999  99887.  53.9  99860. 6.99e6  70.0
#>  7     7 Weibull CF     6.03e-4 6.68e-4 0.999  99833.  66.7  99799. 6.89e6  69.0
#>  8     8 Weibull CF     7.36e-4 8.06e-4 0.999  99766.  80.4  99726. 6.79e6  68.1
#>  9     9 Weibull CF     8.78e-4 9.52e-4 0.999  99686.  94.9  99638. 6.69e6  67.1
#> 10    10 Weibull CF     1.03e-3 1.11e-3 0.999  99591. 110.   99536. 6.59e6  66.2
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table(
  "HeligmanPollard",
  1, 110,
  A = 0.0002,
  B = 0.1,
  C = 0.3,
  D = 0.03,
  E = 10,
  F = 20,
  G = 0.00005,
  H = 1.08
)
#> # A tibble: 110 × 12
#>        x law         frac   mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>       <chr> <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 HeligmanPo… NA       NA 2.10e-4 1.000 100000  21.0  99989. 6.81e6  68.1
#>  2     2 HeligmanPo… NA       NA 8.22e-5 1.000  99979.  8.22 99975. 6.71e6  67.1
#>  3     3 HeligmanPo… NA       NA 6.94e-5 1.000  99971.  6.94 99967. 6.61e6  66.1
#>  4     4 HeligmanPo… NA       NA 7.03e-5 1.000  99964.  7.02 99960. 6.51e6  65.2
#>  5     5 HeligmanPo… NA       NA 7.44e-5 1.000  99957.  7.44 99953. 6.41e6  64.2
#>  6     6 HeligmanPo… NA       NA 7.98e-5 1.000  99949.  7.97 99945. 6.31e6  63.2
#>  7     7 HeligmanPo… NA       NA 8.64e-5 1.000  99941.  8.63 99937. 6.21e6  62.2
#>  8     8 HeligmanPo… NA       NA 9.94e-5 1.000  99933.  9.94 99928. 6.11e6  61.2
#>  9     9 HeligmanPo… NA       NA 1.51e-4 1.000  99923. 15.1  99915. 6.01e6  60.2
#> 10    10 HeligmanPo… NA       NA 3.54e-4 1.000  99908. 35.3  99890. 5.91e6  59.2
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>
```
