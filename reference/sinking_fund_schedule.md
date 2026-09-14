# Sinking fund amortization schedule for a loan

Builds a sinking fund schedule under a fixed loan rate and a fixed
accumulation rate for the sinking fund, using compact actuarial
notation.

## Usage

``` r
sinking_fund_schedule(
  principal,
  n,
  i,
  j,
  k = 1L,
  i_type = "effective",
  j_type = "effective",
  m = 1L,
  j_m = 1L,
  deposit = NULL,
  tol = 1e-08
)
```

## Arguments

- principal:

  Numeric scalar. Initial loan amount.

- n:

  Positive integer. Number of schedule periods.

- i:

  Numeric scalar. Annual interest-rate input for the loan.

- j:

  Numeric scalar. Annual accumulation-rate input for the sinking fund.

- k:

  Positive integer. Number of schedule periods per year.

- i_type:

  Character string indicating the loan interest-rate type. Allowed
  values are `"effective"`, `"nominal_interest"`, `"nominal_discount"`,
  and `"force"`.

- j_type:

  Character string indicating the sinking-fund accumulation-rate type.
  Allowed values are `"effective"`, `"nominal_interest"`,
  `"nominal_discount"`, and `"force"`.

- m:

  Positive integer. Conversion frequency for nominal loan rates. Ignored
  for `i_type = "effective"` and `i_type = "force"`.

- j_m:

  Positive integer. Conversion frequency for nominal sinking-fund rates.
  Ignored for `j_type = "effective"` and `j_type = "force"`.

- deposit:

  Optional numeric scalar. Level sinking-fund deposit per period. If
  `NULL`, it is computed so that the fund accumulates to `principal` at
  time `n`.

- tol:

  Numeric tolerance used for zero checks and final-balance checks.

## Value

A tibble with one row per period and columns:

- period:

  Period index.

- loan_balance_start:

  Outstanding loan balance at the start of the period.

- interest_loan:

  Interest paid on the loan during the period.

- sinking_deposit:

  Deposit made into the sinking fund.

- fund_balance_start:

  Fund balance at the start of the period.

- interest_fund:

  Interest earned by the fund during the period.

- fund_balance_end_before_redemption:

  Fund balance before final redemption.

- redemption_from_fund:

  Amount withdrawn from the fund to redeem the loan at maturity.

- fund_balance_end:

  Fund balance after redemption.

- loan_balance_end:

  Outstanding loan balance after redemption.

- total_cashflow_borrower:

  Borrower's external cash outflow during the period.

- i_effective_loan_annual:

  Equivalent annual effective loan rate.

- i_effective_fund_annual:

  Equivalent annual effective fund rate.

- i_loan_period:

  Effective loan rate per schedule period.

- i_fund_period:

  Effective fund rate per schedule period.

- k:

  Schedule frequency.

## Details

The borrower pays:

- interest on the loan each period, and

- a level deposit into the sinking fund.

At maturity, the sinking fund is used to redeem the principal.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` is the loan interest rate, `j` is the sinking-fund
accumulation rate, `k` is the number of schedule periods per year, `m`
is the conversion frequency for the loan rate, and `j_m` is the
conversion frequency for the sinking-fund rate.

The supplied annual rate specifications are converted to effective
annual rates and then to effective rates per schedule period: \$\$i_p =
(1+i_e)^{1/k} - 1,\qquad j_p = (1+j_e)^{1/k} - 1.\$\$

If `deposit` is `NULL` and the sinking-fund periodic rate `j_p` is
approximately zero, the deposit is computed as `principal / n`.

Otherwise, the standard sinking-fund formula is used: \$\$deposit =
\frac{principal}{s\_{\overline{n}\|j_p}}\$\$ where
\$\$s\_{\overline{n}\|j_p} = \frac{(1+j_p)^n - 1}{j_p}.\$\$

## See also

[`amort_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md),
[`s_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md)

Other amortization:
[`amort_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md),
[`amort_schedule_general()`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule_general.md)

## Examples

``` r
sinking_fund_schedule(
  principal = 100000,
  n = 12,
  i = 0.12,
  j = 0.096,
  i_type = "nominal_interest",
  j_type = "nominal_interest",
  m = 12,
  j_m = 12,
  k = 12
)
#> # A tibble: 12 × 16
#>    period loan_balance_start interest_loan sinking_deposit fund_balance_start
#>     <int>              <dbl>         <dbl>           <dbl>              <dbl>
#>  1      1             100000         1000.           7973.                 0 
#>  2      2             100000         1000.           7973.              7973.
#>  3      3             100000         1000.           7973.             16010.
#>  4      4             100000         1000.           7973.             24111.
#>  5      5             100000         1000.           7973.             32277.
#>  6      6             100000         1000.           7973.             40508.
#>  7      7             100000         1000.           7973.             48805.
#>  8      8             100000         1000.           7973.             57168.
#>  9      9             100000         1000.           7973.             65599.
#> 10     10             100000         1000.           7973.             74097.
#> 11     11             100000         1000.           7973.             82662.
#> 12     12             100000         1000.           7973.             91297.
#> # ℹ 11 more variables: interest_fund <dbl>,
#> #   fund_balance_end_before_redemption <dbl>, redemption_from_fund <dbl>,
#> #   fund_balance_end <dbl>, loan_balance_end <dbl>,
#> #   total_cashflow_borrower <dbl>, i_effective_loan_annual <dbl>,
#> #   i_effective_fund_annual <dbl>, i_loan_period <dbl>, i_fund_period <dbl>,
#> #   k <int>

sinking_fund_schedule(
  principal = 50000,
  n = 10,
  i = 0.02,
  j = 0,
  deposit = NULL
)
#> # A tibble: 10 × 16
#>    period loan_balance_start interest_loan sinking_deposit fund_balance_start
#>     <int>              <dbl>         <dbl>           <dbl>              <dbl>
#>  1      1              50000         1000.            5000                  0
#>  2      2              50000         1000.            5000               5000
#>  3      3              50000         1000.            5000              10000
#>  4      4              50000         1000.            5000              15000
#>  5      5              50000         1000.            5000              20000
#>  6      6              50000         1000.            5000              25000
#>  7      7              50000         1000.            5000              30000
#>  8      8              50000         1000.            5000              35000
#>  9      9              50000         1000.            5000              40000
#> 10     10              50000         1000.            5000              45000
#> # ℹ 11 more variables: interest_fund <dbl>,
#> #   fund_balance_end_before_redemption <dbl>, redemption_from_fund <dbl>,
#> #   fund_balance_end <dbl>, loan_balance_end <dbl>,
#> #   total_cashflow_borrower <dbl>, i_effective_loan_annual <dbl>,
#> #   i_effective_fund_annual <dbl>, i_loan_period <dbl>, i_fund_period <dbl>,
#> #   k <int>
```
