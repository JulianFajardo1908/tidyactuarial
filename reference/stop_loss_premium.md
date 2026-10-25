# Net stop-loss premium

Computes E\[(X-d)+\], the expected excess loss over retention d, with no
loading or discounting. This is a per-risk expectation for X.
Equivalently, the premium is the integral of the survival function from
the retention to infinity, provided the expectation is finite.

## Usage

``` r
stop_loss_premium(x, retention = 0, value = NULL)
```

## Arguments

- x:

  A nonnegative loss sample or simulation tibble, a supported severity
  specification, or an aggregate-distribution result.

- retention:

  Finite nonnegative retention amount(s).

- value:

  Optional name of a loss column when \`x\` is a data frame.

## Value

A tibble with \`retention\`, \`premium\`, and \`method\`.

## Details

Closed forms are available for exponential, gamma, lognormal, Weibull,
and Pareto II severity. Burr XII, log-logistic, and bounded custom
distributions with a survival provider use explicitly identified
numerical integration of the survival function. Finite discrete models
and observations are summed exactly over their mass distributions. A
missing aggregate tail forbids an exact stop-loss expectation; no
renormalization or zero assumption is made. The Pareto II premium is
infinite when shape \<= 1. Per-loss exponential severities transformed
by \[apply_coverage()\] use closed forms for ordinary and franchise
deductibles, including unlimited coverage. This avoids numerical
integration over very large limits.

## Examples

``` r
stop_loss_premium(c(0, 100, 200, 500), retention = c(0, 150))
#> # A tibble: 2 × 3
#>   retention premium method              
#>       <dbl>   <dbl> <chr>               
#> 1         0     200 empirical_simulation
#> 2       150     100 empirical_simulation
stop_loss_premium(severity_spec("exponential", rate = 0.01), retention = 50)
#> # A tibble: 1 × 3
#>   retention premium method     
#>       <dbl>   <dbl> <chr>      
#> 1        50    60.7 closed_form
```
