# Specify an insurance coverage contract

Creates a lightweight S3 specification for per-loss insurance coverage,
including an ordinary or franchise deductible, a coverage limit,
coinsurance, inflation, and optional indexation of contract terms.

## Usage

``` r
coverage_spec(
  deductible = 0,
  limit = Inf,
  coinsurance = 1,
  inflation_factor = 1,
  deductible_type = c("ordinary", "franchise"),
  index_deductible = FALSE,
  index_limit = FALSE,
  label = NULL
)
```

## Arguments

- deductible:

  Nonnegative finite numeric scalar. The deductible applied to the
  inflated loss, possibly adjusted by `index_deductible`.

- limit:

  Nonnegative numeric scalar, or `Inf`. Maximum covered amount **after
  the deductible but before coinsurance**. This is not the maximum
  ground-up loss and not necessarily the insurer's final payment limit.

- coinsurance:

  Numeric scalar in `[0, 1]`. Fraction of the covered amount paid by the
  insurer, applied after the limit. Zero is allowed to represent a
  contract with no insurer participation.

- inflation_factor:

  Positive finite numeric scalar multiplying the original loss. This is
  a **factor**, not a rate: use `1.10` for 10 percent inflation.

- deductible_type:

  Either `"ordinary"` (default) or `"franchise"`. Under a franchise
  deductible, a loss exceeding the deductible is payable from the first
  monetary unit, subject to the limit and coinsurance.

- index_deductible:

  Logical scalar. If `TRUE`, multiply the deductible by
  `inflation_factor` before applying it to the inflated loss.

- index_limit:

  Logical scalar. If `TRUE`, multiply the limit by `inflation_factor`
  before applying it. An infinite limit remains infinite.

- label:

  Optional nonempty, non-whitespace character scalar identifying the
  contract.

## Value

An object of class `tidyact_coverage_spec`, implemented as a named list
containing `deductible`, `limit`, `coinsurance`, `inflation_factor`,
`deductible_type`, `index_deductible`, `index_limit`, and `label`. No
derived payments or distributional quantities are stored.

## Details

This function only records contractual terms. It does not accept a
severity distribution, evaluate payments, simulate losses, or change a
frequency model.

Let `X >= 0` denote the original loss, `f` the inflation factor, `d` the
deductible, `L` the limit, and `c` the coinsurance fraction. Write
`Z = f * X`, `d_f = d * f` if the deductible is indexed (otherwise `d`),
and `L_f = L * f` if the limit is indexed (otherwise `L`). The specified
processing order is inflation, deductible, limit, and coinsurance.

For an ordinary deductible, the intended payment per loss is \$\$Y_L = c
\min\\\max(Z-d_f,0),L_f\\.\$\$

For a franchise deductible, the intended payment per loss is \$\$Y_L = c
\min\\Z,L_f\\ \mathbf{1}\_{\\Z\>d_f\\}.\$\$ Thus a franchise loss
exactly equal to its deductible produces no payment. With a finite
limit, the maximum insurer payment is `c * L_f` (or a smaller achievable
maximum if the loss distribution is bounded).

In standard actuarial notation, the *maximum covered loss* for an
ordinary deductible with finite `d_f` and `L_f` is `u = d_f + L_f`; it
is distinct from this function's `limit` argument.

All monetary amounts must use the same currency and reference monetary
basis. Inputs are deliberately scalar: one object represents one
contract.

## References

Klugman, S. A., Panjer, H. H., and Willmot, G. E. (2012). *Loss Models:
From Data to Decisions*, 4th edition, Chapter 8.

## Examples

``` r
# Default: full insurance of each loss, without inflation.
coverage_spec()
#> $deductible
#> [1] 0
#> 
#> $limit
#> [1] Inf
#> 
#> $coinsurance
#> [1] 1
#> 
#> $inflation_factor
#> [1] 1
#> 
#> $deductible_type
#> [1] "ordinary"
#> 
#> $index_deductible
#> [1] FALSE
#> 
#> $index_limit
#> [1] FALSE
#> 
#> $label
#> NULL
#> 
#> attr(,"class")
#> [1] "tidyact_coverage_spec"

# Ordinary deductible with a capped covered layer and 80% coinsurance.
contract <- coverage_spec(
  deductible = 500,
  limit = 10000,
  coinsurance = 0.80,
  label = "Standard contract"
)
contract$limit
#> [1] 10000

# A qualifying loss is covered from its first unit under a franchise.
coverage_spec(deductible = 1000, deductible_type = "franchise")
#> $deductible
#> [1] 1000
#> 
#> $limit
#> [1] Inf
#> 
#> $coinsurance
#> [1] 1
#> 
#> $inflation_factor
#> [1] 1
#> 
#> $deductible_type
#> [1] "franchise"
#> 
#> $index_deductible
#> [1] FALSE
#> 
#> $index_limit
#> [1] FALSE
#> 
#> $label
#> NULL
#> 
#> attr(,"class")
#> [1] "tidyact_coverage_spec"

# Inflation with indexed deductible, but a fixed nominal limit.
coverage_spec(
  deductible = 500,
  limit = 10000,
  inflation_factor = 1.12,
  index_deductible = TRUE,
  index_limit = FALSE
)
#> $deductible
#> [1] 500
#> 
#> $limit
#> [1] 10000
#> 
#> $coinsurance
#> [1] 1
#> 
#> $inflation_factor
#> [1] 1.12
#> 
#> $deductible_type
#> [1] "ordinary"
#> 
#> $index_deductible
#> [1] TRUE
#> 
#> $index_limit
#> [1] FALSE
#> 
#> $label
#> NULL
#> 
#> attr(,"class")
#> [1] "tidyact_coverage_spec"

# Completely indexed contract, including an unbounded limit.
coverage_spec(
  deductible = 500,
  limit = Inf,
  inflation_factor = 1.05,
  index_deductible = TRUE,
  index_limit = TRUE
)
#> $deductible
#> [1] 500
#> 
#> $limit
#> [1] Inf
#> 
#> $coinsurance
#> [1] 1
#> 
#> $inflation_factor
#> [1] 1.05
#> 
#> $deductible_type
#> [1] "ordinary"
#> 
#> $index_deductible
#> [1] TRUE
#> 
#> $index_limit
#> [1] TRUE
#> 
#> $label
#> NULL
#> 
#> attr(,"class")
#> [1] "tidyact_coverage_spec"
```
