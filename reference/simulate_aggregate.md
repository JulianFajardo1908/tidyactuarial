# Simulate a collective risk model

Samples independent realizations of S = X\[1\] + ... + X\[N\], drawing
frequencies first and then independent severities conditional on those
counts. A zero-frequency realization has aggregate loss zero. The model
assumes iid severities independent of frequency. Whenever the moments
exist, E\[S\] = E\[N\] E\[X\], and Var(S) = E\[N\] Var(X) + Var(N)
E\[X\]^2.

## Usage

``` r
simulate_aggregate(x, n_sim = 1000L, seed = NULL, max_claims = 1000000L)
```

## Arguments

- x:

  A \[collective_risk_spec()\] object. Zero-payment specifications
  produced by \[to_payment_basis()\] are also accepted.

- n_sim:

  Positive integer number of independent realizations.

- seed:

  Optional nonnegative integer random seed, restored after use.

- max_claims:

  Maximum total number of individual claim draws in one invocation.
  Exceeding this protective allocation limit is an error, not a
  truncation of the frequency distribution.

## Value

A tibble with \`simulation\`, \`claim_count\`, and \`aggregate_loss\`.

## Details

The resulting aggregate distribution follows the frequency and severity
specifications on their explicitly declared count basis. All individual
severities are iid and independent of frequency.

## Examples

``` r
model <- collective_risk_spec(frequency_spec("poisson", lambda = 2),
                              severity_spec("degenerate", value = 100))
simulate_aggregate(model, n_sim = 5, seed = 30)
#> # A tibble: 5 × 3
#>   simulation claim_count aggregate_loss
#>        <int>       <dbl>          <dbl>
#> 1          1           0              0
#> 2          2           2            200
#> 3          3           1            100
#> 4          4           2            200
#> 5          5           1            100
```
