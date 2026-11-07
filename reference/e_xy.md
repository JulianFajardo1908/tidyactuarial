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
  tol = 1e-10,
  status = c("joint", "last")
)
```

## Arguments

- lt:

  A life table data frame shared by both lives, or a list of two life
  tables `list(lt_x, lt_y)`, one for each life in that order. Each table
  must contain columns `x` and `lx`.

- x:

  Integer actuarial age for life 1.

- y:

  Integer actuarial age for life 2.

- t:

  Optional nonnegative numeric duration(s). If `NULL`, uses the maximum
  horizon allowed by the tables and selected status.

- type:

  Character: `"curtate"` or `"complete"`.

- frac:

  Fractional-age assumption for `type = "complete"`, as in
  [`t_pxy`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md):
  `"UDD"`, `"CF"`, `"CML"`, or `"Balducci"`. If omitted, valid `frac`
  attributes are inherited from the tables, defaulting to `"UDD"`.
  Inherited `"CML"` is normalized to `"CF"`; conflicting attributes
  require an explicit `frac`, as in `t_pxy`.

- cohort:

  Legacy survival-state selector: `"first"` means joint-life and
  `"last"` means last survivor. Prefer `status` in new calls. Supply
  only one of `cohort` and `status`.

- tidy:

  Logical. If `TRUE`, returns a tibble.

- check:

  Logical. If `TRUE`, performs basic input checks. Table consistency and
  scalar logical controls are always checked.

- tol:

  Numeric tolerance for integer checks.

- status:

  Survival status: `"joint"` (first death) or `"last"` (last survivor).
  Defaults to joint-life when neither selector is supplied. Appended to
  preserve existing positional calls.

## Value

Numeric vector, or tibble if `tidy = TRUE`. The tibble retains its
existing columns, including `cohort`: `"first"` for joint-life and
`"last"` for last survivor, also when the selection is made using
`status`.

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

Each marginal horizon ends at its own table's last recorded age minus
its initial age. Joint-life expectation uses the smaller horizon and
last-survivor expectation the larger. With a shared table, these are the
horizons of the older and younger life, respectively. Survival beyond
each marginal horizon is taken as zero, as in `t_px`; open tables
therefore give truncated expectations. Missing initial ages or zero
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
e_xy(lt, x = 60, y = 62, type = "curtate", status = "joint")
#> [1] 3.601538

# Curtate last-survivor expectancy (Finan, Sec. 57)
e_xy(lt, x = 60, y = 62, type = "curtate", status = "last")
#> [1] 5.746923

# Verify identity (Finan, Example 57.4):
# e_{xy-bar} = e_x + e_y - e_xy
e_joint <- e_xy(lt, x = 60, y = 62, type = "curtate", status = "joint")
e_last  <- e_xy(lt, x = 60, y = 62, type = "curtate", status = "last")
e_x_val <- e_x(lt, x = 60, type = "curtate")
e_y_val <- e_x(lt, x = 62, type = "curtate")
c(last_surv = e_last, sum_minus_joint = e_x_val + e_y_val - e_joint)
#>       last_surv sum_minus_joint 
#>        5.746923        5.746923 

# Complete joint-life expectancy under UDD
e_xy(lt, x = 60, y = 62, type = "complete", frac = "UDD", status = "joint")
#> [1] 3.691013

# Temporary: 3-year curtate joint-life
e_xy(lt, x = 60, y = 62, t = 3, type = "curtate", status = "joint")
#> [1] 2.781231

# Tidy output
e_xy(lt, x = 60, y = 62, type = "curtate", status = "joint", tidy = TRUE)
#> # A tibble: 1 × 7
#>       x     y     t type    frac  cohort    ex
#>   <int> <int> <dbl> <chr>   <chr> <chr>  <dbl>
#> 1    60    62    NA curtate UDD   first   3.60

# Distinct mortality tables, applied to the corresponding lives
lt_x <- data.frame(x = 60:62, lx = c(100, 80, 0))
lt_y <- data.frame(x = 60:62, lx = c(100, 50, 0))
e_xy(list(lt_x, lt_y), 60, 60, status = "joint") # 0.4
#> [1] 0.4
e_xy(list(lt_x, lt_y), 60, 60, status = "last")  # 0.9
#> [1] 0.9
```
