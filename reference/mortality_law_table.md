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

  Character. Within-year assumption used to convert \\\mu_x\\ to
  \\q_x\\. One of `"CF"`, `"UDD"`, `"Balducci"`, or `"CML"`. `"CML"` is
  treated as `"CF"`.

- l0:

  Numeric scalar. Initial radix, that is, the starting value
  \\l\_{x_min}\\.

- close:

  Logical. If `TRUE`, forces the last age to close.

- a_x:

  Numeric scalar. Average fraction of the year lived by those dying
  between age \\x\\ and \\x+1\\. Default is `0.5`.

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
`px = 1 - qx`.

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

- **HeligmanPollard**: odds model returning \\q_x\\ directly.

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

- `"HeligmanPollard"`: `A`, `B`, `C`, `D`, `E`, `F_hp`, and `G`.
  Transitional alias `F` is accepted and mapped to `F_hp`.

## Converting mu(x) to qx

For laws defined by a force of mortality \\\mu_x\\, the one-year death
probability \\q_x\\ is obtained using `frac`:

- `"CF"` or `"CML"`: \\q_x = 1 - \exp(-\mu_x)\\.

- `"UDD"`: \\q_x = \mu_x\\.

- `"Balducci"`: \\q_x = \mu_x/(1+\mu_x)\\.

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
#>        x law     frac     mu_x       qx    px      lx    dx      Lx     Tx    ex
#>    <int> <chr>   <chr>   <dbl>    <dbl> <dbl>   <dbl> <dbl>   <dbl>  <dbl> <dbl>
#>  1     0 Gomper… CF    1   e-5 1.000e-5 1.000 100000  1.000 100000. 1.04e7 104. 
#>  2     1 Gomper… CF    1.08e-5 1.08 e-5 1.000  99999. 1.08   99998. 1.03e7 103. 
#>  3     2 Gomper… CF    1.17e-5 1.17 e-5 1.000  99998. 1.17   99997. 1.02e7 102. 
#>  4     3 Gomper… CF    1.26e-5 1.26 e-5 1.000  99997. 1.26   99996. 1.01e7 101. 
#>  5     4 Gomper… CF    1.36e-5 1.36 e-5 1.000  99995. 1.36   99995. 9.96e6  99.6
#>  6     5 Gomper… CF    1.47e-5 1.47 e-5 1.000  99994. 1.47   99993. 9.86e6  98.6
#>  7     6 Gomper… CF    1.59e-5 1.59 e-5 1.000  99993. 1.59   99992. 9.76e6  97.6
#>  8     7 Gomper… CF    1.71e-5 1.71 e-5 1.000  99991. 1.71   99990. 9.66e6  96.6
#>  9     8 Gomper… CF    1.85e-5 1.85 e-5 1.000  99989. 1.85   99988. 9.56e6  95.6
#> 10     9 Gomper… CF    2.00e-5 2.00 e-5 1.000  99988. 2.00   99987. 9.46e6  94.6
#> # ℹ 101 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table("Makeham", 0, 110, A = 5e-4, B = 1e-6, c = 1.10)
#> # A tibble: 111 × 12
#>        x law     frac      mu_x       qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>   <chr>    <dbl>    <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     0 Makeham CF    0.000501 0.000501 0.999 100000   50.1 99975. 1.04e7 104. 
#>  2     1 Makeham CF    0.000501 0.000501 0.999  99950.  50.1 99925. 1.03e7 103. 
#>  3     2 Makeham CF    0.000501 0.000501 0.999  99900.  50.1 99875. 1.02e7 102. 
#>  4     3 Makeham CF    0.000501 0.000501 0.999  99850.  50.0 99825. 1.01e7 101. 
#>  5     4 Makeham CF    0.000501 0.000501 0.999  99800.  50.0 99775. 1.00e7 100. 
#>  6     5 Makeham CF    0.000502 0.000501 0.999  99750.  50.0 99725. 9.91e6  99.3
#>  7     6 Makeham CF    0.000502 0.000502 0.999  99700.  50.0 99675. 9.81e6  98.4
#>  8     7 Makeham CF    0.000502 0.000502 0.999  99650.  50.0 99625. 9.71e6  97.4
#>  9     8 Makeham CF    0.000502 0.000502 0.999  99600.  50.0 99575. 9.61e6  96.5
#> 10     9 Makeham CF    0.000502 0.000502 0.999  99550.  50.0 99525. 9.51e6  95.5
#> # ℹ 101 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table("Weibull", 1, 110, shape = 2.5, scale = 90)
#> # A tibble: 110 × 12
#>        x law     frac      mu_x      qx    px      lx     dx     Lx     Tx    ex
#>    <int> <chr>   <chr>    <dbl>   <dbl> <dbl>   <dbl>  <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 Weibull CF     3.25e-5 3.25e-5 1.000 100000    3.25 99998. 7.53e6  75.3
#>  2     2 Weibull CF     9.20e-5 9.20e-5 1.000  99997.   9.20 99992. 7.43e6  74.3
#>  3     3 Weibull CF     1.69e-4 1.69e-4 1.000  99988.  16.9  99979. 7.33e6  73.3
#>  4     4 Weibull CF     2.60e-4 2.60e-4 1.000  99971.  26.0  99958. 7.23e6  72.3
#>  5     5 Weibull CF     3.64e-4 3.64e-4 1.000  99945.  36.3  99926. 7.13e6  71.3
#>  6     6 Weibull CF     4.78e-4 4.78e-4 1.000  99908.  47.8  99884. 7.03e6  70.4
#>  7     7 Weibull CF     6.03e-4 6.02e-4 0.999  99861.  60.2  99830. 6.93e6  69.4
#>  8     8 Weibull CF     7.36e-4 7.36e-4 0.999  99800.  73.4  99764. 6.83e6  68.5
#>  9     9 Weibull CF     8.78e-4 8.78e-4 0.999  99727.  87.6  99683. 6.73e6  67.5
#> 10    10 Weibull CF     1.03e-3 1.03e-3 0.999  99639. 102.   99588. 6.63e6  66.6
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
#>  6     5 Logistic CF    0.000101 1.01e-4 1.000  99949.  10.1 99944. 1.04e7  104.
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
  C = 0.03,
  D = 10,
  E = 20,
  F_hp = 0.00005,
  G = 1.08
)
#> # A tibble: 110 × 12
#>        x law         frac   mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>       <chr> <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 HeligmanPo… NA       NA 1.39e-4 1.000 100000  13.9  99993. 6.81e6  68.1
#>  2     2 HeligmanPo… NA       NA 5.83e-5 1.000  99986.  5.83 99983. 6.71e6  67.1
#>  3     3 HeligmanPo… NA       NA 6.30e-5 1.000  99980.  6.30 99977. 6.61e6  66.1
#>  4     4 HeligmanPo… NA       NA 6.80e-5 1.000  99974.  6.80 99971. 6.51e6  65.2
#>  5     5 HeligmanPo… NA       NA 7.35e-5 1.000  99967.  7.34 99963. 6.41e6  64.2
#>  6     6 HeligmanPo… NA       NA 7.94e-5 1.000  99960.  7.93 99956. 6.31e6  63.2
#>  7     7 HeligmanPo… NA       NA 8.62e-5 1.000  99952.  8.61 99948. 6.21e6  62.2
#>  8     8 HeligmanPo… NA       NA 9.93e-5 1.000  99943.  9.93 99938. 6.11e6  61.2
#>  9     9 HeligmanPo… NA       NA 1.51e-4 1.000  99933. 15.1  99926. 6.01e6  60.2
#> 10    10 HeligmanPo… NA       NA 3.54e-4 1.000  99918. 35.3  99901. 5.91e6  59.2
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>

