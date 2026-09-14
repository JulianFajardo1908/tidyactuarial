# Create a life-contingency contract specification

Creates a lightweight actuarial contract object that stores common
life-contingency inputs for use in pipe workflows.

## Usage

``` r
life_contract(
  lt,
  lives = c("single", "joint", "last_survivor"),
  x = NULL,
  y = NULL,
  i,
  i_type = "effective",
  m = 1L,
  ...
)
```

## Arguments

- lt:

  A life table or a list of two life tables. For single-life contracts,
  provide one data frame or tibble. For two-life contracts, provide
  either one data frame used for both lives, or `list(lt_x, lt_y)` with
  one table for each life. Each life table must contain columns `x` and
  `lx`.

- lives:

  Character string. Use `"single"` for a single-life contract, `"joint"`
  for a joint-life two-life contract, or `"last_survivor"` for a
  last-survivor two-life contract.

- x:

  Numeric scalar. Age of the single life, or age of the first life in a
  two-life contract.

- y:

  Numeric scalar. Age of the second life in a two-life contract.
  Required when `lives` is `"joint"` or `"last_survivor"`.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

- ...:

  Reserved for future extensions. Deprecated argument names such as
  `mortality_table`, `age`, `age_x`, `age_y`, `rate`, and `rate_type`
  are not accepted.

## Value

An object of class `"tidyact_life_contract"`.

## Details

This function does not compute actuarial values. It validates and stores
common actuarial inputs such as the life table, life status, ages, and
interest-rate specification. Calculation functions such as
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md),
and simulation functions can then consume this object.

`life_contract()` follows the compact actuarial notation used throughout
`tidyactuarial`:

- `lt`: life table;

- `x`: age of the first or single life;

- `y`: age of the second life;

- `i`: interest rate;

- `i_type`: type of interest rate;

- `m`: conversion frequency for nominal rates.

The object stores actuarial fields using the compact names above. During
the 0.1.4 API transition, it also stores internal compatibility fields
so that functions not yet migrated can continue to read the contract.
These internal fields are not part of the preferred user-facing
notation.

## See also

Other life-contingencies:
[`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md),
[`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md),
[`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md),
[`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md),
[`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md),
[`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md),
[`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md),
[`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md),
[`premium_gross()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md),
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md),
[`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md),
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md),
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

life_contract(
  lt = lt,
  lives = "single",
  x = 40,
  i = 0.05
)
#> <tidyact_life_contract>
#>   lives:  single
#>   x:      40
#>   i:      0.05
#>   i_type: effective
#>   m:      1
#>   tables: 1

life_contract(
  lt = lt,
  lives = "joint",
  x = 60,
  y = 58,
  i = 0.05
)
#> <tidyact_life_contract>
#>   lives:  joint
#>   x:      60
#>   y:      58
#>   i:      0.05
#>   i_type: effective
#>   m:      1
#>   tables: 1
```
