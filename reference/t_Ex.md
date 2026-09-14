# Pure endowment (discounted survival): \\{}\_tE_x\\

Computes the actuarial present value of a pure endowment, i.e., the
expected present value of a payment of 1 made at time \\t\\ if and only
if a life aged \\x\\ survives to age \\x + t\\: \$\${}\_tE_x = v^t \cdot
{}\_tp_x.\$\$

## Usage

``` r
t_Ex(
  lt,
  x,
  t,
  i,
  i_type = "effective",
  m = 1L,
  frac,
  tidy = FALSE,
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- lt:

  A lifetable object as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).
  Must contain columns `x` and `lx`.

- x:

  Integer age(s) at which the endowment starts.

- t:

  Nonnegative numeric duration(s) in years. Fractional durations are
  allowed and are handled through
  [`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md).

- i:

  Annual interest-rate input(s).

- i_type:

  Character vector indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. Ignored for `"effective"` and `"force"`.

- frac:

  Fractional-age assumption passed to
  [`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md):
  `"UDD"`, `"CF"`, `"CML"` (alias of CF), or `"Balducci"`. If not
  specified and `lt` carries a `frac` attribute, that value is used.

- tidy:

  Logical. If `TRUE`, returns a tibble with columns `x`, `t`, `i`,
  `i_type`, `m`, `i_effective`, `frac`, and `nEx`.

- check:

  Logical. If `TRUE`, performs validity checks.

- tol:

  Numeric tolerance for integer checks on `x`.

## Value

Numeric vector of \\{}\_tE_x\\, or a tibble if `tidy = TRUE`.

## Details

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `lt` is the life table, `x` is the age, `t` is the
duration, `i` is the interest-rate input, `i_type` is the interest-rate
type, and `m` is the conversion frequency for nominal rates.

The pure endowment is a fundamental building block in life contingency
mathematics. It serves as the actuarial discount factor, combining
financial discounting with mortality: \$\${}\_tE_x = v^t \cdot
{}\_tp_x.\$\$

The interest-rate input is converted to an annual effective rate before
applying the discount factor: \$\$v = (1+i_e)^{-1}.\$\$

Key identities involving \\{}\_nE_x\\:

- Actuarial accumulated value: \\\ddot{s}\_{x:\overline{n}\|} =
  \ddot{a}\_{x:\overline{n}\|} / {}\_nE_x\\.

- Endowment insurance decomposition: \\A\_{x:\overline{n}\|} =
  A^1\_{x:\overline{n}\|} + {}\_nE_x\\.

- Deferred annuity: \\{}\_{n\|}\ddot{a}\_x = {}\_nE_x \cdot
  \ddot{a}\_{x+n}\\.

For a constant force of mortality \\\mu\\ and force of interest
\\\delta\\: \$\${}\_nE_x = e^{-n(\mu + \delta)}.\$\$

The variance of the pure endowment random variable is:
\$\$\mathrm{Var}(Z) = v^{2n} \cdot {}\_np_x \cdot {}\_nq_x.\$\$

## See also

[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
for survival probabilities without discounting,
[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md)
for insurance APVs,
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md)
for life annuity APVs.

## Examples

``` r
x  <- 0:5
lx <- c(100000, 99500, 99000, 98200, 97000, 95000)
lt <- lifetable(x = x, lx = lx, omega = 5, close = TRUE)

# Basic pure endowment: 3_E_0 = v^3 * 3_p_0
t_Ex(lt, x = 0, t = 3, i = 0.06)
#> [1] 0.8245061

# Verify manually:
(1.06)^(-3) * t_px(lt, x = 0, t = 3)
#> [1] 0.8245061

# Constant force of interest
lt_exp <- lifetable(x = 0:50, lx = 100000 * exp(-0.05 * (0:50)))
t_Ex(
  lt_exp,
  x = 30,
  t = 10,
  i = 0.10,
  i_type = "force"
)
#> [1] 0.2231302
exp(-1.5)
#> [1] 0.2231302

# Nominal annual interest rate convertible monthly
t_Ex(
  lt,
  x = 0,
  t = 3,
  i = 0.06,
  i_type = "nominal_interest",
  m = 12
)
#> [1] 0.8206033

# Vectorized: multiple ages at once
t_Ex(lt, x = c(0, 1, 2), t = 3, i = 0.05, tidy = TRUE)
#> # A tibble: 3 × 8
#>       x     t     i i_type        m i_effective frac    nEx
#>   <int> <dbl> <dbl> <chr>     <int>       <dbl> <chr> <dbl>
#> 1     0     3  0.05 effective     1        0.05 UDD   0.848
#> 2     1     3  0.05 effective     1        0.05 UDD   0.842
#> 3     2     3  0.05 effective     1        0.05 UDD   0.829

# Use in a tidy pipeline
if (requireNamespace("dplyr", quietly = TRUE)) {
  tibble::tibble(x = 0:4, t = c(5, 4, 3, 2, 1)) |>
    dplyr::mutate(pure_endow = t_Ex(lt, x = x, t = t, i = 0.06))
}
#> # A tibble: 5 × 3
#>       x     t pure_endow
#>   <int> <dbl>      <dbl>
#> 1     0     5      0.710
#> 2     1     4      0.756
#> 3     2     3      0.806
#> 4     3     2      0.861
#> 5     4     1      0.924
```
