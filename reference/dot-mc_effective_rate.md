# Internal helper: convert interest rate to annual effective rate

Converts an interest rate supplied under a standard actuarial convention
into an equivalent annual effective interest rate.

## Usage

``` r
.mc_effective_rate(
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

Numeric scalar with the equivalent annual effective interest rate.

## Details

This helper follows the compact actuarial notation used throughout
`tidyactuarial`: `i` is the interest-rate input, `i_type` is the
interest-rate type, and `m` is the conversion frequency for nominal
rates.

The argument `m` is used only to convert nominal annual rates into
equivalent annual effective rates. It does not represent annuity payment
frequency.

Transitional compatibility is intentionally retained for older internal
Monte Carlo calls using `rate =` and `interest_type =`.
