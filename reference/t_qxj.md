# t-year probability of decrement by cause j: t_qxj

Computes \\{}\_t q_x^{(j)}\\, the probability that a life aged `x`
decrements by a specific cause `j` within `t` years, using a multiple
decrement table produced by
[`md_table`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md).

## Usage

``` r
t_qxj(md, x, t, cause, frac = NULL, tidy = FALSE, check = TRUE, tol = 1e-10)
```

## Arguments

- md:

  A multiple decrement table produced by
  [`md_table`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md).
  Must contain columns `x`, `p_total`, and the requested `cause`.

- x:

  Numeric vector. Starting age(s) (integer-valued).

- t:

  Numeric vector. Time horizon(s) in years (t \>= 0). Can be non-integer
  if `frac` is supplied.

- cause:

  Character. Name of the cause column in `md` (e.g., `"q_death"`).

- frac:

  Character. Fractional-age assumption for non-integer `t`: one of
  `"UDD"`, `"CF"`, `"Balducci"`, or `NULL`. If `NULL` (default), `t`
  must be integer-valued.

- tidy:

  Logical. If `TRUE`, returns a tibble with columns `x`, `t`, `cause`,
  `frac`, and `tqxj`.

- check:

  Logical. If `TRUE`, performs input validation (default `TRUE`).

- tol:

  Numeric tolerance for integer checks (default `1e-10`).

## Value

Numeric vector of \\{}\_t q_x^{(j)}\\ (or tibble if `tidy=TRUE`).

## Details

Let \\q_x^{(j)}\\ be the annual decrement probability for cause \\j\\
and \\q_x^{(\tau)}\\ be the total decrement probability. For integer
\\t\\, \$\$ {}\_t q_x^{(j)} = \sum\_{k=0}^{t-1} \left(\prod\_{r=0}^{k-1}
p\_{x+r}^{(\tau)}\right) q\_{x+k}^{(j)}. \$\$

For non-integer \\t = n + s\\ with \\n = \lfloor t \rfloor\\ and \\s \in
\[0,1)\\, this function supports fractional-age assumptions specified by
`frac` and uses the additional convention that the within-year cause
proportions remain constant: \\{}\_s q_x^{(j)} = w_j \\ {}\_s
q_x^{(\tau)}\\ where \\w_j = q_x^{(j)} / q_x^{(\tau)}\\ (and 0 when
\\q_x^{(\tau)}=0\\).

Supported fractional-age assumptions for the total decrement:

- `"UDD"`: \\{}\_s q_x^{(\tau)} = s q_x^{(\tau)}\\.

- `"CF"`: \\{}\_s p_x^{(\tau)} = (p_x^{(\tau)})^s\\.

- `"Balducci"`: \\{}\_s q_x^{(\tau)} = \frac{s
  q_x^{(\tau)}}{1-(1-s)q_x^{(\tau)}}\\.

## Examples

``` r
qx_df <- tibble::tibble(
  x = 30:35,
  q_death = c(0.001, 0.0012, 0.0014, 0.0017, 0.0020, 1.0000),
  q_disability = c(0.002, 0.0021, 0.0022, 0.0023, 0.0024, 0.0000)
)
md <- md_table(qx_df, radix = 1e5, close = TRUE)
t_qxj(md, x = 30, t = 5, cause = "q_death")
#> [1] 0.007243163
t_qxj(md, x = 30, t = 2.5, cause = "q_death", frac = "CF", tidy = TRUE)
#> # A tibble: 1 × 5
#>       x     t cause   frac     tqxj
#>   <int> <dbl> <chr>   <chr>   <dbl>
#> 1    30   2.5 q_death CF    0.00289
```
