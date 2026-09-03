# tidyactuarial

**Actuarial mathematics in R for users who think in formulas, tibbles, and reproducible pipelines.**

`tidyactuarial` provides actuarial mathematics tools designed for transparent,
vectorized, and reproducible workflows in R. The package keeps the underlying
actuarial quantities explicit while making it natural to move from one formula
to a complete analysis built with tibbles, the native pipe, and tidyverse tools.
Structured outputs can be used for teaching, auditing, scenario analysis, and
applied actuarial work.

The current stable release is **0.1.6** on CRAN. The development branch uses
version **0.1.6.9000**.

## What the package covers

The current API includes tools for:

- **Interest theory and cash flows:** rate conversion, present and future
  values, accumulation and discount factors, general cash flows, IRR, and
  equations of value.
- **Annuities and loans:** actuarial annuity factors, arithmetic and geometric
  annuities, amortization schedules, general payment patterns, and sinking
  funds.
- **Bonds and interest-rate risk:** cash-flow schedules, prices, yields, book
  values, callable bonds, duration, convexity, and portfolio measures.
- **Yield curves and immunization:** spot discounting, forward rates, yield
  curves, duration matching, and duration-convexity immunization.
- **Life contingencies:** life tables, survival probabilities, life
  expectancy, life annuities, insurance benefits, premiums, reserves, and
  multiple-life calculations.
- **Simulation:** lifetime simulation and Monte Carlo tools for annuities,
  insurance, premiums, losses, reserves, and multiple-life status models.
- **Reproducible actuarial workflows:** tidy tables, audit-oriented outputs,
  sample datasets, and cash-flow visualizations.

## Design principles

`tidyactuarial` is built around four ideas:

1. **Actuarial transparency.** Functions use recognizable actuarial inputs and
   keep the financial or life-contingency model visible.
2. **Composable workflows.** Many calculations accept vectors, and several
   higher-level functions are tibble-first or pipe-friendly, so actuarial
   calculations can be embedded naturally in `dplyr`, `tidyr`, and `purrr`
   workflows.
3. **Appropriate output for the task.** Direct calculations often return
   numeric values; functions that benefit from inspection can also provide
   tidy, summary, audit, schedule, or portfolio-level outputs.
4. **Reproducibility.** Calculations are designed to be checked, repeated,
   compared across scenarios, and connected to downstream data analysis.

The package does **not** replace actuarial reasoning. It is intended to make
that reasoning easier to reproduce and audit computationally.


## For users who like tidy workflows

`tidyactuarial` does not force every actuarial calculation into a tibble. A
single present value should still be easy to compute as a number. But when the
problem becomes a collection of scenarios, contracts, positions, or portfolios,
the package is designed to fit naturally into a tidy workflow.

Tidyverse-oriented users should feel at home with four recurring patterns:

- **vectorized primitives inside `mutate()`:** standardize rates, value cash
  flows, or evaluate scenarios without leaving the data pipeline;
- **tibble-first summaries:** portfolio duration and convexity consume position
  tables and return one row per portfolio;
- **structured outputs:** schedules, summaries, audit tables, and other outputs
  can be joined, filtered, reshaped, or plotted with familiar tidyverse tools;
- **domain pipelines:** actuarial objects such as life contracts can be built
  progressively with the native `|>` pipe before valuation.

The objective is not to hide actuarial mathematics behind syntax. It is to let
the mathematics remain recognizable while the surrounding workflow becomes
repeatable, inspectable, and scalable.

## Installation

Install the stable release from CRAN:

```r
install.packages("tidyactuarial")
```

Load the package with:

```r
library(tidyactuarial)
```

The development version is maintained at the canonical GitHub repository:

```r
# install.packages("pak")
pak::pak("JulianFajardo1908/tidyactuarial")
```

## Quick start

### 1. Standardize heterogeneous interest-rate conventions

A portfolio may contain rates quoted under different conventions. They can be
placed on a common annual-effective basis before valuation.

```r
library(tidyactuarial)
library(dplyr)
library(tibble)

alternatives <- tibble(
  product = c(
    "annual effective",
    "nominal interest",
    "force of interest",
    "nominal discount"
  ),
  i = c(0.0620, 0.0605, 0.0605, 0.0590),
  i_type = c(
    "effective",
    "nominal_interest",
    "force",
    "nominal_discount"
  ),
  m = c(1, 12, 1, 4)
)

alternatives |>
  mutate(
    i_effective = standardize_interest(
      i_type = i_type,
      i = i,
      m = m
    ),
    value_6y = future_value(
      C = 25000,
      i = i_effective,
      t = 6
    )
  )
```

