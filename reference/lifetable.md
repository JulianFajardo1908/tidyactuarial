# Build an annual life table (tidy tibble) from lx, qx, px, or mx

Creates an annual life table with **integer, consecutive ages** and
returns a **tibble** (tidyverse-friendly) with class `"lifetable"`.

## Usage

``` r
lifetable(
  x,
  lx = NULL,
  qx = NULL,
  px = NULL,
  mx = NULL,
  radix = NULL,
  omega = NULL,
  close = TRUE,
  ax = 0.5,
  type = c("ultimate", "select"),
  frac = c("UDD", "CF", "Balducci"),
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- x:

  Numeric vector of ages. Must be **integer** and **consecutive**
  (annual table), e.g. `0:110`.

- lx:

  Optional numeric vector of survivors \\\ell_x\\. Must be nonnegative
  and nonincreasing.

- qx:

  Optional numeric vector of one-year death probabilities \\q_x\\. `NA`
  values are allowed (useful at the last age when `close=TRUE`), but
  `Inf`/`NaN` are not allowed.

- px:

  Optional numeric vector of one-year survival probabilities \\p_x\\.
  `NA` values are allowed, but `Inf`/`NaN` are not allowed. If provided,
  `qx = 1 - px`.

- mx:

  Optional numeric vector of central death rates \\m_x\\. `NA` values
  are allowed, but `Inf`/`NaN` are not allowed. If provided, converted
  to `qx` using `ax`.

- radix:

  Optional positive scalar. Required if building `lx` from
  (`qx`/`px`/`mx`) and `lx` is not provided.

- omega:

  Optional integer limiting age. If `omega < max(x)`, the table is
  truncated to `omega`. If `omega > max(x)`, an error is raised (the
  function will not invent missing ages).

- close:

  Logical. If `TRUE` (default), closes the table at `omega` (forces
  terminal conditions).

- ax:

  Scalar in `[0,1]`. Average fraction of the year lived by those who die
  in the interval \\\[x, x+1)\\. Under UDD (Finan, Sec. 24.1),
  `ax = 0.5`. Under constant force, \\a_x = 1/\mu - 1/(\exp(\mu)-1)\\.
  At the terminal age with `close = TRUE`, `mx` equals \\1/(1 - a_x)\\,
  which is 2 for `ax = 0.5`. Default is `0.5`.

- type:

  Character. `"ultimate"` or `"select"` (metadata). Stored as an
  attribute and used by downstream functions.

- frac:

  Character. `"UDD"`, `"CF"`, or `"Balducci"` (metadata). Stored as an
  attribute and used by fractional-age functions such as
  [`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md).

- check:

  Logical. If `TRUE` (default), performs strict validity and consistency
  checks.

- tol:

  Numeric tolerance for integer checks and consistency checks.

## Value

A `tibble` with class `c("lifetable","tbl_df","tbl","data.frame")` and
columns:

- `x`: integer ages

- `lx`: survivors at exact age x

- `dx`: deaths in \\\[x, x+1)\\

- `qx`: probability of death in \\\[x, x+1)\\

- `px`: probability of survival to \\x+1\\

- `mx`: central death rate (derived using `ax`). At the terminal age
  with `close = TRUE`, `mx` equals \\1/(1 - a_x)\\ and may be `Inf` if
  `ax = 1`.

Attributes include: `radix`, `omega`, `type`, `frac`, `closed`, `ax`.

## Details

The table can be built from exactly one of:

- `lx` (survivors), or

- `qx` (one-year death probabilities), or

- `px` (one-year survival probabilities), or

- `mx` (central death rates),

and the function will compute the remaining columns consistently: `dx`,
`qx`, `px`, and `mx`.

When multiple inputs are provided, priority is: `lx` \> `qx` \> `px` \>
`mx`. If `lx` is provided together with `qx`, cross-consistency is
validated (both must agree via \\q_x = (\ell_x - \ell\_{x+1}) /
\ell_x\\).

