# Price of a callable bond at a target minimum yield

Computes the maximum price an investor should pay for a callable bond in
order to guarantee a specified minimum yield, using compact actuarial
notation.

## Usage

``` r
bond_callable_price(
  face,
  c,
  n,
  k = 1L,
  call_t,
  call_R,
  y_effective_per_period = NULL,
  y = NULL,
  y_type = "effective",
  y_m = 1L,
  R = NULL,
  tol = 1e-10,
  check = TRUE,
  tidy = FALSE
)
```

## Arguments

- face:

  Numeric scalar. Face or par value of the bond.

- c:

  Numeric scalar. Annual coupon rate as a proportion.

- n:

  Numeric scalar. Final maturity in years. Must be strictly positive.

- k:

  Positive integer. Number of coupon payments per year.

- call_t:

  Numeric vector of callable times in years. Each value must be strictly
  between `0` and `n`, and must align with coupon dates.

- call_R:

  Numeric vector of call prices corresponding to `call_t`.

- y_effective_per_period:

  Optional numeric scalar. Effective yield per coupon period. If
  supplied, it is used directly.

- y:

  Optional numeric scalar. Annual yield rate value.

- y_type:

  Character string indicating the annual yield type: `"effective"`,
  `"nominal_interest"`, `"nominal_discount"`, or `"force"`.

- y_m:

  Positive integer. Conversion frequency for nominal annual yields.

- R:

  Numeric scalar. Redemption value at final maturity. If `NULL`,
  defaults to `face`.

- tol:

  Numeric scalar. Tolerance used in alignment checks.

- check:

  Logical scalar. If `TRUE`, performs input validation.

- tidy:

  Logical scalar. If `FALSE`, returns the worst-case callable-bond
  price. If `TRUE`, returns a tibble with all redemption scenarios.

## Value

If `tidy = FALSE`, a numeric scalar: the worst-case callable-bond price
consistent with the target yield.

If `tidy = TRUE`, a tibble with one row per redemption scenario,
including scenario prices and the worst-case indicator.

## Details

The bond is evaluated under each possible redemption scenario:

- each callable date with its associated call price, and

- final maturity with its final redemption value.

For each scenario, the bond price is computed using the target yield.
The callable-bond price returned by this function is the smallest of
those scenario prices, that is, the maximum price consistent with the
target yield under the least favorable redemption scenario for the
investor.

This follows the standard actuarial/financial interpretation used in
introductory fixed-income mathematics: when a bond is callable at the
issuer's option, the investor must protect against the redemption
scenario that is least favorable to the investor at the required yield.

Assumptions:

- Coupons are paid in arrears at regular intervals.

- `n * k` must be an integer.

- Each `call_t * k` must be an integer.

- Stub periods are not supported.

- Pricing is performed at a coupon date; no accrued interest is
  included.

Yield input conventions:

- If `y_effective_per_period` is supplied, it takes precedence over `y`,
  `y_type`, and `y_m`, and is interpreted as the effective yield per
  coupon period.

- Otherwise, `y`, `y_type`, and `y_m` define an annual yield
  specification, which is converted first to annual effective yield and
  then to effective yield per coupon period.

This function follows the compact bond notation used in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `n` is
maturity, `k` is coupon frequency, `y` is the target yield, `R` is the
final redemption value, `call_t` is the vector of call times, and
`call_R` is the vector of call prices.

Let the callable bond have possible redemption scenarios indexed by \\j
= 1, \dots, J\\, where each scenario corresponds either to a call date
or to final maturity. For scenario \\j\\, let \\P_j(y)\\ denote the bond
price computed at the target yield \\y\\ assuming redemption occurs at
that scenario time and value.

Then this function returns \$\$\min_j P_j(y)\$\$ when `tidy = FALSE`.

This is the maximum price an investor can pay while still guaranteeing
at least the target yield under the least favorable redemption scenario.

## See also

[`bond_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_cash_flows`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_book_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_ytm`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
# Callable bond with two possible call dates
bond_callable_price(
  face = 100,
  c = 0.08,
  n = 10,
  k = 2,
  call_t = c(5, 7),
  call_R = c(105, 102),
  y = 0.06,
  y_type = "effective"
)
#> [1] 112.6591

# Tidy output with all redemption scenarios
bond_callable_price(
  face = 100,
  c = 0.08,
  n = 10,
  k = 2,
  call_t = c(5, 7),
  call_R = c(105, 102),
  y = 0.06,
  y_type = "effective",
  tidy = TRUE
)
#> # A tibble: 3 × 13
#>   scenario_id scenario_type     t redemption_value price_at_target_yield
#>         <int> <chr>         <dbl>            <dbl>                 <dbl>
#> 1           1 call              5              105                  113.
#> 2           2 call              7              102                  113.
#> 3           3 maturity         10              100                  116.
#> # ℹ 8 more variables: is_worst_case <lgl>, yield_per_period <dbl>,
#> #   yield_effective_annual <dbl>, k <int>, face <dbl>, c <dbl>, n <dbl>,
#> #   R <dbl>

# Target yield given directly per coupon period
bond_callable_price(
  face = 1000,
  c = 0.05,
  n = 12,
  k = 2,
  call_t = c(4, 8),
  call_R = c(1030, 1015),
  y_effective_per_period = 0.028
)
#> [1] 948.0812
```
