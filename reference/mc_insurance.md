# Compute simulated present values for life insurance benefits

Computes Monte Carlo simulated present values of life insurance benefits
from simulated future lifetimes, using compact actuarial notation.

## Usage

``` r
mc_insurance(
  .data = NULL,
  i = NULL,
  benefit = 1,
  type = c("whole", "term", "deferred", "deferred_term", "pure_endowment", "endowment",
    "whole_life", "deferred_temporary"),
  n = NULL,
  h = 0,
  timing = c("end_of_year", "moment_of_death"),
  i_type = c("effective", "nominal_interest", "nominal_discount", "force", "nominal"),
  m = 1,
  col_K = "Kx",
  col_T = "Tx",
  col_pv = "pv_benefit",
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

- benefit:

  Numeric scalar. Monetary amount paid when the insured benefit is
  triggered. Default is `1`. Unlike an annuity payment, this is a single
  benefit amount and has no annualized-versus-per-payment
  interpretation.

- type:

  Character string specifying the insurance type. Canonical options are
  `"whole"`, `"term"`, `"deferred"`, `"deferred_term"`,
  `"pure_endowment"`, and `"endowment"`. Transitional aliases
  `"whole_life"` and `"deferred_temporary"` are also accepted.

- n:

  Numeric scalar. Insurance term in years. Required for `"term"`,
  `"deferred_term"`, `"pure_endowment"`, and `"endowment"`.

- h:

  Numeric scalar. Deferral period in years. Default is `0`. Required to
  be positive for `"deferred"` and `"deferred_term"` insurance.

- timing:

  Character string specifying when death benefits are paid. Available
  options are `"end_of_year"` and `"moment_of_death"`. Default is
  `"end_of_year"`.

- i_type:

  Character string specifying the interest-rate convention. Allowed
  values are `"effective"`, `"nominal_interest"`, `"nominal_discount"`,
  and `"force"`. The transitional value `"nominal"` is accepted and
  treated as `"nominal_interest"`.

- m:

  Positive integer. Number of interest conversion periods per year for
  nominal annual rates. Default is `1`. This argument controls the
  interest-rate conversion frequency only. It does not represent benefit
  frequency or premium payment frequency.

- col_K:

  Character string. Name of the column containing simulated curtate
  future lifetimes. Default is `"Kx"`.

- col_T:

  Character string. Name of the column containing simulated complete
  future lifetimes. Required when `timing = "moment_of_death"`. Default
  is `"Tx"`.

- col_pv:

  Character string. Name of the output column containing simulated
  present values of benefits. Default is `"pv_benefit"`.

- ...:

  Transitional compatibility for older calls using `data`, `rate`,
  `insurance`, `term`, `deferral_years`, `payment_timing`,
  `interest_type`, `k_col`, `tx_col`, and `benefit_col`.

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

  Canonical insurance type.

- benefit:

  Benefit amount.

- n:

  Insurance term, if applicable.

- h:

  Deferral period.

- timing:

  Timing used for death benefits.

- benefit_time:

  Simulated payment time of the benefit.

- benefit_indicator:

  Indicator that the benefit is paid.

- pv_benefit:

  Simulated present value of the benefit, or another name supplied
  through `col_pv`.

For transition, the output also includes legacy columns such as `rate`,
`interest_type`, `effective_rate`, `discount_factor`, `insurance`,
`term`, `deferral_years`, and `payment_timing`.

## Details

This function is designed to be used after
[`simulate_lifetime`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md),
[`simulate_lifetimes`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md),
or
[`mc_multilife_status`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md).
It takes simulated values of the curtate future lifetime \\K_x\\, and
when needed the complete future lifetime \\T_x\\, and evaluates the
present value random variable associated with classical life insurance
benefits.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `i` is the interest-rate input, `i_type` is the
interest-rate convention, `m` is the nominal conversion frequency, `n`
is the insurance term, and `h` is the deferral period.

The arguments `m` and `col_K` have deliberately different roles:

- `m` is used only for nominal interest-rate conversion.

- `col_K` identifies the simulated curtate future lifetime column.

If `timing = "end_of_year"`, death benefits are discounted using \\K_x +
1\\. Under this discrete convention, finite terms and deferral periods
must be whole numbers of years because eligibility is determined from
the curtate lifetime \\K_x\\. If `timing = "moment_of_death"`, death
benefits are discounted using \\T_x\\, and fractional terms or deferral
periods are allowed.

The following insurance types are supported:

- `"whole"`: benefit is paid whenever death occurs.

- `"term"`: benefit is paid if death occurs within `n` years.

- `"deferred"`: benefit is paid if death occurs after the deferral
  period `h`.

- `"deferred_term"`: benefit is paid if death occurs after `h` and
  within the following `n` years.

- `"pure_endowment"`: benefit is paid at time `n` if the life survives
  to that time.

- `"endowment"`: death benefit is paid if death occurs within `n` years;
  otherwise, a survival benefit is paid at time `n`.

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
[`mc_annuity`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
[`mc_premium`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md),
[`mc_loss`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md),
[`mc_reserve`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md),
[`summary_mc`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)

Other monte-carlo:
[`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md),
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

