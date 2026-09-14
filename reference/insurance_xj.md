# Cause-specific term/whole-life insurance APV under multiple decrements

This function evaluates cause-specific insurance benefits under a
multiple decrement model. It supports whole-life and term insurance,
integer deferment, vectorized issue ages and interest-rate assumptions,
and compact actuarial notation.

## Usage

``` r
insurance_xj(
  md,
  x,
  i,
  cause,
  type = c("whole", "term"),
  benefit = 1,
  n = NULL,
  h = 0L,
  i_type = "effective",
  m = 1L,
  tidy = FALSE,
  check = TRUE,
  tol = 1e-10
)

A_xj(
  md,
  x,
  i,
  cause,
  type = c("whole", "term"),
  benefit = 1,
  n = NULL,
  h = 0L,
  i_type = "effective",
  m = 1L,
  tidy = FALSE,
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- md:

  A multiple decrement table produced by
  [`md_table`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md).
  Must contain columns `x`, `p_total`, and the requested `cause`.

- x:

  Integer age(s) at issue.

- i:

  Annual interest-rate input. Must produce an annual effective rate
  greater than `-1`.

- cause:

  Character scalar. Name of the cause column in `md`, for example
  `"q_death"`.

- type:

  Character scalar. Insurance type: `"whole"` or `"term"`.

- benefit:

  Numeric benefit amount payable at the end of the year of decrement by
  the specified cause. Default is `1`.

- n:

  Integer term length in years. Required when `type = "term"`.

- h:

  Integer deferment period in years. Default is `0`.

- i_type:

  Character vector indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. Ignored for `"effective"` and `"force"`.

- tidy:

  Logical. If `TRUE`, returns a tibble with inputs and `insurance_xj`.

- check:

  Logical. If `TRUE`, performs input validation.

- tol:

  Numeric tolerance for integer checks.

## Value

Numeric vector of APVs, or a tibble if `tidy = TRUE`.

## Details

Computes the actuarial present value (APV) of an annual discrete
insurance that pays `benefit` at the end of the year of decrement by a
specified cause `j`, using a multiple decrement table produced by
[`md_table`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md).

Let \\q\_{x+k}^{(j)}\\ be the one-year decrement probability for cause
\\j\\ at age \\x+k\\, and let \\p\_{x+r}^{(\tau)}\\ be the one-year
total survival probability against all decrements at age \\x+r\\.

For a product with deferment \\h\\ and term \\n\\, with benefit payable
at the end of the year of decrement by cause \\j\\, the APV is: \$\$
\sum\_{k=h}^{h+n-1} v^{k+1} \left(\prod\_{r=0}^{k-1}
p\_{x+r}^{(\tau)}\right) q\_{x+k}^{(j)}. \$\$

Here \\v = (1+i_e)^{-1}\\, where \\i_e\\ is the annual effective
interest rate obtained from `i`, `i_type`, and `m`.

If `type = "whole"`, the function sets `n` to the remaining length of
the table after deferment, that is, whole life over the available ages.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `md` is a multiple decrement table, `x` is age at
issue, `i` is the interest rate, `i_type` is the interest-rate type, `m`
is the conversion frequency for nominal rates, `n` is the term, and `h`
is the deferment period.

## See also

[`t_qxj`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_qxj.md)
for cause-specific decrement probabilities,
[`lt_tau`](https://julianfajardo1908.github.io/tidyactuarial/reference/lt_tau.md)
to build a single-decrement life table for the total decrement.

## Examples

``` r
qx_df <- tibble::tibble(
  x = 30:35,
  q_death = c(0.001, 0.0012, 0.0014, 0.0017, 0.0020, 1.0000),
  q_disability = c(0.002, 0.0021, 0.0022, 0.0023, 0.0024, 0.0000)
)
md <- md_table(qx_df, radix = 1e5, close = TRUE)

# 5-year term cause-specific insurance for death, i = 5%
insurance_xj(
  md = md,
  x = 30,
  i = 0.05,
  cause = "q_death",
  type = "term",
  n = 5
)
#> [1] 0.006169493

# Whole-life over available ages, 2-year deferred
insurance_xj(
  md = md,
  x = 30,
  i = 0.05,
  cause = "q_death",
  type = "whole",
  h = 2,
  tidy = TRUE
)
#> # A tibble: 1 × 10
#>       x     i i_type        m     h     n type  cause   benefit insurance_xj
#>   <int> <dbl> <chr>     <int> <int> <int> <chr> <chr>     <dbl>        <dbl>
#> 1    30  0.05 effective     1     2    NA whole q_death       1        0.737
```
