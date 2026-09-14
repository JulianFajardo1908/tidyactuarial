# Internal helper: simulate future lifetimes from lx

Internal helper: simulate future lifetimes from lx

## Usage

``` r
.simulate_lifetime_inverse_lx(lt, x, n, n_sim, seed = NULL, frac = NULL)
```

## Arguments

- lt:

  Life table with columns `x` and `lx`.

- x:

  Integer age.

- n:

  Positive integer horizon or `Inf`.

- n_sim:

  Positive integer number of simulations.

- seed:

  Optional seed.

- frac:

  Optional fractional-age assumption. If `NULL`, only the curtate
  lifetime is generated.

## Value

A tibble with simulated curtate and complete future lifetimes.
