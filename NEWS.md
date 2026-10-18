# tidyactuarial 0.2.0

## Bug fixes

* Spot discount and forward calculations retain original log growth rates,
  avoiding overflowed power ratios and preserving small rates and flat curves
  across intervals with large common origins. Linear interpolation remains
  on annual effective spot rates.
* Par coupon rates separate monetary scale from discount sums and preserve
  small positive or negative coupons instead of rounding them to zero.
* Missing spot curves keep their plot list positions; forward intervals with
  missing start times now follow the requested missing-value policy.

* Bond book values retain original log yields when valuing remaining payments.
  Callable scenarios pass the original yield specification to pricing rather
  than an effective equivalent that may have rounded to -1 or overflowed.
* Callable dates must identify distinct coupon periods strictly inside
  maturity after alignment; nonrepresentable period counts are rejected before
  integer conversion in book-value and callable schedules.
* Approved API decision C05: callable `is_worst_case` now marks exactly the
  computed minimum price and all exact computed ties. Calendar tolerance no
  longer determines monetary near ties. Arguments and columns are unchanged.

* Bond prices retain original log yields and recover representable discounted
  amounts when intermediate powers overflow or underflow. Coupon schedules and
  accrued interest also recover finite coupons from overflowing products.
* Bond yields use a stable log price equation, avoiding bracket failures on
  ordinary long bonds and dependence on currency scale. Automatic brackets
  cover representable yields above -1; exhausted iterations now cause an error.
  Nonfinite tolerances, intervals and unsupported integer indices are rejected.
  Public arguments and result columns are preserved.

* General amortization now identifies negative amortization under advance
  payments when accrued interest exceeds regular and extra payments combined.
* Named extra-payment periods are checked before integer conversion, preventing
  fractional names from silently assigning prepayments to the wrong period.
* Loan schedules require finite balance tolerances and reject nonrepresentable
  calculated payments or monetary ledgers explicitly. General level payments
  use a log discount sum to preserve finite payments when discounts overflow.

* Arithmetic annuities retain original log rates and recover representable
  monetary products when standalone factors lose range, preserving signed
  and known zero payments.
* Geometric annuities use stable log sums instead of subtracting nearly equal
  rates or accumulation levels. Small interest-growth spreads are retained
  before period conversion, and convergent perpetuities no longer face an
  arbitrary rate-gap cutoff. Missing finite terms propagate missing values.

* Level annuities retain original log interest rates, small-rate effects over
  long terms and representable monetary values when standalone factors lose
  range. Strictly positive perpetuity rates no longer face an arbitrary cutoff.
* Loan payments and sinking-fund deposits no longer use monetary balance
  tolerances to classify rates as zero. Period rates and variable-rate discount
  factors use original log growth. Public signatures and columns are preserved.
* s_angle documentation now identifies the existing horizon as the end of
  the term, one payment interval after the final due payment.

* solve_value now has an approved trailing argument `residual_tol = tol`,
  separating result-unit residual accuracy from unknown-coordinate accuracy.
  Audit convergence uses this explicit threshold without a hidden floor.
  Exhausting uniroot iterations is now an error. Existing positional arguments
  and output columns are preserved; an audit flag can become more stringent.

* Present/future cash-flow totals and inferred plot present values recover
  cancellation of overflowing terms with exactly equal finite log factors.
  Representable ordinary sums retain their existing evaluation; unequal-factor
  extreme cancellation remains outside this recovery rule.

* Basic cash-flow valuations recover representable signed capital-factor
  products even when a separate factor overflows, underflows or is subnormal.
  Known zero payments stay zero without converting missing inputs to zero.
* Newton solving now requires a small correction as well as a small residual;
  tiny residual units or a boundary-clipped step no longer imply convergence.
  Nonzero derivatives are no longer discarded by an absolute scale threshold.
* Cash-flow plot present values now use the corrected financial basis.
  Unrepresentable aggregate amounts and inferred present values are rejected;
  tabular pipes, negative numeric timelines and editable ggplots are preserved.

