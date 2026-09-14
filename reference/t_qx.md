# t-year death probability from a life table

Computes the t-year death probability \$\${}\_t q_x = \Pr\[T(x) \le t\]
= 1 - {}\_t p_x\$\$ using an annual life table, allowing for fractional
ages under standard actuarial assumptions.

## Usage

``` r
t_qx(lt, x, t, frac, tidy = FALSE, check = TRUE, tol = 1e-10)
```

## Arguments

- lt:

  A lifetable object as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).
  Must contain columns `x` and `lx`. Columns `qx` or `px` are used if
  present.

- x:

  Integer age(s) at which the interval starts.

- t:

  Nonnegative numeric duration(s) in years (can be fractional).

- frac:

  Fractional-age assumption: `"UDD"`, `"CF"`, `"CML"` (alias of CF), or
  `"Balducci"`. If not specified and `lt` carries a `frac` attribute
  (set by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)),
  that value is used. Passed directly to
  [`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md).

- tidy:

  Logical. If `TRUE`, returns a tibble with columns `x`, `t`, `frac`,
  `tqx`.

- check:

  Logical. If `TRUE`, performs validity checks.

- tol:

  Numeric tolerance for integer checks on `x`.

## Value

Numeric vector of \\{}\_t q_x\\, or a tibble if `tidy = TRUE`.

## Details

This is a thin wrapper around
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md):
\$\${}\_t q_x = 1 - {}\_t p_x.\$\$

The identity \\{}\_tq_x = {}\_td_x / \ell_x\\ (Finan, Section 22) holds
for integer \\t\\, where \\{}\_td_x = \ell_x - \ell\_{x+t}\\ is the
expected number of deaths between ages \\x\\ and \\x+t\\.

For fractional durations, the result depends on the chosen assumption
(UDD, CF, or Balducci); see
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
for details and formulas (Finan, Section 24).

The deferred death probability \\{}\_{n\|}q_x\\ can be obtained as
(Finan, Section 23.4): \$\${}\_{n\|}q_x = {}\_np_x \cdot q\_{x+n} =
{}\_{n+1}q_x - {}\_nq_x.\$\$

## See also

[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
for the complementary survival probability,
[`t_Ex`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_Ex.md)
for the pure endowment (discounted survival),
[`e_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_x.md)
for life expectancy,
[`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)
for building the life table input.

## Examples

``` r
x  <- 0:5
lx <- c(100000, 99500, 99000, 98200, 97000, 95000)
lt <- lifetable(x = x, lx = lx, omega = 5, close = TRUE)

# Integer death probability (Finan, Section 22)
t_qx(lt, x = 0, t = 3)  # (l0 - l3) / l0
#> [1] 0.018

# t = 0 always returns 0
t_qx(lt, x = 0, t = 0)
#> [1] 0

# Fractional age under UDD (Finan, Section 24.1)
t_qx(lt, x = 0, t = 2.5, frac = "UDD")
#> [1] 0.014

# Finan Example 22.2a: number of deaths between ages 2 and 5
# 3_d_2 = l_2 - l_5 = 98995 - 97468 = 1527
lt_22 <- lifetable(
  x = 0:5,
  lx = c(100000, 99499, 98995, 98489, 97980, 97468)
)
t_qx(lt_22, x = 2, t = 3) * lt_22$lx[lt_22$x == 2]  # 1527
#> [1] 1527

# Deferred death probability (Finan, Section 23.4):
# 2|1_q_0 = 2_p_0 * q_2 = 3_q_0 - 2_q_0
t_qx(lt, x = 0, t = 3) - t_qx(lt, x = 0, t = 2)
#> [1] 0.008

# Vectorized with tidy output
t_qx(lt, x = c(0, 1), t = c(1.5, 2.2), frac = "Balducci", tidy = TRUE)
#> # A tibble: 2 × 4
#>       x     t frac         tqx
#>   <int> <dbl> <chr>      <dbl>
#> 1     0   1.5 Balducci 0.00751
#> 2     1   2.2 Balducci 0.0155 

# Use in a tidy pipeline
if (requireNamespace("dplyr", quietly = TRUE)) {
  tibble::tibble(age = c(0, 1, 2), duration = c(3, 2.5, 1.7)) |>
    dplyr::mutate(
      surv  = t_px(lt, x = age, t = duration),
      death = t_qx(lt, x = age, t = duration)
    )
}
#> # A tibble: 3 × 4
#>     age duration  surv  death
#>   <dbl>    <dbl> <dbl>  <dbl>
#> 1     0      3   0.982 0.0180
#> 2     1      2.5 0.981 0.0191
#> 3     2      1.7 0.983 0.0166
```
