# Sample bond contracts for fixed-income examples

A small pedagogical dataset containing bond contracts for pricing,
yield-to-maturity, duration, and convexity examples.

A small pedagogical dataset containing bond contracts for pricing,
yield-to-maturity, duration, and convexity examples.

## Usage

``` r
bonds_sample

bonds_sample
```

## Format

A tibble with 5 rows and 8 variables:

- bond_id:

  Bond identifier.

- face:

  Face value of the bond.

- c:

  Annual coupon rate.

- k:

  Number of coupon payments per year.

- n:

  Maturity in years.

- y:

  Annual nominal yield rate consistent with coupon frequency.

- bond_type:

  Short bond type label.

- P:

  Theoretical bond price computed from the listed yield rate.

A tibble with 5 rows and 8 variables:

- bond_id:

  Bond identifier.

- face:

  Face value of the bond.

- c:

  Annual coupon rate.

- k:

  Number of coupon payments per year.

- n:

  Maturity in years.

- y:

  Annual nominal yield rate consistent with coupon frequency.

- bond_type:

  Short bond type label.

- P:

  Theoretical bond price computed from the listed yield rate.

## Source

Synthetic pedagogical data created for tidyactuarial examples.

Synthetic pedagogical data created for tidyactuarial examples.

## Details

This dataset uses the compact bond notation adopted in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `k` is the
coupon frequency, `n` is the maturity, `y` is the yield input, and `P`
is the bond price.

This dataset uses the compact bond notation adopted in `tidyactuarial`:
`face` is the face value, `c` is the annual coupon rate, `k` is the
coupon frequency, `n` is the maturity, `y` is the yield input, and `P`
is the bond price.

## Examples

``` r
data(bonds_sample)

bonds_sample |>
  dplyr::select(bond_id, face, c, k, n, y, P)
#> # A tibble: 5 × 7
#>   bond_id  face     c     k     n     y     P
#>   <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 BOND_A   1000 0.05      2     5 0.055  978.
#> 2 BOND_B   1000 0.08      2    10 0.065 1109.
#> 3 BOND_C   1000 0         1     3 0.04   889.
#> 4 BOND_D   5000 0.045     4     7 0.05  4853.
#> 5 BOND_E   1000 0.06      1    15 0.06  1000.

data(bonds_sample)

bonds_sample |>
  dplyr::select(bond_id, face, c, k, n, y, P)
#> # A tibble: 5 × 7
#>   bond_id  face     c     k     n     y     P
#>   <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 BOND_A   1000 0.05      2     5 0.055  978.
#> 2 BOND_B   1000 0.08      2    10 0.065 1109.
#> 3 BOND_C   1000 0         1     3 0.04   889.
#> 4 BOND_D   5000 0.045     4     7 0.05  4853.
#> 5 BOND_E   1000 0.06      1    15 0.06  1000.
```
