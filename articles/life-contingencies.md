# Life Contingencies with tidyactuarial

## From financial value to actuarial value

Life-contingency mathematics adds one element to the financial
framework: a payment may depend on survival or death. The financial
discount factor still determines how money is moved through time, but it
must now be combined with a probability describing whether the payment
occurs.

For a life aged x, let {}\_tp_x denote the probability of surviving t
years. If

v = \frac{1}{1+i},

then a unit payment at time t, made only if the life survives, has
actuarial present value

{}\_tE_x = v^t\\{}\_tp_x.

This quantity is the **pure endowment factor**. It is the simplest
bridge between financial mathematics and life contingencies.

The same idea extends to annuities, insurance benefits, premiums, and
reserves. The objective of this vignette is to keep that progression
visible:

\text{life table} \longrightarrow \text{survival and death}
\longrightarrow \text{actuarial present values} \longrightarrow
\text{premium} \longrightarrow \text{reserve}.

The mathematics is written first. `tidyactuarial` is then used to
reproduce and audit the calculation.

## A small life table

For integer ages, a life table records the number l_x expected to
survive to exact age x. The basic one-year quantities are

p_x = \frac{l\_{x+1}}{l_x}, \qquad q_x = 1-p_x =
\frac{l_x-l\_{x+1}}{l_x}.

More generally, for an integer duration t,

{}\_tp_x = \frac{l\_{x+t}}{l_x}, \qquad {}\_tq_x = 1-{}\_tp_x.

We begin with a deliberately small table so every result can still be
checked by hand.

``` r

lt <- lifetable(
  x = 60:66,
  lx = c(
    100000,
    99000,
    97500,
    95500,
    93000,
    90000,
    86000
  ),
  close = FALSE,
  frac = "UDD"
)

lt
#> # A tibble: 7 × 6
#>       x     lx    dx     qx    px     mx
#>   <int>  <dbl> <dbl>  <dbl> <dbl>  <dbl>
#> 1    60 100000  1000 0.01   0.99  0.0101
#> 2    61  99000  1500 0.0152 0.985 0.0153
#> 3    62  97500  2000 0.0205 0.979 0.0207
#> 4    63  95500  2500 0.0262 0.974 0.0265
#> 5    64  93000  3000 0.0323 0.968 0.0328
#> 6    65  90000  4000 0.0444 0.956 0.0455
#> 7    66  86000 86000 1      0     2
```

For example,

{}\_3p\_{60} = \frac{l\_{63}}{l\_{60}} = \frac{95500}{100000} = 0.9550,

and therefore

{}\_3q\_{60} = 1-0.9550 = 0.0450.

The same quantities can be calculated directly with
[`t_px()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
and
[`t_qx()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_qx.md).

``` r

survival_audit <- tibble(
  duration = 0:5
) |>
  mutate(
    survival = t_px(
      lt = lt,
      x = 60,
      t = duration,
      frac = "UDD"
    ),
    death = t_qx(
      lt = lt,
      x = 60,
      t = duration,
      frac = "UDD"
    )
  )

survival_audit
#> # A tibble: 6 × 3
#>   duration survival  death
#>      <int>    <dbl>  <dbl>
#> 1        0    1     0     
#> 2        1    0.99  0.0100
#> 3        2    0.975 0.0250
#> 4        3    0.955 0.0450
#> 5        4    0.93  0.0700
#> 6        5    0.9   0.1
```

The pipe does not replace the actuarial formulas. It simply lets several
durations be evaluated in one transparent workflow.

## Actuarial discounting: the pure endowment

Suppose the annual effective interest rate is i=5\\. A payment of 1 at
time 5, conditional on survival of (60) to age 65, has value

{}\_5E\_{60} = v^5\\{}\_5p\_{60}.

Since

{}\_5p\_{60} = \frac{90000}{100000} = 0.9000,

we obtain

{}\_5E\_{60} = (1.05)^{-5}(0.9000) \approx 0.7052.

The manual calculation and the package calculation should agree.

``` r

i <- 0.05
v <- 1 / (1 + i)

pure_endowment_manual <- v^5 * 90000 / 100000

pure_endowment_package <- t_Ex(
  lt = lt,
  x = 60,
  t = 5,
  i = i,
  frac = "UDD"
)

tibble(
  method = c(
    "Manual",
    "tidyactuarial"
  ),
  value = c(
    pure_endowment_manual,
    pure_endowment_package
  )
)
#> # A tibble: 2 × 2
#>   method        value
#>   <chr>         <dbl>
#> 1 Manual        0.705
#> 2 tidyactuarial 0.705
```

