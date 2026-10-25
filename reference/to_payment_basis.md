# Specify a change from per-loss to per-payment basis

Records the exact actuarial change of basis for a collective risk model
whose severity is a per-loss payment specification from
[`apply_coverage()`](https://julianfajardo1908.github.io/tidyactuarial/reference/apply_coverage.md).
The conversion uses binomial thinning of the loss count and conditioning
the payment amount on a strictly positive insurer payment.

## Usage

``` r
to_payment_basis(x, label = NULL)
```

## Arguments

- x:

  A list-backed collective risk specification containing `frequency` (a
  `tidyact_frequency_spec`) and `severity` (a `tidyact_payment_spec`
  with `basis = "per_loss"`). The collective class
  `tidyact_collective_risk_spec`, as provided by
  [`collective_risk_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/collective_risk_spec.md).
  The input must have `count_basis = "loss"`.

- label:

  Optional nonempty character scalar identifying the transformed model.
  If `NULL`, the collective model label is inherited when present.

## Value

For `q > 0`, a `tidyact_payment_basis_spec` that also inherits from
`tidyact_collective_risk_spec`, with thinned frequency, conditional
positive severity, `count_basis = "payment"`, the unchanged source, and
metadata. For `q = 0`, an explicit `tidyact_zero_payment_basis_spec`
with no per-payment severity, since conditioning on zero-probability
events is undefined. This degenerate result is not a collective risk
specification.

## Details

Write `N_L` for the number of losses and `Y_L` for the insurer payment
**per loss**, including zero payments. Put \$\$q = P(Y_L \> 0) =
1-F\_{Y_L}(0).\$\$ Assuming independent, identically distributed loss
severities independent of `N_L`, the number of payments has the
binomial-thinning law \$\$N_P \mid N_L=n \sim Binomial(n,q).\$\$ For
`q > 0`, the **per-payment** severity is \$\$Y_P \stackrel{d}{=} (Y_L
\mid Y_L\>0)\$\$ and its CDF is `0` for `y <= 0` and
\$\$F\_{Y_P}(y)=\frac{F\_{Y_L}(y)-(1-q)}{q}, \quad y\>0.\$\$
Consequently, the probability generating functions satisfy
\$\$G\_{N_P}(z)=G\_{N_L}(1-q+qz),\$\$ and the aggregate payments have
the same distribution on either basis.

Poisson counts remain Poisson with mean `q * lambda`; binomial counts
remain binomial with unchanged number of trials and probability
multiplied by `q`. A negative binomial frequency with `size = r` and
`mu` transforms to the same `size` and mean `q * mu`. For mixed Poisson
models, the conditional intensity becomes `q * Lambda` **without**
discarding the mixing variable. Other frequency families must be thinned
via the general PGF rule rather than silently assumed to stay in the
same family.

When `q = 1`, both basis representations coincide. When `q = 0`, payment
frequency and aggregate payment are identically zero, while
`Y_L | Y_L > 0` is **undefined**. A fabricated point mass at zero must
not be used as a per-payment severity.

The conversion is executable for registered Poisson, binomial, negative
binomial, geometric and finite empirical frequencies. No unknown/custom
frequency family is silently approximated. The probability of a positive
payment is resolved from the exact source CDF or finite discrete masses.
Continuous per-payment severities inherit only the registered exact
operations of their source; unavailable moment orders remain
unavailable. For negative binomial and geometric frequencies, thinning
uses \\p_P=p/(p+q(1-p))\\. If a positive payment frequency would round
to the degenerate parameter `prob = 1`, the conversion stops and the
per-loss model should be retained; positive risk is never silently
removed.

## References

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2012). *Loss Models:
From Data to Decisions*, 4th ed., Appendix C.

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed., Chapter 12.

## See also

[`coverage_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/coverage_spec.md),
[`apply_coverage()`](https://julianfajardo1908.github.io/tidyactuarial/reference/apply_coverage.md)

## Examples

``` r
# Fully executable Poisson collective model with an ordinary deductible.
f <- frequency_spec("poisson", lambda = 4)
x <- severity_spec("discrete", values = c(50, 150, 250),
                   probs = c(0.2, 0.5, 0.3))
paid <- x |> apply_coverage(coverage_spec(deductible = 100))
model <- collective_risk_spec(f, paid)
by_payment <- model |> to_payment_basis()
by_payment$count_basis
#> [1] "payment"
by_payment$thinning$probability
#> [1] 0.8
aggregate_moments(by_payment, order = 1:2)
#> # A tibble: 2 × 4
#>   type  order  value status
#>   <chr> <int>  <dbl> <chr> 
#> 1 raw       1    280 finite
#> 2 raw       2 110400 finite
```
