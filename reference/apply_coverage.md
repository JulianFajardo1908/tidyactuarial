# Apply an insurance contract to a loss severity specification

Creates a per-loss payment severity specification by combining an
existing ground-up severity model with a contract created by
[`coverage_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/coverage_spec.md).
The original model is retained and not discretized, fitted, or
simulated.

## Usage

``` r
apply_coverage(x, coverage, label = NULL)
```

## Arguments

- x:

  A severity specification inheriting from `tidyact_severity_spec`. It
  must represent nonnegative ground-up losses, not an existing payment
  specification.

- coverage:

  A `tidyact_coverage_spec` object from
  [`coverage_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/coverage_spec.md).

- label:

  Optional nonempty character scalar. If `NULL`, the source severity
  label is inherited when present; otherwise the coverage label is used
  when present.

## Value

An S3 object with classes `tidyact_payment_spec`,
`tidyact_severity_spec`, and `tidyact_distribution_spec`. The list
stores `source`, `coverage`, `basis = "per_loss"`, `label`, and a
normalized severity specification (`dist = "discrete"` for finite
discrete losses or `dist = "custom"` for continuous and mixed losses).
The support bound is not asserted to be the smallest possible bound
under the original distribution.

## Details

The payment variable is defined on a **per-loss** basis, retaining every
loss event even when the associated insurer payment is zero. This is not
the conditional payment-per-payment severity distribution.

Let `X >= 0` be the ground-up severity, `f > 0` the inflation factor,
`d_f` the indexed (or fixed) deductible, `L_f` the indexed (or fixed)
layer limit, and `c` the insurer coinsurance fraction. The exact
transformation is \$\$Y_L = c \min\\(fX-d_f)\_+, L_f\\\$\$ for an
ordinary deductible and \$\$Y_L = c \min\\fX,L_f\\ 1(fX\>d_f)\$\$ for a
franchise deductible. The `limit` caps the covered layer **before**
coinsurance; it is not a final insurer-payment limit.

A continuous ground-up distribution can become mixed: probability mass
arises at zero and, when the limit is finite and binding, at the maximum
payment `c * L_f`. Pre-existing atoms are preserved under the
pushforward and may merge. When `coinsurance = 0` or `limit = 0`, the
payment is identically zero. No smoothing or implicit discretization is
performed.

The result is an executable per-loss payment distribution specification;
its `source` and `coverage` fields contain everything necessary to
recover the payment law from the underlying severity provider. The
internal pure functions `.coverage_payment_amount()`,
`.payment_cdf_from_loss()`, `.payment_boundary_atoms()`, and
`.payment_discrete_pushforward()` implement the transformation exactly
given loss values or exact source probabilities. Finite discrete sources
are transformed exactly into a finite discrete distribution. Continuous
or mixed sources use the existing custom-provider contract for CDF,
quantiles, random generation and available exact moments. Moment orders
without an exact registered formula are reported unavailable; no
numerical integration or discretization is introduced silently.

## References

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2012). *Loss Models:
From Data to Decisions*, 4th ed., Chapter 8.

Frees, E. W., Lee, G., and Yang, L., *Loss Data Analytics*, chapters on
claim severity and coverage modifications.

## See also

[`coverage_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/coverage_spec.md)

## Examples

``` r
# Full, registered severity model.
ground_up <- severity_spec("gamma", shape = 2, rate = 0.001,
                           label = "Ground-up severity")
contract <- coverage_spec(deductible = 500, limit = 10000,
                          coinsurance = 0.8)
payments <- ground_up |> apply_coverage(contract)
inherits(payments, "tidyact_payment_spec")
#> [1] TRUE
payments$basis
#> [1] "per_loss"
payments$coverage$deductible
#> [1] 500
```
