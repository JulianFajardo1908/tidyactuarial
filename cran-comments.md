## Resubmission

This is a resubmission.

I fixed the M1mac example failure reported by CRAN in the `mc_annuity()` example.

The issue originated in the multiple-life Monte Carlo workflow:

* `simulate_lifetimes()` could construct an invalid lifetime distribution when terminal mortality values produced missing or non-finite cumulative probabilities.
* `mc_multilife_status()` used defaults that were not fully aligned with the column names returned by `simulate_lifetimes()`.

Changes made:

* `simulate_lifetimes()` now constructs a valid mortality distribution defensively.
* `mc_multilife_status()` now uses defaults compatible with `simulate_lifetimes()`: `sim_id`, `life_id`, `Kx`, and `Tx`.
* A regression test was added for the complete multiple-life workflow used in the CRAN example.

## Test environments

* Local Windows
* CRAN incoming pretest environments

## R CMD check results

0 errors | 0 warnings | 1 note

The remaining NOTE is related to the recent update / CRAN incoming feasibility.

