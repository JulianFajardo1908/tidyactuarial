# Package index

## Financial Mathematics and Interest Rates

Accumulation, discounting, equivalent rates, equations of value,
cash-flow valuation, and internal rates of return.

- [`accumulation_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accumulation_factor.md)
  : Accumulation factor under conventional or time-varying interest
- [`discount_factor()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor.md)
  : Discount factor under conventional or time-varying interest
- [`standardize_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/standardize_interest.md)
  : Standardize an interest rate to the annual effective rate i
- [`interest_equivalents()`](https://julianfajardo1908.github.io/tidyactuarial/reference/interest_equivalents.md)
  : Equivalent interest rates in FM actuarial notation
- [`present_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/present_value.md)
  : Present value of a single payment
- [`future_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/future_value.md)
  : Future value of a single payment
- [`pv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/pv_flow.md)
  : Present value of a general cash flow
- [`fv_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/fv_flow.md)
  : Future value of a general cash flow
- [`solve_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/solve_value.md)
  : Solve a scalar equation of value
- [`irr_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow.md)
  : Internal rate of return for a cash flow
- [`irr_flow_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/irr_flow_multi.md)
  : Multiple internal rates of return for a cash flow
- [`plot_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_cash_flow.md)
  : Plot a cash-flow diagram

## Annuities and Loans

Level and varying annuities, amortization schedules, and loan repayment.

- [`a_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/a_angle.md)
  : Level annuity factor a-angle-n
