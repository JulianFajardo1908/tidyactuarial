# Actuarial present value of a multi-life annuity (up to 3 independent lives)

Computes the APV of a discrete annuity contingent on multiple
independent lives using compact actuarial notation.

## Usage

``` r
annuity_multi(
  lt,
  ages,
  i,
  i_type = "effective",
  m = 1L,
  n = NULL,
  h = 0L,
  k = 1L,
  annuity = c("cohort", "reversionary"),
  cohort = c("first", "last"),
  alpha = NULL,
  timing = c("immediate", "due"),
  woolhouse = c("none", "first", "second")
)
```

## Arguments

- lt:

  A life table object (data frame or tibble) with column `x` and at
  least one of `lx`, `px`, or `qx`. For different mortality assumptions
  by life, pass a list of life tables of the same length as `ages`, for
  example `list(lt_male, lt_female)`.

- ages:

  Integer vector of actuarial ages for the lives at issue. Must have
  length 1, 2, or 3.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`. In `tidyactuarial`, `m`
  is reserved for interest conversion frequency, not deferment.

- n:

  Integer term in years after deferment. If `NULL`, runs to the end of
  the available table horizon, conservatively based on the smallest
  omega across life tables.

- h:

  Integer deferment period in years.

- k:

  Integer payments per year. If `k > 1`, Woolhouse approximations may be
  applied.

- annuity:

  Type of annuity logic: `"cohort"` uses the status defined in `cohort`;
  `"reversionary"` uses the \\\alpha\\ fractional reduction.

- cohort:

  Survival status: `"first"` for joint-life, paying while all lives are
  alive, or `"last"` for last-survivor, paying while at least one life
  remains alive. Used only when `annuity = "cohort"`.

- alpha:

  Reversionary fraction, typically \\0 \le \alpha \le 1\\. Used only
  when `annuity = "reversionary"`. Note: `alpha = 0` matches joint-life;
  `alpha = 1` matches last-survivor.

- timing:

  `"immediate"` or `"due"`.

- woolhouse:

  `"none"`, `"first"`, or `"second"`.

## Value

A single numeric value representing the APV.

## Details

This implementation supports up to three lives, which covers the most
common practical multi-life arrangements.

Supports status-based annuities (joint-life / last-survivor) and a
joint-and-survivor style annuity (`"reversionary"`) that pays 1 while
all lives are alive and then pays a fraction \\\alpha\\ while at least
one life remains alive.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` is the interest rate, `i_type` is the interest-rate
type, `m` is the conversion frequency for nominal rates, `n` is the
term, `h` is the deferment period, and `k` is the payment frequency.

Under the assumption of independent future lifetimes, the survival
probability for the status is calculated as:

- **Joint-life (first-death):** \\{}\_t p\_{x_1 x_2 \dots x_n} =
  \prod\_{j=1}^n {}\_t p\_{x_j}\\

- **Last-survivor:** \\{}\_t p\_{\overline{x_1 x_2 \dots x_n}} = 1 -
  \prod\_{j=1}^n (1 - {}\_t p\_{x_j})\\

For `annuity = "reversionary"`, the APV is a weighted combination of the
two statuses: \$\$APV = APV(\text{joint-life}) + \alpha
\[APV(\text{last-survivor}) - APV(\text{joint-life})\].\$\$

## See also

[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md)
for single-life annuities,
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
for survival probabilities.

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
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
  x = 60:90,
  lx = seq(100000, 0, length.out = 31)
)

annuity_multi(
  lt = lt,
  ages = c(60, 62),
  i = 0.05,
  n = 5,
  cohort = "first",
  timing = "due"
)
#> [1] 3.979153

annuity_multi(
  lt = lt,
  ages = c(60, 62),
  i = 0.05,
  n = 5,
  cohort = "last",
  timing = "due"
)
#> [1] 4.515572
```
