# Amortization schedule with optional prepayment adjustment

Builds an amortization schedule under a fixed annual interest-rate
specification, allowing extra principal payments and optional adjustment
of either the remaining term or the remaining payment amount.

## Usage

``` r
amort_schedule(
  principal,
  n,
  i,
  i_type = "effective",
  m = 1L,
  k = 1L,
  timing = c("immediate", "due"),
  payment = NULL,
  extra_principal = NULL,
  adjust = c("none", "term", "payment"),
  tol = 1e-08
)
```

## Arguments

- principal:

  Numeric scalar. Initial outstanding balance.

- n:

  Positive integer. Number of contractual periods.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the annual interest-rate type:
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, or
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal annual rates.

- k:

  Positive integer. Number of amortization periods per year.

- timing:

  Character string. One of `"immediate"` or `"due"`.

- payment:

  Optional numeric scalar. Initial regular payment per period. If
  `NULL`, it is computed from the loan data.

- extra_principal:

  Optional extra principal payments. Can be:

  - `NULL`,

  - a scalar,

  - an unnamed numeric vector of length `n`,

  - a named numeric vector with names interpreted as period numbers.

- adjust:

  Character string. One of `"none"`, `"term"`, or `"payment"`.

- tol:

  Numeric tolerance for zero-balance detection.

## Value

A tibble with one row per realized period and columns:

- period:

  Period index.

- ob_start:

  Outstanding balance at the start of the period.

- interest:

  Interest charged during the period.

- payment:

  Regular payment in the period.

- extra_principal:

  Extra principal paid in the period.

- principal:

  Principal repaid through the regular payment.

- total_principal:

  Total principal repaid in the period.

- cashflow:

  Total payment made in the period.

- ob_end:

  Outstanding balance at the end of the period.

- i_effective_annual:

  Equivalent annual effective rate.

- i_effective_period:

  Equivalent effective rate per schedule period.

- k:

  Schedule frequency.

- timing:

  Payment timing convention.

- adjust:

  Adjustment rule used.

## Details

The annual rate is converted internally to an effective rate per
schedule period using `k`.

Adjustment policies after extra principal payments:

- `"none"`: keep the original payment and contractual term, unless the
  loan is fully repaid early.

- `"term"`: keep the regular payment and shorten the term. No special
  logic is needed: the loop exits naturally when the outstanding balance
  reaches zero.

- `"payment"`: keep the remaining contractual term and recalculate the
  regular payment after each period.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` is the interest rate, `i_type` is the interest-rate
type, `m` is the conversion frequency for nominal annual rates, and `k`
is the number of amortization periods per year.

For `timing = "immediate"` (annuity-immediate), interest accrues on the
outstanding balance during the period, and the payment is made at the
end. For `timing = "due"` (annuity-due), the payment is made at the
start of the period and interest accrues on the balance after the
payment.

If the user supplies a custom `payment` that is smaller than the
periodic interest, principal repayment will be negative (negative
amortization). This is permitted but the user should be aware.

## See also

[`a_angle`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md),
[`present_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)

Other amortization:
[`amort_schedule_general()`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule_general.md),
[`sinking_fund_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/sinking_fund_schedule.md)

## Examples

``` r
amort_schedule(
  principal = 100000,
  n = 12,
  i = 0.12,
  i_type = "nominal_interest",
  m = 12,
  k = 12
)
#> # A tibble: 12 × 14
#>    period ob_start interest payment extra_principal principal total_principal
#>     <int>    <dbl>    <dbl>   <dbl>           <dbl>     <dbl>           <dbl>
#>  1      1  100000    1000.    8885.               0     7885.           7885.
#>  2      2   92115.    921.    8885.               0     7964.           7964.
#>  3      3   84151.    842.    8885.               0     8043.           8043.
#>  4      4   76108.    761.    8885.               0     8124.           8124.
#>  5      5   67984.    680.    8885.               0     8205.           8205.
#>  6      6   59779.    598.    8885.               0     8287.           8287.
#>  7      7   51492.    515.    8885.               0     8370.           8370.
#>  8      8   43122.    431.    8885.               0     8454.           8454.
#>  9      9   34668.    347.    8885.               0     8538.           8538.
#> 10     10   26130.    261.    8885.               0     8624.           8624.
#> 11     11   17507.    175.    8885.               0     8710.           8710.
#> 12     12    8797.     88.0   8885.               0     8797.           8797.
#> # ℹ 7 more variables: cashflow <dbl>, ob_end <dbl>, i_effective_annual <dbl>,
#> #   i_effective_period <dbl>, k <int>, timing <chr>, adjust <chr>

amort_schedule(
  principal = 100000,
  n = 24,
  i = 0.12,
  i_type = "nominal_interest",
  m = 12,
  k = 12,
  extra_principal = c("6" = 5000, "12" = 3000),
  adjust = "term"
)
#> # A tibble: 23 × 14
#>    period ob_start interest payment extra_principal principal total_principal
#>     <int>    <dbl>    <dbl>   <dbl>           <dbl>     <dbl>           <dbl>
#>  1      1  100000     1000.   4707.               0     3707.           3707.
#>  2      2   96293.     963.   4707.               0     3744.           3744.
#>  3      3   92548.     925.   4707.               0     3782.           3782.
#>  4      4   88766.     888.   4707.               0     3820.           3820.
#>  5      5   84947.     849.   4707.               0     3858.           3858.
#>  6      6   81089.     811.   4707.            5000     3896.           8896.
#>  7      7   72192.     722.   4707.               0     3985.           3985.
#>  8      8   68207.     682.   4707.               0     4025.           4025.
#>  9      9   64182.     642.   4707.               0     4066.           4066.
#> 10     10   60116.     601.   4707.               0     4106.           4106.
#> # ℹ 13 more rows
#> # ℹ 7 more variables: cashflow <dbl>, ob_end <dbl>, i_effective_annual <dbl>,
#> #   i_effective_period <dbl>, k <int>, timing <chr>, adjust <chr>

amort_schedule(
  principal = 100000,
  n = 24,
  i = 0.12,
  i_type = "nominal_interest",
  m = 12,
  k = 12,
  extra_principal = c("6" = 5000, "12" = 3000),
  adjust = "payment"
)
#> # A tibble: 24 × 14
#>    period ob_start interest payment extra_principal principal total_principal
#>     <int>    <dbl>    <dbl>   <dbl>           <dbl>     <dbl>           <dbl>
#>  1      1  100000     1000.   4707.               0     3707.           3707.
#>  2      2   96293.     963.   4707.               0     3744.           3744.
#>  3      3   92548.     925.   4707.               0     3782.           3782.
#>  4      4   88766.     888.   4707.               0     3820.           3820.
#>  5      5   84947.     849.   4707.               0     3858.           3858.
#>  6      6   81089.     811.   4707.            5000     3896.           8896.
#>  7      7   72192.     722.   4402.               0     3681.           3681.
#>  8      8   68512.     685.   4402.               0     3717.           3717.
#>  9      9   64795.     648.   4402.               0     3754.           3754.
#> 10     10   61040.     610.   4402.               0     3792.           3792.
#> # ℹ 14 more rows
#> # ℹ 7 more variables: cashflow <dbl>, ob_end <dbl>, i_effective_annual <dbl>,
#> #   i_effective_period <dbl>, k <int>, timing <chr>, adjust <chr>
```
