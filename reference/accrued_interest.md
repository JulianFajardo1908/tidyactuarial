# Accrued coupon interest and clean/dirty bond prices

Computes the coupon interest accrued between the previous coupon date
and settlement, and optionally reconciles a quoted clean or dirty bond
price. This is a day-count calculation, not a yield-based bond
valuation.

## Usage

``` r
accrued_interest(
  .data = NULL,
  face = NULL,
  c = NULL,
  settlement = NULL,
  previous_coupon = NULL,
  next_coupon = NULL,
  k = 1L,
  day_count = "act/act",
  clean_price = NULL,
  dirty_price = NULL,
  tol = 1e-10
)
```

## Arguments

- .data:

  Optional data frame containing one bond per row. Required columns are
  `face`, `c`, `settlement`, `previous_coupon`, and `next_coupon`.
  Optional columns are `k`, `day_count`, `clean_price`, and
  `dirty_price`. Other columns are preserved. When `.data` is supplied,
  `face`, `c`, and the date arguments must come from its columns.

- face:

  Positive face value of the bond. Numeric scalar or vector in
  direct-input mode; otherwise the corresponding column of `.data`.

- c:

  Nonnegative annual nominal coupon rate, as a proportion (0.06 for 6
  percent). Numeric scalar or vector.

- settlement:

  `Date` of settlement. The accrued-interest convention excludes this
  date from the elapsed interval.

- previous_coupon:

  `Date` of the immediately preceding coupon date.

- next_coupon:

  `Date` of the immediately following coupon date. Settlement must
  satisfy `previous_coupon <= settlement < next_coupon`. At a coupon
  date, supply that date as `previous_coupon` to obtain zero accrued
  interest.

- k:

  Number of regular coupon payments per year, a positive integer;
  defaults to 1. For data-frame input, the `k` column, if present, takes
  precedence over this argument.

- day_count:

  Day-count convention, one of `"act/act"`, `"act/360"`, `"act/365"`, or
  `"30e/360"`. The default is `"act/act"`, defined as actual days
  divided by actual days in the coupon period, with annual coupon
  fraction `1/k`. For data-frame input, a `day_count` column, if
  present, takes precedence over this argument. `"30e/360"` denotes the
  European 30E/360 convention with both day-of-month values capped at
  30.

- clean_price:

  Optional quoted clean price, in the same currency units and for the
  same face value as `face`.

- dirty_price:

  Optional dirty price, on the same basis. If either price is provided,
  the other is determined by the clean/dirty price identity. If both are
  supplied, their consistency is checked.

- tol:

  Positive scalar tolerance for reconciling prices when both are
  supplied; finite and used as a scaled absolute tolerance. The bound is
  `tol * max(1, abs(clean_price), abs(dirty_price), abs(accrued_interest))`
  for each row. The unit floor is part of this price-reconciliation
  rule; it is not a yield-solver tolerance.

## Value

A `tibble`. For direct input, it contains the bond parameters,
settlement/coupon dates, the chosen convention, `coupon_per_period`,
`days_elapsed`, `days_in_period`, `year_fraction`, `coupon_fraction`,
`accrued_interest`, `clean_price`, and `dirty_price`. For data-frame
input, original columns are retained and the audit columns added. When
neither price is supplied, both price columns contain `NA_real_`.

## Details

Let `F` be face value, `c` the nominal annual coupon rate, and `k` the
coupon frequency. The regular coupon is `C = F * c / k`.

For `"act/act"`, with `d` actual elapsed calendar days and `D` actual
days in the full coupon period, the year fraction and accrued interest
are `alpha = d / (k * D)` and `AI = F * c * alpha = C * d / D`.

For `"act/360"` and `"act/365"`, `alpha` equals actual elapsed calendar
days divided by 360 or 365 respectively; for `"30e/360"`, it equals the
number of 30E/360 days divided by 360. These conventions accrue at the
annual coupon rate and therefore need not reach exactly one regular
coupon at the end of every actual calendar coupon period.

The price identity is `dirty_price = clean_price + accrued_interest`. A
price supplied to this function is *not* computed from a yield curve.
Calculations assume a fixed-rate bond with regular coupon periods, no
stubs, no ex-coupon adjustment, no withholding tax, no amortizing
principal, and no transaction costs. The caller supplies the correct
bracketing coupon dates: a full coupon schedule is not inferred.

All direct-input arguments of length greater than one must have the same
length; length-one values are recycled. Calendar dates must have class
`Date`, not bare character strings or numeric date serials. Finite
coupon and accrued amounts are recovered from overflowing intermediate
products when possible; nonrepresentable final amounts cause an error.

## See also

[`bond_cash_flows()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
accrued_interest(
  face = 1000, c = 0.06, k = 2,
  previous_coupon = as.Date("2026-01-01"),
  settlement = as.Date("2026-04-01"),
  next_coupon = as.Date("2026-07-01"),
  clean_price = 1005
)
#> # A tibble: 1 × 15
#>    face     c     k settlement previous_coupon next_coupon day_count
#>   <dbl> <dbl> <int> <date>     <date>          <date>      <chr>    
#> 1  1000  0.06     2 2026-04-01 2026-01-01      2026-07-01  act/act  
#> # ℹ 8 more variables: coupon_per_period <dbl>, days_elapsed <dbl>,
#> #   days_in_period <dbl>, year_fraction <dbl>, coupon_fraction <dbl>,
#> #   accrued_interest <dbl>, clean_price <dbl>, dirty_price <dbl>

# The same position under two market day-count conventions.
accrued_interest(
  face = 1000, c = 0.06, k = 2,
  previous_coupon = as.Date("2026-01-01"),
  settlement = as.Date("2026-04-01"),
  next_coupon = as.Date("2026-07-01"),
  day_count = "30e/360"
)
#> # A tibble: 1 × 15
#>    face     c     k settlement previous_coupon next_coupon day_count
#>   <dbl> <dbl> <int> <date>     <date>          <date>      <chr>    
#> 1  1000  0.06     2 2026-04-01 2026-01-01      2026-07-01  30e/360  
#> # ℹ 8 more variables: coupon_per_period <dbl>, days_elapsed <dbl>,
#> #   days_in_period <dbl>, year_fraction <dbl>, coupon_fraction <dbl>,
#> #   accrued_interest <dbl>, clean_price <dbl>, dirty_price <dbl>

# Pipe-friendly portfolio input: each row is one bond position.
bonds <- tibble::tibble(
  bond = c("A", "B"), face = c(1000, 500), c = c(0.06, 0.04),
  k = c(2L, 2L),
  previous_coupon = as.Date(c("2026-01-01", "2026-01-01")),
  settlement = as.Date(c("2026-04-01", "2026-04-01")),
  next_coupon = as.Date(c("2026-07-01", "2026-07-01"))
)
bonds |> accrued_interest()
#> # A tibble: 2 × 15
#>   bond   face     c     k previous_coupon settlement next_coupon
#>   <chr> <dbl> <dbl> <int> <date>          <date>     <date>     
#> 1 A      1000  0.06     2 2026-01-01      2026-04-01 2026-07-01 
#> 2 B       500  0.04     2 2026-01-01      2026-04-01 2026-07-01 
#> # ℹ 8 more variables: coupon_per_period <dbl>, days_elapsed <dbl>,
#> #   days_in_period <dbl>, year_fraction <dbl>, coupon_fraction <dbl>,
#> #   accrued_interest <dbl>, clean_price <dbl>, dirty_price <dbl>
```
