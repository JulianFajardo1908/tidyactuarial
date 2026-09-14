# Actuarial present value of a two-life annuity

Computes the actuarial present value of a discrete annuity contingent on
two independent lives, using compact actuarial notation.

## Usage

``` r
annuity_xy(
  lt,
  x = NULL,
  y = NULL,
  i = NULL,
  i_type = "effective",
  m = 1L,
  status = c("joint", "last"),
  benefit = NULL,
  n = Inf,
  h = 0L,
  k = 1L,
  timing = c("immediate", "due"),
  woolhouse = c("none", "first", "second"),
  frac,
  tidy = FALSE,
  ...
)
```

## Arguments

- lt:

  A life table, a list of two life tables `list(lt_x, lt_y)`, or a
  `tidyact_life_contract` object created by
  [`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md).
  Each life table must contain columns `x` and `lx`.

- x:

  Integer actuarial age for the first life.

- y:

  Integer actuarial age for the second life.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

- status:

  Character string. Use `"joint"` for joint-life payments while both
  lives are alive, or `"last"` for last-survivor payments while at least
  one life is alive. Ignored when `benefit` is supplied.

- benefit:

  Optional list with numeric scalar weights `both`, `x_only`, and
  `y_only`. These weights define the payment rate according to the
  survival state of the two lives.

- n:

  Term in years. Use `Inf` for the maximum horizon allowed by the life
  tables. For exact k-thly valuation (`woolhouse = "none"`), fractional
  terms are allowed when `n * k` is an integer. Woolhouse approximations
  require an integer number of years.

- h:

  Nonnegative integer deferment period in years.

- k:

  Positive integer. Number of payments per year. The annuity is
  normalized to an annual payment rate of 1, so each individual payment
  has amount `1 / k`.

- timing:

  Payment timing. Use `"immediate"` or `"due"`.

- woolhouse:

  Woolhouse approximation for `k > 1`: `"none"`, `"first"`, or
  `"second"`.

- frac:

  Fractional-age assumption for exact k-thly computation: `"UDD"`,
  `"CF"`, `"CML"`, or `"Balducci"`.

- tidy:

  Logical scalar. If `FALSE`, returns a numeric APV. If `TRUE`, returns
  a one-row tibble.

- ...:

  Transitional compatibility for older calls using `mortality_table`,
  `age_x`, `age_y`, `rate`, `rate_type`, `cohort`, `term_years`,
  `deferment_years`, `payments_per_year`, and `output`.

## Value

If `tidy = FALSE`, a numeric scalar.

If `tidy = TRUE`, a one-row tibble with input values, standardized
interest rate, term used, and APV.

## Details

The function supports joint-life, last-survivor, and state-based
reversionary-style payments. The life table input may be either one
common table for both lives or a list of two life tables, one for each
life.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `lt` is the life table input, `x` and `y` are the two
actuarial ages, `i` is the interest-rate input, `i_type` is the
interest-rate type, `m` is the conversion frequency for nominal rates,
`n` is the term, `h` is the deferment period, and `k` is the payment
frequency.

The function assumes independent future lifetimes. For state-based
benefits, the expected payment at time \\t\\ is \$\$
b\_{\text{both}}\\{}\_tp_x{}\_tp_y + b\_{x\text{
only}}\\{}\_tp_x(1-{}\_tp_y) + b\_{y\text{ only}}\\{}\_tp_y(1-{}\_tp_x).
\$\$

When `benefit = NULL`, `status = "joint"` uses
`benefit = list(both = 1, x_only = 0, y_only = 0)`, while
`status = "last"` uses
`benefit = list(both = 1, x_only = 1, y_only = 1)`.

For `k`-thly payments, the function values a payment rate of 1 per year,
so each payment has size \\1/k\\. For exact valuation, a fractional term
is admissible whenever it contains a whole number of payments: \$\$nk
\in \mathbb{N}.\$\$

Woolhouse approximations are applied only to the standard joint-life and
last-survivor statuses. For a deferred annuity, the Woolhouse endpoint
corrections are multiplied by the issue-date value of the status at the
beginning of the payment period. This preserves the deferment factor
\\v^h\\{}\_hp\_{xy}\\ or its last-survivor analogue.

## See also

[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`insurance_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`premium_xy`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`t_pxy`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md),
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`premium_gross()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md),
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md),
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)

## Examples

``` r
lt <- data.frame(
  x  = 60:66,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000, 86000)
)

# Joint-life annuity-due
annuity_xy(
  lt = lt,
  x = 60,
  y = 62,
  i = 0.05,
  status = "joint",
  timing = "due"
)
#> [1] 3.52856

# Last-survivor annuity-due
annuity_xy(
  lt = lt,
  x = 60,
  y = 62,
  i = 0.05,
  status = "last",
  timing = "due"
)
#> [1] NA

# Different life tables for the two lives
lt_m <- lt
lt_f <- data.frame(
  x  = 60:66,
  lx = c(100000, 99200, 98100, 96500, 94500, 92000, 89000)
)

annuity_xy(
  lt = list(lt_m, lt_f),
  x = 60,
  y = 62,
  i = 0.05,
  status = "joint",
  timing = "due"
)
#> [1] 3.553047

# State-based reversionary-style payments
annuity_xy(
  lt = list(lt_m, lt_f),
  x = 60,
  y = 62,
  i = 0.05,
  benefit = list(both = 0, x_only = 1, y_only = 0),
  timing = "due"
)
#> [1] NA
```
