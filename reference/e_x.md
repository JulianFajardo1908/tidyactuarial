# Expected future lifetime from an annual life table

Computes the curtate or complete expected future lifetime at integer age
\\x\\, optionally restricted to a temporary horizon of \\t\\ years.

## Usage

``` r
e_x(
  lt,
  x,
  t = NULL,
  type = c("curtate", "complete"),
  frac,
  tidy = FALSE,
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- lt:

  A life table object as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)
  (must contain columns `x` and `lx`).

- x:

  Integer age(s).

- t:

  Optional nonnegative numeric duration(s). If `NULL` (default), the
  whole-life expectancy is computed (i.e., horizon extends to \\\omega -
  x\\). If a numeric value is provided, the \\t\\-year temporary life
  expectancy is returned.

- type:

  Character: `"curtate"` (default) or `"complete"`.

- frac:

  Fractional-age assumption for `type = "complete"`: `"UDD"`, `"CF"`,
  `"CML"` (alias of CF), or `"Balducci"`. If not specified and `lt`
  carries a `frac` attribute (set by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)),
  that value is used.

- tidy:

  Logical. If `TRUE`, returns a tibble.

- check:

  Logical. If `TRUE`, performs basic input checks.

- tol:

  Numeric tolerance for integer checks.

## Value

A numeric vector of expected future lifetimes, or a tibble if
`tidy = TRUE` with columns `x`, `t`, `type`, `frac`, `ex`.

## Details

**Curtate life expectancy** (Finan, Section 23.7): \$\$e_x =
\sum\_{k=1}^{\omega - x} {}\_k p_x = \frac{1}{\ell_x}
\sum\_{k=1}^{\omega - x} \ell\_{x+k}.\$\$

The \\t\\-year temporary curtate expectancy is (Finan, Sec. 23.7):
\$\$e\_{x:\overline{t}\|} = \sum\_{k=1}^{t} {}\_k p_x.\$\$

**Complete life expectancy** (Finan, Section 23.3): \$\$\breve{e}\_x =
\int_0^{\omega - x} {}\_t p_x \\ dt = \frac{T_x}{\ell_x}.\$\$

The integral is decomposed year-by-year. Within each year, the
within-year survival integral \\\int_0^s {}\_u p_y \\ du\\ is evaluated
in closed form under the selected fractional-age assumption (Finan,
Section 24):

- UDD (Sec. 24.1): \\\int_0^s {}\_u p_y \\ du = s - \frac{1}{2} s^2
  q_y\\

- CF (Sec. 24.2): \\\int_0^s {}\_u p_y \\ du = (1 - p_y^s) / (-\ln
  p_y)\\

- Balducci (Sec. 24.3): \\\int_0^s {}\_u p_y \\ du = \frac{p_y}{q_y} \ln
  \left( \frac{p_y + q_y s}{p_y} \right)\\

Under UDD, the complete expectancy satisfies the well-known
approximation (Finan, Example 20.24): \$\$\breve{e}\_x \approx e_x +
\frac{1}{2}.\$\$