Financial discounting and survival are not competing ideas. They are the
two components of the same actuarial present value.

## A temporary life annuity-due

Consider a 5-year temporary life annuity-due on (60) with unit annual
payments. Payments occur at times

0,1,2,3,4,

provided the life is alive at each payment date. Its actuarial present
value is

\ddot a\_{60:\overline{5}\|} = \sum\_{k=0}^{4} v^k\\{}\_kp\_{60}.

Using the life table directly,

\ddot a\_{60:\overline{5}\|} = 1 + v\frac{l\_{61}}{l\_{60}} +
v^2\frac{l\_{62}}{l\_{60}} + v^3\frac{l\_{63}}{l\_{60}} +
v^4\frac{l\_{64}}{l\_{60}}.

``` r

survival_0_4 <- lt$lx[1:5] / lt$lx[1]

annuity_manual <- sum(
  v^(0:4) * survival_0_4
)

annuity_package <- annuity_x(
  lt = lt,
  x = 60,
  i = i,
  n = 5,
  timing = "due",
  frac = "UDD"
)

tibble(
  method = c(
    "Manual",
    "tidyactuarial"
  ),
  apv = c(
    annuity_manual,
    annuity_package
  )
)
#> # A tibble: 2 × 2
#>   method          apv
#>   <chr>         <dbl>
#> 1 Manual         4.42
#> 2 tidyactuarial  4.42
```

The annuity value is approximately 4.4173. This is not the value of five
certain payments. Each future payment is discounted financially and
weighted by the probability that the life remains alive.

## A temporary life insurance

Now consider a 5-year term insurance on (60) with benefit 1 payable at
the end of the year of death.

The probability that death occurs in policy year k+1 is

{}\_kp\_{60}q\_{60+k} = \frac{l\_{60+k}-l\_{61+k}}{l\_{60}},

for k=0,\ldots,4. Therefore,

A^{1}\_{60:\overline{5}\|} = \sum\_{k=0}^{4} v^{k+1}
{}\_kp\_{60}q\_{60+k}.

``` r

death_0_4 <- (
  lt$lx[1:5] - lt$lx[2:6]
) / lt$lx[1]

insurance_manual <- sum(
  v^(1:5) * death_0_4
)

insurance_package <- insurance_x(
  lt = lt,
  x = 60,
  i = i,
  n = 5,
  type = "term",
  benefit = 1
)

tibble(
  method = c(
    "Manual",
    "tidyactuarial"
  ),
  apv = c(
    insurance_manual,
    insurance_package
  )
)
#> # A tibble: 2 × 2
#>   method           apv
#>   <chr>          <dbl>
#> 1 Manual        0.0845
#> 2 tidyactuarial 0.0845
```

For a benefit of 100,000, the actuarial present value of benefits is
simply

100000 A^{1}\_{60:\overline{5}\|}.

``` r

benefit <- 100000

insurance_x(
  lt = lt,
  x = 60,
  i = i,
  n = 5,
  type = "term",
  benefit = benefit
)
#> [1] 8447.935
```

## An actuarial identity as an audit

The temporary insurance, temporary annuity-due, and pure endowment
satisfy

A^{1}\_{x:\overline{n}\|} = 1 - d\\\ddot a\_{x:\overline{n}\|} -
{}\_nE_x,

where

d = \frac{i}{1+i}.

This identity is useful because the three quantities were obtained
through different calculations.

``` r

d <- i / (1 + i)

identity_value <- 1 -
  d * annuity_package -
  pure_endowment_package

tibble(
  direct_insurance = insurance_package,
  identity_value = identity_value,
  difference = insurance_package - identity_value
)
#> # A tibble: 1 × 3
#>   direct_insurance identity_value difference
#>              <dbl>          <dbl>      <dbl>
#> 1           0.0845         0.0845  -2.78e-16
```

The difference should be zero up to numerical precision. The point of
the audit is not to replace the theory with a test; it is to verify that
the separate implementations preserve the same actuarial identity.

## Net premium by the equivalence principle

Suppose the 5-year term insurance has benefit 100,000 and level annual
premiums payable in advance while the insured is alive, for at most five
years.

At issue, the equivalence principle requires

\operatorname{APV}(\text{premiums}) =
\operatorname{APV}(\text{benefits}).

