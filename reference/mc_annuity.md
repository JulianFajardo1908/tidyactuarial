# Compute simulated present values for life annuities

Computes Monte Carlo simulated present values of life annuity payments
from simulated future lifetimes, using compact actuarial notation.

## Usage

``` r
mc_annuity(
  .data = NULL,
  i,
  payment = 1,
  k = 1L,
  type = c("whole", "temporary", "deferred", "deferred_temporary", "certain",
    "guaranteed", "whole_life"),
  n = NULL,
  h = 0,
  n_guar = NULL,
  timing = c("immediate", "due"),
  i_type = c("effective", "nominal_interest", "nominal_discount", "force", "nominal"),
  m = 1,
  col_K = "Kx",
  col_T = "Tx",
  col_pv = "pv_annuity",
  ...
)
```

## Arguments

- .data:

  A data frame or tibble containing simulated future lifetimes,
  typically returned by
  [`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md)
  or by
  [`mc_multilife_status`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md)
  when working with multiple-life statuses.

- i:

  Numeric scalar. Interest-rate input used for discounting.

- payment:

  Numeric scalar. Amount paid at each annuity payment date. Default is
  `1`. This is a per-payment amount, not an annualized payment rate.

- k:

  Positive integer. Number of annuity payments per year. Default is `1`,
  corresponding to annual payments.

- type:

  Character string specifying the annuity type. Canonical options are
  `"whole"`, `"temporary"`, `"deferred"`, `"deferred_temporary"`,
  `"certain"`, and `"guaranteed"`. The transitional alias `"whole_life"`
  is also accepted and mapped to `"whole"`.

- n:

  Numeric scalar. Term of the annuity in years. Required for
  `"temporary"`, `"deferred_temporary"`, and `"certain"` annuities.

- h:

  Numeric scalar. Deferral period in years. Default is `0`. Required to
  be positive for `"deferred"` and `"deferred_temporary"` annuities.

- n_guar:

  Numeric scalar. Guaranteed payment period in years. Required for
  `type = "guaranteed"`.

- timing:

  Character string specifying the annuity payment timing. Available
  options are `"immediate"` and `"due"`.

- i_type:

  Character string specifying the interest-rate convention. Allowed
  values are `"effective"`, `"nominal_interest"`, `"nominal_discount"`,
  and `"force"`. The transitional value `"nominal"` is accepted and
  treated as `"nominal_interest"`.

- m:

  Positive integer. Number of interest conversion periods per year for
  nominal annual rates. Default is `1`. This argument controls the
  interest-rate conversion frequency only. It does not represent annuity
  payment frequency.

- col_K:

  Character string. Name of the column containing simulated curtate
  future lifetimes. Default is `"Kx"`.

- col_T:

  Character string. Name of the column containing simulated complete
  future lifetimes. Default is `"Tx"`. This column is required when
  `k > 1`, except for annuities certain.

- col_pv:

  Character string. Name of the output column containing simulated
  present values of annuity payments. Default is `"pv_annuity"`.

- ...:

  Transitional compatibility for older calls using `data`, `rate`,
  `payments_per_year`, `annuity`, `term`, `deferral_years`,
  `guarantee_years`, `interest_type`, `k_col`, `tx_col`, and
  `annuity_col`.

## Value

A tibble with the original simulation columns and additional columns:

- i:

  Original interest-rate input.

- i_type:

  Interest-rate convention.

- m:

  Interest conversion frequency.

- i_effective:

  Equivalent annual effective interest rate.

- v:

  Annual discount factor.

- type:

  Canonical annuity type.

- payment:

  Legacy-compatible amount of each annuity payment.

- payment_per_payment:

  Amount paid at each payment date.

- payment_annualized:

  Payment amount multiplied by the number of payments per year.

- k:

  Annuity payment frequency.

- n:

  Annuity term, if applicable.

- h:

  Deferral period.

- n_guar:

  Guaranteed period, if applicable.

- timing:

  Annuity payment timing.

- n_payments:

  Number of payments made in the simulated scenario.

- first_payment_time:

  First payment time in the simulated scenario.

- last_payment_time:

  Last payment time in the simulated scenario.

- pv_annuity:

  Simulated present value of annuity payments, or another name supplied
  through `col_pv`.

For transition, the output also includes legacy columns such as `rate`,
`interest_type`, `effective_rate`, `discount_factor`, `annuity`,
`payments_per_year`, `term`, `deferral_years`, and `guarantee_years`.

## Details

This function is designed to be used after
[`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
or
[`mc_multilife_status`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md).
It takes simulated values of the curtate future lifetime \\K_x\\, and
when needed the complete future lifetime \\T_x\\, and evaluates the
present value random variable associated with classical annuity
benefits.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` is the interest-rate input, `i_type` is the
interest-rate convention, `m` is the nominal conversion frequency, `k`
is the annuity payment frequency, `n` is the annuity term, and `h` is
the deferral period.

The arguments `m` and `k` have different meanings:

- `m` is used only for nominal interest-rate conversion.

- `k` controls how frequently annuity payments are made.

The argument `payment` represents the amount of each annuity payment.
Thus, for a monthly annuity with total annual payment equal to 1, use
`payment = 1 / 12` and `k = 12`. The output makes the units explicit
through `payment_per_payment = payment` and
`payment_annualized = k * payment`.

For annual payments, `k = 1`, the function works directly with \\K_x\\.
For fractional payments, such as monthly, quarterly, or semiannual
payments, the function uses \\T_x\\ to determine whether the life is
alive at each fractional payment time.

For annual whole-life annuity-immediate, the simulated present value is
\$\$ Y = \sum\_{j=1}^{K_x} c v^j, \$\$ where \\c\\ is the amount of each
payment.

For annual whole-life annuity-due, the simulated present value is \$\$
\ddot{Y} = \sum\_{j=0}^{K_x} c v^j. \$\$

The function returns simulated present values, not only their expected
value. Therefore the resulting column can be summarized with
[`summary_mc`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md),
plotted with `ggplot2`, or used to construct premiums, losses, and
reserves.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*. Second Edition. Society of
Actuaries.

## See also

[`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`mc_multilife_status`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_premium`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_loss`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`summary_mc`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

Other monte-carlo:
[`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md),
[`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md),
[`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
[`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

## Examples

``` r
lt <- tibble::tibble(
  x = 40:100,
  qx = seq(0.002, 1, length.out = 61)
)

# Annual whole-life annuity-due
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    seed = 123
  ) |>
  mc_annuity(
    i = 0.05,
    type = "whole",
    payment = 1,
    k = 1,
    timing = "due"
  )
#> # A tibble: 25 × 41
#>    sim_id simulation_id     x   age method  frac  fractional    Kx
#>     <int>         <int> <int> <int> <chr>   <chr> <chr>      <int>
#>  1      1             1    40    40 inverse udd   udd            6
#>  2      2             2    40    40 inverse udd   udd           13
#>  3      3             3    40    40 inverse udd   udd            8
#>  4      4             4    40    40 inverse udd   udd           15
#>  5      5             5    40    40 inverse udd   udd           17
#>  6      6             6    40    40 inverse udd   udd            2
#>  7      7             7    40    40 inverse udd   udd            9
#>  8      8             8    40    40 inverse udd   udd           15
#>  9      9             9    40    40 inverse udd   udd            9
#> 10     10            10    40    40 inverse udd   udd            8
#> # ℹ 15 more rows
#> # ℹ 33 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, annuity <chr>, payment <dbl>,
#> #   payment_per_payment <dbl>, payment_annualized <dbl>, k <int>, …

# Monthly whole-life annuity-due with total annual payment equal to 1
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    frac = "udd",
    seed = 123
  ) |>
  mc_annuity(
    i = 0.05,
    type = "whole",
    payment = 1 / 12,
    k = 12,
    timing = "due"
  )
#> # A tibble: 25 × 41
#>    sim_id simulation_id     x   age method  frac  fractional    Kx
#>     <int>         <int> <int> <int> <chr>   <chr> <chr>      <int>
#>  1      1             1    40    40 inverse udd   udd            6
#>  2      2             2    40    40 inverse udd   udd           13
#>  3      3             3    40    40 inverse udd   udd            8
#>  4      4             4    40    40 inverse udd   udd           15
#>  5      5             5    40    40 inverse udd   udd           17
#>  6      6             6    40    40 inverse udd   udd            2
#>  7      7             7    40    40 inverse udd   udd            9
#>  8      8             8    40    40 inverse udd   udd           15
#>  9      9             9    40    40 inverse udd   udd            9
#> 10     10            10    40    40 inverse udd   udd            8
#> # ℹ 15 more rows
#> # ℹ 33 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, annuity <chr>, payment <dbl>,
#> #   payment_per_payment <dbl>, payment_annualized <dbl>, k <int>, …

# Quarterly temporary life annuity-immediate
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    frac = "udd",
    seed = 123
  ) |>
  mc_annuity(
    i = 0.05,
    type = "temporary",
    n = 20,
    payment = 1 / 4,
    k = 4,
    timing = "immediate"
  )
#> # A tibble: 25 × 41
#>    sim_id simulation_id     x   age method  frac  fractional    Kx
#>     <int>         <int> <int> <int> <chr>   <chr> <chr>      <int>
#>  1      1             1    40    40 inverse udd   udd            6
#>  2      2             2    40    40 inverse udd   udd           13
#>  3      3             3    40    40 inverse udd   udd            8
#>  4      4             4    40    40 inverse udd   udd           15
#>  5      5             5    40    40 inverse udd   udd           17
#>  6      6             6    40    40 inverse udd   udd            2
#>  7      7             7    40    40 inverse udd   udd            9
#>  8      8             8    40    40 inverse udd   udd           15
#>  9      9             9    40    40 inverse udd   udd            9
#> 10     10            10    40    40 inverse udd   udd            8
#> # ℹ 15 more rows
#> # ℹ 33 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, annuity <chr>, payment <dbl>,
#> #   payment_per_payment <dbl>, payment_annualized <dbl>, k <int>, …

# Nominal interest convertible monthly, with quarterly payments
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    frac = "udd",
    seed = 123
  ) |>
  mc_annuity(
    i = 0.06,
    i_type = "nominal_interest",
    m = 12,
    type = "whole",
    payment = 1 / 4,
    k = 4,
    timing = "due"
  )
#> # A tibble: 25 × 41
#>    sim_id simulation_id     x   age method  frac  fractional    Kx
#>     <int>         <int> <int> <int> <chr>   <chr> <chr>      <int>
#>  1      1             1    40    40 inverse udd   udd            6
#>  2      2             2    40    40 inverse udd   udd           13
#>  3      3             3    40    40 inverse udd   udd            8
#>  4      4             4    40    40 inverse udd   udd           15
#>  5      5             5    40    40 inverse udd   udd           17
#>  6      6             6    40    40 inverse udd   udd            2
#>  7      7             7    40    40 inverse udd   udd            9
#>  8      8             8    40    40 inverse udd   udd           15
#>  9      9             9    40    40 inverse udd   udd            9
#> 10     10            10    40    40 inverse udd   udd            8
#> # ℹ 15 more rows
#> # ℹ 33 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, annuity <chr>, payment <dbl>,
#> #   payment_per_payment <dbl>, payment_annualized <dbl>, k <int>, …

# Multiple-life status workflow
lt |>
  simulate_lifetimes(
    x = c(60, 58),
    n_sim = 25,
    frac = "udd",
    seed = 123
  ) |>
  mc_multilife_status(status = "joint") |>
  mc_annuity(
    i = 0.04,
    type = "whole",
    payment = 1,
    k = 1,
    timing = "due",
    col_K = "K_status",
    col_T = "T_status"
  )
#> # A tibble: 25 × 33
#>    sim_id   sim K_status T_status n_lives status     i  rate i_type   
#>     <int> <int>    <int>    <dbl>   <int> <chr>  <dbl> <dbl> <chr>    
#>  1      1     1        0    0.220       2 joint   0.04  0.04 effective
#>  2      2     2        1    1.38        2 joint   0.04  0.04 effective
#>  3      3     3        1    1.59        2 joint   0.04  0.04 effective
#>  4      4     4        0    0.352       2 joint   0.04  0.04 effective
#>  5      5     5        2    2.11        2 joint   0.04  0.04 effective
#>  6      6     6        0    0.244       2 joint   0.04  0.04 effective
#>  7      7     7        0    0.668       2 joint   0.04  0.04 effective
#>  8      8     8        3    3.42        2 joint   0.04  0.04 effective
#>  9      9     9        1    1.80        2 joint   0.04  0.04 effective
#> 10     10    10        1    1.02        2 joint   0.04  0.04 effective
#> # ℹ 15 more rows
#> # ℹ 24 more variables: interest_type <chr>, m <int>, i_effective <dbl>,
#> #   effective_rate <dbl>, v <dbl>, discount_factor <dbl>, type <chr>,
#> #   annuity <chr>, payment <dbl>, payment_per_payment <dbl>,
#> #   payment_annualized <dbl>, k <int>, payments_per_year <int>, n <dbl>,
#> #   term <dbl>, h <dbl>, deferral_years <dbl>, n_guar <dbl>,
#> #   guarantee_years <dbl>, timing <chr>, n_payments <int>, …
```
