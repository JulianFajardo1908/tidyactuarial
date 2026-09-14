# Internal helper: validate numeric scalar

Internal helper: validate numeric scalar

## Usage

``` r
.mc_assert_numeric_scalar(
  x,
  arg,
  min = -Inf,
  max = Inf,
  strict_min = FALSE,
  strict_max = FALSE,
  allow_null = FALSE
)
```

## Arguments

- x:

  Object to validate.

- arg:

  Character string with the argument name.

- min:

  Minimum allowed value. Default is `-Inf`.

- max:

  Maximum allowed value. Default is `Inf`.

- strict_min:

  Logical. Should the lower bound be strict?

- strict_max:

  Logical. Should the upper bound be strict?

- allow_null:

  Logical. Should `NULL` be allowed?

## Value

Invisibly returns `TRUE` if validation is successful.