By default, the table is actuarially closed at `omega`:
\$\$\ell\_{\omega+1} = 0 \Rightarrow d\_{\omega} = \ell\_{\omega}
\Rightarrow q\_{\omega} = 1 \Rightarrow p\_{\omega} = 0.\$\$

The life table follows the standard actuarial construction described in
Finan, Sections 22–24 (Exam MLC preparation).

The basic identities are (Finan, Section 22): \$\$\ell_x = \ell_0 \cdot
s(x), \quad d_x = \ell_x - \ell\_{x+1}, \quad q_x = d_x / \ell_x, \quad
p_x = \ell\_{x+1} / \ell_x.\$\$

The central death rate `mx` is computed via the discrete approximation
(Finan, Section 23.9): \$\$m_x = \frac{q_x}{1 - a_x \cdot q_x}\$\$ which
under UDD (`ax = 0.5`) reduces to the classical formula \\m_x = q_x /
(1 - 0.5 \\ q_x)\\ (Finan, Section 24.1). This arises because under UDD,
\\L_x = \ell_x - \tfrac{1}{2} d_x\\, and therefore \\m_x = d_x / L_x\\.

At the terminal age \\\omega\\ with `close = TRUE`, closure forces
\\q\_\omega = 1\\, \\p\_\omega = 0\\, and \\d\_\omega = \ell\_\omega\\.
The corresponding \\m\_\omega\\ equals \\1/(1 - a_x)\\, which is 2 under
UDD (`ax = 0.5`). If `ax = 1`, \\m\_\omega = \infty\\.

## See also

[`km_lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/km_lifetable.md)
for Kaplan–Meier construction,
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
and
[`t_qx`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_qx.md)
for survival and death probabilities (including fractional ages),
[`e_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_x.md)
for curtate and complete life expectancy,
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md)
and
[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md)
for life contingency valuations that consume a life table.

## Examples

