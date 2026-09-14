# Actuarial present value of a life annuity

Computes the actuarial present value of a discrete life annuity using
compact actuarial notation.

## Usage

``` r
annuity_x(
  lt,
  x,
  i,
  i_type = "effective",
  m = 1L,
  n = NULL,
  h = 0L,
  k = 1L,
  timing = c("immediate", "due"),
  woolhouse = c("none", "first", "second"),
  frac = NULL,
  tidy = FALSE
)
```

## Arguments

- lt:

  A life table as produced by
  [`lifetable`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md),
  or a `tidyact_life_contract` object created by
  [`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md).
  A life table must contain columns `x` and `lx`.

- x:

  Integer actuarial age. Optional when `lt` is a single-life
  `tidyact_life_contract`.

- i:

  Numeric scalar. Annual interest-rate input. Optional when `lt` is a
  single-life `tidyact_life_contract`.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal interest rates.
  Ignored for `i_type = "effective"` and `i_type = "force"`. In
  `tidyactuarial`, `m` is reserved for interest conversion frequency,
  not deferment.

- n:

  Numeric term in years. Use `NULL` or `Inf` for a whole-life annuity.
  For exact k-thly valuation (`woolhouse = "none"`), fractional terms
  are allowed when `n * k` is an integer. Woolhouse approximations
  require an integer number of years.

- h:

  Integer deferment period in years.

- k:

  Positive integer. Number of annuity payments per year. For example,
  use `k = 12` for monthly payments. The annuity is normalized to an
  annual payment rate of 1, so each individual payment has amount
  `1 / k`.

- timing:

  Character string. Either `"immediate"` for payments at the end of each
  payment period or `"due"` for payments at the beginning of each
  payment period.

- woolhouse:

  Character string. For `k > 1`, use `"none"` for exact fractional-age
  computation, `"first"` for the first-order Woolhouse approximation, or
  `"second"` for the second-order Woolhouse approximation.

- frac:

  Character string. Fractional-age assumption used when `k > 1` and
  `woolhouse = "none"`. Allowed values are `"UDD"`, `"CF"`, `"CML"`, and
  `"Balducci"`. If `NULL`, the `frac` attribute of `lt` is used when
  available; otherwise `"UDD"` is used.

- tidy:

  Logical. If `FALSE`, returns a numeric APV. If `TRUE`, returns a
  one-row tibble with intermediate quantities.

## Value

If `tidy = FALSE`, a numeric scalar containing the actuarial present
value.

If `tidy = TRUE`, a one-row tibble with the main input values,
equivalent interest rate, deferment factor, pure endowment factor, and
APV.

## Details

The function supports:

- whole-life annuities,

- temporary annuities,

- integer deferment,

- annual or k-thly payments,

- exact fractional survival for k-thly payments,

- first- and second-order Woolhouse approximations.

This function follows the compact actuarial notation used throughout
`tidyactuarial`:

- `lt`: life table;

- `x`: actuarial age;

- `i`: interest rate;

- `i_type`: interest-rate type;

- `m`: interest conversion frequency;

- `n`: annuity term;

- `h`: deferment period;

- `k`: payment frequency.

For annual annuities-due, \$\$\ddot{a}\_{x:\overline{n}\|} =
\sum\_{j=0}^{n-1} v^j\\{}\_jp_x.\$\$

For annual annuities-immediate, \$\$a\_{x:\overline{n}\|} =
\sum\_{j=1}^{n} v^j\\{}\_jp_x.\$\$

Deferment is handled through \$\$v^h\\{}\_hp_x,\$\$ where \\h\\ is the
deferment period.

For k-thly payments with `woolhouse = "none"`, fractional survival is
computed under the selected fractional-age assumption. The payment
stream is normalized to an annual payment rate of 1:
\$\$\ddot{a}\_{x:\overline{n}\|}^{(k)} = \frac{1}{k}\sum\_{j=0}^{kn-1}
v^{j/k}\\{}\_{j/k}p_x.\$\$ Consequently, each k-thly installment has
amount \\1/k\\. This normalization is essential when the function is
used as the premium annuity in the equivalence principle: the resulting
premium is annualized, and the amount paid at each installment is the
annualized premium divided by \\k\\.

## See also

[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`reserve_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`t_px`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md),
[`t_Ex`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_Ex.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
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
  x  = 60:65,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000)
)

# Annual annuity-immediate
annuity_x(
  lt = lt,
  x = 60,
  i = 0.06,
  timing = "immediate"
)
#> [1] 4.012725

# Annual annuity-due
annuity_x(
  lt = lt,
  x = 60,
  i = 0.06,
  timing = "due"
)
#> [1] 5.012725

# Temporary annuity
annuity_x(
  lt = lt,
  x = 60,
  i = 0.06,
  n = 3,
  timing = "due"
)
#> [1] 2.801709

# Deferred annuity
annuity_x(
  lt = lt,
  x = 60,
  i = 0.06,
  h = 2,
  timing = "due"
)
#> [1] 3.078762

# Tidy output
annuity_x(
  lt = lt,
  x = 60,
  i = 0.06,
  n = 3,
  timing = "due",
  tidy = TRUE
)
#> # A tibble: 1 × 17
#>       x     i i_type        m i_effective     n n_used     h   x_h     k timing
#>   <int> <dbl> <chr>     <int>       <dbl> <dbl>  <dbl> <int> <int> <int> <chr> 
#> 1    60  0.06 effective     1        0.06     3      3     0    60     1 due   
#> # ℹ 6 more variables: woolhouse <chr>, frac <chr>, deferment_factor <dbl>,
#> #   pure_endowment_factor <dbl>, annuity_value_at_start <dbl>, apv <dbl>

# Pipe workflow with a life contract
life_contract(lt = lt, lives = "single", x = 60, i = 0.06) |>
  annuity_x(n = 3, timing = "due")
#> [1] 2.801709
```
