# Summarise Monte Carlo simulation output

Computes tidy summary statistics from simulated actuarial values, using
a column-oriented interface consistent with the Monte Carlo functions in
`tidyactuarial`.

## Usage

``` r
summary_mc(
  .data = NULL,
  col_value = "present_value",
  by = NULL,
  probs = c(0.025, 0.5, 0.975),
  var_probs = c(0.95, 0.99),
  na_rm = TRUE,
  ...
)
```

## Arguments

- .data:

  A data.frame or tibble containing simulation output.

- col_value:

  Character string. Name of the numeric column to summarise. Defaults to
  `"present_value"`.

- by:

  Optional character vector of grouping columns. If supplied, the
  summary is computed separately within each group. If `by = NULL` and
  `.data` is already grouped with
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html),
  the current grouping structure is used.

- probs:

  Numeric vector of probabilities for quantiles. Use
  [`numeric()`](https://rdrr.io/r/base/numeric.html) to omit these
  columns.

- var_probs:

  Numeric vector of probabilities for VaR and TVaR. Use
  [`numeric()`](https://rdrr.io/r/base/numeric.html) to omit these
  columns.

- na_rm:

  Logical scalar. If `TRUE`, missing values are removed before computing
  statistics.

- ...:

  Transitional compatibility for older calls using `data`, `value_col`,
  and `group_cols`.

## Value

A tibble with summary statistics.

## Details

This function is intentionally generic. It can summarise simulated
present values from annuities, insurances, premiums, reserves, losses,
or any other numeric actuarial indicator stored in a tidy simulation
table.

This function follows the compact column-naming convention used
throughout the Monte Carlo layer of `tidyactuarial`: column arguments
are prefixed with `col_`. Thus, `col_value` identifies the simulated
actuarial value to summarise.

The function computes the number of simulations used, number of missing
values, mean, variance, standard deviation, standard error, minimum,
maximum, selected quantiles, empirical VaR, and empirical TVaR.

Empirical VaR uses the lower quantile (the inverse empirical CDF; type
1), without interpolation between observed loss amounts. In contrast,
the descriptive \`q...\` columns retain the default interpolated
quantiles from \[stats::quantile()\].

TVaR uses the mean of the upper \`1 - p\` fraction of the empirical loss
distribution, with the appropriate fraction of any probability mass at
VaR. Equivalently, for \`0 \<= p \< 1\` and \`v = VaR_p(X)\`,
\`TVaR_p(X) = v + E\[(X - v)\_+\] / (1 - p)\`. For \`p = 1\`, the finite
empirical upper-endpoint limit (\`max(x)\`) is reported. At \`p = 0\`,
TVaR is the empirical mean. Negative simulated values are permitted
because \`summary_mc()\` is a generic numeric summary. TVaR is evaluated
from ordered empirical probability masses, avoiding subtraction of
extreme losses. A fractional boundary atom is retained. Variance,
standard deviation and error are evaluated independently in scaled form
when squaring loses range: variance may be zero or infinite while the
deviation or error remains representable. Undefined moments for
nonfinite observations remain missing; extended upper tails can be
infinite. A sample smaller than two has missing variance, deviation and
error.

The column `se_mean` is the usual \\s/\sqrt{n}\\ estimate under
independent, identically distributed observations. It is not a general
Monte Carlo error estimate for antithetic, clustered, weighted or
otherwise dependent samples. A method label alone does not identify
independent sampling units after filtering, grouping or reordering, so
pairs are not inferred automatically. For known independent antithetic
pairs, summarise their pair means instead. An odd unpaired observation
or unequal weights requires an error calculation appropriate to that
sampling design.

Quantile labels retain the existing rounding to thousandths of
probability; probabilities within a selector must yield distinct labels.
Empty grouped inputs retain the statistical columns with zero output
rows. An ungrouped empty effective sample retains one row of counts and
missing statistics.

If `na_rm = TRUE`, missing values in `col_value` are removed before
computing statistics. If `na_rm = FALSE` and missing values are present,
most numerical statistics are returned as `NA_real_`, avoiding
accidental silent deletion of missing reserve or loss scenarios.

## See also

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md)

## Examples

``` r
sim <- tibble::tibble(
  sim_id = 1:5,
  t = c(0, 0, 1, 1, 1),
  L_t = c(10, 12, 8, 15, 11)
)

summary_mc(sim, col_value = "L_t")
#> # A tibble: 1 × 16
#>   n_sim n_total n_missing  mean variance    sd se_mean   min   max  q025  q500
#>   <int>   <int>     <int> <dbl>    <dbl> <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1     5       5         0  11.2      6.7  2.59    1.16     8    15   8.2    11
#> # ℹ 5 more variables: q975 <dbl>, VaR_950 <dbl>, VaR_990 <dbl>, TVaR_950 <dbl>,
#> #   TVaR_990 <dbl>
summary_mc(sim, col_value = "L_t", by = "t")
#> # A tibble: 2 × 17
#>       t n_sim n_total n_missing  mean variance    sd se_mean   min   max  q025
#>   <dbl> <int>   <int>     <int> <dbl>    <dbl> <dbl>   <dbl> <dbl> <dbl> <dbl>
#> 1     0     2       2         0  11        2    1.41    1       10    12 10.0 
#> 2     1     3       3         0  11.3     12.3  3.51    2.03     8    15  8.15
#> # ℹ 6 more variables: q500 <dbl>, q975 <dbl>, VaR_950 <dbl>, VaR_990 <dbl>,
#> #   TVaR_950 <dbl>, TVaR_990 <dbl>

# Transitional compatibility with older argument names
summary_mc(sim, value_col = "L_t", group_cols = "t")
#> # A tibble: 2 × 17
#>       t n_sim n_total n_missing  mean variance    sd se_mean   min   max  q025
#>   <dbl> <int>   <int>     <int> <dbl>    <dbl> <dbl>   <dbl> <dbl> <dbl> <dbl>
#> 1     0     2       2         0  11        2    1.41    1       10    12 10.0 
#> 2     1     3       3         0  11.3     12.3  3.51    2.03     8    15  8.15
#> # ℹ 6 more variables: q500 <dbl>, q975 <dbl>, VaR_950 <dbl>, VaR_990 <dbl>,
#> #   TVaR_950 <dbl>, TVaR_990 <dbl>
```
