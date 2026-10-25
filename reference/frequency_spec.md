# Specify a claim frequency distribution

Creates a lightweight specification of a claim count distribution for
use in actuarial risk models.

## Usage

``` r
frequency_spec(dist, ..., custom = NULL, label = NULL)
```

## Arguments

- dist:

  Character scalar identifying the frequency distribution. Currently
  supported values are \`"poisson"\`, \`"binomial"\`,
  \`"negative_binomial"\`, \`"geometric"\`, and \`"custom"\`.

- ...:

  Named parameters defining the selected distribution.

- custom:

  Optional named list defining a custom count distribution. Used only
  when \`dist = "custom"\`. At minimum, the list must contain \`pmf\`, a
  probability mass function.

- label:

  Optional character scalar used to identify the specification.

## Value

An object with classes \`"tidyact_frequency_spec"\` and
\`"tidyact_distribution_spec"\`.

## Details

A frequency specification represents a nonnegative integer-valued random
variable. The constructor stores the probabilistic model only; it does
not simulate observations, estimate parameters, or calculate aggregate
losses.

Built-in parameterizations follow \`stats\`: Poisson uses \`lambda\`,
binomial uses \`size\` and \`prob\`, negative binomial uses \`size\` and
\`prob\`, and geometric uses \`prob\` with support beginning at zero.

## Examples

``` r
frequency_spec("poisson", lambda = 4)
#> <tidyact_frequency_spec>
#> Distribution: Poisson
#> Parameters:
#>   lambda: 4
#> Support: {0, 1, 2, ...}
frequency_spec("binomial", size = 20, prob = 0.15)
#> <tidyact_frequency_spec>
#> Distribution: Binomial
#> Parameters:
#>   size: 20
#>   prob: 0.15
#> Support: {0, 1, ..., 20}
frequency_spec("negative_binomial", size = 2.5, prob = 0.4)
#> <tidyact_frequency_spec>
#> Distribution: Negative binomial
#> Parameters:
#>   size: 2.5
#>   prob: 0.4
#> Support: {0, 1, 2, ...}
frequency_spec("geometric", prob = 0.25)
#> <tidyact_frequency_spec>
#> Distribution: Geometric
#> Parameters:
#>   prob: 0.25
#> Support: {0, 1, 2, ...}
```
