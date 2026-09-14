# t-year survival probability from a life table

Computes the t-year survival probability \$\${}\_t p_x = P\[T(x) \>
t\]\$\$ using an annual life table, allowing for fractional ages under
standard actuarial assumptions.

## Usage

``` r
t_px(lt, x, t, frac, tidy = FALSE, check = TRUE, tol = 1e-10)
```

## Arguments

- lt:

  A lifetable object as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).
  Must contain columns `x` and `lx`. Columns `qx` or `px` are used if
  present.

- x:

  Integer age(s) at which survival starts.

- t:

  Nonnegative numeric duration(s) in years (can be fractional).

- frac:

  Fractional-age assumption: `"UDD"`, `"CF"`, `"CML"` (alias of CF), or
  `"Balducci"`. If not specified and `lt` carries a `frac` attribute
  (set by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)),
  that value is used.

- tidy:

  Logical. If `TRUE`, returns a tibble with columns `x`, `t`, `frac`,
  `tpx`.

- check:

  Logical. If `TRUE`, performs validity checks.

- tol:

  Numeric tolerance for integer checks on `x`.

## Value

Numeric vector of \\{}\_t p_x\\, or a tibble if `tidy = TRUE`.

## Details

The integer-year survival is obtained directly from the life table
(Finan, Section 22): \$\${}\_n p_x = \frac{\ell\_{x+n}}{\ell_x}\$\$

For non-integer durations, let \\t = n + s\\ with \\n = \lfloor t
\rfloor\\ and \\s \in \[0,1)\\. Then (Finan, Section 24): \$\${}\_t p_x
= {}\_n p_x \times {}\_s p\_{x+n}\$\$

The fractional-year factor \\{}\_s p_y\\ depends on the assumption:

- UDD (Finan, Sec. 24.1): \\{}\_s p_y = 1 - s \times q_y\\

- CF (Finan, Sec. 24.2): \\{}\_s p_y = (p_y)^s\\

- Balducci (Finan, Sec. 24.3): \\{}\_s p_y = \frac{p_y}{1 - (1 - s)
  \times q_y}\\

If \\x + t \> \omega\\ (the terminal age), the function returns 0 since
no survival is possible beyond the table's limiting age.
