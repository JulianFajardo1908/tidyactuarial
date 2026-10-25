# General amortization schedule with variable rates and payments

Builds a loan amortization schedule allowing the effective interest-rate
pattern, regular-payment pattern, and extra-principal pattern to vary by
period.

## Usage

``` r
amort_schedule_general(
  principal,
  n,
  i,
  i_type = "effective",
  m = 1L,
  k = 1L,
  timing = c("immediate", "due"),
  payment = NULL,
  extra_principal = 0,
  output = c("schedule", "summary"),
  tol = 1e-08
)
```

## Arguments

- principal:

  Positive numeric scalar. Initial outstanding balance.

- n:

  Positive integer scalar. Maximum number of amortization periods.

- i:

  Numeric vector of interest-rate inputs. It must have length 1 or `n`.
  A scalar is recycled over all periods.

- i_type:

  Character vector indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`. It must have length 1 or `n`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. It must have length 1 or `n`.

- k:

  Positive integer scalar. Number of amortization periods per year.

- timing:

  Character scalar. Either `"immediate"` for payments at the end of each
  period or `"due"` for payments at the beginning.

- payment:

  Payment specification. It may be:

  - `NULL`, in which case a level payment is calculated;

  - a nonnegative numeric scalar;

  - a nonnegative numeric vector of length `n`;

  - a function with arguments `period`, `ob_start`, and
    `i_effective_period`, returning one nonnegative payment.

- extra_principal:

  Optional nonnegative extra-principal payments. It may be a scalar or a
  numeric vector of length `n`. Defaults to zero.

- output:

  Character scalar. Either `"schedule"` for the complete amortization
  table or `"summary"` for a compact actuarial summary.

- tol:

  Finite positive numeric scalar in monetary units used for zero-balance
  detection and the negative-amortization threshold.

## Value

With `output = "schedule"`, a tibble with one row per realized period.

With `output = "summary"`, a one-row tibble containing the initial
principal, number of realized periods, total interest, total paid,
ending balance, and an indicator of negative amortization.

## Details

The function extends the fixed-pattern workflow of
[`amort_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md)
without modifying that function. It supports:

- a scalar interest rate recycled over all periods;

- a vector of interest rates, one for each period;

- a level payment computed automatically;

- a scalar or period-specific payment vector;

- a payment function depending on the current loan state.

Original log accumulation rates are converted directly to period rates.
Level-payment discount factors use cumulative log growth, rather than
products of rounded accumulation factors. Period rates must remain
finite and greater than -1; a displayed annual equivalent may overflow
even when the period rate is representable. The term is `n / k` years.

Each value of `i` is interpreted as an annual rate under its associated
`i_type` and `m`. It is first converted to an annual effective rate and
then to the effective rate for one amortization period: \$\$i_j^{(p)} =
(1 + i_j)^{1/k} - 1.\$\$

When `payment = NULL`, the level payment is determined from the
period-specific discount factors. For payments in arrears, \$\$P =
\frac{L}{\sum\_{j=1}^{n} \prod\_{h=1}^{j}(1+i_h^{(p)})^{-1}}.\$\$

For payments in advance, the discount factors correspond to payment
times \\0,1,\ldots,n-1\\.

A payment smaller than the interest charged may produce negative
amortization. The schedule identifies such periods explicitly.

Negative amortization means that interest exceeds the total payment,
including extras, by more than `tol`. This condition applies to both
timings, including interest accrued after an advance payment. Under due
timing, the principal columns continue to record payments before
interest; the negative-amortization flag refers to the net debt
movement.