- [`s_angle()`](https://julianfajardo1908.github.io/tidyactuarial/reference/s_angle.md)
  : Level annuity accumulation factor s-angle-n
- [`annuity_arith()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_arith.md)
  : Arithmetic annuity factor
- [`annuity_geom()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_geom.md)
  : Geometric annuity factor
- [`amort_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule.md)
  : Amortization schedule with optional prepayment adjustment
- [`amort_schedule_general()`](https://julianfajardo1908.github.io/tidyactuarial/reference/amort_schedule_general.md)
  : General amortization schedule with variable rates and payments
- [`sinking_fund_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/sinking_fund_schedule.md)
  : Sinking fund amortization schedule for a loan

## Bonds, Duration, Convexity, and Immunization

Bond valuation, yield, book value, callable bonds, duration, convexity,
portfolio measures, and immunization.

- [`bond_cash_flows()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_cash_flows.md)
  : Cash flow structure of a level coupon bond
- [`accrued_interest()`](https://julianfajardo1908.github.io/tidyactuarial/reference/accrued_interest.md)
  : Accrued coupon interest and clean/dirty bond prices
- [`bond_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_price.md)
  : Price of a level coupon bond from its yield
- [`bond_ytm()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_ytm.md)
  : Yield to maturity of a level coupon bond
- [`bond_book_value()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_book_value.md)
  : Book value of a level coupon bond at a coupon date
- [`bond_callable_price()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_callable_price.md)
  : Price of a callable bond at a target minimum yield
- [`duration_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/duration_cash_flow.md)
  : Duration of a general cash-flow stream
- [`convexity_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/convexity_cash_flow.md)
  : Convexity of a general cash-flow stream
- [`bond_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_duration.md)
  : Macaulay and modified duration of a level coupon bond under a flat
  yield
- [`bond_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bond_convexity.md)
  : Discrete convexity of a level coupon bond under a flat yield
- [`portfolio_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_duration.md)
  : Compute portfolio duration as a market-value-weighted average
- [`portfolio_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/portfolio_convexity.md)
  : Compute portfolio convexity as a market-value-weighted average
- [`immunize_duration()`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration.md)
  : Duration-based immunization with multiple assets
- [`immunize_duration_convexity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/immunize_duration_convexity.md)
  : Duration and convexity immunization with multiple assets
- [`plot_immunization_gap()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_immunization_gap.md)
  : Plot immunization performance under interest-rate shifts

## Term Structure of Interest Rates

Spot discount factors, yield curves, and forward rates.

- [`discount_factor_spot()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discount_factor_spot.md)
  : Spot discount factor
- [`yield_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/yield_curve.md)
  : Validate a yield curve and compute discount factors
- [`forward_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_rate.md)
  : Compute an implied forward rate from a discrete spot curve
- [`bootstrap_spot_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/bootstrap_spot_curve.md)
  : Bootstrap a spot yield curve from instrument prices
- [`forward_curve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/forward_curve.md)
  : Construct a forward-rate curve from spot rates
- [`par_rate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/par_rate.md)
  : Par coupon rate implied by a spot yield curve

## Life Tables and Survival

Life-table construction, mortality laws, Kaplan-Meier estimation,
survival probabilities, life expectancy, and commutation functions.

- [`lifetable()`](https://julianfajardo1908.github.io/tidyactuarial/reference/lifetable.md)
  : Build an annual life table (tidy tibble) from lx, qx, px, or mx
- [`mortality_law_table()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mortality_law_table.md)
  : Generate a tidy life table from a theoretical mortality law
- [`km_lifetable()`](https://julianfajardo1908.github.io/tidyactuarial/reference/km_lifetable.md)
  : Kaplan–Meier survival curve and a lifetable-style life table
- [`plot_km()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_km.md)
  : Plot a Kaplan–Meier survival curve
- [`t_px()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
  : t-year survival probability from a life table
- [`t_qx()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_qx.md)
  : t-year death probability from a life table
- [`t_Ex()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_Ex.md)
  : Pure endowment (discounted survival): \\{}\_tE_x\\
- [`e_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_x.md)
  : Expected future lifetime from an annual life table
- [`commutation_table()`](https://julianfajardo1908.github.io/tidyactuarial/reference/commutation_table.md)
  : Build an annual commutation table (discrete ages)

## Single-Life Contingencies

Life annuities, life insurance, premiums, reserves, and contract
workflows for a single life.

- [`life_contract()`](https://julianfajardo1908.github.io/tidyactuarial/reference/life_contract.md)
  : Create a life-contingency contract specification
- [`add_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_insurance.md)
  : Add an insurance benefit specification to a life contract
- [`add_premium_schedule()`](https://julianfajardo1908.github.io/tidyactuarial/reference/add_premium_schedule.md)
  : Add a contingent premium-payment schedule to a life contract
- [`annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_x.md)
  : Actuarial present value of a life annuity
- [`insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_x.md)
  : Actuarial present value of a life insurance
- [`insurance_variable_k()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_variable_k.md)
  : Actuarial present value of a life insurance with variable k-thly
  benefits
- [`apv_life_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/apv_life_flow.md)
  : Actuarial present value of a payment stream under mortality
- [`plot_contingent_cash_flow()`](https://julianfajardo1908.github.io/tidyactuarial/reference/plot_contingent_cash_flow.md)
  : Plot discrete life-contingent cash flows
- [`premium_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_x.md)
  : Net premium for single-life insurance by the equivalence principle
- [`premium_gross()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_gross.md)
  : Gross premium under a simple expense-loaded equivalence principle
- [`reserve_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_x.md)
  : Benefit reserves for single-life insurance

## Multiple-Life Contingencies

Joint-life, last-survivor, and multi-life survival and contingent
values.

- [`t_pxy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_pxy.md)
  : Two-life survival probability for independent lives
- [`e_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/e_xy.md)
  : Expected future lifetime for two independent lives
- [`annuity_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_xy.md)
  : Actuarial present value of a two-life annuity
- [`insurance_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xy.md)
  : Actuarial present value of a two-life insurance
- [`premium_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/premium_xy.md)
  : Net premium for two-life insurance by the equivalence principle
- [`reserve_xy()`](https://julianfajardo1908.github.io/tidyactuarial/reference/reserve_xy.md)
  : Benefit reserves for two-life insurance
- [`annuity_multi()`](https://julianfajardo1908.github.io/tidyactuarial/reference/annuity_multi.md)
  : Actuarial present value of a multi-life annuity (up to 3 independent
  lives)

## Multiple Decrements

Multiple-decrement tables, total-decrement life tables, cause-specific
probabilities, and cause-specific insurance values.

- [`md_table()`](https://julianfajardo1908.github.io/tidyactuarial/reference/md_table.md)
  : Multiple decrement table (annual, discrete ages)
- [`lt_tau()`](https://julianfajardo1908.github.io/tidyactuarial/reference/lt_tau.md)
  : Total-decrement lifetable from a multiple decrement table: lt_tau
- [`t_qxj()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_qxj.md)
  : t-year probability of decrement by cause j: t_qxj
- [`insurance_xj()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xj.md)
  [`A_xj()`](https://julianfajardo1908.github.io/tidyactuarial/reference/insurance_xj.md)
  : Cause-specific term/whole-life insurance APV under multiple
  decrements

## Simulation and Actuarial Risk

Lifetime simulation, Monte Carlo valuation, loss distributions,
reserves, multi-life simulation, and simulation summaries.

- [`simulate_lifetime()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetime.md)
  : Simulate future lifetimes from a life table
- [`simulate_lifetimes()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_lifetimes.md)
  : Simulate future lifetimes for multiple lives
- [`simulate_annuity_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_annuity_x.md)
  : Monte Carlo simulation of a life annuity
- [`simulate_insurance_x()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_insurance_x.md)
  : Monte Carlo simulation of a life insurance
- [`mc_annuity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_annuity.md)
  : Compute simulated present values for life annuities
- [`mc_insurance()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_insurance.md)
  : Compute simulated present values for life insurance benefits
- [`mc_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_premium.md)
  : Compute Monte Carlo net premiums for life contingencies
- [`mc_reserve()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_reserve.md)
  : Compute Monte Carlo prospective reserves for life contingencies
- [`mc_loss()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_loss.md)
  : Compute Monte Carlo loss random variables for life contingencies
- [`mc_multilife_status()`](https://julianfajardo1908.github.io/tidyactuarial/reference/mc_multilife_status.md)
  : Compute multiple-life simulated status variables
- [`summary_mc()`](https://julianfajardo1908.github.io/tidyactuarial/reference/summary_mc.md)
  : Summarise Monte Carlo simulation output

## Collective Risk, Coverage, and Tail Measures

Frequency and severity models, insurance payments, aggregate losses,
simulation, and risk measures.

- [`frequency_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/frequency_spec.md)
  : Specify a claim frequency distribution
- [`severity_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/severity_spec.md)
  : Specify an individual claim severity distribution
- [`empirical_frequency()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_frequency.md)
  : Specify an empirical claim frequency distribution
- [`empirical_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/empirical_severity.md)
  : Specify an empirical claim severity distribution
- [`distribution_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_moments.md)
  : Calculate moments of a frequency or severity distribution
- [`collective_risk_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/collective_risk_spec.md)
  : Specify a collective risk model
- [`coverage_spec()`](https://julianfajardo1908.github.io/tidyactuarial/reference/coverage_spec.md)
  : Specify an insurance coverage contract
- [`apply_coverage()`](https://julianfajardo1908.github.io/tidyactuarial/reference/apply_coverage.md)
  : Apply an insurance contract to a loss severity specification
- [`to_payment_basis()`](https://julianfajardo1908.github.io/tidyactuarial/reference/to_payment_basis.md)
  : Specify a change from per-loss to per-payment basis
- [`discretize_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/discretize_severity.md)
  : Discretize a continuous claim severity distribution
- [`distribution_convolution()`](https://julianfajardo1908.github.io/tidyactuarial/reference/distribution_convolution.md)
  : Specify a convolution of probability distributions
- [`aggregate_moments()`](https://julianfajardo1908.github.io/tidyactuarial/reference/aggregate_moments.md)
  : Calculate moments of a collective aggregate loss
- [`aggregate_distribution()`](https://julianfajardo1908.github.io/tidyactuarial/reference/aggregate_distribution.md)
  : Compute the aggregate loss distribution
- [`simulate_frequency()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_frequency.md)
  : Simulate claim counts from a frequency model
- [`simulate_severity()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_severity.md)
  : Simulate individual claim severities
- [`simulate_aggregate()`](https://julianfajardo1908.github.io/tidyactuarial/reference/simulate_aggregate.md)
  : Simulate a collective risk model
- [`value_at_risk()`](https://julianfajardo1908.github.io/tidyactuarial/reference/value_at_risk.md)
  : Value at Risk for actuarial losses
- [`tail_value_at_risk()`](https://julianfajardo1908.github.io/tidyactuarial/reference/tail_value_at_risk.md)
  : Tail Value at Risk (Expected Shortfall)
- [`stop_loss_premium()`](https://julianfajardo1908.github.io/tidyactuarial/reference/stop_loss_premium.md)
  : Net stop-loss premium
- [`print(`*`<tidyact_aggregate_distribution>`*`)`](https://julianfajardo1908.github.io/tidyactuarial/reference/print.tidyact_aggregate_distribution.md)
  : Print an aggregate loss distribution
- [`print(`*`<tidyact_collective_risk_spec>`*`)`](https://julianfajardo1908.github.io/tidyactuarial/reference/print.tidyact_collective_risk_spec.md)
  : Print a collective risk model specification
- [`print(`*`<tidyact_convolution_spec>`*`)`](https://julianfajardo1908.github.io/tidyactuarial/reference/print.tidyact_convolution_spec.md)
  : Print a convolution specification
- [`print(`*`<tidyact_frequency_spec>`*`)`](https://julianfajardo1908.github.io/tidyactuarial/reference/print.tidyact_frequency_spec.md)
  : Print a frequency distribution specification
- [`print(`*`<tidyact_payment_spec>`*`)`](https://julianfajardo1908.github.io/tidyactuarial/reference/print.tidyact_payment_spec.md)
  : Print a payment severity specification
- [`print(`*`<tidyact_severity_spec>`*`)`](https://julianfajardo1908.github.io/tidyactuarial/reference/print.tidyact_severity_spec.md)
  : Print a severity distribution specification

## Datasets

Reproducible datasets for financial and actuarial examples.

- [`bonds_sample`](https://julianfajardo1908.github.io/tidyactuarial/reference/bonds_sample.md)
  : Sample bond contracts for fixed-income examples
- [`cash_flows_sample`](https://julianfajardo1908.github.io/tidyactuarial/reference/cash_flows_sample.md)
  : Sample cash flows for interest theory examples
- [`loans_sample`](https://julianfajardo1908.github.io/tidyactuarial/reference/loans_sample.md)
  : Sample loan contracts for amortization examples
- [`mortality_colombia_tables`](https://julianfajardo1908.github.io/tidyactuarial/reference/mortality_colombia_tables.md)
  : Colombian mortality tables
- [`mortality_world_sample_2015_2023`](https://julianfajardo1908.github.io/tidyactuarial/reference/mortality_world_sample_2015_2023.md)
  : World mortality sample panel, 2015–2023
- [`mortality_world_sample_2023`](https://julianfajardo1908.github.io/tidyactuarial/reference/mortality_world_sample_2023.md)
  : World mortality sample, 2023
- [`multiple_decrement_sample`](https://julianfajardo1908.github.io/tidyactuarial/reference/multiple_decrement_sample.md)
  : Sample multiple decrement probabilities
- [`soa08lt`](https://julianfajardo1908.github.io/tidyactuarial/reference/soa08lt.md)
  : SOA Illustrative Life Table
