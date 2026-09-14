# Future value of a single payment

Computes the future value of a payment invested at time 0 and
accumulated to a given time, using the annual effective interest rate
implied by the supplied interest-rate specification and compact
actuarial notation.

## Usage

``` r
future_value(C, i, i_type = "effective", m = 1, t, tidy = FALSE)
```

## Arguments

- C:

  Numeric vector of initial payment amounts or capitals.

- i:

  Numeric vector of interest-rate values.

- i_type:

  Character vector indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer vector giving the conversion frequency for nominal
  rates. Ignored for `"effective"` and `"force"`.

- t:

  Numeric vector of times in years from valuation to accumulation.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric future value. If `TRUE`,
  returns a tibble with intermediate calculations.

## Value

If `tidy = FALSE`, a numeric vector of future values.

If `tidy = TRUE`, a tibble with input values, equivalent rates,
accumulation factors, and future values.

## Details

The future value is computed as \$\$FV = C(1+i)^t\$\$ where \\i\\ is the
annual effective interest rate.

The input interest rate may be supplied as:

- annual effective interest rate,

- nominal annual interest rate,

- nominal annual discount rate,

- force of interest.

Internally, all rate specifications are first converted to the
equivalent annual effective interest rate using
[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md).

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `C` denotes the initial payment amount or capital, `t`
denotes time, `i` denotes the interest-rate input, `i_type` denotes the
interest-rate type, and `m` denotes the conversion frequency for nominal
rates.

Input vectors must have length 1 or a common length. Missing values are
propagated. This function does not accept dates; use
[`fv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md)
for dated cash flows.

## See also

[`standardize_interest`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md),
[`present_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`fv_flow`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md)

Other time-value:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`fv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md),
[`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md),
[`solve_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/solve_value.md)

## Examples

``` r
# Numeric future value
future_value(C = 1000, i = 0.08, t = 3)
#> [1] 1259.712

# Nominal interest converted monthly
future_value(
  C = 1000,
  i = 0.12,
  i_type = "nominal_interest",
  m = 12,
  t = 5
)
#> [1] 1816.697

# Tibble output for teaching or auditing
future_value(
  C = 1000,
  i = 0.08,
  t = 3,
  tidy = TRUE
)
#> # A tibble: 1 × 8
#>       C     t i_input i_type      m i_effective accumulation_factor future_value
#>   <dbl> <dbl>   <dbl> <chr>   <dbl>       <dbl>               <dbl>        <dbl>
#> 1  1000     3    0.08 effect…     1        0.08                1.26        1260.

# Vectorized example
future_value(
  C = c(1000, 2500, 4000),
  i = c(0.08, 0.10, 0.12),
  i_type = c("effective", "nominal_interest", "force"),
  m = c(1, 12, 1),
  t = c(3, 5, 2)
)
#> [1] 1259.712 4113.272 5084.997
```