If P is the annual net premium,

P\\ \ddot a\_{60:\overline{5}\|} = 100000 A^{1}\_{60:\overline{5}\|},

so

P = \frac{ 100000A^{1}\_{60:\overline{5}\|} }{ \ddot
a\_{60:\overline{5}\|} }.

The manual premium is therefore approximately 1,912.47.

``` r

premium_manual <- benefit *
  insurance_manual /
  annuity_manual

premium_package <- premium_x(
  lt = lt,
  x = 60,
  i = i,
  type = "term",
  benefit = benefit,
  n = 5,
  k = 1,
  n_prem = 5,
  timing = "due",
  output = "value"
)

tibble(
  method = c(
    "Manual",
    "tidyactuarial"
  ),
  premium = c(
    premium_manual,
    premium_package
  )
)
#> # A tibble: 2 × 2
#>   method        premium
#>   <chr>           <dbl>
#> 1 Manual          1912.
#> 2 tidyactuarial   1912.
```

For an audit-oriented result,
[`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md)
can also return the components of the equation of equivalence.

``` r

premium_x(
  lt = lt,
  x = 60,
  i = i,
  type = "term",
  benefit = benefit,
  n = 5,
  k = 1,
  n_prem = 5,
  timing = "due",
  output = "summary"
)
#> # A tibble: 1 × 6
#>   premium_annualized premium_per_payment payments_per_year apv_benefits
#>                <dbl>               <dbl>             <int>        <dbl>
#> 1              1912.               1912.                 1        8448.
#> # ℹ 2 more variables: apv_premium_annuity <dbl>, equivalence_residual <dbl>
```

This distinction is useful in actuarial work: a single value answers the
pricing question, while the summary exposes the quantities needed to
audit the result.

## Reserves: valuing the remaining contract

A premium determined at issue does not remain the appropriate measure of
the insurer’s obligation at later policy durations. Conditional on the
policy still being in force at duration t, the prospective reserve is

{}\_tV = \operatorname{APV}\_t (\text{future benefits}) - P\\
\operatorname{APV}\_t (\text{future premiums}).

Consider duration t=2, immediately before the premium due at that
duration. The insured is then age 62 and the contract has three years
remaining.

The remaining premium annuity is

\ddot a\_{62:\overline{3}\|},

and the remaining term-insurance value is

A^{1}\_{62:\overline{3}\|}.

Thus,

{}\_2V = 100000 A^{1}\_{62:\overline{3}\|} - P \ddot
a\_{62:\overline{3}\|}.

``` r

survival_62 <- lt$lx[3:5] / lt$lx[3]

annuity_62 <- sum(
  v^(0:2) * survival_62
)

death_62 <- (
  lt$lx[3:5] - lt$lx[4:6]
) / lt$lx[3]

insurance_62 <- sum(
  v^(1:3) * death_62
)

reserve_2_manual <- benefit *
  insurance_62 -
  premium_package *
  annuity_62

reserve_2_manual
#> [1] 1586.166
```

The same contract can be valued at several policy durations with
[`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md).

``` r

reserve_schedule <- reserve_x(
  lt = lt,
  x = 60,
  i = i,
  type = "term",
  n = 5,
  benefit = benefit,
  P = premium_package,
  k = 1,
  n_prem = 5,
  timing = "due",
  t = 0:5,
  method = "prospective",
  output = "summary"
)

reserve_schedule
#> # A tibble: 6 × 6
#>       t   age reserve premium_annualized premium_per_payment method     
#>   <int> <int>   <dbl>              <dbl>               <dbl> <chr>      
#> 1     0    60      0               1912.               1912. prospective
#> 2     1    61   1018.              1912.               1912. prospective
#> 3     2    62   1586.              1912.               1912. prospective
#> 4     3    63   1656.              1912.               1912. prospective
#> 5     4    64   1160.              1912.               1912. prospective
#> 6     5    65      0               1912.               1912. prospective
```

For this annual fully discrete contract, the recursive method provides a
second computational route.

