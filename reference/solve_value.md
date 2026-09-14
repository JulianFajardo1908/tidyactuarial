# Solve a scalar equation of value

Solves for one unknown scalar argument of an existing actuarial or
financial function. The remaining arguments are supplied through `args`,
and the unknown is chosen with `solve_for`.

## Usage

``` r
solve_value(
  fn,
  solve_for,
  target,
  args = list(),
  result = NULL,
  interval = NULL,
  start = NULL,
  derivative = NULL,
  method = c("auto", "uniroot", "newton"),
  multiple = c("error", "all", "first"),
  tol = 1e-10,
  maxiter = 1000L,
  scan_points = 401L,
  max_expand = 6L,
  output = c("value", "summary", "audit")
)
```

## Arguments

- fn:

  A function, or the name of a function, whose scalar result is to be
  matched to `target`.

- solve_for:

  Character scalar. Name of the scalar argument to solve for.

- target:

  Finite numeric scalar. Desired value of the selected result.

- args:

  Named list containing all known arguments passed to `fn`. Do not
  supply a non-`NULL` value for the argument named in `solve_for`.

- result:

  Optional result extractor. Use `NULL` when `fn` returns a numeric
  scalar; a character scalar naming a column or list element; or a
  function that extracts a numeric scalar from the object returned by
  `fn`.

- interval:

  Optional finite numeric vector of length 2. It defines the admissible
  search interval. When omitted, a conservative interval is inferred
  from `solve_for`, `target`, and the numeric values in `args`.

- start:

  Optional finite numeric scalar used as the initial value for
  Newton–Raphson. It is also used as a fallback starting point when
  `method = "auto"` cannot bracket a root.

- derivative:

  Optional function of one argument returning the derivative of the
  equation residual with respect to the unknown. When omitted under
  Newton–Raphson, a central finite-difference derivative is used.

- method:

  Character scalar. One of `"auto"`, `"uniroot"`, or `"newton"`. The
  default first searches for bracketed roots and uses Newton–Raphson
  only when no bracket is found and `start` is available.

- multiple:

  Character scalar controlling multiple roots found inside the interval:
  `"error"`, `"all"`, or `"first"`.

- tol:

  Positive numeric scalar. Convergence and residual tolerance.

- maxiter:

  Positive integer. Maximum number of iterations.

- scan_points:

  Positive integer. Number of points used to detect sign changes and
  possible multiple roots.

- max_expand:

  Nonnegative integer. Maximum number of automatic interval expansions
  when an interval was inferred and a bracket is not found initially. An
  interval supplied explicitly by the user is never expanded.

- output:

  Character scalar. One of `"value"`, `"summary"`, or `"audit"`.

## Value

Depending on `output`:

- `"value"`: numeric scalar or vector containing the solution(s).

- `"summary"`: compact tibble with the unknown, solution, target,
  achieved value, residual, and method.

- `"audit"`: detailed tibble with convergence diagnostics and search
  information.

## Details

The equation solved is \$\$g(x) = f(\ldots, x, \ldots) - \mathrm{target}
= 0,\$\$ where `f` is the function supplied in `fn` and `x` is the
argument named in `solve_for`.

This function is intended to reuse the stable calculation functions
already available in tidyactuarial. It does not reproduce their
actuarial formulas.

`solve_value()` is restricted to one scalar unknown. It is appropriate
for quantities such as an effective interest rate, a payment, a
principal, a present value, or another continuous scalar parameter.

Bracketed root finding is preferred because it is generally more stable
than an unconstrained Newton iteration. The interval is scanned before
solving; therefore, possible multiple roots can be detected. This is
important for non-monotone equations of value.

Discrete unknowns, such as an integer number of payments, should not be
solved by pretending they are continuous. A dedicated discrete solver or
a model-specific wrapper should be used for those cases.

## See also

[`stats::uniroot()`](https://rdrr.io/r/stats/uniroot.html),
[`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`a_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md)

Other time-value:
[`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md),
[`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md),
[`future_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md),
[`fv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md),
[`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md),
[`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md),
[`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md),
[`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md),
[`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md)

## Examples

``` r
# Solve for the annual effective rate
solve_value(
  fn = present_value,
  solve_for = "i",
  target = 8000,
  args = list(
    C = 10000,
    t = 5,
    i_type = "effective"
  ),
  interval = c(0, 0.20)
)
#> [1] 0.04563955

# Solve for a level annuity payment. Because a_angle(tidy = TRUE)
# returns a tibble, select the present_value column explicitly.
solve_value(
  fn = a_angle,
  solve_for = "payment",
  target = 100000,
  args = list(
    n = 10,
    i = 0.05,
    timing = "immediate",
    tidy = TRUE
  ),
  result = "present_value",
  interval = c(0, 20000),
  output = "summary"
)
#> # A tibble: 1 × 6
#>   solve_for solution target achieved residual method 
#>   <chr>        <dbl>  <dbl>    <dbl>    <dbl> <chr>  
#> 1 payment     12950. 100000   100000        0 uniroot

# Newton--Raphson for a simple custom equation
solve_value(
  fn = function(x) x^2,
  solve_for = "x",
  target = 2,
  start = 1,
  interval = c(0, 2),
  method = "newton"
)
#> [1] 1.414214
```
