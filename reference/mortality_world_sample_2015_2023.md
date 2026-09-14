# World mortality sample panel, 2015–2023

A compact international panel of period life tables for selected
countries from 2015 to 2023. The dataset is intended for comparative
mortality examples, especially before, during, and after the COVID-19
pandemic period.

## Usage

``` r
mortality_world_sample_2015_2023
```

## Format

A tibble with 35,451 rows and 14 variables:

- country:

  Country name.

- country_code:

  Numeric ISO country code.

- continent:

  Continent.

- region:

  Geographic region.

- year:

  Calendar year, from 2015 to 2023.

- pandemic_period:

  Period label: `"pre_pandemic"`, `"pre_pandemic_reference"`,
  `"pandemic"`, `"transition"`, or `"post_pandemic"`.

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

This dataset is a selected-country panel, not a complete world mortality
database.

## Examples

``` r
data(mortality_world_sample_2015_2023)

mortality_world_sample_2015_2023 |>
  dplyr::filter(country == "Colombia", sex == "both", x == 70) |>
  dplyr::select(year, pandemic_period, qx, lx)
#> # A tibble: 9 × 4
#>    year pandemic_period            qx     lx
#>   <int> <chr>                   <dbl>  <dbl>
#> 1  2015 pre_pandemic           0.0208 77051.
#> 2  2016 pre_pandemic           0.0202 77249.
#> 3  2017 pre_pandemic           0.0198 77413.
#> 4  2018 pre_pandemic           0.0196 77633.
#> 5  2019 pre_pandemic_reference 0.0193 78056.
#> 6  2020 pandemic               0.0261 73182.
#> 7  2021 pandemic               0.0309 67670.
#> 8  2022 transition             0.0206 77211.
#> 9  2023 post_pandemic          0.0180 79845.
```
