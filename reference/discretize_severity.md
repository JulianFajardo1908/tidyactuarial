# Discretize a continuous claim severity distribution

Converts a continuous nonnegative severity specification into an
explicit lattice distribution. The transformation is intended for
actuarial algorithms that require discrete severities, such as Panjer
recursion or FFT-based aggregate-loss methods.

Discretization is always explicit: this function is never called
silently by aggregate-loss functions.

## Usage

``` r
discretize_severity(
  x,
  step,
  to = NULL,
  method = c("unbiased", "upper", "lower", "rounding"),
  tail_prob = 1e-08,
  label = NULL
)
```

## Arguments

- x:

  A continuous `tidyact_severity_spec` object.

- step:

  Positive finite numeric scalar giving the lattice spacing.

- to:

  Optional positive finite upper grid point. It must be an integer
  multiple of `step`. If `NULL`, the upper point is selected from the
  `(1 - tail_prob)` quantile and rounded upward to the next grid point.

- method:

  Discretization method. One of `"unbiased"`, `"upper"`, `"lower"`, or
  `"rounding"`.

- tail_prob:

  Probability used to select `to` when `to = NULL`. Must satisfy
  `0 < tail_prob < 1`.

- label:

  Optional nonempty character scalar. If `NULL`, the label of `x` is
  retained.

## Value

A `tidyact_severity_spec` and `tidyact_distribution_spec` object with
`dist = "discrete"`, lattice support, and discretization information in
`metadata$discretization`.

The metadata records:

- `method`;

- `step`;

- `to`;

- whether `to` was supplied or selected from `tail_prob`;

- the requested `tail_prob` when applicable;

- the actual probability above `to`;

- the explicit tail treatment;

- the original distribution identifier; and

- the source of the limited mean for the unbiased method.

## Details

Let \\F\\ be the severity CDF, \\h\\ the lattice step, and \\b =
\mathrm{to}\\. The lattice is

\$\$0, h, 2h, \ldots, b.\$\$

The four methods follow standard actuarial discretization conventions.

### Upper method

For lattice points below `to`,

\$\$ p_x = F(x+h)-F(x). \$\$

This assigns each interval to its lower lattice endpoint. Probability
above `to` is assigned explicitly to the upper grid point.

### Lower method

\$\$ p_0 = F(0), \qquad p_x = F(x)-F(x-h). \$\$

This assigns each interval to its upper lattice endpoint. Probability
above `to` is added to the upper grid point.

### Rounding method

Probability is allocated according to the midpoint intervals around each
lattice point. Thus the first cell extends from zero to `step / 2`,
interior cells have width `step`, and the last cell contains everything
above `to - step / 2`.

### Unbiased method

The unbiased method performs local first-moment matching. If \\L(d) =
E\[\min(X,d)\]\\, the finite-grid probabilities before the final tail
adjustment are

\$\$ p_0 = 1 - F(0) - \frac{L(h)-L(0)}{h}, \$\$

\$\$ p_x = \frac{2L(x)-L(x-h)-L(x+h)}{h}, \qquad 0 \< x \< b, \$\$

and

\$\$ p_b = \frac{L(b)-L(b-h)}{h} - 1 + F(b). \$\$

The residual tail probability above `to` is then assigned to `to`.
Consequently, the resulting distribution is a proper probability
distribution and its first moment matches \\E\[\min(X,b)\]\\, rather
than silently discarding probability above the truncation point.

For the exponential, gamma, lognormal, Weibull, and Pareto II families,
the first limited moment used by the unbiased method is evaluated
analytically. For other continuous specifications with a CDF, including
Burr XII, log-logistic, and eligible custom models, the limited mean is
obtained by numerical integration of the survival function. The source
used is recorded in `metadata$discretization$limited_mean_source`.

Only continuous severity specifications are accepted in this initial
implementation. Finite discrete and empirical severities already have
probability masses and should not be silently re-discretized. Support
for mixed severities can be added later without changing this public
interface.

The returned object uses the existing `"discrete"` severity operations
but has `support$type = "lattice"`. Zero-probability grid points need
not be stored explicitly in `params$values`; the lattice information is
retained in `support`.

## References

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2019). *Loss Models:
From Data to Decisions*, 5th ed. Wiley.

## See also

[`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md),
[`distribution_convolution()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_convolution.md)

## Examples

``` r
x <- severity_spec(
  "gamma",
  shape = 2,
  rate = 0.001
)

# Automatic upper grid point from a small tail probability.
dx <- discretize_severity(
  x,
  step = 100
)
dx
#> <tidyact_severity_spec>
#> Distribution: Finite discrete
#> Parameters:
#>   values: 0, 100, 200, 300, ...
#>   probs: 0.001585779, 0.008905010, 0.016251719, 0.022119521, ...
#> Support: lattice [0, 21600]

# Inspect the resulting lattice probabilities.
tibble::tibble(
  amount = dx$params$values,
  probability = dx$params$probs
)
#> # A tibble: 217 × 2
#>    amount probability
#>     <dbl>       <dbl>
#>  1      0     0.00159
#>  2    100     0.00891
#>  3    200     0.0163 
#>  4    300     0.0221 
#>  5    400     0.0267 
#>  6    500     0.0303 
#>  7    600     0.0329 
#>  8    700     0.0347 
#>  9    800     0.0359 
#> 10    900     0.0366 
#> # ℹ 207 more rows

# Use a fixed truncation point and another discretization rule.
discretize_severity(
  x,
  step = 250,
  to = 10000,
  method = "rounding"
)
#> <tidyact_severity_spec>
#> Distribution: Finite discrete
#> Parameters:
#>   values: 0, 250, 500, 750, ...
#>   probs: 0.007190985, 0.047786257, 0.075222937, 0.088183534, ...
#> Support: lattice [0, 10000]

# The discretization choices remain auditable.
dx$metadata$discretization
#> $method
#> [1] "unbiased"
#> 
#> $step
#> [1] 100
#> 
#> $to
#> [1] 21600
#> 
#> $cutoff_source
#> [1] "tail_prob"
#> 
#> $requested_tail_prob
#> [1] 1e-08
#> 
#> $actual_tail_probability
#> [1] 9.404758e-09
#> 
#> $tail_handling
#> [1] "assigned_to_upper_grid_point"
#> 
#> $source_dist
#> [1] "gamma"
#> 
#> $limited_mean_source
#> [1] "analytic"
#> 
```