* IRR searches no longer classify small monetary NPVs as grid roots.
  Positive rescaling preserves roots across monetary units, sign checks
  avoid residual products, and reported NPVs retain the original currency.
  Scaling that would erase a nonzero cash flow is rejected explicitly.
* solve_value interval scans now refine sign-changing brackets rather than
  treating all residuals below an absolute tolerance as distinct grid roots.

* Interval factors, equivalent-rate tables and basic cash-flow valuations
  retain the original log accumulation rate when an annual effective
  equivalent rounds to -1 or overflows. Interval discounts no longer require
  a representable reciprocal accumulation. Future cash-flow ratios avoid
  overflow of their separate accumulation levels. Public schemas are retained;
  extreme annual-equivalent audit fields may still display -1 or Inf.

* Rate conversions and accumulation/spot discount factors retain precision
  near zero using log1p and expm1. Small positive or negative rates no longer
  collapse to zero before conversion or lose their effect over long terms.
  Missing rate conventions now propagate missing equivalents as documented.

* Deferred two-life insurance now retains survival conditioning from issue.
  Last-survivor continuation includes paths with only one survivor at the
  end of deferment, instead of restarting both lives at advanced ages.
  Its annuity and maturity-survival audit values use the same conditioning.

* Fractional deferred Monte Carlo annuities now anchor their payment grid
  at the deferment rather than issue time. Non-grid-aligned deferments no
  longer omit eligible payments; the shared reserve calendar is corrected too.
* Negative-binomial and geometric frequency thinning now avoids intermediate
  overflow for tiny original `prob`. Conversions that would round a positive
  payment frequency to zero now fail explicitly and retain the per-loss
  model as the available representation.

* Internal development instructions and audit records are excluded from
  source-package archives.

* Life-contingent Monte Carlo insurance, annuity and reserve calculations
  now reject noninteger or infinite curtate lifetimes, infinite complete
  lifetimes, and observed pairs inconsistent with K <= T < K + 1.
  Missing values retain their existing meaning. Certain annuities remain
  independent of lifetime values. A shared internal validator prevents
  chained valuations from accepting contradictory versions of the same life.

* Monte Carlo life annuities now preserve missing lifetime information as
  missing present values and payment counts, instead of zero payments.
  Certain annuities remain independent of lifetime data.
* Fractional Monte Carlo annuity schedules now compare payment grid dates
  directly with the complete lifetime. A fixed epsilon no longer removes
  payments just before death or introduces payments just after death.
  Existing exact-death endpoint conventions are preserved.
* Guaranteed fractional annuities retain their guaranteed payments even
  when death occurs at time zero. The shared payment schedule also serves
  Monte Carlo reserve and fractional annuity simulation calculations.

* Last-survivor recursive reserves now use backward recursion across the
  both-alive and each single-survivor state. The previous scalar recursion
  mixed these conditioning states and disagreed with prospective reserves.
  Documentation explicitly conditions reserve_xy() on both lives being alive
  at valuation. Joint-life recursion and public output columns are preserved.
* Constant-force fractional lifetime simulation now evaluates log(1-q) using
  log1p(-q). Tiny positive mortality probabilities no longer round the
  denominator to zero and collapse conditional death times to the year start.

* Discrete VaR now compares the requested level directly with cumulative
  probabilities, without shifting it by an absolute epsilon. Levels just
  above an atom or the represented aggregate mass no longer select the
  previous atom or slip into an uncomputed tail.
* VaR from FFT aggregates now checks whether omitted claim-count probability
  could change the selected quantile, using the minimum possible loss of
  omitted counts. Ambiguous quantiles are rejected with advice to reduce
  `tol`. Documentation distinguishes unrepresented mass from an upper loss
  tail: omitted large counts can still produce small aggregate losses.

* Aggregate distributions now infer decimal lattices relative to the severity
  magnitude and merge support points using relative monetary tolerances.
  Small monetary units no longer collapse distinct losses into zero, and
  convolution/FFT `max_loss` cutoffs respect the same scale. Strictly positive
  masses below 1e-18 are retained rather than silently discarded.
