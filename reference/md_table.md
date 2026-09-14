# Multiple decrement table (annual, discrete ages)

Builds a multiple decrement table from cause-specific annual decrement
probabilities \\q_x^{(j)}\\. This function is annual/discrete: ages must
be integer-valued and the input probabilities are interpreted as
one-year decrement probabilities for each cause.

## Usage

``` r
md_table(
  qx_df,
  age_col = "x",
  cause_cols = NULL,
  radix = 1e+05,
  close = TRUE,
  check = TRUE,
  tol = 1e-10
)
```

## Arguments

- qx_df:

  A data.frame/tibble with an age column (default `x`) and one or more
  cause columns containing annual probabilities in \\\[0,1\]\\.
  Recommended naming convention: cause columns start with `"q_"` (e.g.,
  `q_death`, `q_disability`).

- age_col:

  Character. Name of the age column (default `"x"`).

- cause_cols:

  Character vector. Names of the cause columns. If `NULL` (default), all
  columns other than `age_col` are treated as causes.

- radix:

  Numeric. Starting cohort size at the first age (default `1e5`).

- close:

  Logical. If `TRUE`, requires \\q\_{\omega}^{(\tau)} = 1\\ at the last
  age (default `TRUE`).

- check:

  Logical. If `TRUE`, performs input validation (default `TRUE`).

- tol:

  Numeric tolerance used in checks (default `1e-10`).

## Value

A tibble with columns:

- `x`: integer ages.

- `lx`: cohort \\\ell_x\\.

- `q_total`: total decrement probability \\q_x^{(\tau)}\\.

- `p_total`: total survival probability \\p_x^{(\tau)}\\.

- `d_total`: total decrements \\d_x^{(\tau)} = \ell_x q_x^{(\tau)}\\.

- cause columns (as provided).

- cause-specific decrements `d_*` with \\d_x^{(j)} = \ell_x q_x^{(j)}\\.

## Details

Let the cause columns be \\q_x^{(1)}, \dots, q_x^{(J)}\\. The total
decrement probability is \\q_x^{(\tau)} = \sum_j q_x^{(j)}\\ and the
total survival probability is \\p_x^{(\tau)} = 1 - q_x^{(\tau)}\\. The
cohort is generated recursively by \\\ell\_{x+1} = \ell_x \\
p_x^{(\tau)}\\ with starting radix \\\ell\_{x_0} = \text{radix}\\.

If `close = TRUE`, the last age (omega) must satisfy
\\q\_{\omega}^{(\tau)} = 1\\ (within tolerance), so that the table
closes naturally.

## Examples

``` r
qx_df <- tibble::tibble(
  x = 30:35,
  q_death = c(0.001, 0.0012, 0.0014, 0.0017, 0.0020, 1.0000),
  q_disability = c(0.002, 0.0021, 0.0022, 0.0023, 0.0024, 0.0000)
)
md <- md_table(qx_df, radix = 1e5, close = TRUE)
md
#> # A tibble: 6 × 9
#>       x     lx q_total p_total d_total q_death q_disability d_death d_disability
#>   <int>  <dbl>   <dbl>   <dbl>   <dbl>   <dbl>        <dbl>   <dbl>        <dbl>
#> 1    30 1   e5  0.003    0.997    300   0.001        0.002     100          200 
#> 2    31 9.97e4  0.0033   0.997    329.  0.0012       0.0021    120.         209.
#> 3    32 9.94e4  0.0036   0.996    358.  0.0014       0.0022    139.         219.
#> 4    33 9.90e4  0.004    0.996    396.  0.0017       0.0023    168.         228.
#> 5    34 9.86e4  0.0044   0.996    434.  0.002        0.0024    197.         237.
#> 6    35 9.82e4  1        0      98183.  1            0       98183.           0 
```