# Transitional compatibility with older names
mortality_law_table("Weibull", 1, 110, k = 2.5, lambda = 90)
#> # A tibble: 110 × 12
#>        x law     frac      mu_x      qx    px      lx     dx     Lx     Tx    ex
#>    <int> <chr>   <chr>    <dbl>   <dbl> <dbl>   <dbl>  <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 Weibull CF     3.25e-5 3.25e-5 1.000 100000    3.25 99998. 7.53e6  75.3
#>  2     2 Weibull CF     9.20e-5 9.20e-5 1.000  99997.   9.20 99992. 7.43e6  74.3
#>  3     3 Weibull CF     1.69e-4 1.69e-4 1.000  99988.  16.9  99979. 7.33e6  73.3
#>  4     4 Weibull CF     2.60e-4 2.60e-4 1.000  99971.  26.0  99958. 7.23e6  72.3
#>  5     5 Weibull CF     3.64e-4 3.64e-4 1.000  99945.  36.3  99926. 7.13e6  71.3
#>  6     6 Weibull CF     4.78e-4 4.78e-4 1.000  99908.  47.8  99884. 7.03e6  70.4
#>  7     7 Weibull CF     6.03e-4 6.02e-4 0.999  99861.  60.2  99830. 6.93e6  69.4
#>  8     8 Weibull CF     7.36e-4 7.36e-4 0.999  99800.  73.4  99764. 6.83e6  68.5
#>  9     9 Weibull CF     8.78e-4 8.78e-4 0.999  99727.  87.6  99683. 6.73e6  67.5
#> 10    10 Weibull CF     1.03e-3 1.03e-3 0.999  99639. 102.   99588. 6.63e6  66.6
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>

mortality_law_table(
  "HeligmanPollard",
  1, 110,
  A = 0.0002,
  B = 0.1,
  C = 0.03,
  D = 10,
  E = 20,
  F = 0.00005,
  G = 1.08
)
#> # A tibble: 110 × 12
#>        x law         frac   mu_x      qx    px      lx    dx     Lx     Tx    ex
#>    <int> <chr>       <chr> <dbl>   <dbl> <dbl>   <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1     1 HeligmanPo… NA       NA 1.39e-4 1.000 100000  13.9  99993. 6.81e6  68.1
#>  2     2 HeligmanPo… NA       NA 5.83e-5 1.000  99986.  5.83 99983. 6.71e6  67.1
#>  3     3 HeligmanPo… NA       NA 6.30e-5 1.000  99980.  6.30 99977. 6.61e6  66.1
#>  4     4 HeligmanPo… NA       NA 6.80e-5 1.000  99974.  6.80 99971. 6.51e6  65.2
#>  5     5 HeligmanPo… NA       NA 7.35e-5 1.000  99967.  7.34 99963. 6.41e6  64.2
#>  6     6 HeligmanPo… NA       NA 7.94e-5 1.000  99960.  7.93 99956. 6.31e6  63.2
#>  7     7 HeligmanPo… NA       NA 8.62e-5 1.000  99952.  8.61 99948. 6.21e6  62.2
#>  8     8 HeligmanPo… NA       NA 9.93e-5 1.000  99943.  9.93 99938. 6.11e6  61.2
#>  9     9 HeligmanPo… NA       NA 1.51e-4 1.000  99933. 15.1  99926. 6.01e6  60.2
#> 10    10 HeligmanPo… NA       NA 3.54e-4 1.000  99918. 35.3  99901. 5.91e6  59.2
#> # ℹ 100 more rows
#> # ℹ 1 more variable: mx <dbl>
```
