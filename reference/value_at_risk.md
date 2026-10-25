# Value at Risk for actuarial losses

Computes the lower quantile VaR at level p: the smallest x for which
F_X(x) \>= p. No interpolation across probability atoms; for discrete
claims, the quantile is an observed support point, not an interpolated
monetary amount.

## Usage

``` r
value_at_risk(x, level = 0.95, value = NULL)
```

## Arguments

- x:

  A vector of observed losses, a tibble of simulations, a severity
  specification with an exact quantile, or an
  \[aggregate_distribution()\] result. A zero-payment specification is
  also accepted.

- level:

  Probability levels strictly between zero and one.

- value:

  Optional character name of a loss column in a data frame. By default,
  \`aggregate_loss\`, \`claim_amount\`, \`claim_count\`, \`loss\`, or
  \`payment\` is selected (in that order).

## Value

A tibble with \`level\`, \`value_at_risk\`, and \`method\`.

## Details

The tail probability retained by an aggregate-distribution object is
never renormalized away. Quantiles in its uncomputed tail are rejected.
For sampled losses the definition is empirical, not a model-based claim.
FFT count truncation can omit probability at small losses as well as
large losses. If the omitted count mass could move the selected quantile
to a smaller amount, VaR is rejected; recompute with a smaller \`tol\`.

## Examples

``` r
value_at_risk(c(0, 100, 100, 300), level = c(0.5, 0.9))
#> # A tibble: 2 × 3
#>   level value_at_risk method              
#>   <dbl>         <dbl> <chr>               
#> 1   0.5           100 empirical_simulation
#> 2   0.9           300 empirical_simulation
value_at_risk(severity_spec("exponential", rate = 0.01), level = 0.95)
#> # A tibble: 1 × 3
#>   level value_at_risk method        
#>   <dbl>         <dbl> <chr>         
#> 1  0.95          300. exact_quantile
```