This illustrates a central package pattern: standardize actuarial assumptions
first, then apply the same valuation function across scenarios.

### 2. Accumulate under a time-varying force of interest

`accumulation_factor()` can work with a conventional interest rate, a general
accumulation function, or a time-varying force of interest.

```r
delta_fun <- function(t) {
  0.03 + 0.004 * t
}

accumulation_factor(
  s = 2,
  t = 5,
  delta = delta_fun
)
```

For a force of interest \(\delta(t)\), the calculation corresponds to

\[
a(s,t)
=
\exp\left\{\int_s^t \delta(u)\,du\right\}.
\]

### 3. Build a general amortization schedule

The general loan engine supports level or non-level payments, period-specific
rates, extra principal, and payment rules.

```r
schedule <- amort_schedule_general(
  principal = 100000,
  n = 12,
  i = 0.12,
  i_type = "nominal_interest",
  m = 12,
  k = 12
)

schedule
```

A compact summary is also available:

```r
amort_schedule_general(
  principal = 100000,
  n = 60,
  i = 0.08,
  k = 12,
  output = "summary"
)
```

### 4. Price and inspect a coupon bond

```r
bond_cash_flows(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  R = 1000
)

bond_price(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  y = 0.06,
  y_type = "effective"
)
```

The same bond framework also includes yield, book value, callable-bond,
duration, and convexity calculations.


### 5. Move from bond valuation to duration and convexity

The bond tools extend naturally from price to interest-rate risk. For a single
bond, Macaulay duration, modified duration, and discrete convexity can be
computed from the same compact actuarial specification.

```r
bond_duration(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  y = 0.06,
  y_type = "effective"
)

bond_convexity(
  face = 1000,
  c = 0.05,
  n = 10,
  k = 2,
  y = 0.06,
  y_type = "effective"
)
```

For portfolio work, duration and convexity are implemented as summarise-style,
tibble-first functions. Each input row can represent a position and each output
row a portfolio.

```r
positions <- tibble(
  portfolio_id = c("A", "A", "A", "B", "B"),
  P = c(980, 1020, 995, 1500, 1200),
  D = c(2.8, 5.1, 8.4, 4.6, 7.2),
  C = c(9.7, 31.5, 79.2, 24.8, 58.1)
)

positions |>
  portfolio_duration(
    col_portfolio = "portfolio_id",
    col_P = "P",
    col_D = "D"
  )

positions |>
  portfolio_convexity(
    col_portfolio = "portfolio_id",
    col_P = "P",
    col_C = "C"
  )
```

This is the type of transition the package is designed to support: from an
individual actuarial formula to a portfolio-level workflow without changing the
underlying financial interpretation.

### 6. Move from a life table to a premium calculation

```r
lt <- data.frame(
  x = 40:90,
  lx = round(100000 * exp(-0.018 * (0:50)^1.35))
)
lt$lx[nrow(lt)] <- 0

premium_x(
  lt = lt,
  x = 40,
  i = 0.05,
  type = "term",
  benefit = 100000,
  n = 20,
  k = 12,
  n_prem = 10,
  output = "summary"
)
```

Contracts can also be assembled progressively:

```r
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
    n_prem = 10,
    timing = "due"
  ) |>
  premium_x(output = "summary")
```

## Reliability and development

The package source includes unit and regression tests under `tests/testthat/`.
The development roadmap is focused on strengthening automated checks, public
coverage reporting, high-level vignettes, and external use cases before
expanding the API further.

For reproducible work, use a released CRAN version when stability is the main
priority and the development branch when testing upcoming changes.

## Documentation

Function-level documentation and examples are available from R:

```r
help(package = "tidyactuarial")
?future_value
?amort_schedule_general
?bond_price
?bond_duration
?bond_convexity
?portfolio_duration
?premium_x
```

The package includes sample data for cash flows, loans, bonds, mortality, and
multiple-decrement workflows.

## Contributing and reporting problems

Bug reports and reproducible examples are welcome through GitHub Issues:

<https://github.com/JulianFajardo1908/tidyactuarial/issues>

When reporting a numerical issue, please include the function call, inputs,
expected actuarial result, observed result, and `sessionInfo()` whenever
possible.

## References

The package is grounded in standard actuarial mathematics and financial
mathematics. Useful references for the implemented topics include:

- Dickson, D. C. M., Hardy, M. R., & Waters, H. R. *Actuarial Mathematics for
  Life Contingent Risks*.
- Kellison, S. G. *The Theory of Interest*.
- Finan, M. B. *A Reading of the Theory of Life Contingencies*.

## License

MIT License. See `LICENSE` for details.
