# Compute the aggregate loss distribution

Evaluates the distribution of the collective aggregate loss

\$\$S = \sum\_{i=1}^{N} X_i\$\$

from a `tidyact_collective_risk_spec` object.

The function separates the actuarial model from the computational
algorithm. It never fits a distribution, never simulates the aggregate
loss, and never discretizes a continuous severity implicitly.

## Usage

``` r
aggregate_distribution(
  x,
  method = c("auto", "analytic", "convolution", "panjer", "fft"),
  tol = 1e-08,
  max_loss = NULL,
  ...
)
```

## Arguments

- x:

  A `tidyact_collective_risk_spec` object.

- method:

  Computational method. One of `"auto"`, `"analytic"`, `"convolution"`,
  `"panjer"`, or `"fft"`.

- tol:

  Positive finite probability tolerance smaller than one. It is used
  when an infinite claim-count distribution must be truncated
  numerically or when Panjer recursion is allowed to stop after
  capturing at least `1 - tol` of the aggregate probability.

- max_loss:

  Optional nonnegative finite numeric scalar giving the largest
  aggregate-loss value to retain in the returned grid. Probability above
  the retained grid is not renormalized; it is reported separately as
  `tail_probability`, together with any omitted claim-count probability.

- ...:

  Reserved for future computational controls. Additional arguments are
  currently rejected.

## Value

An object with classes `"tidyact_aggregate_distribution"` and
`"tidyact_risk_distribution"`. It contains:

- `schema_version`:

  Internal schema version.

- `method`:

  The computational method actually used.

- `grid`:

  A tibble with `loss`, `probability`, and `cdf`.

- `support`:

  Support information for the retained grid.

- `tail_probability`:

  Probability not represented on the retained grid.

- `model`:

  The source collective risk specification.

- `label`:

  The model label, if any.

- `metadata`:

  Audit information about method selection, truncation, exactness, and
  numerical controls.

## Details

`aggregate_distribution()` operates only on an already specified
collective model. The probabilistic model is never changed in order to
make an algorithm applicable.

In particular, if the severity distribution is continuous and no
supported analytic form is available, the function stops and asks the
user to apply
[`discretize_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discretize_severity.md)
explicitly before using Panjer recursion or FFT.

### Automatic method selection

With `method = "auto"`, the function uses the following hierarchy:

1.  an implemented analytic representation for deterministic aggregate
    structures;

2.  Panjer recursion when the severity is on a lattice and the frequency
    distribution supplies valid Panjer parameters;

3.  exact finite convolution when both frequency and severity have
    finite discrete support;

4.  FFT when the severity is on a lattice and the frequency distribution
    supplies the probability operations required to truncate its count
    support.

If none of these conditions is satisfied, an informative error is
returned.

### Analytic method

The initial analytic engine handles aggregate losses that are degenerate
at zero and deterministic severities. If \\X = c\\ almost surely, then

\$\$S = cN\$\$

and the aggregate probabilities are obtained directly from the count
distribution. Infinite count support is truncated according to `tol`
unless `max_loss` supplies a tighter explicit cutoff.

Additional analytic compound families may be added later without
changing the public interface.

### Convolution method

The convolution engine is exact for finite claim-count support and
finite discrete severity support. It evaluates

\$\$ P(S \in A) = \sum_n P(N=n) P(X_1+\cdots+X_n \in A) \$\$

by repeated finite convolution. If `max_loss` is supplied, the full
finite distribution is evaluated first and probability above the
requested cutoff is reported as tail probability.

### Panjer method

For a frequency distribution in the \\(a,b,0)\\ class,

\$\$ p_n = \left(a + \frac{b}{n}\right)p\_{n-1}, \$\$

and a lattice severity with probabilities \\f_j\\, the aggregate
probabilities satisfy

\$\$ g_0 = G_N(f_0) \$\$

and, for \\k \ge 1\\,

\$\$ g_k = \frac{ \sum\_{j=1}^{k} \left(a + \frac{bj}{k}\right) f_j
g\_{k-j} }{ 1-a f_0 }. \$\$

Only severity probabilities available on the lattice are used. No
discretization is performed by this engine.

### FFT method

FFT evaluates a finite polynomial approximation to the compound
distribution. For an infinite claim-count distribution, the count
support is first truncated at a quantile whose omitted probability is no
greater than `tol`. This omitted count probability is carried explicitly
into `tail_probability`; it is not wrapped into the retained FFT grid.

The FFT engine therefore uses the truncated count polynomial

\$\$ \sum\_{n=0}^{n\_{\max}} p_n z^n \$\$

rather than the full PGF. This avoids silently treating circular
aliasing as aggregate probability.

### Returned probabilities

The returned `grid` contains:

- `loss`: aggregate loss amount;

- `probability`: probability mass assigned to that amount;

- `cdf`: cumulative probability captured on the retained grid.

The grid is intentionally not renormalized when a positive tail remains.
Consequently,

\$\$ \sum p_s + p\_{\mathrm{omitted}} = 1 \$\$

up to numerical tolerance. With loss-grid truncation alone, omitted mass
is above the grid. FFT count truncation also omits events with large
claim counts but potentially small aggregate losses (especially when
zero severities are possible). Thus `tail_probability` is total
unrepresented mass, not necessarily `P(S > max(grid$loss))`. VaR checks
whether omitted count mass could change its selected quantile; TVaR and
stop-loss reject unresolved mass.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed. Society of Actuaries.

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2019). *Loss Models:
From Data to Decisions*, 5th ed. Wiley.

## See also

[`collective_risk_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/collective_risk_spec.md),
[`discretize_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discretize_severity.md),
[`aggregate_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/aggregate_moments.md)

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

# Continuous severities are never discretized implicitly.
if (FALSE) { # \dontrun{
aggregate_distribution(model)
} # }

lattice_severity <- discretize_severity(
  severity,
  step = 100
)

lattice_model <- collective_risk_spec(
  frequency,
  lattice_severity
)

aggregate_distribution(
  lattice_model,
  method = "panjer",
  tol = 1e-8
)
#> <tidyact_aggregate_distribution>
#> Method: panjer
#> Grid points: 545
#> Retained loss range: [0, 54400]
#> Captured probability: 0.9999999901
#> Tail probability: 9.871212736e-09

aggregate_distribution(
  lattice_model,
  method = "fft",
  tol = 1e-8
)
#> <tidyact_aggregate_distribution>
#> Method: fft
#> Grid points: 3142
#> Retained loss range: [0, 432000]
#> Captured probability: 0.9999999981
#> Tail probability: 1.923058379e-09
```
