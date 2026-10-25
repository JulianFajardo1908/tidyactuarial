# Specify an empirical claim frequency distribution

Constructs the exact discrete distribution implied by observed claim
counts or a weighted count table. No parametric distribution is fitted,
no smoothing is applied, and unobserved counts receive probability zero.

## Usage

``` r
empirical_frequency(data, count = NULL, weight = NULL, label = NULL)
```

## Arguments

- data:

  A nonempty numeric vector of observed nonnegative integer counts, or a
  data frame containing those counts.

- count:

  For a data frame, an unquoted column containing the observed counts.
  Required for data-frame input and omitted for vector input.

- weight:

  Optional nonnegative observation weights. For a data frame, provide an
  unquoted column; for a vector input, provide a numeric vector of the
  same length. When omitted, every row has weight one. Weights in a
  summarized frequency table may represent the number of policies having
  each claim count; they are **not** exposure offsets for fitting a
  rate.

- label:

  Optional nonempty character scalar identifying the distribution.

## Value

An object of classes `"tidyact_frequency_spec"` and
`"tidyact_distribution_spec"`, with the ordered fields `schema_version`,
`dist`, `params`, `support`, `data`, `custom`, `label`, and `metadata`.
The `data` field is a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns `count`, `weight`, and `probability`, one row per count
with positive empirical mass.

## Details

If the observed counts are \\n_1,\ldots,n_m\\ and their nonnegative
weights are \\w_1,\ldots,w_m\\, the empirical probability mass function
is \$\$\widehat p_k = \frac{\sum\_{i=1}^m w_i\\I(n_i=k)}{\sum\_{i=1}^m
w_i}.\$\$

At least one weight must be positive. Rows with zero weight do not
contribute to the empirical support. Missing, negative, fractional, or
nonfinite claim counts are rejected rather than silently discarded.
Counts must not exceed \\2^{53}\\, the largest consecutive integer
representable exactly by an IEEE-754 double. Weights must be finite,
nonnegative, and have a strictly positive finite total. Counts are kept
in increasing order; no gaps in the observed set are filled with
artificial positive probabilities.

This is the empirical distribution of the **claim count per
observational unit** (such as a policy-year), not a table of individual
claims. A vector of all ones describes a degenerate count distribution
at one, not the total number of claims in a portfolio.

The result has the same lightweight S3 contract as
[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md).
Its `dist` field is `"empirical"`; `params` holds the finite count
values and their exact empirical probabilities, and `data` contains the
aggregated observed weights and probabilities. Only this compact
frequency table is retained, not the original individual records.

The internal frequency registry provides the PMF, CDF, quantile
function, RNG, raw and factorial moments, and probability generating
function for this model. A general finite empirical frequency
distribution is not assumed to belong to the Panjer \\(a,b,0)\\ class;
its `panjer` operation is therefore unavailable. Other methods can use
the same specification without silently fitting or approximating its
probabilities.

## See also

[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md),
[`distribution_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_moments.md)

## Examples

``` r
# One observation per policy-year: 0, 1, or 2 claims.
counts <- c(0, 0, 0, 1, 1, 2)
n <- empirical_frequency(counts)
n
#> <tidyact_frequency_spec>
#> Distribution: Empirical
#> Parameters:
#>   values: 0, 1, 2
#>   probs: 0.5000000, 0.3333333, 0.1666667
#> Support: {0, 1, ..., 2}
n$data
#> # A tibble: 3 × 3
#>   count weight probability
#>   <dbl>  <dbl>       <dbl>
#> 1     0      3       0.5  
#> 2     1      2       0.333
#> 3     2      1       0.167
distribution_moments(n, order = 1:3)
#> # A tibble: 3 × 4
#>   type  order value status
#>   <chr> <int> <dbl> <chr> 
#> 1 raw       1 0.667 finite
#> 2 raw       2 1     finite
#> 3 raw       3 1.67  finite
distribution_moments(n, order = 1:3, type = "factorial")
#> # A tibble: 3 × 4
#>   type      order value status
#>   <chr>     <int> <dbl> <chr> 
#> 1 factorial     1 0.667 finite
#> 2 factorial     2 0.333 finite
#> 3 factorial     3 0     finite

# The same empirical distribution as a summarized portfolio table.
portfolio <- tibble::tibble(
  claims = c(0, 1, 2),
  policies = c(3, 2, 1)
)
portfolio |>
  empirical_frequency(count = claims, weight = policies)
#> <tidyact_frequency_spec>
#> Distribution: Empirical
#> Parameters:
#>   values: 0, 1, 2
#>   probs: 0.5000000, 0.3333333, 0.1666667
#> Support: {0, 1, ..., 2}

# Unweighted data-frame input and a descriptive label.
observations <- tibble::tibble(claim_count = c(0, 1, 0, 2, 1))
observations |>
  empirical_frequency(count = claim_count, label = "Observed policy counts")
#> <tidyact_frequency_spec>
#> Distribution: Empirical
#> Parameters:
#>   values: 0, 1, 2
#>   probs: 0.4, 0.4, 0.2
#> Support: {0, 1, ..., 2}
#> Label: Observed policy counts
```
