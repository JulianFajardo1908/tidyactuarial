# Actuarial present value of a payment stream under mortality

Computes the actuarial present value (APV) of a cash-flow stream
contingent on survival. The life table is supplied as the first argument
(pipe-friendly). Payments may be specified by numeric times or by
calendar dates.

## Usage

``` r
apv_life_flow(
  lt,
  ages,
  t = NULL,
  date = NULL,
  date0 = NULL,
  cf,
  i,
  i_type = "effective",
  m = 1L,
  status = c("single", "first", "last", "reversionary"),
  alpha = NULL,
  plot = FALSE
)
```

## Arguments

- lt:

  A life table data frame with column `x` and at least one of `lx`,
  `px`, or `qx`.

- ages:

  Integer vector of actuarial ages. Use length 1 for a single life and
  length 2 or more for multiple lives.

- t:

  Numeric vector of payment times in years, measured from time 0.
  Provide either `t` or `date`.

- date:

  Optional vector of `Date` payment dates. Provide either `t` or `date`.

- date0:

  Optional `Date` used as time 0 when `date` is provided. If missing,
  the minimum of `date` is used.

- cf:

  Numeric vector of cash flows. Must have the same length as `t` or
  `date`.

- i:

  Numeric scalar. Annual interest-rate input.

- i_type:

  Character string indicating the interest-rate type. Allowed values are
  `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and
  `"force"`.

- m:

  Positive integer. Conversion frequency for nominal rates. Ignored for
  `i_type = "effective"` and `i_type = "force"`.

- status:

  Survival status: `"single"`, `"first"`, `"last"`, or `"reversionary"`.

- alpha:

  Reversionary fraction for `status = "reversionary"`. While all lives
  are alive, full benefit is paid; while at least one but not all are
  alive, `alpha` times the benefit is paid.

- plot:

  Logical. If `TRUE`, attaches a ggplot object in `attr(result, "plot")`
  showing cumulative APV over time.

## Value

A tibble with one row per payment and columns: `t`, `cf`, `surv_prob`,
`discount`, `expected_cf`, `pv`, and `pv_cum`. If `date` was provided, a
`date` column is included. The total APV is stored as
`attr(result, "apv")`.

## Details

Multiple lives are supported under an independence assumption, through
common statuses: single-life, first-death (all alive), last-survivor
(any alive), and reversionary (joint-and-survivor) with fraction
`alpha`.

This function follows the compact actuarial notation used throughout
`tidyactuarial`: `t` denotes payment time, `cf` denotes cash flows, `i`
denotes the interest rate, `i_type` denotes the interest-rate type, and
`m` denotes the conversion frequency for nominal rates.

For each payment at time \\t\\, the APV contribution is \$\$PV(t) = C(t)
v^t P(\text{status alive at } t).\$\$

The survival probability depends on the `status`:

- `"single"`: \\{}\_t p_x\\ for a single life.

- `"first"`: \\{}\_t p\_{x_1} \cdot {}\_t p\_{x_2} \cdots\\, so all
  lives must be alive.

- `"last"`: \\1 - \prod_j (1 - {}\_t p\_{x_j})\\, so at least one life
  must be alive.

- `"reversionary"`: full benefit while all lives are alive, and fraction
  \\\alpha\\ while at least one but not all lives are alive.

Fractional-year survival is computed under UDD within each year.

## Examples

``` r
lt <- data.frame(
  x = 40:100,
  lx = seq(100000, 0, length.out = 61)
)

apv_life_flow(
  lt = lt,
  ages = 40,
  t = c(1, 2, 3),
  cf = c(100, 100, 100),
  i = 0.05
)
#> # A tibble: 3 × 7
#>       t    cf surv_prob discount expected_cf    pv pv_cum
#>   <dbl> <dbl>     <dbl>    <dbl>       <dbl> <dbl>  <dbl>
#> 1     1   100     0.983    0.952        98.3  93.7   93.7
#> 2     2   100     0.967    0.907        96.7  87.7  181. 
#> 3     3   100     0.95     0.864        95    82.1  263. 

apv_life_flow(
  lt = lt,
  ages = c(60, 58),
  t = c(1, 2, 3),
  cf = c(100, 100, 100),
  i = 0.05,
  status = "first"
)
#> # A tibble: 3 × 7
#>       t    cf surv_prob discount expected_cf    pv pv_cum
#>   <dbl> <dbl>     <dbl>    <dbl>       <dbl> <dbl>  <dbl>
#> 1     1   100     0.952    0.952        95.2  90.6   90.6
#> 2     2   100     0.905    0.907        90.5  82.1  173. 
#> 3     3   100     0.859    0.864        85.9  74.2  247. 
```