``` r

reserve_x(
  lt = lt,
  x = 60,
  i = i,
  type = "term",
  n = 5,
  benefit = benefit,
  P = premium_package,
  k = 1,
  n_prem = 5,
  timing = "due",
  t = 0:5,
  method = "recursive",
  output = "summary"
)
#> # A tibble: 6 × 6
#>       t   age  reserve premium_annualized premium_per_payment method   
#>   <int> <int>    <dbl>              <dbl>               <dbl> <chr>    
#> 1     0    60 0                     1912.               1912. recursive
#> 2     1    61 1.02e+ 3              1912.               1912. recursive
#> 3     2    62 1.59e+ 3              1912.               1912. recursive
#> 4     3    63 1.66e+ 3              1912.               1912. recursive
#> 5     4    64 1.16e+ 3              1912.               1912. recursive
#> 6     5    65 9.40e-13              1912.               1912. recursive
```

The prospective and recursive approaches answer the same actuarial
question from different directions. Agreement between them is therefore
a substantive audit, not merely a software check.

## The same contract as a pipe workflow

The direct calculations above make each actuarial quantity explicit.
Once the contract is understood, the same specification can be
represented as a short workflow.

``` r

contract <- life_contract(
  lt = lt,
  lives = "single",
  x = 60,
  i = i
) |>
  add_insurance(
    type = "term",
    benefit = benefit,
    n = 5
  ) |>
  add_premium_schedule(
    k = 1,
    n_prem = 5,
    timing = "due"
  )

contract |>
  premium_x(
    output = "summary"
  )
#> # A tibble: 1 × 6
#>   premium_annualized premium_per_payment payments_per_year apv_benefits
#>                <dbl>               <dbl>             <int>        <dbl>
#> 1              1912.               1912.                 1        8448.
#> # ℹ 2 more variables: apv_premium_annuity <dbl>, equivalence_residual <dbl>
```

This is where a pipe is useful: it follows the actuarial construction of
the contract itself.

1.  Define the life and financial basis.
2.  Add the insurance benefit.
3.  Add the premium-payment schedule.
4.  Apply the equivalence principle.

The pipe is not used to hide the mathematics. It records the contract in
the same order in which the actuary specifies it.

## Moving to a benchmark life table

The small table above was useful because every quantity could be
reproduced manually. For realistic calculations, the same functions work
with larger tables.

`tidyactuarial` includes `soa08lt`, a tidy version of the SOA
Illustrative Life Table intended for reproducible actuarial examples and
benchmark calculations.

``` r

data("soa08lt")

soa08lt |>
  filter(
    x >= 60,
    x <= 65
  ) |>
  select(
    x,
    lx,
    dx,
    qx,
    px
  )
#> # A tibble: 6 × 5
#>       x     lx    dx     qx    px
#>   <int>  <dbl> <dbl>  <dbl> <dbl>
#> 1    60 81881. 1127. 0.0138 0.986
#> 2    61 80754. 1212. 0.0150 0.985
#> 3    62 79542. 1303. 0.0164 0.984
#> 4    63 78239. 1399. 0.0179 0.982
#> 5    64 76840. 1500. 0.0195 0.980
#> 6    65 75340. 1606. 0.0213 0.979
```

For example, a whole-life annuity-due and a whole-life insurance at age
65 can be valued without changing the mathematical language of the
previous sections.

``` r

tibble(
  quantity = c(
    "Whole-life annuity-due",
    "Whole-life insurance, benefit 100000"
  ),
  value = c(
    annuity_x(
      lt = soa08lt,
      x = 65,
      i = 0.05,
      timing = "due"
    ),
    insurance_x(
      lt = soa08lt,
      x = 65,
      i = 0.05,
      type = "whole",
      benefit = 100000
    )
  )
)
#> # A tibble: 2 × 2
#>   quantity                               value
#>   <chr>                                  <dbl>
#> 1 Whole-life annuity-due                  10.6
#> 2 Whole-life insurance, benefit 100000 49534.
```

The difference is scale, not principle.

## Final actuarial reading

The complete workflow can now be summarized without introducing new
formulas.

A life table provides survival and death probabilities. Financial
discounting moves each possible payment to the valuation date. Their
combination produces actuarial present values. The equivalence principle
converts those values into a premium, and the same valuation principle
applied at a later duration produces a reserve.

In symbols,

v^t \quad+\quad {}\_tp_x \quad\longrightarrow\quad {}\_tE_x,

and, more generally,

\text{discounting} + \text{mortality} \longrightarrow \text{APV}
\longrightarrow \text{premium} \longrightarrow \text{reserve}.

`tidyactuarial` keeps this progression reproducible while preserving the
actuarial structure of the calculation. The package is most useful after
the contract has been stated correctly: it does not replace the equation
of value, the mortality model, or the timing convention; it makes them
easier to calculate, compare, and audit.
