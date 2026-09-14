# Sample multiple decrement probabilities

A small pedagogical annual multiple decrement dataset with three causes:
death, disability, and withdrawal. It is intended for examples involving
multiple decrement tables, total-decrement life tables, cause-specific
decrement probabilities, and cause-specific insurance benefits.

A small pedagogical annual multiple decrement dataset with three causes:
death, disability, and withdrawal. It is intended for examples involving
multiple decrement tables, total-decrement life tables, cause-specific
decrement probabilities, and cause-specific insurance benefits.

## Usage

``` r
multiple_decrement_sample

multiple_decrement_sample
```

## Format

A tibble with 7 rows and 6 variables:

- x:

  Integer actuarial age.

- q_death:

  One-year death decrement probability.

- q_disability:

  One-year disability decrement probability.

- q_withdrawal:

  One-year withdrawal decrement probability.

- q_total:

  Total one-year decrement probability.

- p_total:

  Total one-year survival probability.

A tibble with 7 rows and 6 variables:

- x:

  Integer actuarial age.

- q_death:

  One-year death decrement probability.

- q_disability:

  One-year disability decrement probability.

- q_withdrawal:

  One-year withdrawal decrement probability.

- q_total:

  Total one-year decrement probability.

- p_total:

  Total one-year survival probability.

## Source

Synthetic pedagogical data created for tidyactuarial examples.

Synthetic pedagogical data created for tidyactuarial examples.

## Details

This dataset already follows the compact actuarial convention `x` for
age and `q` for decrement probabilities.

This dataset already follows the compact actuarial convention `x` for
age and `q` for decrement probabilities.

## Examples

``` r
data(multiple_decrement_sample)

multiple_decrement_sample |>
  dplyr::select(x, q_death, q_disability, q_withdrawal, q_total, p_total)
#> # A tibble: 7 × 6
#>       x q_death q_disability q_withdrawal q_total p_total
#>   <int>   <dbl>        <dbl>        <dbl>   <dbl>   <dbl>
#> 1    50  0.006        0.012         0.08   0.098    0.902
#> 2    51  0.0065       0.0135        0.075  0.095    0.905
#> 3    52  0.007        0.015         0.07   0.092    0.908
#> 4    53  0.0078       0.0165        0.065  0.0893   0.911
#> 5    54  0.0087       0.018         0.06   0.0867   0.913
#> 6    55  0.0098       0.0195        0.055  0.0843   0.916
#> 7    56  0.011        0.021         0.05   0.082    0.918

data(multiple_decrement_sample)

multiple_decrement_sample |>
  dplyr::select(x, q_death, q_disability, q_withdrawal, q_total, p_total)
#> # A tibble: 7 × 6
#>       x q_death q_disability q_withdrawal q_total p_total
#>   <int>   <dbl>        <dbl>        <dbl>   <dbl>   <dbl>
#> 1    50  0.006        0.012         0.08   0.098    0.902
#> 2    51  0.0065       0.0135        0.075  0.095    0.905
#> 3    52  0.007        0.015         0.07   0.092    0.908
#> 4    53  0.0078       0.0165        0.065  0.0893   0.911
#> 5    54  0.0087       0.018         0.06   0.0867   0.913
#> 6    55  0.0098       0.0195        0.055  0.0843   0.916
#> 7    56  0.011        0.021         0.05   0.082    0.918
```
