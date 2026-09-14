# Internal helper: annual annuity payment times

Internal helper: annual annuity payment times

## Usage

``` r
.mc_annuity_payment_times_annual(K, type, n, h, n_guar, timing)
```

## Arguments

- K:

  Numeric scalar. Simulated curtate future lifetime.

- type:

  Character string. Canonical annuity type.

- n:

  Numeric scalar or `NULL`.

- h:

  Numeric scalar. Deferral period.

- n_guar:

  Numeric scalar or `NULL`.

- timing:

  Character string. Either `"immediate"` or `"due"`.

## Value

Numeric vector with annual payment times.