On a payoff row the regular payment is applied first and extras are
capped at the remaining debt; no callback is evaluated after full
payoff. This allocation differs from
[`amort_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md),
which preserves the requested extra first. Both cap total cash flow at
the amount due. Automatically calculated level payments are determined
before extras and are not recast by this function. The discount sum is
evaluated in log space before combining it with the principal. Active
balances require a positive, representable calculated payment;
non-finite monetary ledgers cause errors. A principal below `tol` may
produce an empty schedule, and small residual balances may be treated as
zero within that absolute tolerance. Storage grows with `n`; feasible
terms are limited by integer indexing and available memory.

## See also

[`amort_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md),
[`a_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)

Other amortization:
[`amort_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md),
[`sinking_fund_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/sinking_fund_schedule.md)

## Examples

``` r
# Level payments and a constant rate
amort_schedule_general(
  principal = 100000,
  n = 12,
  i = 0.12,
  i_type = "nominal_interest",
  m = 12,
  k = 12
)
#> # A tibble: 12 × 15
#>    period ob_start i_effective_annual i_effective_period interest payment
#>     <int>    <dbl>              <dbl>              <dbl>    <dbl>   <dbl>
#>  1      1  100000               0.127               0.01   1000     8885.
#>  2      2   92115.              0.127               0.01    921.    8885.
#>  3      3   84151.              0.127               0.01    842.    8885.
#>  4      4   76108.              0.127               0.01    761.    8885.
#>  5      5   67984.              0.127               0.01    680.    8885.
#>  6      6   59779.              0.127               0.01    598.    8885.
#>  7      7   51492.              0.127               0.01    515.    8885.
#>  8      8   43122.              0.127               0.01    431.    8885.
#>  9      9   34668.              0.127               0.01    347.    8885.
#> 10     10   26130.              0.127               0.01    261.    8885.
#> 11     11   17507.              0.127               0.01    175.    8885.
#> 12     12    8797.              0.127               0.01     88.0   8885.
#> # ℹ 9 more variables: extra_principal <dbl>, principal <dbl>,
#> #   total_principal <dbl>, cashflow <dbl>, ob_end <dbl>,
#> #   negative_amortization <lgl>, timing <chr>, k <int>, payment_source <chr>

# Increasing payments
amort_schedule_general(
  principal = 10000,
  n = 5,
  i = 0.06,
  payment = c(1800, 1900, 2000, 2200, 3000)
)
#> # A tibble: 5 × 15
#>   period ob_start i_effective_annual i_effective_period interest payment
#>    <int>    <dbl>              <dbl>              <dbl>    <dbl>   <dbl>
#> 1      1   10000                0.06               0.06     600     1800
#> 2      2    8800                0.06               0.06     528     1900
#> 3      3    7428                0.06               0.06     446.    2000
#> 4      4    5874.               0.06               0.06     352.    2200
#> 5      5    4026.               0.06               0.06     242.    3000
#> # ℹ 9 more variables: extra_principal <dbl>, principal <dbl>,
#> #   total_principal <dbl>, cashflow <dbl>, ob_end <dbl>,
#> #   negative_amortization <lgl>, timing <chr>, k <int>, payment_source <chr>

# Period-specific annual effective rates
amort_schedule_general(
  principal = 10000,
  n = 4,
  i = c(0.04, 0.05, 0.06, 0.07),
  payment = NULL
)
#> # A tibble: 4 × 15
#>   period ob_start i_effective_annual i_effective_period interest payment
#>    <int>    <dbl>              <dbl>              <dbl>    <dbl>   <dbl>
#> 1      1   10000                0.04               0.04     400    2818.
#> 2      2    7582.               0.05               0.05     379.   2818.
#> 3      3    5143.               0.06               0.06     309.   2818.
#> 4      4    2634.               0.07               0.07     184.   2818.
#> # ℹ 9 more variables: extra_principal <dbl>, principal <dbl>,
#> #   total_principal <dbl>, cashflow <dbl>, ob_end <dbl>,
#> #   negative_amortization <lgl>, timing <chr>, k <int>, payment_source <chr>

# Payment determined from the current balance
payment_rule <- function(
  period,
  ob_start,
  i_effective_period
) {
  1500 + 100 * (period - 1)
}

amort_schedule_general(
  principal = 8000,
  n = 6,
  i = 0.05,
  payment = payment_rule
)
#> # A tibble: 6 × 15
#>   period ob_start i_effective_annual i_effective_period interest payment
#>    <int>    <dbl>              <dbl>              <dbl>    <dbl>   <dbl>
#> 1      1    8000                0.05               0.05    400     1500 
#> 2      2    6900                0.05               0.05    345     1600 
#> 3      3    5645                0.05               0.05    282.    1700 
#> 4      4    4227.               0.05               0.05    211.    1800 
#> 5      5    2639.               0.05               0.05    132.    1900 
#> 6      6     871.               0.05               0.05     43.5    914.
#> # ℹ 9 more variables: extra_principal <dbl>, principal <dbl>,
#> #   total_principal <dbl>, cashflow <dbl>, ob_end <dbl>,
#> #   negative_amortization <lgl>, timing <chr>, k <int>, payment_source <chr>

# Compact summary
amort_schedule_general(
  principal = 100000,
  n = 60,
  i = 0.08,
  k = 12,
  output = "summary"
)
#> # A tibble: 1 × 6
#>   principal periods_realized total_interest total_paid ending_balance
#>       <dbl>            <int>          <dbl>      <dbl>          <dbl>
#> 1    100000               60         20858.    120858.              0
#> # ℹ 1 more variable: negative_amortization <lgl>
```
