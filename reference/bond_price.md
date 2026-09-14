# Price of a level coupon bond from its yield

Computes the dirty price of a level coupon bond at time 0 from its
yield, using compact actuarial notation.

## Usage

``` r
bond_price(
  face,
  c,
  n,
  k = 1L,
  y_effective_per_period = NULL,
  y = NULL,
  y_type = "effective",
  y_m = 1L,
  R = NULL,
  tol = 1e-10,
  check = TRUE
)
```

## Arguments

- face:

  Numeric scalar. Face value of the bond.

- c:

  Numeric scalar. Annual coupon rate as a proportion.

- n:

  Numeric scalar. Time to maturity in years.

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

  Numeric scalar. Redemption value at maturity. If `NULL`, defaults to
  `face`.

- tol:

  Numeric scalar. Tolerance used when checking alignment of maturity
  with coupon periods.

- check:

  Logical scalar. If `TRUE`, performs basic input validation.

## Value

Numeric scalar: dirty price of the bond at time 0.

## Details

Assumptions:

- Coupons are paid in arrears at regular intervals.

- `n * k` must be an integer.

- Stub periods are not supported.

- No accrued interest is considered; the price is evaluated at a coupon
  date.

The yield may be supplied in either of two ways:

- directly as an effective yield per coupon period through
  `y_effective_per_period`, or

- as an annual rate specification through `y`, `y_type`, and `y_m`.

If an annual rate specification is supplied, it is first converted to
the equivalent annual effective yield and then to the effective yield
per coupon period.

This function follows the compact bond notation used in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `n` is the time
to maturity, `k` is the coupon frequency, `y` is the annual yield input,
and `R` is the redemption value.

Let \\j\\ be the effective yield per coupon period, \\k\\ the number of
coupon payments per year, and let \\N = nk\\ be the total number of
coupon periods. With coupon per period \\C = face \cdot c/k\\ and
discount factor \\v = 1/(1+j)\\, the price is: \$\$P = \sum\_{r=1}^{N}
C_r v^r,\$\$ where the sum runs over all coupon and redemption cash
flows indexed by coupon period \\r\\.

## See also

[`bond_ytm`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`bond_cash_flows`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md),
[`bond_duration`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_convexity`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_book_value`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md)

Other bonds:
[`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md),
[`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md),
[`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md),
[`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md),
[`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)

## Examples

``` r
# 5-year annual coupon bond, yield given as annual effective
bond_price(
  face = 100,
  c = 0.08,
  n = 5,
  k = 1,
  y = 0.06,
  y_type = "effective"
)
#> [1] 108.4247

# 10-year semiannual bond, yield given directly per coupon period
bond_price(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  y_effective_per_period = 0.03
)
#> [1] 925.6126

# Semiannual coupons, nominal annual yield convertible quarterly
bond_price(
  face = 100,
  c = 0.08,
  n = 5,
  k = 2,
  y = 0.06,
  y_type = "nominal_interest",
  y_m = 4
)
#> [1] 108.3287
```
