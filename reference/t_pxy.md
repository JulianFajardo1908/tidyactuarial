# Two-life survival probability for independent lives

Computes the survival probability for two independent lives with
actuarial ages `x` and `y` at time 0 under a joint-life or last-survivor
status.

## Usage

``` r
t_pxy(lt, x, y, t, frac, status = c("joint", "last"))
```

## Arguments

- lt:

  Either:

  - a single life table data frame, used for both lives; or

  - a list of two life tables `list(lt_x, lt_y)`, one for each life.

  Each life table must contain columns `x` and `lx`.

- x:

  Integer actuarial age of the first life at time 0.

- y:

  Integer actuarial age of the second life at time 0.

- t:

  Nonnegative time (may be fractional).

- frac:

  Fractional-age assumption: `"UDD"`, `"CF"`, `"CML"` (alias of CF), or
  `"Balducci"`. If not specified and the supplied life table(s) carry a
  `frac` attribute, that value is used. If two tables are supplied and
  their `frac` attributes differ, `frac` must be supplied explicitly.
  Passed to
  [`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md).

- status:

  Two-life status: `"joint"` or `"last"`.

## Value

A single numeric value.

## Details

Independence is assumed throughout (Finan, Sections 56–57).

**Joint-life status** (Finan, Section 56): the status survives as long
as *both* lives are alive. \$\${}\_tp\_{xy} = {}\_tp_x \cdot
{}\_tp_y.\$\$

**Last-survivor status** (Finan, Section 57): the status survives as
long as *at least one* life is alive. \$\${}\_tp\_{\overline{xy}} =
{}\_tp_x + {}\_tp_y - {}\_tp_x \cdot {}\_tp_y.\$\$

Individual survival probabilities \\{}\_tp_x\\ and \\{}\_tp_y\\ are
computed via
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md),
which supports fractional ages under UDD, constant force, and Balducci
assumptions (Finan, Section 24).

## See also

[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
for single-life survival,
[`e_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_xy.md)
for joint-life expectancy,
[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md)
for two-life annuity APVs,
[`insurance_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md)
for two-life insurance APVs.

## Examples

``` r
lt <- data.frame(
  x  = 60:66,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000, 86000)
)

# Joint life, 2.5 years, UDD (Finan, Sec. 56)
t_pxy(lt, x = 60, y = 62, t = 2.5, frac = "UDD", status = "joint")
#> [1] 0.9056154

# Verify: joint = product of marginals
t_px(lt, x = 60, t = 2.5, frac = "UDD") *
  t_px(lt, x = 62, t = 2.5, frac = "UDD")
#> [1] 0.9056154

# Last survivor, 2.5 years, constant force (Finan, Sec. 57)
t_pxy(lt, x = 60, y = 62, t = 2.5, frac = "CF", status = "last")
#> [1] 0.9978385

# Same result if the same table is supplied explicitly for both lives
t_pxy(list(lt, lt), x = 60, y = 62, t = 2.5, frac = "UDD", status = "joint")
#> [1] 0.9056154

# Different life tables for the two lives
lt_m <- data.frame(
  x  = 60:66,
  lx = c(100000, 98500, 96800, 94800, 92400, 89500, 86000)
)
lt_f <- data.frame(
  x  = 60:66,
  lx = c(100000, 99000, 97800, 96400, 94700, 92700, 90300)
)
t_pxy(list(lt_m, lt_f), x = 60, y = 62, t = 2.5, frac = "UDD", status = "joint")
#> [1] 0.9178384

# Finan Example 56.2 style: integer survival
# 10_p_{50:60} = 10_p_50 * 10_p_60
lt_ilt <- data.frame(
  x  = 50:70,
  lx = c(8950901, 8879913, 8804189, 8723382, 8637048,
         8544731, 8445974, 8340310, 8227261, 8106334,
         7977338, 7839775, 7693040, 7536522, 7369603,
         7191658, 7002051, 6800139, 6585264, 6356752,
         6114913)
)
t_pxy(lt_ilt, x = 50, y = 60, t = 10, status = "joint")
#> [1] NA

# Finan Problem 56.1: t_q_xy = t_q_x + t_q_y - t_q_x * t_q_y
p_joint <- t_pxy(lt, x = 60, y = 62, t = 3, status = "joint")
q_joint <- 1 - p_joint
qx <- 1 - t_px(lt, x = 60, t = 3)
qy <- 1 - t_px(lt, x = 62, t = 3)
c(q_joint = q_joint, q_sum = qx + qy - qx * qy)  # should match
#>   q_joint     q_sum 
#> 0.1184615 0.1184615 
```
