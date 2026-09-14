# Total-decrement lifetable from a multiple decrement table: lt_tau

Builds a single-decrement lifetable for the *total* decrement (any
cause), using \\q_x^{(\tau)}\\ from a multiple decrement table produced
by
[`md_table`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md).
This enables direct re-use of single-life functions (e.g., `t_px`,
`t_qx`, `t_Ex`, annuities, insurances) under the total decrement model.

## Usage

``` r
lt_tau(md, ...)
```

## Arguments

- md:

  A multiple decrement table (typically the output of
  [`md_table`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md)),
  containing columns `x` and `q_total`.

- ...:

  Additional arguments passed to
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)
  (e.g., `radix`, `omega`, `close`, `ax`, `type`, `frac`, `check`,
  `tol`).

## Value

A lifetable object as produced by
[`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).

## Details

Given cause-specific decrement probabilities \\q_x^{(j)}\\, the total
decrement is \\q_x^{(\tau)} = \sum_j q_x^{(j)}\\. This function simply
passes `x = md$x` and `qx = md$q_total` to
[`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md).

## Examples

``` r
qx_df <- tibble::tibble(
  x = 30:35,
  q_death = c(0.001, 0.0012, 0.0014, 0.0017, 0.0020, 1.0000),
  q_disability = c(0.002, 0.0021, 0.0022, 0.0023, 0.0024, 0.0000)
)
md <- md_table(qx_df, radix = 1e5, close = TRUE)
lt <- lt_tau(md, radix = 1e5, close = TRUE, frac = "UDD")
t_px(lt, x = 30, t = 5)
#> [1] 0.9818329
```
