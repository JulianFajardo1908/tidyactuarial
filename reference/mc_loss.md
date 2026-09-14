# Compute Monte Carlo loss random variables for life contingencies

Constructs simulated actuarial losses from present values of benefits
and premium-payment annuities while keeping annualized premiums distinct
from amounts paid at each premium date.

## Usage

``` r
mc_loss(
  .data = NULL,
  col_Z = "pv_benefit",
  col_Y = "pv_annuity",
  col_P = "P",
  col_L = "L",
  P = NULL,
  premium_unit = c("auto", "annualized", "per_payment", "annuity_scale"),
  k = NULL,
  annuity_payment = NULL,
  tol = 1e-10,
  ...
)
```

## Arguments

- .data:

  A data frame or tibble containing simulated present values of benefits
  and premium annuities.

- col_Z:

  Character scalar naming the simulated present value of benefits.
  Default is `"pv_benefit"`.

- col_Y:

  Character scalar naming the simulated present value of the premium
  annuity. Default is `"pv_annuity"`.

- col_P:

  Character scalar naming the premium input column. When omitted, the
  function searches, in order, for `premium_annualized`,
  `premium_per_payment`, `P`, and `premium`.

- col_L:

  Character scalar naming the simulated loss output. Default is `"L"`.

- P:

  Optional nonnegative numeric scalar supplied directly instead of
  reading a premium column.

- premium_unit:

  Unit of `P` or the selected premium column: `"annualized"`,
  `"per_payment"`, or `"annuity_scale"`. The latter is the coefficient
  that directly multiplies `col_Y`. With `"auto"`, explicit modern
  column names determine the unit, while `P`, `premium`, and a direct
  `P` argument retain their historical annuity-scale interpretation.

- k:

  Optional positive integer number of premium payments per year. By
  default it is inferred from `payments_per_year` or `k` in `.data`; if
  neither exists, `k = 1` is used.

- annuity_payment:

  Optional positive numeric scalar giving the payment amount used to
  construct `col_Y`. It is normally inferred from `payment_per_payment`,
  `payment`, or `payment_annualized` in the output of
  [`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md).

- tol:

  Nonnegative numeric tolerance for consistency checks.

- ...:

  Transitional compatibility for older calls using `data`,
  `benefit_col`, `annuity_col`, `premium_col`, `loss_col`, and
  `premium`.

## Value

A tibble containing the original simulation and standardized columns:

- premium_annualized:

  Annualized premium \\P^{(k)}\\.

- premium_per_payment:

  Amount collected at each premium date.

- payments_per_year:

  Premium payment frequency `k`.

- premium_annuity_scale:

  Coefficient multiplying `col_Y`.

- pv_premiums:

  Simulated present value of premium income.

- L:

  Simulated loss, or the name supplied through `col_L`.

A compatibility column `loss` is synchronized with `col_L`.

## Details

Let \\Z\\ be the present value random variable of benefits. Suppose
`col_Y` contains \$\$ Y_c = c\sum_j v^{t_j}, \$\$ where \\c\\ is the
amount used in
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md)
at each of the \\k\\ premium dates per year.

If \\P^{(k)}\\ is the annualized premium, the actual installment is
\\P^{(k)}/k\\, and the simulated present value of premiums is \$\$ \Pi =
\frac{P^{(k)}}{k c}Y_c. \$\$ Hence the loss at issue is \$\$ L = Z -
\Pi. \$\$

The recommended normalized premium annuity uses `payment = 1 / k` in
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md).
Then \\c=1/k\\, \\Y_c=Y^{(k)}\\, and the expression simplifies to \$\$ L
= Z - P^{(k)}Y^{(k)}. \$\$

This convention agrees with
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
and
[`reserve_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md):
the premium is annualized, while the amount collected at each date is
the annualized premium divided by `k`.

For backward compatibility, legacy columns `P` and `premium` are
interpreted as coefficients that multiply the supplied annuity present
value directly. If such a coefficient is \\q\\, then \$\$
P\_{\mathrm{per\\ payment}} = q c, \qquad P^{(k)} = k q c. \$\$

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*. Second Edition. Society of
Actuaries.

## See also

[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_premium`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
simulated <- tibble::tibble(
  pv_benefit = c(900, 700, 1100),
  pv_annuity = c(8, 7, 9),
  payment_per_payment = 1 / 12,
  payment_annualized = 1,
  payments_per_year = 12,
  premium_annualized = 120
)

simulated |>
  mc_loss()
#> # A tibble: 3 × 11
#>   pv_benefit pv_annuity payment_per_payment payment_annualized payments_per_year
#>        <dbl>      <dbl>               <dbl>              <dbl>             <int>
#> 1        900          8              0.0833                  1                12
#> 2        700          7              0.0833                  1                12
#> 3       1100          9              0.0833                  1                12
#> # ℹ 6 more variables: premium_annualized <dbl>, premium_per_payment <dbl>,
#> #   premium_annuity_scale <dbl>, pv_premiums <dbl>, L <dbl>, loss <dbl>

# A premium supplied directly as an annualized amount
simulated |>
  mc_loss(
    P = 120,
    premium_unit = "annualized"
  )
#> # A tibble: 3 × 12
#>   pv_benefit pv_annuity payment_per_payment payment_annualized payments_per_year
#>        <dbl>      <dbl>               <dbl>              <dbl>             <int>
#> 1        900          8              0.0833                  1                12
#> 2        700          7              0.0833                  1                12
#> 3       1100          9              0.0833                  1                12
#> # ℹ 7 more variables: premium_annualized <dbl>, P <dbl>,
#> #   premium_per_payment <dbl>, premium_annuity_scale <dbl>, pv_premiums <dbl>,
#> #   L <dbl>, loss <dbl>

# Historical coefficient multiplying the annuity PV directly
tibble::tibble(
  pv_benefit = c(900, 700),
  pv_annuity = c(8, 7),
  P = 100
) |>
  mc_loss()
#> # A tibble: 2 × 10
#>   pv_benefit pv_annuity     P premium_annualized premium_per_payment
#>        <dbl>      <dbl> <dbl>              <dbl>               <dbl>
#> 1        900          8   100                100                 100
#> 2        700          7   100                100                 100
#> # ℹ 5 more variables: payments_per_year <int>, premium_annuity_scale <dbl>,
#> #   pv_premiums <dbl>, L <dbl>, loss <dbl>
```
