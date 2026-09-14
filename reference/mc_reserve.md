# Compute Monte Carlo prospective reserves for life contingencies

Computes simulated prospective loss random variables at one or more
policy durations. Future benefits and future premiums are revalued from
each requested duration.

## Usage

``` r
mc_reserve(
  .data = NULL,
  t = 0,
  i = NULL,
  P = NULL,
  col_P = "P",
  premium_unit = c("auto", "annualized", "per_payment", "annuity_scale"),
  benefit = 1,
  payment = 1,
  k = 1L,
  type = c("whole", "term", "deferred", "deferred_term", "pure_endowment", "endowment",
    "whole_life", "deferred_temporary"),
  annuity_type = c("whole", "temporary", "deferred", "deferred_temporary", "certain",
    "guaranteed", "whole_life"),
  n = NULL,
  h = 0,
  n_guar = NULL,
  timing = c("end_of_year", "moment_of_death"),
  premium_timing = c("due", "immediate"),
  reserve_timing = c("before_payment", "after_payment"),
  i_type = c("effective", "nominal_interest", "nominal_discount", "force", "nominal"),
  m = 1,
  col_K = "Kx",
  col_T = "Tx",
  in_force_basis = c("auto", "complete", "curtate"),
  not_in_force = c("na", "zero"),
  col_L = "L_t",
  tol = 1e-10,
  premium = NULL,
  ...
)
```

## Arguments

- .data:

  A data frame or tibble containing simulated curtate future lifetimes
  and, when required, complete future lifetimes.

- t:

  Nonnegative numeric vector of valuation durations.

- i:

  Numeric scalar. Interest-rate input used for discounting.

- P:

  Optional nonnegative numeric scalar supplied directly as the premium
  input.

- col_P:

  Character scalar naming a premium column in `.data`. The default is
  `"P"`. When it is not supplied explicitly, modern standardized premium
  columns are preferred.

- premium_unit:

  Unit of `P` or the selected premium column: `"annualized"`,
  `"per_payment"`, or `"annuity_scale"`. With `"auto"`,
  `premium_annualized`, `premium_per_payment`, and
  `premium_annuity_scale` determine their own units, while legacy `P`
  and `premium` retain their historical annuity-scale interpretation.

- benefit:

  Nonnegative numeric scalar. Insurance benefit amount.

- payment:

  Positive numeric scalar. Amount used at each premium-annuity payment
  date. For the normalized \\k\\-thly convention, use `payment = 1 / k`.

- k:

  Positive integer number of premium payments per year.

- type:

  Insurance type. Supported values are `"whole"`, `"term"`,
  `"deferred"`, `"deferred_term"`, `"pure_endowment"`, and
  `"endowment"`.

- annuity_type:

  Premium-annuity type. Supported values are `"whole"`, `"temporary"`,
  `"deferred"`, `"deferred_temporary"`, `"certain"`, and `"guaranteed"`.

- n:

  Optional contract or premium term in years.

- h:

  Nonnegative deferral period in years.

- n_guar:

  Optional guaranteed premium-payment period in years.

- timing:

  Death-benefit timing: `"end_of_year"` or `"moment_of_death"`.

- premium_timing:

  Premium-annuity timing: `"due"` or `"immediate"`.

- reserve_timing:

  Whether cash flows exactly at the valuation duration are included:
  `"before_payment"` or `"after_payment"`.

- i_type:

  Interest-rate convention.

- m:

  Positive integer nominal conversion frequency.

- col_K:

  Curtate future lifetime column.

- col_T:

  Complete future lifetime column.

- in_force_basis:

  Basis used to determine whether a simulated policy is in force:
  `"auto"`, `"complete"`, or `"curtate"`.

- not_in_force:

  Output for known scenarios that are not in force: `"na"` or `"zero"`.
  Missing lifetime information remains missing under either option.

- col_L:

  Output column containing the prospective loss.

- tol:

  Nonnegative numeric tolerance for consistency checks.

- premium:

  Deprecated explicit alias for `P`. It remains a formal argument
  because otherwise R partially matches it against `premium_unit` and
  `premium_timing`.

- ...:

  Transitional compatibility for older argument names.

## Value

A tibble with one row per simulation and requested duration. Important
standardized columns include:

- Z_t:

  Future benefit present value at duration `t`.

- Y_t:

  Future premium-annuity basis present value.

- future_pv_premiums:

  Actual future premium present value.

- premium_annualized:

  Annualized premium \\P^{(k)}\\.

- premium_per_payment:

  Premium paid at each date.

- premium_annuity_scale:

  Coefficient multiplying `Y_t`.

- L_t:

  Prospective loss, or the name supplied through `col_L`.

## Details

Let \\Z_t\\ be the present value at duration \\t\\ of future benefits.
Suppose the future premium annuity is constructed with amount \\c\\ at
each of the \\k\\ payment dates per year: \$\$ Y\_{t,c}=c\sum\_{j:t_j\ge
t}v^{t_j-t}. \$\$

If \\P^{(k)}\\ is the annualized premium, then the installment is
\\P^{(k)}/k\\ and the coefficient multiplying \\Y\_{t,c}\\ is \$\$
q=\frac{P^{(k)}}{kc}. \$\$ Therefore the simulated prospective loss is
\$\$ L_t=Z_t-qY\_{t,c}. \$\$

Under the recommended normalization `payment = 1 / k`, \\q=P^{(k)}\\ and
\$\$ L_t=Z_t-P^{(k)}Y_t^{(k)}. \$\$

If no premium is supplied, the function estimates the issue scale
coefficient from complete benefit-annuity simulation pairs: \$\$
\widehat q=\frac{\overline Z_0}{\overline Y\_{0,c}}. \$\$ This makes the
sample mean issue loss equal to zero, up to numerical error, when
`reserve_timing = "before_payment"`.

The column `Y_t` is the present value of the premium-annuity basis,
including the amount supplied through `payment`. The column
`future_pv_premiums` is the actual simulated present value of premium
income, equal to `premium_annuity_scale * Y_t`.

## See also

[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_premium`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_loss`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`reserve_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`reserve_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
simulated <- tibble::tibble(
  Kx = c(2, 4),
  Tx = c(2.4, 4.7)
)

simulated |>
  mc_reserve(
    t = c(0, 1),
    i = 0.05,
    type = "whole",
    annuity_type = "whole",
    payment = 1 / 12,
    k = 12
  )
#> # A tibble: 4 × 48
#>      Kx    Tx     t duration in_force reserve_timing not_in_force     i  rate
#>   <dbl> <dbl> <dbl>    <dbl> <lgl>    <chr>          <chr>        <dbl> <dbl>
#> 1     2   2.4     0        0 TRUE     before_payment na            0.05  0.05
#> 2     2   2.4     1        1 TRUE     before_payment na            0.05  0.05
#> 3     4   4.7     0        0 TRUE     before_payment na            0.05  0.05
#> 4     4   4.7     1        1 TRUE     before_payment na            0.05  0.05
#> # ℹ 39 more variables: i_type <chr>, interest_type <chr>, m <int>,
#> #   i_effective <dbl>, effective_rate <dbl>, v <dbl>, discount_factor <dbl>,
#> #   type <chr>, insurance <chr>, annuity_type <chr>, annuity <chr>,
#> #   benefit <dbl>, payment <dbl>, payment_per_payment <dbl>,
#> #   payment_annualized <dbl>, k <int>, payments_per_year <int>, n <dbl>,
#> #   term <dbl>, h <dbl>, deferral_years <dbl>, n_guar <dbl>,
#> #   guarantee_years <dbl>, timing <chr>, payment_timing <chr>, …
```
