# Monte Carlo simulation of a life insurance

Simulates present values of a discrete single-life insurance payable at
the end of the year of death, or at maturity for an endowment insurance.

## Usage

``` r
simulate_insurance_x(
  lt,
  x = NULL,
  i = NULL,
  i_type = NULL,
  m = NULL,
  type = c("whole", "term", "endowment"),
  n = Inf,
  benefit = 1,
  method = c("inverse"),
  n_sim = 10000L,
  seed = NULL,
  output = c("simulations", "summary"),
  ...
)
```

## Arguments

- lt:

  A life table or a `tidyact_life_contract`.

- x:

  Integer actuarial age.

- i:

  Numeric scalar interest-rate input.

- i_type:

  Interest-rate convention.

- m:

  Positive integer nominal conversion frequency.

- type:

  `"whole"`, `"term"`, or `"endowment"`.

- n:

  Positive integer term, or `Inf` for whole life.

- benefit:

  Nonnegative insurance benefit.

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
  `rate_type`, `insurance_type`, and `term_years`.

## Value

A tibble with one row per simulation, or a summary. Simulation output
includes `benefit_indicator`, `benefit_time`, `present_value`, and
`pv_benefit`.

## See also

Other simulation:
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md)

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
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md)

## Examples

``` r
lt <- data.frame(
  x = 60:66,
  lx = c(100000, 99000, 97500, 95500, 93000, 90000, 0)
)

simulate_insurance_x(
  lt = lt,
  x = 60,
  i = 0.05,
  type = "term",
  n = 5,
  benefit = 100000,
  n_sim = 25,
  seed = 123
)
#> # A tibble: 25 × 26
#>    sim_id simulation_id contract_type      x   age     n term_years type 
#>     <int>         <int> <chr>          <int> <int> <int>      <int> <chr>
#>  1      1             1 term_insurance    60    60     5          5 term 
#>  2      2             2 term_insurance    60    60     5          5 term 
#>  3      3             3 term_insurance    60    60     5          5 term 
#>  4      4             4 term_insurance    60    60     5          5 term 
#>  5      5             5 term_insurance    60    60     5          5 term 
#>  6      6             6 term_insurance    60    60     5          5 term 
#>  7      7             7 term_insurance    60    60     5          5 term 
#>  8      8             8 term_insurance    60    60     5          5 term 
#>  9      9             9 term_insurance    60    60     5          5 term 
#> 10     10            10 term_insurance    60    60     5          5 term 
#> # ℹ 15 more rows
#> # ℹ 18 more variables: insurance_type <chr>, benefit <dbl>, i <dbl>,
#> #   rate <dbl>, i_type <chr>, rate_type <chr>, m <int>, i_effective <dbl>,
#> #   Kx <int>, curtate_lifetime <int>, death_age <dbl>,
#> #   died_within_horizon <lgl>, covered <lgl>, benefit_indicator <dbl>,
#> #   payment_time <dbl>, benefit_time <dbl>, present_value <dbl>,
#> #   pv_benefit <dbl>
```
