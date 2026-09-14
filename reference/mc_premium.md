# Compute Monte Carlo net premiums for life contingencies

Estimates net premiums from simulated present values of benefits and
premium annuities, while distinguishing the annualized premium from the
amount paid at each premium date.

## Usage

``` r
mc_premium(
  .data = NULL,
  col_Z = "pv_benefit",
  col_Y = "pv_annuity",
  col_P = "P",
  by = NULL,
  na_rm = TRUE,
  k = NULL,
  annuity_payment = NULL,
  tol = 1e-10,
  ...
)
```

## Arguments

- .data:

  A data frame or tibble containing simulated present values. Usually
  obtained after applying
  [`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md)
  and
  [`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md)
  to the same simulated lifetime sample.

- col_Z:

  Character scalar naming the simulated present value of benefits.
  Default is `"pv_benefit"`.

- col_Y:

  Character scalar naming the simulated present value of the premium
  annuity. Default is `"pv_annuity"`.

- col_P:

  Character scalar naming the compatibility output containing the
  coefficient that directly multiplies `col_Y`. Default is `"P"`. For a
  normalized \\k\\-thly premium annuity constructed with
  `payment = 1 / k`, this coefficient is the annualized premium.

- by:

  Optional character vector of grouping columns. If supplied, the
  premium is estimated separately within each group. If `by = NULL` and
  `.data` is already grouped, the current grouping is used.

- na_rm:

  Logical scalar. If `TRUE`, simulations with a missing benefit or
  annuity present value are removed as complete pairs. The same
  simulation rows are therefore used in both means.

- k:

  Optional positive integer number of premium payments per year. By
  default it is inferred from `payments_per_year` or `k` in `.data`; if
  neither exists, `k = 1` is used.

- annuity_payment:

  Optional positive numeric scalar giving the amount paid at each date
  when `col_Y` was constructed. It is normally inferred from
  `payment_per_payment`, `payment`, or `payment_annualized` in the
  output of
  [`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md).

- tol:

  Nonnegative numeric tolerance for consistency checks.

- ...:

  Transitional compatibility for older calls using `data`,
  `benefit_col`, `annuity_col`, and `premium_col`.

## Value

A tibble containing the original simulations and standardized premium
columns:

- premium_annualized:

  Estimated annualized premium \\\widehat P^{(k)}\\.

- premium_per_payment:

  Amount collected at each premium date.

- payments_per_year:

  Premium payment frequency `k`.

- premium_annuity_scale:

  Coefficient \\\widehat q\\ multiplying `col_Y`.

- mc_equivalence_residual:

  Difference \\\overline Z-\widehat q\overline{Y_c}\\ within the
  estimation group.

The column selected by `col_P` stores `premium_annuity_scale` for
backward compatibility. Unless `col_P = "premium"`, a compatibility
column `premium` is also created with the same scale coefficient.

## Details

Let \\Z\\ denote the simulated present value of benefits. Suppose the
simulated premium annuity is \$\$ Y_c = c\sum_j v^{t_j}, \$\$ where
\\c\\ is the amount used at each of the \\k\\ premium dates per year.
The Monte Carlo coefficient that directly multiplies this annuity is
\$\$ \widehat q = \frac{\overline Z}{\overline{Y_c}}. \$\$

The corresponding premium amount at each payment date is \$\$ \widehat
P\_{\mathrm{per\\ payment}} = \widehat q c, \$\$ and the annualized
premium is \$\$ \widehat P^{(k)} = k\widehat q c. \$\$

The recommended premium-annuity normalization uses `payment = 1 / k` in
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md).
In that case, \$\$ \widehat q = \widehat P^{(k)}, \qquad \widehat
P\_{\mathrm{per\\ payment}} = \frac{\widehat P^{(k)}}{k}. \$\$

If instead `payment = 1`, then \\\widehat q\\ is the amount paid at each
premium date, while the annualized premium is \\k\widehat q\\.

When `na_rm = TRUE`, missing values are removed jointly: a simulation
contributes only if both `col_Z` and `col_Y` are observed. This prevents
the numerator and denominator from being estimated from different
simulated samples.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*. Second Edition. Society of
Actuaries.

## See also

[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_loss`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
simulated <- tibble::tibble(
  pv_benefit = c(800, 1200),
  pv_annuity = c(8, 12),
  payment_per_payment = 1 / 12,
  payment_annualized = 1,
  payments_per_year = 12
)

simulated |>
  mc_premium()
#> # A tibble: 2 × 11
#>   pv_benefit pv_annuity payment_per_payment payment_annualized payments_per_year
#>        <dbl>      <dbl>               <dbl>              <dbl>             <dbl>
#> 1        800          8              0.0833                  1                12
#> 2       1200         12              0.0833                  1                12
#> # ℹ 6 more variables: P <dbl>, premium_annualized <dbl>,
#> #   premium_per_payment <dbl>, premium_annuity_scale <dbl>,
#> #   mc_equivalence_residual <dbl>, premium <dbl>

# Here P is annualized because the annuity uses payment = 1 / 12.

# With payment = 1 at each monthly date, P is the monthly amount,
# while premium_annualized is twelve times P.
simulated_unit_payments <- tibble::tibble(
  pv_benefit = c(800, 1200),
  pv_annuity = c(96, 144),
  payment_per_payment = 1,
  payment_annualized = 12,
  payments_per_year = 12
)

simulated_unit_payments |>
  mc_premium()
#> # A tibble: 2 × 11
#>   pv_benefit pv_annuity payment_per_payment payment_annualized payments_per_year
#>        <dbl>      <dbl>               <dbl>              <dbl>             <dbl>
#> 1        800         96                   1                 12                12
#> 2       1200        144                   1                 12                12
#> # ℹ 6 more variables: P <dbl>, premium_annualized <dbl>,
#> #   premium_per_payment <dbl>, premium_annuity_scale <dbl>,
#> #   mc_equivalence_residual <dbl>, premium <dbl>
```
