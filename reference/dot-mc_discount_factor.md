# Internal helper: compute annual discount factor

Computes the annual discount factor from an interest-rate convention.

## Usage

``` r
.mc_discount_factor(
  i,
  i_type = c("effective", "nominal_interest", "nominal_discount", "force"),
  m = 1,
  rate = NULL,
  interest_type = NULL
)
```

## Arguments

- i:

  Numeric scalar. Interest-rate input.

- i_type:

  Character string. Interest-rate convention. One of `"effective"`,
  `"nominal_interest"`, `"nominal_discount"`, or `"force"`. The legacy
  value `"nominal"` is accepted internally and treated as
  `"nominal_interest"`.

- m:

  Numeric scalar. Number of interest conversion periods per year for
  nominal annual rates. Default is `1`.

- rate:

  Deprecated internal alias for `i`.

- interest_type:

  Deprecated internal alias for `i_type`.

## Value

Numeric scalar with the annual discount factor.
