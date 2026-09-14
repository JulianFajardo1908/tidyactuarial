# Internal rate of return for a cash flow

Computes the internal rate of return (IRR) of a cash flow by finding the
annual effective rate that makes its present value equal to zero, using
compact actuarial notation.

## Usage

``` r
irr_flow(
  cf,
  t = NULL,
  date = NULL,
  m = 1L,
  interval = c(-0.99, 10),
  tol = 1e-10,
  maxiter = 1000,
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

- interval:

  Numeric vector of length 2 giving the search interval for the annual
  effective IRR. Default is `c(-0.99, 10)`.

- tol:

  Numeric tolerance passed to
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- maxiter:

  Maximum number of iterations passed to
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- day_count:

  Day-count convention used when `date` is supplied. One of `"act/365"`
  or `"act/360"`.

## Value

A one-row tibble with:

- irr:

  Estimated IRR as an annual effective rate.

- i_effective_annual:

  Same as `irr`, reported explicitly.

- j_nominal_interest:

  Equivalent nominal annual interest rate convertible `m` times.

- delta:

  Equivalent force of interest.

- npv:

  Present value at the estimated IRR, close to zero.

- interval_left:

  Left endpoint of the search interval.

- interval_right:

  Right endpoint of the search interval.

- converged:

  Logical flag indicating whether a root was found.

- n_iter:

  Number of iterations used by `uniroot`.

- n_cashflows:

  Length of `cf`.

- has_both_signs:

  Whether the cash flow has at least one positive and one negative
  value.

- n_sign_changes:

  Number of sign changes in the nonzero cash-flow sequence.

If no sign change is present in the cash flow, or if the NPV does not
change sign over `interval`, the function returns `converged = FALSE`
and `irr = NA_real_`.

## Details

The cash flow is supplied explicitly through `cf`. Its timing is given
either through `t` (in years) or `date` (calendar dates). If `date` is
supplied, the earliest date is treated as time 0.

The IRR returned is interpreted as an annual effective rate.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `cf` denotes cash flows, `t` denotes time, and `m`
denotes the conversion frequency used to report the equivalent nominal
annual interest rate.

The IRR is defined as the rate \\r\\ satisfying \$\$\sum\_{k} C_k
(1+r)^{-t_k} = 0\$\$ where \\C_k\\ are the cash flows and \\t_k\\ the
corresponding times in years.

The root is found using
[`uniroot`](https://rdrr.io/r/stats/uniroot.html) over the specified
`interval`. If the NPV does not change sign over the interval, no root
can be bracketed and the function returns gracefully with
`converged = FALSE`.

The number of sign changes in the nonzero cash-flow sequence is reported
as a diagnostic. If there is exactly one sign change, the IRR is usually
unique under the usual ordered cash-flow setting.

## See also

[`pv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`irr_flow_multi`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`bond_ytm`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md)

Other time-value:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`future_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md),
[`fv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md),
[`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`solve_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/solve_value.md)

## Examples

``` r
irr_flow(
  cf = c(-1000, 300, 400, 500),
  t = c(0, 1, 2, 3)
)
#> # A tibble: 1 × 12
#>      irr i_effective_annual j_nominal_interest  delta      npv interval_left
#>    <dbl>              <dbl>              <dbl>  <dbl>    <dbl>         <dbl>
#> 1 0.0890             0.0890             0.0890 0.0852 1.07e-10         -0.99
#> # ℹ 6 more variables: interval_right <dbl>, converged <lgl>, n_iter <int>,
#> #   n_cashflows <int>, has_both_signs <lgl>, n_sign_changes <int>

irr_flow(
  cf = c(-1000, 300, 400, 500),
  date = as.Date(c("2026-01-01", "2027-01-01", "2028-01-01", "2029-01-01"))
)
#> # A tibble: 1 × 12
#>      irr i_effective_annual j_nominal_interest  delta      npv interval_left
#>    <dbl>              <dbl>              <dbl>  <dbl>    <dbl>         <dbl>
#> 1 0.0889             0.0889             0.0889 0.0852 1.08e-10         -0.99
#> # ℹ 6 more variables: interval_right <dbl>, converged <lgl>, n_iter <int>,
#> #   n_cashflows <int>, has_both_signs <lgl>, n_sign_changes <int>
```
