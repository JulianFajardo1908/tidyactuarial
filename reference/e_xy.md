# Expected future lifetime for two independent lives

Computes the expected future lifetime for two independent lives aged `x`
and `y`, for either joint-life (first death) or last-survivor (second
death).

## Usage

``` r
e_xy(
  lt,
  x,
  y,
  t = NULL,
  type = c("curtate", "complete"),
  frac,
  cohort = c("first", "last"),
  tidy = FALSE,
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- lt:

  A life table data frame with columns `x` and `lx`.

- x:

  Integer actuarial age for life 1.

- y:

  Integer actuarial age for life 2.

- t:

  Optional nonnegative numeric duration(s). If `NULL`, uses the maximum
  horizon allowed by the table.

- type:

  Character: `"curtate"` or `"complete"`.

- frac:

  Fractional-age assumption for `type = "complete"`, as in
  [`t_pxy`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md):
  `"UDD"`, `"CF"`, `"CML"`, or `"Balducci"`. If not specified and `lt`
  carries a `frac` attribute, that value is used. An inherited `"CML"`
  attribute is normalized to `"CF"`.

- cohort:

  Two-life cohort: `"first"` (joint-life) or `"last"` (last survivor).

- tidy:

  Logical. If `TRUE`, returns a tibble.

- check:

  Logical. If `TRUE`, performs basic input checks. Table consistency and
  scalar logical controls are always checked.

- tol:

  Numeric tolerance for integer checks.

## Value

Numeric vector, or tibble if `tidy = TRUE`.

## Details

**Curtate expectation** (Finan, Section 56.4 / Section 57): \$\$e\_{xy}
= \sum\_{k=1}^{\infty} {}\_kp\_{xy}, \quad e\_{\overline{xy}} =
\sum\_{k=1}^{\infty} {}\_kp\_{\overline{xy}}.\$\$

**Complete expectation** (Finan, Section 56.4): \$\$\mathring{e}\_{xy} =
\int_0^{\infty} {}\_tp\_{xy} \\ dt.\$\$

The integral is decomposed year-by-year and evaluated analytically under
UDD, constant force, or Balducci, retaining small survival in log form.
Observed annual `lx` ratios determine the fractional survival. Survival
is always measured from the initial ages, conditional on both lives
being alive at time zero. In particular, last-survivor survival at later
times does not imply that both lives remain alive.

Horizons end at the last recorded age: the older life limits joint-life
expectation and the younger life limits last-survivor expectation.
Survival beyond that age is taken as zero, as in `t_px`; an open table
therefore gives a truncated expectation. Missing initial ages or zero
initial survivors give `NA`, including when `t = 0`. Tables must have
unique consecutive annual integer ages and finite, nonnegative,
nonincreasing `lx`. Observed `px`/`qx` must be probabilities consistent
with annual `lx` ratios within `1e-10`; unknown probabilities may be
`NA`. The age tolerance `tol` does not relax this mortality consistency
threshold.

\*\*Key identity\*\* (Finan, Example 57.4):
\$\$\mathring{e}\_{\overline{xy}} = \mathring{e}\_x + \mathring{e}\_y -
\mathring{e}\_{xy}.\$\$

This can be used to cross-validate results.

## See also

[`e_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_x.md)
for single-life expectancy,
[`t_pxy`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md)
for two-life survival probabilities,
[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md)
for two-life annuity APVs.

## Examples

``` r
lt <- data.frame(
  x  = 60:66,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000, 86000)
)

# Curtate joint-life expectancy (Finan, Sec. 56.4)
e_xy(lt, x = 60, y = 62, type = "curtate", cohort = "first")
#> [1] 3.601538

# Curtate last-survivor expectancy (Finan, Sec. 57)
e_xy(lt, x = 60, y = 62, type = "curtate", cohort = "last")
#> [1] 5.746923

# Verify identity (Finan, Example 57.4):
# e_{xy-bar} = e_x + e_y - e_xy
e_joint <- e_xy(lt, x = 60, y = 62, type = "curtate", cohort = "first")
e_last  <- e_xy(lt, x = 60, y = 62, type = "curtate", cohort = "last")
e_x_val <- e_x(lt, x = 60, type = "curtate")
e_y_val <- e_x(lt, x = 62, type = "curtate")
c(last_surv = e_last, sum_minus_joint = e_x_val + e_y_val - e_joint)
#>       last_surv sum_minus_joint 
#>        5.746923        5.746923 

# Complete joint-life expectancy under UDD
e_xy(lt, x = 60, y = 62, type = "complete", frac = "UDD", cohort = "first")
#> [1] 3.691013

# Temporary: 3-year curtate joint-life
e_xy(lt, x = 60, y = 62, t = 3, type = "curtate", cohort = "first")
#> [1] 2.781231

# Tidy output
e_xy(lt, x = 60, y = 62, type = "curtate", cohort = "first", tidy = TRUE)
#> # A tibble: 1 × 7
#>       x     y     t type    frac  cohort    ex
#>   <int> <int> <dbl> <chr>   <chr> <chr>  <dbl>
#> 1    60    62    NA curtate UDD   first   3.60
```
