# World mortality sample, 2023

A compact international sample of period life tables for selected
countries in 2023. The dataset is intended for recent and simple
examples involving central death rates, one-year death probabilities,
survival probabilities, and life-table calculations.

## Usage

``` r
mortality_world_sample_2023
```

## Format

A tibble with 3,939 rows and 13 variables:

- country:

  Country name.

- country_code:

  Numeric ISO country code.

- continent:

  Continent.

- region:

  Geographic region.

- year:

  Calendar year.

- sex:

  Sex category: `"male"`, `"female"`, or `"both"`.

- x:

  Integer actuarial age, from 0 to 100.

- mx:

  Central death rate at age `x`.

- qx:

  One-year death probability between ages `x` and `x + 1`.

- px:

  One-year survival probability between ages `x` and `x + 1`.

- lx:

  Number of survivors at exact age `x`, based on `l0 = 100000`.

- dx:

  Expected number of deaths between ages `x` and `x + 1`.

- source:

  Data source.

## Source

United Nations, World Population Prospects 2024.

## Details

The dataset is derived from central death rates `mx`. Death
probabilities `qx` were computed using the annual approximation \$\$ q_x
= \frac{m_x}{1 + (1 - a_x)m_x}, \$\$ with \\a_x = 0.5\\. The last
available age is closed by setting `qx = 1`. Survivors `lx` and expected
deaths `dx` are then reconstructed recursively from `l0 = 100000`.

This dataset is a selected-country sample, not a complete world
mortality database.

## Examples

``` r
data(mortality_world_sample_2023)

mortality_world_sample_2023 |>
  dplyr::filter(country == "Colombia", sex == "both") |>
  dplyr::select(x, mx, qx, px, lx, dx)
#> # A tibble: 101 × 6
#>        x       mx       qx    px      lx    dx
#>    <int>    <dbl>    <dbl> <dbl>   <dbl> <dbl>
#>  1     0 0.00992  0.00987  0.990 100000  987. 
#>  2     1 0.000720 0.000719 0.999  99013.  71.2
#>  3     2 0.000573 0.000573 0.999  98942.  56.7
#>  4     3 0.000460 0.000460 1.000  98885.  45.5
#>  5     4 0.000375 0.000375 1.000  98840.  37.0
#>  6     5 0.000311 0.000311 1.000  98802.  30.7
#>  7     6 0.000266 0.000266 1.000  98772.  26.2
#>  8     7 0.000237 0.000237 1.000  98746.  23.4
#>  9     8 0.000223 0.000223 1.000  98722.  22.0
#> 10     9 0.000222 0.000222 1.000  98700.  21.9
#> # ℹ 91 more rows
```
