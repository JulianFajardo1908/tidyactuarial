# Simulate future lifetimes for multiple lives

Simulates independent curtate and complete future lifetimes for several
initial ages from one life table. The function uses
[`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md)
as its single-life simulation engine so that age validation, truncation
treatment, fractional-age assumptions, and random-number conventions
remain consistent across the Monte Carlo module.

## Usage

``` r
simulate_lifetimes(
  data,
  x,
  n_sim = 1000L,
  frac = c("udd", "cml", "balducci", "constant", "cfm", "constant_force"),
  method = c("inverse", "multinomial", "antithetic"),
  seed = NULL,
  truncation = c("conditional", "error"),
  tol = 1e-10
)
```

## Arguments

- data:

  A data frame or tibble containing a life table.

- x:

  Nonempty numeric vector of nonnegative integer initial ages. Each
  position represents one life; repeated ages are allowed.

- n_sim:

  Positive integer number of simulations per life.

- frac:

  Fractional-age assumption. Canonical values are `"udd"`, `"cml"`, and
  `"balducci"`. The historical values `"constant"`, `"cfm"`, and
  `"constant_force"` are accepted as aliases for `"cml"`.

- method:

  Simulation method passed to
  [`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md):
  `"inverse"`, `"multinomial"`, or `"antithetic"`.

- seed:

  Optional nonnegative integer seed. When supplied, one random stream is
  initialized for the complete multiple-life simulation and the caller's
  previous random-number state is restored afterward.

- truncation:

  Treatment of a mortality table that does not exhaust the lifetime
  distribution: `"conditional"` retains the historical conditional
  simulation with one warning, while `"error"` stops.

- tol:

  Nonnegative numeric tolerance used for age and mortality checks.

## Value

A tibble with one row per simulation and life. Standard columns include
`sim_id`, `simulation_id`, `life_id`, `x`, `Kx`, `curtate_lifetime`,
`Tx`, `complete_lifetime`, `death_age`, `method`, and `frac`.
Compatibility aliases `sim`, `life`, `K`, and `T` are retained.

## Details

The life table must contain an age column named `x`, `age`, or `Age`,
and at least one mortality basis among `qx`, `px`, or `lx`. The
precedence is `qx`, then `px`, then `lx`.

Unlike the previous implementation, invalid mortality values are not
silently replaced by zero and the last death probability is not forcibly
overwritten. Such repairs can materially change the simulated lifetime
distribution.

If `lx` is supplied, one-year death probabilities are derived as \$\$
q_y = 1 - \frac{l\_{y+1}}{l_y} \$\$ for ages with positive exposure. A
terminal zero in `lx` therefore generates the appropriate terminal
`qx = 1`. If the final available `lx` remains positive, the resulting
distribution is recognized as truncated and handled according to
`truncation`.

Conditional on the supplied life table, the simulated lives are
independent. A single seed is set once for the entire call; the seed is
not reset for each life, which avoids introducing artificial perfect
dependence between lives of the same age.

## See also

[`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`mc_multilife_status`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
lt <- tibble::tibble(
  x = 40:43,
  qx = c(0.10, 0.20, 0.30, 1)
)

simulate_lifetimes(
  data = lt,
  x = c(40, 41),
  n_sim = 25,
  frac = "udd",
  seed = 123
)
#> # A tibble: 50 × 19
#>    sim_id simulation_id life_id  life     x   age method  frac  fractional    Kx
#>     <int>         <int>   <int> <int> <int> <int> <chr>   <chr> <chr>      <int>
#>  1      1             1       1     1    40    40 inverse udd   udd            2
#>  2      2             2       1     1    40    40 inverse udd   udd            3
#>  3      3             3       1     1    40    40 inverse udd   udd            2
#>  4      4             4       1     1    40    40 inverse udd   udd            3
#>  5      5             5       1     1    40    40 inverse udd   udd            3
#>  6      6             6       1     1    40    40 inverse udd   udd            0
#>  7      7             7       1     1    40    40 inverse udd   udd            3
#>  8      8             8       1     1    40    40 inverse udd   udd            3
#>  9      9             9       1     1    40    40 inverse udd   udd            3
#> 10     10            10       1     1    40    40 inverse udd   udd            2
#> # ℹ 40 more rows
#> # ℹ 9 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, sim <int>, K <int>, T <dbl>
```
