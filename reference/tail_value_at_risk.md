# Tail Value at Risk (Expected Shortfall)

Calculates TVaR_p(X) = \[E(X 1(X \> v)) + v(F(v) - p)\] / (1-p), where v
= VaR_p(X). This correctly allocates only the necessary fraction of a
probability atom at v to the upper tail.

## Usage

``` r
tail_value_at_risk(x, level = 0.95, value = NULL)
```

## Arguments

- x:

  Finite nonnegative losses, a tibble of simulations, a supported
  severity specification, or an aggregate-distribution result.

- level:

  Probabilities strictly between zero and one.

- value:

  Optional loss column name for data frames.

## Value

A tibble with \`level\`, \`tail_value_at_risk\`, and \`method\`.

## Details

An aggregate distribution with unresolved probability mass cannot yield
exact TVaR, even when its VaR is known: the missing loss expectation is
not assumed to be zero. For continuous severity families with
implemented stop-loss formulas, TVaR = VaR + E\[(X-VaR)+\]/(1-p).

## Examples

``` r
tail_value_at_risk(c(0, 100, 100, 300), level = c(0.5, 0.9))
#> # A tibble: 2 × 3
#>   level tail_value_at_risk method              
#>   <dbl>              <dbl> <chr>               
#> 1   0.5                200 empirical_simulation
#> 2   0.9                300 empirical_simulation
tail_value_at_risk(severity_spec("exponential", rate = 0.01), level = 0.95)
#> # A tibble: 1 × 3
#>   level tail_value_at_risk method     
#>   <dbl>              <dbl> <chr>      
#> 1  0.95               400. closed_form
```
