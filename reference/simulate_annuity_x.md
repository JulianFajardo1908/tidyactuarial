# Monte Carlo simulation of a life annuity

Simulates present values of a discrete single-life annuity from a life
table. Annual and subannual payments are supported. For subannual
payments, a complete future lifetime is generated inside the year of
death under a fractional-age assumption.

## Usage

``` r
simulate_annuity_x(
  lt,
  x = NULL,
  i = NULL,
  i_type = NULL,
  m = NULL,
  n = Inf,
  k = 1L,
  timing = c("due", "immediate"),
  payment = 1,
  frac = c("udd", "cml", "balducci"),
  method = c("inverse"),
  n_sim = 10000L,
  seed = NULL,
  output = c("simulations", "summary"),
  ...
)
```

## Arguments

- lt:

  A life table or a `tidyact_life_contract`. A life table must contain
  columns `x` and `lx`.

- x:

  Integer actuarial age. Optional for a life contract.

- i:

  Numeric scalar interest-rate input.

- i_type:

  Interest-rate convention.

- m:

  Positive integer nominal conversion frequency.

- n:

  Positive integer term in years, or `Inf` for whole life.

- k:

  Positive integer number of annuity payments per year.

- timing:

  Payment timing: `"due"` or `"immediate"`.

- payment:

  Nonnegative amount paid at each payment date. To simulate an
  annualized payment rate of 1 with `k` payments per year, use
  `payment = 1 / k`.

- frac:

  Fractional-age assumption used to simulate the complete lifetime
  within the year of death: `"udd"`, `"cml"`, or `"balducci"`.

- method:

  Simulation method. Currently only `"inverse"`.

- n_sim:

  Positive integer number of simulations.

- seed:

  Optional nonnegative integer seed.

- output:

  `"simulations"` or `"summary"`.

- ...:

  Transitional compatibility for `mortality_table`, `age`, `rate`,
  `rate_type`, `term_years`, and `payments_per_year`.

## Value

A tibble with one row per simulation, or a summary from
[`summary_mc`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md).
Simulation output includes `payment_per_payment`, `payment_annualized`,
`Kx`, `Tx`, `n_payments`, `present_value`, and `pv_annuity`.

## Details

The amount `payment` is a per-payment amount. If \\N\\ payments are made
at times \\t_j\\, the simulated present value is \$\$ \sum\_{j=1}^{N}
\mathrm{payment}\\v^{t_j}. \$\$

For `k > 1`, the curtate lifetime alone is insufficient because payments
may occur during the year of death. The function therefore simulates a
complete lifetime \\T_x=K_x+S\\ under `frac`.

## See also

Other simulation:
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
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
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)

## Examples

``` r
lt <- data.frame(
  x = 60:66,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000, 0)
)

simulate_annuity_x(
  lt = lt,
  x = 60,
  i = 0.05,
  n_sim = 25,
  seed = 123
)
#> # A tibble: 25 × 31
#>    sim_id simulation_id contract_type     x   age     n term_years     k
#>     <int>         <int> <chr>         <int> <int> <dbl>      <dbl> <int>
#>  1      1             1 annuity          60    60   Inf        Inf     1
#>  2      2             2 annuity          60    60   Inf        Inf     1
#>  3      3             3 annuity          60    60   Inf        Inf     1
#>  4      4             4 annuity          60    60   Inf        Inf     1
#>  5      5             5 annuity          60    60   Inf        Inf     1
#>  6      6             6 annuity          60    60   Inf        Inf     1
#>  7      7             7 annuity          60    60   Inf        Inf     1
#>  8      8             8 annuity          60    60   Inf        Inf     1
#>  9      9             9 annuity          60    60   Inf        Inf     1
#> 10     10            10 annuity          60    60   Inf        Inf     1
#> # ℹ 15 more rows
#> # ℹ 23 more variables: payments_per_year <int>, timing <chr>, payment <dbl>,
#> #   payment_per_payment <dbl>, payment_annualized <dbl>, frac <chr>, i <dbl>,
#> #   rate <dbl>, i_type <chr>, rate_type <chr>, m <int>, i_effective <dbl>,
#> #   Kx <int>, curtate_lifetime <int>, Tx <dbl>, complete_lifetime <dbl>,
#> #   death_age <int>, died_within_horizon <lgl>, n_payments <int>,
#> #   first_payment_time <dbl>, last_payment_time <dbl>, present_value <dbl>, …

simulate_annuity_x(
  lt = lt,
  x = 60,
  i = 0.05,
  n = 5,
  k = 12,
  payment = 1 / 12,
  frac = "udd",
  n_sim = 25,
  seed = 123
)
#> # A tibble: 25 × 31
#>    sim_id simulation_id contract_type     x   age     n term_years     k
#>     <int>         <int> <chr>         <int> <int> <int>      <int> <int>
#>  1      1             1 annuity          60    60     5          5    12
#>  2      2             2 annuity          60    60     5          5    12
#>  3      3             3 annuity          60    60     5          5    12
#>  4      4             4 annuity          60    60     5          5    12
#>  5      5             5 annuity          60    60     5          5    12
#>  6      6             6 annuity          60    60     5          5    12
#>  7      7             7 annuity          60    60     5          5    12
#>  8      8             8 annuity          60    60     5          5    12
#>  9      9             9 annuity          60    60     5          5    12
#> 10     10            10 annuity          60    60     5          5    12
#> # ℹ 15 more rows
#> # ℹ 23 more variables: payments_per_year <int>, timing <chr>, payment <dbl>,
#> #   payment_per_payment <dbl>, payment_annualized <dbl>, frac <chr>, i <dbl>,
#> #   rate <dbl>, i_type <chr>, rate_type <chr>, m <int>, i_effective <dbl>,
#> #   Kx <int>, curtate_lifetime <int>, Tx <dbl>, complete_lifetime <dbl>,
#> #   death_age <dbl>, died_within_horizon <lgl>, n_payments <int>,
#> #   first_payment_time <dbl>, last_payment_time <dbl>, present_value <dbl>, …
```
