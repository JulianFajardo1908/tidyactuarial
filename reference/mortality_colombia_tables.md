# Colombian mortality tables

A tidy collection of Colombian mortality tables for life-contingency
examples. The dataset includes regulatory and pedagogical mortality
tables used in Colombian actuarial applications.

## Usage

``` r
mortality_colombia_tables
```

## Format

A tibble with 12 variables:

- table_id:

  Mortality table identifier.

- sex:

  Sex category, typically `"male"` or `"female"`.

- x:

  Integer actuarial age.

- lx:

  Number of survivors at exact age `x`.

- dx:

  Expected number of deaths between ages `x` and `x + 1`.

- qx:

  One-year death probability between ages `x` and `x + 1`.

- px:

  One-year survival probability between ages `x` and `x + 1`.

- mu_x:

  Force of mortality at age `x`, when available.

- ex:

  Complete life expectancy at age `x`, when available.

- source:

  Source identifier or reference.

- qx_calc:

  Death probability recalculated from `lx` and `dx`, when available.

- qx_diff:

  Difference between reported `qx` and recalculated `qx`, when
  available.

## Source

Colombian mortality tables cleaned for tidyactuarial examples. Source
identifiers are provided in the `source` column.

## Details

The dataset is intended for actuarial examples involving Colombian
mortality tables, survival probabilities, life annuities, life insurance
present values, and validation of life-table calculations.

The variable names follow the compact actuarial notation used throughout
`tidyactuarial`: `x` denotes age, `lx` the number of lives, `dx` the
number of deaths, `qx` the one-year death probability, `px` the one-year
survival probability, `mu_x` the force of mortality, and `ex` the life
expectancy at age `x`.

The variables `qx_calc` and `qx_diff` are included as validation aids.
They allow users to compare reported death probabilities against
probabilities reconstructed from `lx` and `dx`.

Some tables may start at different initial ages, use different terminal
ages, or use different radix values. Users should filter the desired
table and sex before passing the data to life-contingency functions.

## Examples

``` r
data(mortality_colombia_tables)

head(mortality_colombia_tables)
#> # A tibble: 6 × 12
#>   table_id        sex       x    lx    dx    qx    px  mu_x    ex source qx_calc
#>   <chr>           <chr> <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>    <dbl>
#> 1 Asegurados_198… Unis…    20   345     0     0     1    NA    NA r0996…       0
#> 2 Asegurados_198… Unis…    21   345     0     0     1    NA    NA r0996…       0
#> 3 Asegurados_198… Unis…    22   346     0     0     1    NA    NA r0996…       0
#> 4 Asegurados_198… Unis…    23   347     0     0     1    NA    NA r0996…       0
#> 5 Asegurados_198… Unis…    24   348     0     0     1    NA    NA r0996…       0
#> 6 Asegurados_198… Unis…    25   348     0     0     1    NA    NA r0996…       0
#> # ℹ 1 more variable: qx_diff <dbl>

mortality_colombia_tables |>
  dplyr::count(table_id, sex)
#> # A tibble: 11 × 3
#>    table_id                       sex        n
#>    <chr>                          <chr>  <int>
#>  1 Asegurados_1984_1988           Unisex    46
#>  2 Asegurados_1998_2003           female    81
#>  3 Asegurados_1998_2003           male      81
#>  4 BEPS_2014                      female    96
#>  5 BEPS_2014                      male      96
#>  6 Mortalidad_invalidos_1980_1989 female    12
#>  7 Mortalidad_invalidos_1980_1989 male       4
#>  8 RV08_Rentistas_2005_2008       female    96
#>  9 RV08_Rentistas_2005_2008       male      96
#> 10 Rentistas_RV89_ISS_1980_1989   female    61
#> 11 Rentistas_RV89_ISS_1980_1989   male      54

rv08_male <- mortality_colombia_tables |>
  dplyr::filter(table_id == "RV08_Rentistas_2005_2008", sex == "male") |>
  dplyr::select(x, lx, dx, qx, px, mu_x, ex)

head(rv08_male)
#> # A tibble: 6 × 7
#>       x      lx    dx       qx    px  mu_x    ex
#>   <int>   <dbl> <dbl>    <dbl> <dbl> <dbl> <dbl>
#> 1    15 1000000   485 0.000485 1.000    NA  64.8
#> 2    16  999515   496 0.000496 1.000    NA  63.9
#> 3    17  999019   509 0.000509 0.999    NA  62.9
#> 4    18  998510   522 0.000523 0.999    NA  61.9
#> 5    19  997988   537 0.000538 0.999    NA  60.9
#> 6    20  997451   553 0.000554 0.999    NA  60  
```
