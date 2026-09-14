# Simulate future lifetimes from a life table

Simulates curtate and, optionally, complete future lifetimes from a life
table containing one-year death probabilities.

## Usage

``` r
simulate_lifetime(
  lt,
  x,
  n_sim = 10000L,
  x_col = "x",
  qx_col = "qx",
  method = c("inverse", "multinomial", "antithetic"),
  frac = c("udd", "cml", "balducci", "none", "constant_force"),
  seed = NULL,
  include_distribution = FALSE,
  truncation = c("conditional", "error"),
  tol = 1e-10
)
```

## Arguments

- lt:

  A data frame or tibble containing the life table.

- x:

  Nonnegative integer initial actuarial age. The age must appear
  explicitly in the column selected by `x_col`.

- n_sim:

  Positive integer number of simulations.

- x_col:

  Character scalar naming the age column.

- qx_col:

  Character scalar naming the one-year death-probability column.

- method:

  Simulation method for the curtate future lifetime: `"inverse"`,
  `"multinomial"`, or `"antithetic"`.

- frac:

  Fractional-age assumption used inside the year of death: `"udd"`,
  `"cml"`, `"balducci"`, or `"none"`. The legacy value
  `"constant_force"` is accepted as an alias for `"cml"`.

- seed:

  Optional nonnegative integer seed. When supplied, the caller's
  random-number state is restored after simulation.

- include_distribution:

  Logical scalar. If `TRUE`, the probability distribution used for
  simulation is attached as a list-column.

- truncation:

  Treatment of a life table whose available death probabilities do not
  exhaust the lifetime distribution. With `"conditional"`, the
  historical behavior is retained and the probabilities are normalized
  conditional on death within the available ages, with a warning. With
  `"error"`, the simulation stops.

- tol:

  Nonnegative numeric tolerance used for age-grid and probability
  checks.

## Value

A tibble with one row per simulation and standardized columns including
`sim_id`, `Kx`, `curtate_lifetime`, `Tx`, `complete_lifetime`,
`death_age`, `method`, and `frac`. The logical column
`distribution_conditioned` indicates whether a truncated table was
normalized conditionally.

## Details

For a life aged \\x\\, the curtate future lifetime has probability mass
function \$\$ P(K_x=k)={}\_kp_xq\_{x+k}. \$\$ The selected life-table
ages must therefore start at \\x\\ and proceed in consecutive one-year
steps. Missing or duplicated ages are rejected because the survival
recursion would otherwise no longer represent \\{}\_kp_x\\.

Under UDD, the fractional part of \\T_x\\ is uniform conditional on the
year of death. Under CML, it follows the conditional constant-force
distribution. Under Balducci, it follows the corresponding conditional
Balducci distribution.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*. Second Edition. Society of
Actuaries.

## See also

[`simulate_lifetimes`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_premium`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_loss`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
lt <- tibble::tibble(
  x = 40:43,
  qx = c(0.10, 0.20, 0.30, 1)
)

lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    method = "inverse",
    frac = "udd",
    seed = 123
  )
#> # A tibble: 25 × 14
#>    sim_id simulation_id     x   age method  frac  fractional    Kx
#>     <int>         <int> <int> <int> <chr>   <chr> <chr>      <int>
#>  1      1             1    40    40 inverse udd   udd            2
#>  2      2             2    40    40 inverse udd   udd            3
#>  3      3             3    40    40 inverse udd   udd            2
#>  4      4             4    40    40 inverse udd   udd            3
#>  5      5             5    40    40 inverse udd   udd            3
#>  6      6             6    40    40 inverse udd   udd            0
#>  7      7             7    40    40 inverse udd   udd            3
#>  8      8             8    40    40 inverse udd   udd            3
#>  9      9             9    40    40 inverse udd   udd            3
#> 10     10            10    40    40 inverse udd   udd            2
#> # ℹ 15 more rows
#> # ℹ 6 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>

lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    method = "antithetic",
    frac = "cml",
    seed = 123
  )
#> # A tibble: 25 × 14
#>    sim_id simulation_id     x   age method     frac  fractional    Kx
#>     <int>         <int> <int> <int> <chr>      <chr> <chr>      <int>
#>  1      1             1    40    40 antithetic cml   cml            2
#>  2      2             2    40    40 antithetic cml   cml            3
#>  3      3             3    40    40 antithetic cml   cml            3
#>  4      4             4    40    40 antithetic cml   cml            1
#>  5      5             5    40    40 antithetic cml   cml            2
#>  6      6             6    40    40 antithetic cml   cml            3
#>  7      7             7    40    40 antithetic cml   cml            3
#>  8      8             8    40    40 antithetic cml   cml            1
#>  9      9             9    40    40 antithetic cml   cml            3
#> 10     10            10    40    40 antithetic cml   cml            0
#> # ℹ 15 more rows
#> # ℹ 6 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>
```
