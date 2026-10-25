# Simulate claim counts from a frequency model

Draws independent realizations of the claim frequency random variable N
using the RNG registered for its distribution. A draw represents the
number of claims on one exposure or observation unit, not the portfolio
total unless the model itself is specified at portfolio level.

## Usage

``` r
simulate_frequency(x, n_sim = 1000L, seed = NULL)
```

## Arguments

- x:

  A \[frequency_spec()\] or \[empirical_frequency()\] specification.

- n_sim:

  Positive integer number of simulations.

- seed:

  Optional nonnegative integer seed. When supplied, the caller's
  random-number state is restored after the call.

## Value

A tibble with \`simulation\` and \`claim_count\` columns.

## Details

A missing RNG provider is an error, not a reason to silently approximate
the model. For an empirical frequency, the draws follow the observed
mass function exactly.

## Examples

``` r
simulate_frequency(frequency_spec("poisson", lambda = 3), n_sim = 5, seed = 10)
#> # A tibble: 5 × 2
#>   simulation claim_count
#>        <int>       <dbl>
#> 1          1           3
#> 2          2           2
#> 3          3           3
#> 4          4           4
#> 5          5           1
```
