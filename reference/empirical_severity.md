# Specify an empirical claim severity distribution

Constructs the discrete severity distribution implied by observed
individual claim amounts or a weighted table of claim amounts. No
parametric family is fitted, observations are not rounded, and no
smoothing or discretization is performed.

## Usage

``` r
empirical_severity(data, amount = NULL, weight = NULL, label = NULL)
```

## Arguments

- data:

  A nonempty numeric vector of nonnegative observed claim amounts, or a
  data frame containing those amounts.

- amount:

  For data-frame input, an unquoted column containing individual claim
  amounts. Required for data frames; omit for numeric vectors.

- weight:

  Optional nonnegative observation weights. For data frames, supply an
  unquoted column; for vectors, supply a numeric vector of equal length.
  If omitted, all observations have weight one. In a summarized table,
  weights can represent the multiplicities of each observed amount.
  Weights are not exposure offsets or inputs to a fitted model.

- label:

  Optional nonempty character scalar identifying the distribution.

## Value

An object with classes `"tidyact_severity_spec"` and
`"tidyact_distribution_spec"`, containing `schema_version`, `dist`,
`params`, `support`, `data`, `custom`, `label`, and `metadata`. The
`data` field is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with `amount`, `weight`, and `probability` columns, sorted by amount.
Only observed amounts with positive empirical probability are retained.

## Details

Given observed amounts \\x_1,\ldots,x_n\\ and nonnegative weights
\\w_1,\ldots,w_n\\, the exact empirical probability assigned to amount
\\x\\ is \$\$\widehat{p}(x) = \frac{\sum\_{i=1}^n w_i
I(x_i=x)}{\sum\_{i=1}^n w_i}.\$\$

Only strictly positive-weight observations contribute to the
distribution; at least one positive weight is required. Repeated amounts
are combined and stored in increasing order. Every unobserved amount has
probability zero. Amounts must be finite, nonnegative numeric values. An
observed amount of zero is valid and produces a genuine probability mass
at zero; it is not removed or converted into a positive-payment
severity.

The result is a *finite discrete* severity specification, even when the
observed amounts are decimal or come from an underlying continuous loss
process. It is **not** a continuous density estimate and has no PDF.
Values are compared exactly as represented numerically: close but
unequal amounts are not merged. The function also does not infer a
loss/payment basis, deductibles, limits, or monetary rounding rules.

The S3 contract matches
[`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md):
`dist = "empirical"`, with `params = list(values = ..., probs = ...)`
and a compact `data` table. The original individual observations are not
retained. The internal severity registry makes the PMF, CDF, quantile,
RNG, raw moments, limited moments, MGF, and Laplace transform available.
No simulation occurs during construction.

For these finite observations all positive integer-order raw moments
exist mathematically, although large powers can exceed floating-point
range.

## See also

[`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md),
[`empirical_frequency()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_frequency.md),
[`distribution_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_moments.md)

## Examples

``` r
# One claim amount per observation, including a zero payment.
losses <- c(0, 500, 500, 1250.50, 3000)
x <- empirical_severity(losses)
x
#> <tidyact_severity_spec>
#> Distribution: Empirical
#> Parameters:
#>   values: 0.0, 500.0, 1250.5, 3000.0
#>   probs: 0.2, 0.4, 0.2, 0.2
#> Support: discrete [0, 3000]
x$data
#> # A tibble: 4 × 3
#>   amount weight probability
#>    <dbl>  <dbl>       <dbl>
#> 1     0       1         0.2
#> 2   500       2         0.4
#> 3  1250.      1         0.2
#> 4  3000       1         0.2
distribution_moments(x, order = 1:4)
#> # A tibble: 4 × 4
#>   type  order   value status
#>   <chr> <int>   <dbl> <chr> 
#> 1 raw       1 1.05e 3 finite
#> 2 raw       2 2.21e 6 finite
#> 3 raw       3 5.84e 9 finite
#> 4 raw       4 1.67e13 finite

# Exactly the same empirical distribution from a summarized claim table.
claims <- tibble::tibble(
  payment = c(0, 500, 1250.50, 3000),
  claims = c(1, 2, 1, 1)
)
claims |>
  empirical_severity(amount = payment, weight = claims)
#> <tidyact_severity_spec>
#> Distribution: Empirical
#> Parameters:
#>   values: 0.0, 500.0, 1250.5, 3000.0
#>   probs: 0.2, 0.4, 0.2, 0.2
#> Support: discrete [0, 3000]

# A tidyverse pipeline with individual claim observations.
tibble::tibble(claim_amount = c(150, 150, 375, 900)) |>
  empirical_severity(amount = claim_amount, label = "Reported severities")
#> <tidyact_severity_spec>
#> Distribution: Empirical
#> Parameters:
#>   values: 150, 375, 900
#>   probs: 0.50, 0.25, 0.25
#> Support: discrete [150, 900]
#> Label: Reported severities
```