* Stop-loss premiums for covered exponential per-loss severities now use
  closed forms for ordinary and franchise deductibles, inflation, coinsurance,
  and finite or infinite limits. Very large limits no longer produce spurious
  zero premiums through quadrature. Their reported method changes from
  `numerical_survival` to `closed_form`; TVaR uses the corrected premiums too.

* Immunization functions now use relative checks for liability present values
  and two-asset duration degeneracy, avoiding rejection of valid portfolios
  solely because of monetary units or small asset prices. Non-finite
  liability valuations and sensitivities are rejected explicitly.
* Immunization systems with more assets than moment constraints now use row-scaled singular
  value decomposition for the minimum-norm asset units, instead of normal
  equations that could falsely classify distinct sensitivities as singular.
* Clarified that `immunize_duration_convexity()` requires convexity with
  respect to the annual effective yield. The coupon-frequency-scaled
  `bond_convexity()` output generally uses a different yield variable;
  documentation now gives the chain-rule conversion. Bond output meanings
  are preserved. Examples now use convexities on the liability yield basis.

* Corrected complete `e_xy(..., cohort = "last")` calculations to preserve
  conditioning on both lives being alive at the initial ages. Annual
  integration now uses survival from those original ages, including paths
  with only one survivor, instead of restarting both lives each year.
  Adaptive quadrature replaces the fixed trapezoid grid for both cohorts.
  Missing initial ages and zero initial survivors return `NA` consistently.
* `t_px()` now obtains integer survival directly from `lx`, including at
  the last recorded age, without requiring a next-year probability.
  An extinct attained cohort has zero survival even when its fractional
  probability is undefined. This also prevents spurious `NA` in `e_xy()`.

* Corrected `mortality_law_table("HeligmanPollard", ...)` to the classical
  eight-parameter odds model. `H` is now required; `C` is the childhood
  exponent, `D`/`E`/`F_hp` describe the accident hump, and `G`/`H` describe
  old-age mortality. Previous seven-parameter calls must be respecified;
  adding `H` to the old values is insufficient. The existing `F` alias
  denotes the same parameter as `F_hp`. Log-space evaluation avoids
  undefined probabilities when odds overflow.
* Beta-law conditional probabilities now use log upper-tail survival,
  avoiding premature `qx = 1` when survival is small.
* Mortality-law tables now compute `mx = dx / Lx` and `ex = Tx / lx`
  without artificial denominator floors. Zero-exposure positive deaths
  give `Inf`; undefined `0/0` ratios for extinct cohorts give `NaN`.

* `mortality_law_table()` now derives annual death probabilities from the
  integrated continuous force of mortality, independently of `frac`.
  This changes Gompertz, Makeham, Weibull and Logistic results and the former
  UDD/Balducci conversions. `mu_x` remains the force at integer age;
  `a_x` still controls the exposure approximation. Direct `qx` laws and
  forced terminal closure retain their existing behavior.

* Corrected `lifetable()` conversions between `mx` and `qx` for `ax != 0.5`,
  using the mean fraction of the year lived by those who die. This correction
  can change previous actuarial results; results for `ax = 0.5` are preserved.

# tidyactuarial 0.1.6

## Bug fixes

* Fixed the construction of the cumulative distribution function used by
  `simulate_lifetime()` to prevent platform-dependent numerical failures
  when floating-point accumulation produces values slightly greater than one.

* Added a regression test for the multiple-life simulation workflow using
  `simulate_lifetimes()`, `mc_multilife_status()`, and `mc_annuity()`.

* This release addresses the errors reported by CRAN on macOS ARM64.

# tidyactuarial 0.1.5

* Fixed the multiple-life Monte Carlo workflow used in the `mc_annuity()` examples.
* `simulate_lifetimes()` now constructs lifetime simulations defensively when mortality inputs contain invalid terminal values.
* `mc_multilife_status()` now uses defaults compatible with `simulate_lifetimes()`: `sim_id`, `life_id`, `Kx`, and `Tx`.
* Added a regression test for the full multiple-life simulation workflow.