# Whole-life insurance payable at the end of the year of death
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    seed = 123
  ) |>
  mc_insurance(
    i = 0.05,
    type = "whole",
    benefit = 1
  )
#> # A tibble: 25 × 35
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
#> # ℹ 27 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, insurance <chr>, benefit <dbl>,
#> #   n <dbl>, term <dbl>, h <dbl>, deferral_years <dbl>, timing <chr>, …

# 20-year term insurance
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    seed = 123
  ) |>
  mc_insurance(
    i = 0.05,
    type = "term",
    n = 20,
    benefit = 100000
  )
#> # A tibble: 25 × 35
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
#> # ℹ 27 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, insurance <chr>, benefit <dbl>,
#> #   n <dbl>, term <dbl>, h <dbl>, deferral_years <dbl>, timing <chr>, …

# 10-year deferred whole-life insurance
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    seed = 123
  ) |>
  mc_insurance(
    i = 0.05,
    type = "deferred",
    h = 10,
    benefit = 1
  )
#> # A tibble: 25 × 35
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
#> # ℹ 27 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, insurance <chr>, benefit <dbl>,
#> #   n <dbl>, term <dbl>, h <dbl>, deferral_years <dbl>, timing <chr>, …

# Endowment insurance payable at the moment of death if death occurs
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    frac = "udd",
    seed = 123
  ) |>
  mc_insurance(
    i = 0.05,
    type = "endowment",
    n = 20,
    timing = "moment_of_death",
    benefit = 1
  )
#> # A tibble: 25 × 35
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
#> # ℹ 27 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, insurance <chr>, benefit <dbl>,
#> #   n <dbl>, term <dbl>, h <dbl>, deferral_years <dbl>, timing <chr>, …

# Nominal interest rate convertible monthly
lt |>
  simulate_lifetime(
    x = 40,
    n_sim = 25,
    seed = 123
  ) |>
  mc_insurance(
    i = 0.06,
    i_type = "nominal_interest",
    m = 12,
    type = "whole",
    benefit = 1
  )
#> # A tibble: 25 × 35
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
#> # ℹ 27 more variables: curtate_lifetime <int>, Tx <dbl>,
#> #   complete_lifetime <dbl>, death_age <int>, qx_at_death_year <dbl>,
#> #   distribution_conditioned <lgl>, i <dbl>, rate <dbl>, i_type <chr>,
#> #   interest_type <chr>, m <int>, i_effective <dbl>, effective_rate <dbl>,
#> #   v <dbl>, discount_factor <dbl>, type <chr>, insurance <chr>, benefit <dbl>,
#> #   n <dbl>, term <dbl>, h <dbl>, deferral_years <dbl>, timing <chr>, …

# First-death insurance using a multiple-life status
lt |>
  simulate_lifetimes(
    x = c(60, 58),
    n_sim = 25,
    frac = "udd",
    seed = 123
  ) |>
  mc_multilife_status(status = "joint") |>
  mc_insurance(
    i = 0.04,
    type = "whole",
    benefit = 100000,
    col_K = "K_status",
    col_T = "T_status"
  )
#> # A tibble: 25 × 27
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
#> # ℹ 18 more variables: interest_type <chr>, m <int>, i_effective <dbl>,
#> #   effective_rate <dbl>, v <dbl>, discount_factor <dbl>, type <chr>,
#> #   insurance <chr>, benefit <dbl>, n <dbl>, term <dbl>, h <dbl>,
#> #   deferral_years <dbl>, timing <chr>, payment_timing <chr>,
#> #   benefit_time <dbl>, benefit_indicator <dbl>, pv_benefit <dbl>
```
