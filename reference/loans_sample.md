# Sample loan contracts for amortization examples

A small pedagogical dataset containing level-payment loan contracts for
amortization schedule and outstanding balance examples.

A small pedagogical dataset containing level-payment loan contracts for
amortization schedule and outstanding balance examples.

## Usage

``` r
loans_sample

loans_sample
```

## Format

A tibble with 4 rows and 7 variables:

- loan_id:

  Loan identifier.

- L:

  Initial loan principal.

- i:

  Annual effective interest rate.

- n_months:

  Loan term in months.

- k:

  Number of payments per year.

- loan_type:

  Short loan type label.

- R:

  Level payment amount per payment period.

A tibble with 4 rows and 7 variables:

- loan_id:

  Loan identifier.

- L:

  Initial loan principal.

- i:

  Annual effective interest rate.

- n_months:

  Loan term in months.

- k:

  Number of payments per year.

- loan_type:

  Short loan type label.

- R:

  Level payment amount per payment period.

## Source

Synthetic pedagogical data created for tidyactuarial examples.

Synthetic pedagogical data created for tidyactuarial examples.

## Details

This dataset uses compact loan notation: `L` is the initial loan
principal, `i` is the annual effective interest rate, `n_months` is the
loan term in months, `k` is the payment frequency, and `R` is the level
payment.

This dataset uses compact loan notation: `L` is the initial loan
principal, `i` is the annual effective interest rate, `n_months` is the
loan term in months, `k` is the payment frequency, and `R` is the level
payment.

## Examples

``` r
data(loans_sample)

loans_sample |>
  dplyr::select(loan_id, L, i, n_months, k, R)
#> # A tibble: 4 × 6
#>   loan_id      L     i n_months     k     R
#>   <chr>    <dbl> <dbl>    <dbl> <dbl> <dbl>
#> 1 LOAN_A   10000 0.08        24    12  451.
#> 2 LOAN_B   25000 0.105       36    12  807.
#> 3 LOAN_C   80000 0.06       120    12  882.
#> 4 LOAN_D  120000 0.075      180    12 1096.

data(loans_sample)

loans_sample |>
  dplyr::select(loan_id, L, i, n_months, k, R)
#> # A tibble: 4 × 6
#>   loan_id      L     i n_months     k     R
#>   <chr>    <dbl> <dbl>    <dbl> <dbl> <dbl>
#> 1 LOAN_A   10000 0.08        24    12  451.
#> 2 LOAN_B   25000 0.105       36    12  807.
#> 3 LOAN_C   80000 0.06       120    12  882.
#> 4 LOAN_D  120000 0.075      180    12 1096.
```
