# Specify an individual claim severity distribution

Creates a lightweight specification of a nonnegative claim amount \\X\\.
A specification records the probabilistic model; it does not fit data,
draw samples, discretize amounts, or calculate aggregate losses.

## Usage

``` r
severity_spec(dist, ..., custom = NULL, label = NULL)
```

## Arguments

- dist:

  One of `"exponential"`, `"gamma"`, `"lognormal"`, `"weibull"`,
  `"pareto"`, `"burr"`, `"loglogistic"`, `"degenerate"`, `"discrete"`,
  or `"custom"`.

- ...:

  Named distribution parameters, as described in *Details*.

- custom:

  Named list of computational functions and support information when
  `dist = "custom"`; `NULL` for built-in families.

- label:

  Optional nonempty character scalar identifying the model.

## Value

An object with classes `"tidyact_severity_spec"` and
`"tidyact_distribution_spec"`. The ordered fields are `schema_version`,
`dist`, `params`, `support`, `data`, `custom`, `label`, and `metadata`.
Its `data` field is `NULL`; empirical severities are handled separately.

## Details

All severities satisfy \\X \ge 0\\. The supported built-in models are:

- **Exponential:** `rate > 0`, matching
  [`stats::dexp()`](https://rdrr.io/r/stats/Exponential.html).

- **Gamma:** `shape > 0`, `rate > 0`, matching
  [`stats::dgamma()`](https://rdrr.io/r/stats/GammaDist.html).

- **Lognormal:** `meanlog` is finite and `sdlog > 0`, matching
  [`stats::dlnorm()`](https://rdrr.io/r/stats/Lognormal.html). A point
  mass is specified with `"degenerate"`.

- **Weibull:** `shape > 0`, `scale > 0`, matching
  [`stats::dweibull()`](https://rdrr.io/r/stats/Weibull.html).

- **Pareto II (Lomax):** `shape > 0`, `scale > 0`; the survival function
  is \\P(X\>x)=(1+x/\mathrm{scale})^{-\mathrm{shape}}\\ for \\x \ge 0\\.
  This is *not* the Pareto I distribution with positive lower endpoint.

- **Burr XII:** `shape1 > 0`, `shape2 > 0`, `scale > 0`, with survival
  function
  \\P(X\>x)=\[1+(x/\mathrm{scale})^{\mathrm{shape1}}\]^{-\mathrm{shape2}}\\.

- **Log-logistic:** `shape > 0`, `scale > 0`, the Burr XII special case
  `shape1 = shape`, `shape2 = 1`.

- **Degenerate:** `value >= 0` is a finite amount with probability one.

- **Finite discrete:** `values` is a strictly increasing vector of
  distinct finite nonnegative amounts; `probs` contains strictly
  positive probabilities, with the same length and summing to one (to
  numerical tolerance). Amounts need not be integer multiples of a
  common unit.

Unlike a frequency distribution, an individual claim severity may have
an atom at zero and need not be absolutely continuous. The
`"degenerate"` and `"discrete"` models are represented as discrete
specifications rather than being forced into a continuous family.

For `dist = "custom"`, `custom` must be a named list with `support` and
at least one of `pdf` or `pmf`. The `support` list must contain `type`,
`lower`, and `upper`, with `type` in `"continuous"`, `"discrete"`,
`"lattice"`, or `"mixed"`; lattice support additionally requires a
positive `step`. The `support` component may also be a function of
`params` returning that list. A mixed specification requires `pdf`,
`pmf`, and `cdf`. Custom operations, when provided, follow these
interfaces: `pdf(x, params, log = FALSE)`,
`pmf(x, params, log = FALSE)`,
`cdf(q, params, lower.tail = TRUE, log.p = FALSE)`,
`quantile(p, params, lower.tail = TRUE, log.p = FALSE)`,
`rng(n, params)`, `raw_moment(order, params)`,
`limited_moment(order, limit, params)`, `mgf(t, params)`, and
`laplace(t, params)`. The argument `params` is the named list collected
from `...`. As with
[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md),
the constructor checks the *shape* of a custom definition but cannot
certify its mathematical validity.

The internal registry supplies probability functions and raw moments for
built-in families. Some advanced operations (for example limited
moments, the MGF of heavy-tailed distributions, and numerical Laplace
transforms) are intentionally left unavailable until their public
interfaces are set. In particular, no numerical approximation is
performed by this constructor.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed. Society of Actuaries.

## See also

[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md)

## Examples

``` r
severity_spec("exponential", rate = 0.002)
#> <tidyact_severity_spec>
#> Distribution: Exponential
#> Parameters:
#>   rate: 0.002
#> Support: continuous [0, Inf]
severity_spec("gamma", shape = 2.5, rate = 0.001)
#> <tidyact_severity_spec>
#> Distribution: Gamma
#> Parameters:
#>   shape: 2.5
#>   rate: 0.001
#> Support: continuous [0, Inf]
severity_spec("lognormal", meanlog = 8, sdlog = 0.8)
#> <tidyact_severity_spec>
#> Distribution: Lognormal
#> Parameters:
#>   meanlog: 8
#>   sdlog: 0.8
#> Support: continuous [0, Inf]
severity_spec("weibull", shape = 1.7, scale = 5000)
#> <tidyact_severity_spec>
#> Distribution: Weibull
#> Parameters:
#>   shape: 1.7
#>   scale: 5000
#> Support: continuous [0, Inf]

# Pareto II and Burr XII use severity distributions starting at zero.
severity_spec("pareto", shape = 3, scale = 2000)
#> <tidyact_severity_spec>
#> Distribution: Pareto II (Lomax)
#> Parameters:
#>   shape: 3
#>   scale: 2000
#> Support: continuous [0, Inf]
severity_spec("burr", shape1 = 1.5, shape2 = 2.5, scale = 1500)
#> <tidyact_severity_spec>
#> Distribution: Burr XII
#> Parameters:
#>   shape1: 1.5
#>   shape2: 2.5
#>   scale: 1500
#> Support: continuous [0, Inf]
severity_spec("loglogistic", shape = 2.5, scale = 1500)
#> <tidyact_severity_spec>
#> Distribution: Log-logistic
#> Parameters:
#>   shape: 2.5
#>   scale: 1500
#> Support: continuous [0, Inf]

# A fixed benefit amount, including a point mass at zero.
severity_spec("degenerate", value = 1000)
#> <tidyact_severity_spec>
#> Distribution: Degenerate
#> Parameters:
#>   value: 1000
#> Support: discrete [1000, 1000]
severity_spec("degenerate", value = 0)
#> <tidyact_severity_spec>
#> Distribution: Degenerate
#> Parameters:
#>   value: 0
#> Support: discrete [0, 0]

# A claim amount distribution with a genuine atom at zero.
severity_spec(
  "discrete",
  values = c(0, 500, 2500),
  probs = c(0.1, 0.6, 0.3),
  label = "Illustrative claim payments"
)
#> <tidyact_severity_spec>
#> Distribution: Finite discrete
#> Parameters:
#>   values: 0, 500, 2500
#>   probs: 0.1, 0.6, 0.3
#> Support: discrete [0, 2500]
#> Label: Illustrative claim payments

# An explicitly defined custom continuous model.
severity_spec(
  "custom",
  rate = 0.002,
  custom = list(
    pdf = function(x, params, log = FALSE) {
      stats::dexp(x, rate = params$rate, log = log)
    },
    support = list(type = "continuous", lower = 0, upper = Inf)
  )
)
#> <tidyact_severity_spec>
#> Distribution: Custom
#> Parameters:
#>   rate: 0.002
#> Support: continuous [0, Inf]
```
