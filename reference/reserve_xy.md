# Benefit reserves for two-life insurance

Computes prospective or recursive terminal reserves for joint-life and
last-survivor insurance. For k-thly premiums, `P` is the annualized
premium and each installment equals `P / k`.

## Usage

``` r
reserve_xy(
  lt,
  x = NULL,
  y = NULL,
  i = NULL,
  i_type = "effective",
  m = 1L,
  type = c("whole", "term", "endowment", "pure_endowment"),
  status = c("joint", "last"),
  n = Inf,
  h = 0L,
  benefit = 1,
  P = NULL,
  n_prem = NULL,
  k = 1L,
  timing = c("due", "immediate"),
  premium_start = c("issue", "deferred"),
  frac = c("UDD", "CF", "CML", "Balducci"),
  woolhouse = c("none", "first", "second"),
  t = NULL,
  method = c("prospective", "recursive"),
  output = c("summary", "value", "audit", "table"),
  tidy = NULL,
  check = TRUE,
  tol = 1e-10,
  ...
)
```

## Arguments

- lt:

  One life table, `list(lt_x, lt_y)`, or a two-life
  [`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md)
  object.

- x, y:

  Integer ages at issue. Optional for a life contract.

- i:

  Annual interest-rate input. Optional for a life contract.

- i_type:

  Interest-rate type.

- m:

  Conversion frequency for nominal rates.

- type:

  One of `"whole"`, `"term"`, `"endowment"`, or `"pure_endowment"`.

- status:

  `"joint"` or `"last"`.

- n:

  Insurance term in years after deferment.

- h:

  Nonnegative integer deferment in years.

- benefit:

  Positive benefit amount.

- P:

  Optional annualized premium. If `NULL`,
  [`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md)
  is used.

- n_prem:

  Premium-paying term. Fractional values require `n_prem * k` to be an
  integer.

- k:

  Number of premium payments per year.

- timing:

  `"due"` or `"immediate"`.

- premium_start:

  `"issue"` or `"deferred"`.

- frac:

  Fractional-age assumption.

- woolhouse:

  `"none"`, `"first"`, or `"second"`.

- t:

  Integer policy durations.

- method:

  `"prospective"` or `"recursive"`. Recursion currently requires
  `h = 0`, `k = 1`, due premiums, and premiums starting at issue.

- output:

  `"summary"`, `"value"`, or `"audit"`. `"table"` is a compatibility
  alias for `"summary"`.

- tidy:

  Deprecated logical output selector.

- check:

  Logical input-check switch.

- tol:

  Numeric tolerance.

- ...:

  Deprecated argument aliases.

## Value

A compact tibble, a named numeric vector, or a long audit tibble.

## Details

The prospective reserve is \$\${}\_tV =
\operatorname{APV}\_t(\text{future benefits}) -
P^{(k)}\operatorname{APV}\_t(\text{future premium annuity}).\$\$ Because
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md)
assigns amount `1 / k` to each payment, `P` is annualized and the actual
installment is `P / k`.

Reserves are measured immediately before a premium payable at duration
`t`. Pure endowments are valued as endowment APV minus term-insurance
APV.

## See also

[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md)

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
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md),
[`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)
