# Specify a collective risk model

Creates a lightweight specification of the classical collective risk
model

\$\$S = \sum\_{i=1}^{N} X_i,\$\$

where \\N\\ is a claim count random variable and \\X_1, X_2, \ldots\\
are identically distributed individual claim severities. Independence
between the frequency variable and the severities, and mutual
independence of the severities, are intrinsic assumptions of this
specification.

The constructor records the probabilistic model only. It does not
calculate aggregate moments, construct the distribution of \\S\\,
discretize a severity distribution, simulate losses, or apply an
approximation.

## Usage

``` r
collective_risk_spec(frequency, severity, count_basis = NULL, label = NULL)
```

## Arguments

- frequency:

  A `tidyact_frequency_spec` object, typically created with
  [`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md)
  or
  [`empirical_frequency()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_frequency.md).

- severity:

  A `tidyact_severity_spec` object, typically created with
  [`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md)
  or
  [`empirical_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_severity.md).

- count_basis:

  Either `NULL`, `"loss"`, or `"payment"`. The count basis indicates
  whether `frequency` counts underlying losses or positive payments.
  When `NULL`, the constructor uses basis information already carried by
  the component specifications when available; otherwise the default is
  `"loss"`.

- label:

  Optional nonempty character scalar identifying the model.

## Value

An object with classes `"tidyact_collective_risk_spec"` and
`"tidyact_risk_spec"`. It contains the following fields:

- `schema_version`: internal schema version.

- `frequency`: the frequency specification.

- `severity`: the severity specification.

- `count_basis`: either `"loss"` or `"payment"`.

- `label`: optional user label.

- `metadata`: reserved metadata list.

## Details

The collective model is represented by the random sum

\$\$S = X_1 + \cdots + X_N,\$\$

with the convention \\S = 0\\ when \\N = 0\\.

`collective_risk_spec()` deliberately keeps the model specification
separate from computational methods. In particular, no Panjer recursion,
convolution, FFT calculation, Monte Carlo simulation, numerical
discretization, or normal approximation is performed by this function.

The `count_basis` field is part of the model because frequency and
severity must refer to the same event basis. A loss-basis specification
counts underlying losses, including losses that may later produce a zero
payment after coverage is applied. A payment-basis specification counts
positive payments. Conversion between these bases is a separate
actuarial operation and is not performed silently by this constructor.

The constructor does not expose an `independence` argument. Independence
is part of the definition of this version of the collective risk model
rather than an optional computational setting.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed. Society of Actuaries.

## See also

[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md),
[`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md),
[`empirical_frequency()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_frequency.md),
[`empirical_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_severity.md),
[`distribution_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_moments.md)

## Examples

``` r
frequency <- frequency_spec(
  "poisson",
  lambda = 4
)

severity <- severity_spec(
  "gamma",
  shape = 2,
  rate = 0.001
)

model <- collective_risk_spec(
  frequency,
  severity
)

model
#> <tidyact_collective_risk_spec>
#> Model: S = sum(X_i, i = 1, ..., N)
#> Frequency: Poisson
#> Severity: Gamma
#> Count basis: loss

# An explicit payment-basis model.
collective_risk_spec(
  frequency,
  severity,
  count_basis = "payment",
  label = "Illustrative payment model"
)
#> <tidyact_collective_risk_spec>
#> Model: S = sum(X_i, i = 1, ..., N)
#> Frequency: Poisson
#> Severity: Gamma
#> Count basis: payment
#> Label: Illustrative payment model

# Empirical components can be used without fitting a parametric model.
empirical_n <- empirical_frequency(c(0, 0, 1, 1, 2, 3))
empirical_x <- empirical_severity(c(500, 750, 1000, 1500, 3000))

collective_risk_spec(
  empirical_n,
  empirical_x
)
#> <tidyact_collective_risk_spec>
#> Model: S = sum(X_i, i = 1, ..., N)
#> Frequency: Empirical
#> Severity: Empirical
#> Count basis: loss
```
