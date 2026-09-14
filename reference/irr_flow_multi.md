# Multiple internal rates of return for a cash flow

Searches for multiple internal rates of return (IRRs) of a cash flow by
scanning a search interval and solving for all detectable roots of the
net present value (NPV) function, using compact actuarial notation.

## Usage

``` r
irr_flow_multi(
  cf,
  t = NULL,
  date = NULL,
  m = 1L,
  search_interval = c(-0.99, 10),
  grid_points = 2000L,
  tol = 1e-10,
  maxiter = 1000L,
  day_count = c("act/365", "act/360")
)
```

## Arguments

- cf:

  Numeric vector of cash flows.

- t:

  Optional numeric vector of cash-flow times in years.

- date:

  Optional vector of cash-flow dates. If supplied, the earliest date is
  treated as time 0.

- m:

  Positive integer used only to report an equivalent nominal annual
  interest rate convertible `m` times per year.

- search_interval:

  Numeric vector of length 2 giving the search interval for annual
  effective IRRs. Default is `c(-0.99, 10)`.

- grid_points:

  Positive integer giving the number of grid points used to scan the
  interval. Larger values improve detection at the cost of speed.

- tol:

  Numeric tolerance passed to
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- maxiter:

  Positive integer passed to
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- day_count:

  Day-count convention used when `date` is supplied. One of `"act/365"`
  or `"act/360"`.

## Value

A tibble with one row per detected IRR and columns:

- root_id:

  Root index.

- irr:

  Detected IRR as an annual effective rate.

- i_effective_annual:

  Same as `irr`, reported explicitly.

- j_nominal_interest:

  Equivalent nominal annual interest rate convertible `m` times.

- delta:

  Equivalent force of interest.

- npv:

  NPV evaluated at the detected root, approximately zero.

- interval_left:

  Left endpoint of the local search bracket.

- interval_right:

  Right endpoint of the local search bracket.

- n_cashflows:

  Length of `cf`.

- has_both_signs:

  Whether the cash flow has at least one positive and one negative
  value.

- n_sign_changes_cashflow:

  Number of sign changes in the nonzero cash-flow sequence.

If no roots are detected, the function returns a tibble with zero rows.

## Details

This function is intended for cash flows with multiple sign changes,
where more than one IRR may exist. It evaluates the NPV on a fine grid
over the search interval, identifies subintervals with sign changes (and
grid points where the NPV is approximately zero), and applies
[`uniroot`](https://rdrr.io/r/stats/uniroot.html) to each candidate
interval.

The IRRs returned are interpreted as annual effective rates.

Timing can be supplied either through `t` (in years) or `date` (calendar
dates). If `date` is supplied, the earliest date is treated as time 0.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `cf` denotes cash flows, `t` denotes time, and `m`
denotes the conversion frequency used to report the equivalent nominal
annual interest rate.

This function detects roots numerically over a finite search interval.
It may miss roots if:

- the grid is too coarse,

- two roots are extremely close,

- the NPV touches zero without changing sign,

- or the root lies outside the search interval.

For a single-IRR workflow, use
[`irr_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md).

## See also

[`irr_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`pv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md)

Other time-value:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`future_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md),
[`fv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md),
[`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`solve_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/solve_value.md)

## Examples

``` r
# A standard single-IRR cash flow
irr_flow_multi(
  cf = c(-1000, 300, 400, 500),
  t = c(0, 1, 2, 3)
)
#> # A tibble: 1 × 11
#>   root_id    irr i_effective_annual j_nominal_interest  delta      npv
#>     <int>  <dbl>              <dbl>              <dbl>  <dbl>    <dbl>
#> 1       1 0.0890             0.0890             0.0890 0.0852 1.36e-12
#> # ℹ 5 more variables: interval_left <dbl>, interval_right <dbl>,
#> #   n_cashflows <int>, has_both_signs <lgl>, n_sign_changes_cashflow <int>

# A cash flow with multiple sign changes
irr_flow_multi(
  cf = c(-1000, 5000, -4500, 200),
  t = c(0, 1, 2, 3),
  search_interval = c(-0.99, 5),
  grid_points = 5000
)
#> # A tibble: 3 × 11
#>   root_id    irr i_effective_annual j_nominal_interest  delta       npv
#>     <int>  <dbl>              <dbl>              <dbl>  <dbl>     <dbl>
#> 1       1 -0.953             -0.953             -0.953 -3.06   9.30e- 4
#> 2       2  0.111              0.111              0.111  0.105 -3.10e- 9
#> 3       3  2.84               2.84               2.84   1.35  -6.02e-10
#> # ℹ 5 more variables: interval_left <dbl>, interval_right <dbl>,
#> #   n_cashflows <int>, has_both_signs <lgl>, n_sign_changes_cashflow <int>

# Date-based version
irr_flow_multi(
  cf = c(-1000, 300, 400, 500),
  date = as.Date(c("2026-01-01", "2027-01-01", "2028-01-01", "2029-01-01"))
)
#> # A tibble: 1 × 11
#>   root_id    irr i_effective_annual j_nominal_interest  delta      npv
#>     <int>  <dbl>              <dbl>              <dbl>  <dbl>    <dbl>
#> 1       1 0.0889             0.0889             0.0889 0.0852 1.25e-12
#> # ℹ 5 more variables: interval_left <dbl>, interval_right <dbl>,
#> #   n_cashflows <int>, has_both_signs <lgl>, n_sign_changes_cashflow <int>
```
