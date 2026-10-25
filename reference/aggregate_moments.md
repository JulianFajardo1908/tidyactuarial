# Calculate moments of a collective aggregate loss

Calculates analytical raw moments, central moments, or cumulants of a
collective risk model

\$\$S = \sum\_{i=1}^{N} X_i,\$\$

using the moments of the claim count distribution and the individual
severity distribution stored in a `tidyact_collective_risk_spec` object.

No simulation, numerical integration, discretization, or approximation
is performed by this function.

## Usage

``` r
aggregate_moments(x, order = 1:4, type = "raw")
```

## Arguments

- x:

  A `tidyact_collective_risk_spec` object created by
  [`collective_risk_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/collective_risk_spec.md).

- order:

  Nonempty numeric vector of nonnegative integer moment orders. Cumulant
  orders must be positive.

- type:

  One of `"raw"` (default), `"central"`, or `"cumulant"`.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with one row per requested order and columns: `type`, `order`, `value`,
and `status`.

## Details

Let

\$\$m_j = E\[X^j\]\$\$

denote the raw severity moments and

\$\$\nu_k = E\[(N)\_k\]\$\$

the factorial moments of the claim count. For positive integer \\r\\,
the raw aggregate moment is evaluated through the random-sum identity

\$\$ E\[S^r\] = \sum\_{k=1}^{r} \nu_k B\_{r,k}(m_1,\ldots,m\_{r-k+1}),
\$\$

where \\B\_{r,k}\\ is a partial exponential Bell polynomial.

This formulation includes the familiar identities

\$\$E\[S\] = E\[N\]E\[X\]\$\$

and

\$\$ \operatorname{Var}(S) = E\[N\]\operatorname{Var}(X) +
\operatorname{Var}(N)(E\[X\])^2. \$\$

Central moments and cumulants are derived algebraically from aggregate
raw moments. For a compound Poisson model, cumulants use the direct
identity

\$\$\kappa_r(S) = \lambda E\[X^r\]\$\$

whenever the corresponding severity moment is finite.

The function respects the status information returned by
[`distribution_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_moments.md).
Results are classified as:

- `"finite"`: a finite numerical result;

- `"infinite"`: a mathematically divergent raw or central moment;

- `"undefined"`: the requested quantity cannot be defined from the
  available moments;

- `"overflow"`: a theoretically finite calculation exceeded
  floating-point range.

Because both frequency and severity are nonnegative in this module, a
finite first moment equal to zero identifies a degenerate-at-zero
component. If either \\N=0\\ almost surely or \\X=0\\ almost surely,
then the aggregate loss is degenerate at zero and all positive-order
aggregate moments and cumulants are zero.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed. Society of Actuaries.

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2019). *Loss Models:
From Data to Decisions*, 5th ed. Wiley.

## See also

[`collective_risk_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/collective_risk_spec.md),
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

aggregate_moments(model)
#> # A tibble: 4 × 4
#>   type  order   value status
#>   <chr> <int>   <dbl> <chr> 
#> 1 raw       1 8   e 3 finite
#> 2 raw       2 8.80e 7 finite
#> 3 raw       3 1.18e12 finite
#> 4 raw       4 1.86e16 finite

aggregate_moments(
  model,
  order = 1:4,
  type = "central"
)
#> # A tibble: 4 × 4
#>   type    order   value status
#>   <chr>   <int>   <dbl> <chr> 
#> 1 central     1 0       finite
#> 2 central     2 2.40e 7 finite
#> 3 central     3 9.60e10 finite
#> 4 central     4 2.21e15 finite

aggregate_moments(
  model,
  order = 1:4,
  type = "cumulant"
)
#> # A tibble: 4 × 4
#>   type     order   value status
#>   <chr>    <int>   <dbl> <chr> 
#> 1 cumulant     1 8   e 3 finite
#> 2 cumulant     2 2.40e 7 finite
#> 3 cumulant     3 9.60e10 finite
#> 4 cumulant     4 4.80e14 finite
```
