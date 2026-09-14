# Benefit reserves for single-life insurance

Computes terminal benefit reserves at selected integer policy durations
by the prospective or recursive method.

## Usage

``` r
reserve_x(
  lt,
  x,
  i,
  i_type = "effective",
  m = 1L,
  type = c("whole", "term", "endowment"),
  n = Inf,
  h = 0L,
  benefit = 1,
  P = NULL,
  k = 1L,
  frac = c("UDD", "CF", "CML", "Balducci"),
  timing = c("due", "immediate"),
  premium_start = c("issue", "deferred"),
  n_prem = NULL,
  woolhouse = c("none", "first", "second"),
  t = NULL,
  method = c("prospective", "recursive"),
  output = c("summary", "value", "audit", "table"),
  tidy = NULL,
  check = TRUE,
  ...
)
```

## Arguments

- lt:

  A life table containing columns `x` and `lx`, or a single-life
  contract created with
  [`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md).

- x:

  Integer actuarial age at issue. Optional for a life contract.

- i:

  Numeric scalar. Annual interest-rate input. Optional for a life
  contract.

- i_type:

  Interest-rate type: `"effective"`, `"nominal_interest"`,
  `"nominal_discount"`, or `"force"`.

- m:

  Positive integer. Conversion frequency for nominal interest rates.

- type:

  Insurance type: `"whole"`, `"term"`, or `"endowment"`.

- n:

  Insurance term in years. Use `Inf` for whole-life insurance.

- h:

  Nonnegative integer deferment period in years.

- benefit:

  Positive insurance benefit.

- P:

  Optional annualized premium \\P^{(k)}\\. If `NULL`, it is calculated
  with
  [`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md)
  by the equivalence principle.

- k:

  Positive integer. Number of premium payments per year.

- frac:

  Fractional-age assumption for exact k-thly premium annuities.

- timing:

  Premium timing. Currently only `"due"` is supported, which gives
  reserves immediately before any premium payable at duration `t`.

- premium_start:

  Start of premium payments: `"issue"` or `"deferred"`.

- n_prem:

  Premium-paying term in years. A fractional term is permitted when
  `n_prem * k` is an integer.

- woolhouse:

  Woolhouse approximation order for the premium annuity: `"none"`,
  `"first"`, or `"second"`.

- t:

  Optional integer vector of policy durations. If `NULL`, all supported
  integer durations are returned.

- method:

  Reserve method: `"prospective"` or `"recursive"`. The recursive method
  currently supports annual premiums only (`k = 1`).

- output:

  Output level. `"summary"` returns a compact reserve schedule,
  `"value"` returns a named numeric vector, and `"audit"` returns the
  reserve components in long format. `"table"` is accepted as a
  deprecated alias for `"summary"`.

- tidy:

  Deprecated compatibility argument. `TRUE` maps to `output = "summary"`
  and `FALSE` to `output = "value"`.

- check:

  Logical scalar. If `TRUE`, validates inputs.

- ...:

  Transitional compatibility for older calls using `mortality_table`,
  `age`, `rate`, `rate_type`, `insurance_type`, `term_years`, `premium`,
  `premium_term_years`, and `durations`.

## Value

For `output = "summary"`, a tibble with at most six columns: duration,
attained age, reserve, annualized premium, premium per payment, and
method.

For `output = "value"`, a named numeric vector.

For `output = "audit"`, a long-format tibble containing future benefit
APV, future premium APV, reserve, and premium amounts at each duration.

## Details

The prospective method supports annual and true k-thly premiums payable
in advance. The premium input `P` is always interpreted as the
annualized premium \\P^{(k)}\\. The amount paid at each premium date is
\\P^{(k)} / k\\.

At integer duration \\t\\, conditional on survival to age \\x+t\\, the
prospective reserve is \$\$ {}\_tV_x =
\operatorname{APV}\_t(\text{future benefits}) - P^{(k)}
\operatorname{APV}\_t(\text{future premium annuity}). \$\$

The premium annuity is normalized to an annual payment rate of 1, so
each installment has amount \\1/k\\. Therefore, the multiplier in the
reserve formula is the annualized premium \\P^{(k)}\\, not the
installment \\P^{(k)}/k\\.

Reserves are measured immediately before any premium payable at duration
\\t\\. This is the standard fully discrete terminal-reserve convention
for premiums payable in advance.

For annual premiums, the recursive method uses \$\$ {}\_{t+1}V_x =
\frac{ ({}\_tV_x + P_t)(1+i) - b\_{t+1}q\_{x+t} }{p\_{x+t}}. \$\$

## See also

[`premium_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`insurance_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`annuity_x`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`life_contract`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`add_insurance`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md)

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md),
[`premium_gross()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md),
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md),
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)

## Examples

``` r
lt <- data.frame(
  x = 40:90,
  lx = round(100000 * exp(-0.018 * (0:50)^1.35))
)
lt$lx[nrow(lt)] <- 0

reserve_x(
  lt = lt,
  x = 40,
  i = 0.05,
  type = "term",
  n = 20,
  benefit = 100000,
  k = 12,
  n_prem = 10,
  t = c(0, 5, 10, 15, 20)
)
#> # A tibble: 5 × 6
#>       t   age reserve premium_annualized premium_per_payment method     
#>   <int> <int>   <dbl>              <dbl>               <dbl> <chr>      
#> 1     0    40      0               5841.                487. prospective
#> 2     5    45  17829.              5841.                487. prospective
#> 3    10    50  36402.              5841.                487. prospective
#> 4    15    55  24485.              5841.                487. prospective
#> 5    20    60      0               5841.                487. prospective

life_contract(
  lt = lt,
  lives = "single",
  x = 40,
  i = 0.05
) |>
  add_insurance(
    type = "term",
    benefit = 100000,
    n = 20
  ) |>
  add_premium_schedule(
    k = 12,
    n_prem = 10
  ) |>
  reserve_x(
    t = c(0, 5, 10, 15, 20),
    output = "summary"
  )
#> # A tibble: 5 × 6
#>       t   age reserve premium_annualized premium_per_payment method     
#>   <int> <int>   <dbl>              <dbl>               <dbl> <chr>      
#> 1     0    40      0               5841.                487. prospective
#> 2     5    45  17829.              5841.                487. prospective
#> 3    10    50  36402.              5841.                487. prospective
#> 4    15    55  24485.              5841.                487. prospective
#> 5    20    60      0               5841.                487. prospective
```
