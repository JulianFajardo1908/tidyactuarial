# Discount factor under conventional or time-varying interest

Computes the discount factor from time `t` back to time `s` using
exactly one of three interest specifications:

- a conventional interest rate `i`;

- an accumulation function `a(t)`;

- a time-varying force of interest `delta(t)`.

## Usage

``` r
discount_factor(
  s = 0,
  t,
  i = NULL,
  i_type = "effective",
  m = 1,
  a = NULL,
  delta = NULL,
  subdivisions = 100L,
  rel.tol = 1e-08,
  tidy = FALSE
)
```

## Arguments

- s:

  Numeric vector of valuation times. Defaults to 0.

- t:

  Numeric vector of payment or accumulation times.

- i:

  Optional numeric vector of conventional interest-rate values.

- i_type:

  Character vector indicating the conventional interest-rate type.
  Allowed values are `"effective"`, `"nominal_interest"`,
  `"nominal_discount"`, and `"force"`. Used only when `i` is supplied.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. Used only when `i` is supplied.

- a:

  Optional accumulation function of one numeric time argument.

- delta:

  Optional force-of-interest function of one numeric time argument.

- subdivisions:

  Positive integer giving the maximum number of subintervals used by
  [`stats::integrate()`](https://rdrr.io/r/stats/integrate.html) when
  `delta` is supplied.

- rel.tol:

  Positive relative tolerance passed to
  [`stats::integrate()`](https://rdrr.io/r/stats/integrate.html) when
  `delta` is supplied.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric vector. If `TRUE`,
  returns a tibble with the inputs, accumulation factor, and discount
  factor.

## Value

If `tidy = FALSE`, a numeric vector of discount factors.

If `tidy = TRUE`, a tibble containing the interval, interest model,
relevant intermediate quantities, accumulation factor, and discount
factor.

## Details

The discount factor is the reciprocal of the corresponding accumulation
factor: \$\$v(s,t) = \frac{1}{A(s,t)}.\$\$

Therefore, \$\$v(s,t) = (1+i)^{-(t-s)}\$\$ for a constant annual
effective rate, \$\$v(s,t) = \frac{a(s)}{a(t)}\$\$ for an accumulation
function, and \$\$v(s,t) = \exp\left(-\int_s^t \delta(u)\\du\right)\$\$
for a time-varying force of interest.

Exactly one of `i`, `a`, or `delta` must be supplied.

Numeric arguments may have length 1 or a common length. Scalars are
recycled over the remaining scenarios, making the function suitable for
use inside
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
pipelines.

This function handles general discounting over an interval \\\[s,t\]\\.
For discount factors obtained specifically from a spot-rate curve, see
[`discount_factor_spot`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md).

## See also

[`accumulation_factor`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor_spot`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`present_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md)

Other interest:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

Other time-value:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`future_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md),
[`fv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md),
[`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`solve_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/solve_value.md)

## Examples

``` r
# Constant annual effective interest
discount_factor(
  t = 5,
  i = 0.07
)
#> [1] 0.7129862

# One rate recycled over several times
discount_factor(
  t = c(1, 2, 5),
  i = 0.07
)
#> [1] 0.9345794 0.8734387 0.7129862

# Accumulation function
a_fun <- function(t) {
  exp(0.03 * t + 0.002 * t^2)
}

discount_factor(
  s = 2,
  t = 5,
  a = a_fun
)
#> [1] 0.876341

# Time-varying force of interest
delta_fun <- function(t) {
  0.03 + 0.004 * t
}

discount_factor(
  s = 2,
  t = 5,
  delta = delta_fun
)
#> [1] 0.876341

# Pipe-friendly use
if (requireNamespace("dplyr", quietly = TRUE) &&
    requireNamespace("tibble", quietly = TRUE)) {
  scenarios <- tibble::tibble(
    i = 0.07,
    t = c(1, 2, 3, 5)
  )

  scenarios |>
    dplyr::mutate(
      discount = discount_factor(
        t = t,
        i = i
      )
    )
}
#> # A tibble: 4 × 3
#>       i     t discount
#>   <dbl> <dbl>    <dbl>
#> 1  0.07     1    0.935
#> 2  0.07     2    0.873
#> 3  0.07     3    0.816
#> 4  0.07     5    0.713
```
