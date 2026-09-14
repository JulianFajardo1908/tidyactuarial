# Compute multiple-life simulated status variables

Combines simulated future lifetimes for several lives into one simulated
multiple-life status. A joint-life status terminates at the first death,
whereas a last-survivor status terminates at the last death.

## Usage

``` r
mc_multilife_status(
  data,
  status = c("joint", "last_survivor"),
  col_sim = "sim_id",
  col_life = "life_id",
  col_K = "Kx",
  col_T = "Tx",
  tol = 1e-10
)
```

## Arguments

- data:

  A data frame or tibble, typically returned by
  [`simulate_lifetimes`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md).

- status:

  Multiple-life status. Canonical values are `"joint"` and
  `"last_survivor"`. The aliases `"joint_life"`, `"last"`, and
  `"last_survivor_life"` are accepted.

- col_sim:

  Character scalar naming the simulation identifier column.

- col_life:

  Character scalar naming the life identifier column. The default is
  `"life_id"`. Supply `NULL` only when no life identifier exists; in
  that case the function can validate equal row counts across
  simulations but cannot detect duplicated or substituted lives.

- col_K:

  Character scalar naming the curtate future lifetime column.

- col_T:

  Character scalar naming the complete future lifetime column.

- tol:

  Nonnegative numeric tolerance used when checking that each complete
  future lifetime is compatible with its curtate lifetime.

## Value

A tibble with one row per simulation and:

- sim_id:

  Standard simulation identifier.

- sim:

  Compatibility alias for the simulation identifier.

- K_status:

  Curtate future lifetime of the status.

- T_status:

  Complete future lifetime of the status.

- n_lives:

  Number of lives represented in each simulation.

- status:

  Canonical status: `"joint"` or `"last_survivor"`.

If `col_sim` is neither `"sim_id"` nor `"sim"`, that original identifier
column is also retained.

## Details

For simulated complete future lifetimes \\T_1,\ldots,T_r\\, the
multiple-life complete future lifetime is \$\$
T\_{\mathrm{joint}}=\min(T_1,\ldots,T_r) \$\$ for the joint-life status
and \$\$ T\_{\mathrm{last}}=\max(T_1,\ldots,T_r) \$\$ for the
last-survivor status.

The corresponding curtate future lifetime is obtained with the same
minimum or maximum operation on \\K_1,\ldots,K_r\\. Because the function
validates \\K_j \le T_j \< K_j+1\\, the returned values satisfy the same
curtate-complete relationship.

When `col_life` is available, every simulation must contain exactly one
row for every life and the same set of lives must appear in every
simulation. This prevents a missing or duplicated life from being
silently treated as a different multiple-life contract.

## See also

[`simulate_lifetimes`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
simulated <- tibble::tibble(
  sim_id = rep(1:2, each = 2),
  life_id = rep(c("x", "y"), times = 2),
  Kx = c(2, 5, 4, 1),
  Tx = c(2.4, 5.2, 4.5, 1.3)
)

simulated |>
  mc_multilife_status(status = "joint")
#> # A tibble: 2 × 6
#>   sim_id   sim K_status T_status n_lives status
#>    <int> <int>    <int>    <dbl>   <int> <chr> 
#> 1      1     1        2      2.4       2 joint 
#> 2      2     2        1      1.3       2 joint 

simulated |>
  mc_multilife_status(status = "last_survivor")
#> # A tibble: 2 × 6
#>   sim_id   sim K_status T_status n_lives status       
#>    <int> <int>    <int>    <dbl>   <int> <chr>        
#> 1      1     1        5      5.2       2 last_survivor
#> 2      2     2        4      4.5       2 last_survivor
```
