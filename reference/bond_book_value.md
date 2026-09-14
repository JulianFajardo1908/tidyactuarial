# Book value of a level coupon bond at a coupon date

Computes the book value of a level coupon bond at one or more coupon
dates, under a specified yield basis, using compact actuarial notation.

## Usage

``` r
bond_book_value(
  face,
  c,
  n,
  t,
  k = 1L,
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

  Numeric scalar. Final maturity in years.

- t:

  Numeric vector. Valuation time(s) in years, measured from issue. Each
  value must lie between `0` and `n` and must align with coupon dates.

- k:

  Positive integer. Number of coupon payments per year.

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

  Logical scalar. If `FALSE`, returns a numeric vector of book values.
  If `TRUE`, returns a tibble with intermediate quantities.

## Value

If `tidy = FALSE`, a numeric vector of book values, one for each `t`.

If `tidy = TRUE`, a tibble with valuation times, valuation periods, book
values, yield information, and bond inputs.

## Details

The book value is interpreted prospectively: at a valuation time that
lies on the coupon grid, it equals the present value at that time of all
remaining future coupons and the final redemption amount, discounted at
the bond's yield basis.

This function interprets `t` as a time immediately after any coupon due
at that date has been paid. Therefore:

- at `t = 0`, the book value equals the bond price,

- at `t = n`, the book value is 0.

Assumptions:

- Coupons are paid in arrears at regular intervals.

- `n * k` must be an integer.

- Each `t * k` must be an integer.

- Stub periods are not supported.

- Valuation is performed at coupon dates; no accrued interest is
  included.

Yield input conventions:

- If `y_effective_per_period` is supplied, it takes precedence over `y`,
  `y_type`, and `y_m`, and is interpreted as the effective yield per
  coupon period.

- Otherwise, `y`, `y_type`, and `y_m` define an annual yield
  specification, which is converted first to annual effective yield and
  then to effective yield per coupon period.

This function follows the compact bond notation used in `tidyactuarial`:
`P` is price, `face` is the face value, `c` is the annual coupon rate,
`n` is maturity, `k` is coupon frequency, `y` is the yield, `R` is
redemption value, and `t` is valuation time.

Let the valuation time correspond to coupon period \\s\\, with total
maturity period count \\N\\. If the remaining future cash flows are
\\C\_{s+1}, \dots, C_N\\, and \\i_p\\ is the effective yield per coupon
period, then the book value at time \\s\\ is \$\$BV_s =
\sum\_{r=s+1}^{N} C_r (1+i_p)^{-(r-s)}.\$\$

This is the prospective book value on the bond's yield basis.

## See also

[`bond_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_cash_flows`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md)

Other bonds:
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
# Book value at time 0 equals price
bond_book_value(
  face = 100,
  c = 0.08,
  n = 5,
  t = 0,
  k = 2,
  y = 0.06,
  y_type = "effective"
)
#> [1] 108.9228

# Book value at several coupon dates
bond_book_value(
  face = 100,
  c = 0.08,
  n = 5,
  t = c(0, 1, 2, 3, 4, 5),
  k = 1,
  y = 0.06,
  y_type = "effective"
)
#> [1] 108.4247 106.9302 105.3460 103.6668 101.8868   0.0000

# Tidy output
bond_book_value(
  face = 100,
  c = 0.08,
  n = 5,
  t = c(0, 1, 2, 3, 4, 5),
  k = 1,
  y = 0.06,
  y_type = "effective",
  tidy = TRUE
)
#> # A tibble: 6 × 10
#>       t valuation_period book_value yield_per_period yield_effective_annual
#>   <dbl>            <int>      <dbl>            <dbl>                  <dbl>
#> 1     0                0       108.           0.0600                   0.06
#> 2     1                1       107.           0.0600                   0.06
#> 3     2                2       105.           0.0600                   0.06
#> 4     3                3       104.           0.0600                   0.06
#> 5     4                4       102.           0.0600                   0.06
#> 6     5                5         0            0.0600                   0.06
#> # ℹ 5 more variables: k <int>, face <dbl>, c <dbl>, n <dbl>, R <dbl>

# Yield given directly per coupon period
bond_book_value(
  face = 1000,
  c = 0.05,
  n = 10,
  t = c(0, 2, 4, 6),
  k = 2,
  y_effective_per_period = 0.03
)
#> [1] 925.6126 937.1945 950.2300 964.9015
```