``` r
# Example 1: build from lx (Finan, Section 22 style)
x  <- 0:5
lx <- c(100000, 99500, 99000, 98200, 97000, 95000)
lt1 <- lifetable(x = x, lx = lx, omega = 5, close = TRUE)
lt1
#> # A tibble: 6 × 6
#>       x     lx    dx      qx    px      mx
#>   <int>  <dbl> <dbl>   <dbl> <dbl>   <dbl>
#> 1     0 100000   500 0.005   0.995 0.00501
#> 2     1  99500   500 0.00503 0.995 0.00504
#> 3     2  99000   800 0.00808 0.992 0.00811
#> 4     3  98200  1200 0.0122  0.988 0.0123 
#> 5     4  97000  2000 0.0206  0.979 0.0208 
#> 6     5  95000 95000 1       0     2      

# Example 2: build from qx (radix required)
qx <- c(0.005, 0.005, 0.008, 0.012, 0.020, 1)
lt2 <- lifetable(x = x, qx = qx, radix = 100000, omega = 5, close = TRUE)
lt2
#> # A tibble: 6 × 6
#>       x      lx     dx    qx    px      mx
#>   <int>   <dbl>  <dbl> <dbl> <dbl>   <dbl>
#> 1     0 100000    500  0.005 0.995 0.00501
#> 2     1  99500    498. 0.005 0.995 0.00501
#> 3     2  99002.   792. 0.008 0.992 0.00803
#> 4     3  98210.  1179. 0.012 0.988 0.0121 
#> 5     4  97032.  1941. 0.02  0.98  0.0202 
#> 6     5  95091. 95091. 1     0     2      

# Example 3: build from px
px <- 1 - c(0.005, 0.005, 0.008, 0.012, 0.020, 1)
lt3 <- lifetable(x = x, px = px, radix = 100000, omega = 5, close = TRUE)
lt3
#> # A tibble: 6 × 6
#>       x      lx     dx      qx    px      mx
#>   <int>   <dbl>  <dbl>   <dbl> <dbl>   <dbl>
#> 1     0 100000    500  0.00500 0.995 0.00501
#> 2     1  99500    498. 0.00500 0.995 0.00501
#> 3     2  99002.   792. 0.00800 0.992 0.00803
#> 4     3  98210.  1179. 0.0120  0.988 0.0121 
#> 5     4  97032.  1941. 0.0200  0.98  0.0202 
#> 6     5  95091. 95091. 1       0     2      

# Example 4: build from mx
mx <- c(0.005, 0.006, 0.008, 0.012, 0.020, 0.030)
lt4 <- lifetable(x = x, mx = mx, radix = 100000, omega = 5, close = TRUE, ax = 0.5)
lt4
#> # A tibble: 6 × 6
#>       x      lx     dx      qx    px    mx
#>   <int>   <dbl>  <dbl>   <dbl> <dbl> <dbl>
#> 1     0 100000    499. 0.00499 0.995 0.005
#> 2     1  99501.   595. 0.00598 0.994 0.006
#> 3     2  98906.   788. 0.00797 0.992 0.008
#> 4     3  98118.  1170. 0.0119  0.988 0.012
#> 5     4  96948.  1920. 0.0198  0.980 0.02 
#> 6     5  95028. 95028. 1       0     2    

# Example 5: truncate to a smaller omega
lt5 <- lifetable(x = 0:10, lx = 100000 * exp(-0.01 * (0:10)), omega = 7, close = TRUE)
lt5
#> # A tibble: 8 × 6
#>       x      lx     dx      qx    px      mx
#>   <int>   <dbl>  <dbl>   <dbl> <dbl>   <dbl>
#> 1     0 100000    995. 0.00995 0.990 0.01000
#> 2     1  99005.   985. 0.00995 0.990 0.01000
#> 3     2  98020.   975. 0.00995 0.990 0.01000
#> 4     3  97045.   966. 0.00995 0.990 0.01000
#> 5     4  96079.   956. 0.00995 0.990 0.01000
#> 6     5  95123.   946. 0.00995 0.990 0.01000
#> 7     6  94176.   937. 0.00995 0.990 0.01000
#> 8     7  93239. 93239. 1       0     2      

# Example 6: Finan Example 22.1 - exponential survival s(x) = exp(-0.005x)
lt_exp <- lifetable(
  x  = 0:7,
  lx = 1000 * exp(-0.005 * (0:7)),
  close = TRUE
)
lt_exp
#> # A tibble: 8 × 6
#>       x    lx     dx      qx    px      mx
#>   <int> <dbl>  <dbl>   <dbl> <dbl>   <dbl>
#> 1     0 1000    4.99 0.00499 0.995 0.00500
#> 2     1  995.   4.96 0.00499 0.995 0.00500
#> 3     2  990.   4.94 0.00499 0.995 0.00500
#> 4     3  985.   4.91 0.00499 0.995 0.00500
#> 5     4  980.   4.89 0.00499 0.995 0.00500
#> 6     5  975.   4.86 0.00499 0.995 0.00500
#> 7     6  970.   4.84 0.00499 0.995 0.00500
#> 8     7  966. 966.   1       0     2      

# Example 7: verify survival identity (Finan, Section 22)
# 2_p_2 = l_4 / l_2 = 97000 / 99000
lt1$lx[lt1$x == 4] / lt1$lx[lt1$x == 2]
#> [1] 0.979798

# Example 8: without closure - qx at omega is not forced to 1
lt_open <- lifetable(x = 0:3, lx = c(1000, 900, 750, 500), close = FALSE)
lt_open$qx  # last element is NA
#> [1] 0.1000000 0.1666667 0.3333333 1.0000000

# Example 9: access table metadata
attr(lt1, "omega")   # 5
#> [1] 5
attr(lt1, "closed")  # TRUE
#> [1] TRUE
attr(lt1, "frac")    # "UDD"
#> [1] "UDD"
attr(lt1, "ax")      # 0.5
#> [1] 0.5
```
