# Future value of a general cash flow

Computes the future value of a cash-flow vector under either:

- a constant interest-rate specification, or

- a term structure of spot rates, one rate per cash flow.

## Usage

``` r
fv_flow(
  cf,
  i,
  i_type = "effective",
  m = 1L,
  t = NULL,
  date = NULL,
  day_count = c("act/365", "act/360"),
  tol = 1e-10
)
```

## Arguments

- cf:

  Numeric vector of cash flows.

- i:

  Numeric scalar or numeric vector of interest-rate values.

- i_type:

  Character vector indicating the interest-rate type: `"effective"`,
  `"nominal_interest"`, `"nominal_discount"`, or `"force"`. May have
  length 1 or the same length as `cf`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. May have length 1 or the same length as `cf`.

- t:

  Optional numeric vector of cash-flow times in years.

- date:

  Optional vector of cash-flow dates. If supplied, the earliest date is
  treated as time 0.

- day_count:

  Day-count convention used to convert dates to year fractions. One of
  `"act/365"` or `"act/360"`.

- tol:

  Numeric tolerance used in internal checks.

## Value

Numeric scalar: the future value of the cash flow accumulated to the
latest cash-flow time.

## Details

The cash flow is supplied explicitly through `cf`. Its timing is
supplied either through `t` (in years) or `date` (calendar dates). If
`date` is supplied, the earliest date is taken as time 0.

The future value is accumulated to the latest payment time or latest
date.

Interest-rate input:

- If `i` has length 1, the same rate is used for all cash flows.

- If `i` has the same length as `cf`, each rate is interpreted as the
  annual effective spot rate associated with the corresponding cash-flow
  time.

Rate types may be supplied in FM-style notation:

- annual effective rate \\i\\,

- nominal annual interest rate \\j^{(m)}\\,

- nominal annual discount rate \\d^{(m)}\\,

- force of interest \\\delta\\.

Internally, all supplied rates are converted to annual effective rates
using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).
When `i` is a vector, the accumulation uses the implied discount-factor
ratio under the spot-rate interpretation.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `cf` denotes cash flows, `t` denotes time, `i` denotes
the interest rate, `i_type` denotes the interest-rate type, and `m`
denotes the conversion frequency for nominal rates.

Let \\T\\ be the latest cash-flow time, the accumulation horizon. For
each cash flow \\C_k\\ at time \\t_k\\ with annual effective spot rate
\\i_k\\, the future value contribution is \$\$FV_k = C_k \cdot
\frac{(1+i_T)^T}{(1+i_k)^{t_k}}.\$\$

The total future value is \\FV = \sum_k FV_k\\. When a single constant
rate is supplied, \\i_k = i_T = i\\ for all \\k\\, and the formula
simplifies to \$\$FV = \sum_k C_k (1+i)^{T-t_k}.\$\$

## See also

[`pv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`future_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md),
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)

Other time-value:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`future_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md),
[`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`solve_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/solve_value.md)

## Examples

``` r
# Constant annual effective rate
fv_flow(
  cf = c(100, 150, 200),
  i = 0.08,
  i_type = "effective",
  t = c(0, 1, 2)
)
#> [1] 478.64

# Spot rates, one per cash flow
fv_flow(
  cf = c(100, 150, 200),
  i = c(0.05, 0.055, 0.06),
  i_type = "effective",
  t = c(1, 2, 3)
)
#> [1] 473.9408

# Using dates; earliest date is taken as t = 0
fv_flow(
  cf = c(100, 150, 200),
  i = c(0.05, 0.055, 0.06),
  i_type = "effective",
  date = as.Date(c("2026-01-10", "2027-01-10", "2028-01-10"))
)
#> [1] 472.1136

# Nominal rates by cash flow
fv_flow(
  cf = c(100, 100, 100),
  i = c(0.12, 0.12, 0.12),
  i_type = "nominal_interest",
  m = c(12, 12, 12),
  t = c(1, 2, 3)
)
#> [1] 339.656
```
