# Calculate moments of a frequency or severity distribution

Calculates raw, central, factorial, or cumulant moments from an existing
frequency or severity specification. The calculation is deterministic:
it does not fit a model, generate observations, or approximate moments
using simulation or numerical integration.

## Usage

``` r
distribution_moments(x, order = 1:4, type = "raw")
```

## Arguments

- x:

  A `tidyact_frequency_spec` or `tidyact_severity_spec` object.

- order:

  Nonempty numeric vector of nonnegative integer moment orders. For
  cumulants, all orders must be positive.

- type:

  One of `"raw"` (default), `"central"`, `"factorial"`, or `"cumulant"`.
  Factorial moments are available only for frequency specifications.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with one row per requested order and columns: `type` (character),
`order` (integer), `value` (double), and `status` (character). Input
order and repeated orders are preserved. Undefined values are returned
as `NA_real_`.

## Details

For a random variable \\Z\\, the raw and central moments are \$\$m_r =
E\[Z^r\], \qquad \mu_r = E\[(Z-E\[Z\])^r\].\$\$

For a nonnegative integer-valued frequency \\N\\, the factorial moment
is \$\$E\[(N)\_r\], \qquad (N)\_r=N(N-1)\cdots(N-r+1).\$\$

Cumulants are calculated algebraically from raw moments. In particular,
\\\kappa_1=E\[Z\]\\, \\\kappa_2=\mathrm{Var}(Z)\\, and
\\\kappa_3=E\[(Z-E\[Z\])^3\]\\ when the relevant moments are finite.

Moment order zero is one for raw, central, and factorial moments.
Cumulants start at order one.

All built-in distributions use their registered analytical raw or
factorial moment functions. A custom specification must explicitly
supply `raw_moment` or (for a frequency) `factorial_moment` to provide a
moment calculation; supplying only a PMF or PDF does not trigger
numerical integration or summation. Raw and factorial frequency moments
can be converted into one another using Stirling numbers when the
necessary source moments are available.

The `status` column distinguishes:

- `"finite"`: a finite numerical result;

- `"infinite"`: a mathematically divergent moment;

- `"undefined"`: the moment is not defined or the specification does not
  provide sufficient information to evaluate it;

- `"overflow"`: a theoretically finite moment or an intermediate
  algebraic expression exceeds the available floating-point range.

For built-in Pareto II, Burr XII, and log-logistic severities,
divergence is determined from the distribution's analytical
moment-existence condition. For custom distributions, an explicitly
returned positive `Inf` is interpreted as mathematical divergence;
custom moment functions are responsible for this distinction.

A central moment of positive order requires a finite mean. When the mean
exists but a higher-order moment diverges, the corresponding central
moment is infinite. Higher-order cumulants are reported as undefined if
the moments needed for their definition are infinite. The first cumulant
follows the first raw moment.

Central moments and cumulants derived from raw moments may suffer from
cancellation for extremely large parameter values. Such arithmetic is
not silently replaced by a simulated or approximated answer.

## References

Bowers, N. L., Gerber, H. U., Hickman, J. C., Jones, D. A., and Nesbitt,
C. J. (1997). *Actuarial Mathematics*, 2nd ed. Society of Actuaries.

## See also

[`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md),
[`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md)

## Examples

``` r
# Raw and central moments of a claim count distribution.
counts <- frequency_spec("poisson", lambda = 4)
distribution_moments(counts)
#> # A tibble: 4 × 4
#>   type  order value status
#>   <chr> <int> <dbl> <chr> 
#> 1 raw       1     4 finite
#> 2 raw       2    20 finite
#> 3 raw       3   116 finite
#> 4 raw       4   756 finite
distribution_moments(counts, order = 1:4, type = "central")
#> # A tibble: 4 × 4
#>   type    order value status
#>   <chr>   <int> <dbl> <chr> 
#> 1 central     1     0 finite
#> 2 central     2     4 finite
#> 3 central     3     4 finite
#> 4 central     4    52 finite
distribution_moments(counts, order = 0:4, type = "factorial")
#> # A tibble: 5 × 4
#>   type      order value status
#>   <chr>     <int> <dbl> <chr> 
#> 1 factorial     0     1 finite
#> 2 factorial     1     4 finite
#> 3 factorial     2    16 finite
#> 4 factorial     3    64 finite
#> 5 factorial     4   256 finite
distribution_moments(counts, order = 1:4, type = "cumulant")
#> # A tibble: 4 × 4
#>   type     order value status
#>   <chr>    <int> <dbl> <chr> 
#> 1 cumulant     1     4 finite
#> 2 cumulant     2     4 finite
#> 3 cumulant     3     4 finite
#> 4 cumulant     4     4 finite

# Raw moments of a nonnegative claim amount.
loss <- severity_spec("gamma", shape = 2.5, rate = 0.001)
distribution_moments(loss, order = 1:4)
#> # A tibble: 4 × 4
#>   type  order   value status
#>   <chr> <int>   <dbl> <chr> 
#> 1 raw       1 2.5 e 3 finite
#> 2 raw       2 8.75e 6 finite
#> 3 raw       3 3.94e10 finite
#> 4 raw       4 2.17e14 finite

# The mean exists but the variance does not.
heavy_tail <- severity_spec("pareto", shape = 1.5, scale = 2000)
distribution_moments(heavy_tail, order = 1:4)
#> # A tibble: 4 × 4
#>   type  order value status  
#>   <chr> <int> <dbl> <chr>   
#> 1 raw       1  4000 finite  
#> 2 raw       2   Inf infinite
#> 3 raw       3   Inf infinite
#> 4 raw       4   Inf infinite
distribution_moments(heavy_tail, order = 1:4, type = "central")
#> # A tibble: 4 × 4
#>   type    order value status  
#>   <chr>   <int> <dbl> <chr>   
#> 1 central     1     0 finite  
#> 2 central     2   Inf infinite
#> 3 central     3   Inf infinite
#> 4 central     4   Inf infinite

# A nonrandom payment has zero central moments of positive order.
fixed <- severity_spec("degenerate", value = 1000)
distribution_moments(fixed, order = 1:4, type = "central")
#> # A tibble: 4 × 4
#>   type    order value status
#>   <chr>   <int> <dbl> <chr> 
#> 1 central     1     0 finite
#> 2 central     2     0 finite
#> 3 central     3     0 finite
#> 4 central     4     0 finite
```
