# Internal helper: fractional annuity payment times

Internal helper: fractional annuity payment times

## Usage

``` r
.mc_annuity_payment_times_fractional(
  T,
  type,
  n,
  h,
  n_guar,
  timing,
  payment_interval
)
```

## Arguments

- T:

  Numeric scalar. Simulated complete future lifetime.

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

- payment_interval:

  Numeric scalar. Time between payments.

## Value

Numeric vector with fractional payment times.
