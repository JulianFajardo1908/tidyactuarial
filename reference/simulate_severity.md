# Simulate individual claim severities

Samples independent nonnegative claim amounts from an actuarial severity
specification, including atoms at zero when present. A realization is
one individual claim amount, not an aggregate or a fitted severity
estimate.

## Usage

``` r
simulate_severity(x, n_sim = 1000L, seed = NULL)
```

## Arguments

- x:

  A \[severity_spec()\], \[empirical_severity()\], or compatible payment
  severity specification.

- n_sim:

  Positive integer number of simulations.

- seed:

  Optional nonnegative integer seed; preserves the caller's RNG state
  when supplied.

## Value

A tibble with \`simulation\` and \`claim_amount\` columns.

## Details

A missing RNG provider produces an explicit error. Zero severities are
retained; no implicit conversion from per-loss to per-payment basis
takes place.

## Examples

``` r
simulate_severity(severity_spec("exponential", rate = 0.002),
                  n_sim = 5, seed = 20)
#> # A tibble: 5 × 2
#>   simulation claim_amount
#>        <int>        <dbl>
#> 1          1         96.7
#> 2          2         29.2
#> 3          3         31.7
#> 4          4       1106. 
#> 5          5        502. 
```
