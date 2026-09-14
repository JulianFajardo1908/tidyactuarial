# Accumulation factor under conventional or time-varying interest

Computes the accumulation factor from time `s` to time `t` using exactly
one of three interest specifications:

- a conventional interest rate `i`;

- an accumulation function `a(t)`;

- a time-varying force of interest `delta(t)`.

## Usage

``` r
accumulation_factor(
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

  Numeric vector of starting times. Defaults to 0.

- t:

  Numeric vector of ending times.

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

  Optional accumulation function of one numeric time argument. The
  function must return one positive finite numeric value for each
  supplied time.

- delta:

  Optional force-of-interest function of one numeric time argument.
  Numerical integration is performed separately over each interval
  \\\[s,t\]\\.

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
  returns a tibble with the inputs and intermediate quantities.

## Value

If `tidy = FALSE`, a numeric vector of accumulation factors.

If `tidy = TRUE`, a tibble containing the interval, model, relevant
intermediate quantities, and accumulation factor.

## Details

The accumulation factor is \$\$A(s,t) = (1+i)^{t-s}\$\$ for a constant
annual effective rate, \$\$A(s,t) = \frac{a(t)}{a(s)}\$\$ for an
accumulation function, and \$\$A(s,t) = \exp\left(\int_s^t
\delta(u)\\du\right)\$\$ for a time-varying force of interest.

Exactly one of `i`, `a`, or `delta` must be supplied.

Numeric arguments must have length 1 or a common length. Scalars are
recycled over the remaining scenarios, making the function suitable for
use inside
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
pipelines.

Times must satisfy \\0 \le s \le t\\. Missing times propagate as missing
accumulation factors.

## See also

[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`present_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`future_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md)

Other interest:
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md),
[`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md),
[`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md),
[`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)

Other time-value:
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
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
accumulation_factor(t = 5, i = 0.07)
#> [1] 1.402552

# One rate recycled over several times
accumulation_factor(
  t = c(1, 2, 5),
  i = 0.07
)
#> [1] 1.070000 1.144900 1.402552

# Accumulation function
a_fun <- function(t) {
  exp(0.03 * t + 0.002 * t^2)
}

accumulation_factor(
  s = 2,
  t = 5,
  a = a_fun
)
#> [1] 1.141108

# Time-varying force of interest
delta_fun <- function(t) {
  0.03 + 0.004 * t
}

accumulation_factor(
  s = 2,
  t = 5,
  delta = delta_fun
)
#> [1] 1.141108

# Pipe-friendly use with a small tibble
if (requireNamespace("dplyr", quietly = TRUE) &&
    requireNamespace("tibble", quietly = TRUE)) {
  scenarios <- tibble::tibble(
    i = 0.07,
    t = c(1, 2, 3, 5)
  )

  scenarios |>
    dplyr::mutate(
      accumulation = accumulation_factor(
        t = t,
        i = i
      )
    )
}
#> # A tibble: 4 × 3
#>       i     t accumulation
#>   <dbl> <dbl>        <dbl>
#> 1  0.07     1         1.07
#> 2  0.07     2         1.14
#> 3  0.07     3         1.23
#> 4  0.07     5         1.40
```
