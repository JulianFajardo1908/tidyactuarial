# Gross premium under a simple expense-loaded equivalence principle

Converts a net-premium result from
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md)
or
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md)
into an expense-loaded gross premium.

## Usage

``` r
premium_gross(
  prem,
  alpha = 0,
  beta = 0,
  gamma = 0,
  k = NULL,
  output = c("value", "summary", "audit", "table"),
  tidy = NULL,
  check = TRUE,
  tol = 1e-10,
  ...
)
```

## Arguments

- prem:

  A one-row data frame or tibble. The preferred input is
  `premium_x(..., output = "summary")` or
  `premium_xy(..., output = "summary")`. It must contain an annualized
  net premium and the APV of the normalized premium annuity.

- alpha:

  Nonnegative numeric scalar. Initial acquisition expense as a multiple
  of one gross premium installment. The expense at issue is \\\alpha
  G^{(k)} / k\\.

- beta:

  Numeric scalar in \\\[0,1)\\. Proportional expense charged on every
  gross premium installment.

- gamma:

  Nonnegative numeric scalar. Fixed monetary expense incurred at every
  premium-payment date. Its APV is \\\gamma k a^{(k)}\\, because
  `a_premiums` is normalized with payments of \\1/k\\.

- k:

  Optional positive integer payment frequency. By default it is inferred
  from `payments_per_year` or `k` in `prem`; if neither is present,
  `k = 1` is used.

- output:

  Output level. `"value"` returns the annualized gross premium,
  `"summary"` returns a compact one-row tibble, and `"audit"` returns
  the extended-equivalence components in long format. `"table"` is
  accepted as a compatibility alias for `"summary"`.

- tidy:

  Deprecated compatibility argument. `TRUE` maps to `output = "summary"`
  and `FALSE` to `output = "value"`.

- check:

  Logical scalar. If `TRUE`, validates the inputs.

- tol:

  Nonnegative numeric tolerance used for consistency checks.

- ...:

  Transitional compatibility. The deprecated argument
  `payments_per_year` is mapped to `k`.

## Value

For `output = "value"`, a numeric scalar containing the annualized gross
premium \\G^{(k)}\\.

For `output = "summary"`, a one-row tibble with six columns: annualized
gross premium, gross premium per payment, annualized net premium,
annualized loading, payment frequency, and equivalence residual.

For `output = "audit"`, a long-format tibble with the APVs of gross
premiums, benefits, and each expense component.

## Details

The function preserves the package-wide distinction between an
annualized premium and the amount paid at each of the `k` payment dates.

Let \\a^{(k)}\\ denote the APV of the premium annuity returned by
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md)
or
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md).
That annuity has \\k\\ payments per year, each of amount \\1/k\\; hence
it represents an annual payment rate of 1.

If \\P^{(k)}\\ is the annualized net premium and \\G^{(k)}\\ is the
annualized gross premium, the extended equivalence equation implemented
is \$\$ G^{(k)}a^{(k)} = P^{(k)}a^{(k)} + \alpha\frac{G^{(k)}}{k} +
\beta G^{(k)}a^{(k)} + \gamma k a^{(k)}. \$\$

Therefore, \$\$ G^{(k)} = \frac{P^{(k)} + k\gamma} {(1-\beta)-\alpha/(k
a^{(k)})}. \$\$

The actual premium installment is \$\$ G\_{\mathrm{per\\ payment}} =
\frac{G^{(k)}}{k}. \$\$

For `k = 1`, this reduces to the previous annual formula: \$\$ G =
\frac{P\_{\mathrm{net}}+\gamma} {(1-\beta)-\alpha/a}. \$\$

This intentionally simple model assumes that `gamma` is incurred at the
same dates and under the same contingency as premium payments. Expenses
with a different timing or contingency require their own APV and are not
represented by `gamma`.

Preferred column names in `prem` are `premium_annualized`,
`premium_per_payment`, `payments_per_year`, and `apv_premium_annuity`.
Legacy annual tables using `P`, `premium`, `P_net`, `a_premiums`, or
`apv_premiums` remain supported.

Legacy premium columns are accepted automatically only when `k = 1`,
because their unit is ambiguous for subannual premiums.

## See also

[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md),
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)

## Examples

``` r
net <- tibble::tibble(
  premium_annualized = 1200,
  premium_per_payment = 100,
  payments_per_year = 12,
  apv_premium_annuity = 10
)

premium_gross(
  net,
  alpha = 0.5,
  beta = 0.05,
  gamma = 20,
  output = "summary"
)
#> # A tibble: 1 × 6
#>   gross_premium_annualized gross_premium_per_payment net_premium_annualized
#>                      <dbl>                     <dbl>                  <dbl>
#> 1                    1522.                      127.                   1200
#> # ℹ 3 more variables: loading_annualized <dbl>, payments_per_year <int>,
#> #   equivalence_residual <dbl>

# Pipeline from a net-premium calculation
if (FALSE) { # \dontrun{
life_contract(
  lt = lt,
  lives = "single",
  x = 40,
  i = 0.05
) |>
  add_insurance(
    type = "term",
    benefit = 100000,
    n = 20
  ) |>
  add_premium_schedule(
    k = 12,
    n_prem = 10
  ) |>
  premium_x(output = "summary") |>
  premium_gross(
    alpha = 0.5,
    beta = 0.05,
    gamma = 20,
    output = "summary"
  )
} # }
```
