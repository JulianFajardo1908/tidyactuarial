# Internal helper: safe payment times

Creates a sequence of payment times. If the upper bound is smaller than
the lower bound, it returns `numeric(0)`.

## Usage

``` r
.mc_payment_times(from, to, by = 1)
```

## Arguments

- from:

  Numeric scalar. First payment time.

- to:

  Numeric scalar. Last payment time.

- by:

  Numeric scalar. Step between payment times. Default is `1`.

## Value

Numeric vector.
