# Specify a convolution of probability distributions

Creates a lazy specification of the convolution of two independent
distributions or of an iid sum of a single distribution.

If \\X\\ and \\Y\\ are independent, the pairwise form represents

\$\$Z = X + Y.\$\$

The iid form represents

\$\$Z_n = X_1 + \cdots + X_n,\$\$

where \\X_1,\ldots,X_n\\ are independent copies of the distribution
specified by `x`.

The function records the convolution model but does not evaluate a
density, mass function, distribution function, or numerical convolution.

## Usage

``` r
distribution_convolution(x, y = NULL, n = NULL, label = NULL)
```

## Arguments

- x:

  A `tidyact_distribution_spec` object.

- y:

  Optional second `tidyact_distribution_spec` object. Supply `y` for a
  pairwise convolution `x + y`.

- n:

  Optional nonnegative integer scalar. Supply `n` for the iid
  convolution of `n` copies of `x`.

- label:

  Optional nonempty character scalar identifying the convolution.

## Value

For a genuine convolution, an object with classes
`"tidyact_convolution_spec"` and `"tidyact_distribution_spec"`.

The object follows the common distribution specification schema:

- `schema_version`:

  Internal schema version.

- `dist`:

  The identifier `"convolution"`.

- `params`:

  The lazy convolution definition.

- `support`:

  Inferred support information.

- `data`:

  Always `NULL`.

- `custom`:

  Always `NULL`.

- `label`:

  Optional user label.

- `metadata`:

  Reserved metadata list.

When `n = 1`, the original distribution specification is returned
instead of wrapping it in a convolution object.

## Details

Exactly one of `y` and `n` must be supplied.

The pairwise form

    distribution_convolution(x, y)

represents the distribution of the sum of two independent random
variables.

The iid form

    distribution_convolution(x, n = 5)

represents the five-fold convolution of `x`.

The cases `n = 0` and `n = 1` follow the usual convolution conventions:

- `n = 0` represents the degenerate distribution at zero;

- `n = 1` returns the original distribution specification. If `label` is
  supplied, only the label of the returned copy is changed.

The operation is deliberately *lazy*. It does not choose a computational
algorithm, discretize a continuous distribution, truncate an infinite
support, or apply FFT or Panjer recursion. Those decisions belong to
later computational functions.

Support bounds are propagated algebraically. For example, if `x` has
support bounded below by \\a\\ and `y` by \\b\\, the convolution is
bounded below by \\a+b\\. Infinite upper bounds are preserved.

Support type is inferred conservatively:

- count + count remains count;

- iid lattice sums remain lattice;

- a continuous component convolved with a discrete component is
  continuous;

- any convolution involving a mixed distribution is classified as mixed;

- otherwise discrete supports are retained as discrete.

Independence is part of the meaning of a convolution specification and
is therefore not stored as a separate flag.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed. Society of Actuaries.

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2019). *Loss Models:
From Data to Decisions*, 5th ed. Wiley.

## See also

[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md),
[`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md),
[`collective_risk_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/collective_risk_spec.md)

## Examples

``` r
x <- severity_spec(
  "gamma",
  shape = 2,
  rate = 0.001
)

y <- severity_spec(
  "lognormal",
  meanlog = 7,
  sdlog = 0.6
)

# Pairwise convolution: X + Y
distribution_convolution(x, y)
#> <tidyact_convolution_spec>
#> Mode: pairwise
#> Components: gamma + lognormal
#> Support: continuous [0, Inf]

# Four iid claim amounts: X1 + ... + X4
distribution_convolution(
  x,
  n = 4
)
#> <tidyact_convolution_spec>
#> Mode: iid
#> Component: gamma
#> Copies: 4
#> Support: continuous [0, Inf]

# The zero-fold convolution is degenerate at zero.
distribution_convolution(
  x,
  n = 0
)
#> <tidyact_convolution_spec>
#> Mode: iid
#> Component: gamma
#> Copies: 0
#> Support: discrete [0, 0]

# The one-fold convolution is the original specification.
identical(
  distribution_convolution(x, n = 1),
  x
)
#> [1] TRUE

# Count distributions can also be convolved.
n_claims <- frequency_spec(
  "poisson",
  lambda = 3
)

distribution_convolution(
  n_claims,
  n = 2
)
#> <tidyact_convolution_spec>
#> Mode: iid
#> Component: poisson
#> Copies: 2
#> Support: count [0, Inf]
```
