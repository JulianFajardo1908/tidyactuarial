# Contributing to tidyactuarial

Thank you for your interest in contributing to `tidyactuarial`.

The package is intended to support actuarial mathematics and life-contingency
workflows in R while keeping the underlying mathematics, timing conventions,
and actuarial assumptions explicit. Contributions are welcome when they improve
correctness, clarity, reproducibility, documentation, or practical actuarial use.

## Reporting bugs

Before opening an issue, please check whether the problem can be reproduced with
the current development version.

A useful bug report should include:

- the function call that produced the problem;
- all relevant inputs;
- the expected actuarial or financial result;
- the observed result;
- a minimal reproducible example whenever possible;
- `sessionInfo()`.

For numerical discrepancies, please also state the convention being used, such
as:

- annual effective, nominal, discount, or force-of-interest rate;
- payment timing;
- valuation date;
- mortality or fractional-age assumption;
- benefit or premium timing;
- prospective or recursive reserve convention.

This information is important because different actuarial conventions can lead
to different, but internally valid, numerical results.

## Suggesting enhancements

Enhancement proposals are welcome when they have a clear actuarial use case.

Please describe:

1. the actuarial problem to be solved;
2. the mathematical definition or formula involved;
3. the expected inputs and outputs;
4. one or more reference examples when available;
5. how the proposal fits with the existing package API.

New functionality should not hide the actuarial model behind software. Whenever
possible, the mathematical structure should remain visible and auditable.

## Pull requests

Before submitting a pull request:

1. keep the change focused on one issue or feature;
2. add or update tests when behavior changes;
3. update documentation when user-facing behavior changes;
4. preserve existing function interfaces unless a change is necessary;
5. avoid unnecessary programming complexity in user-facing examples;
6. run:

```r
devtools::test()
devtools::check()
```

The package should pass `R CMD check` without errors, warnings, or notes before
a change is considered complete.

## Testing actuarial calculations

Changes that affect actuarial or financial calculations should include tests
that verify the result against one or more of the following:

- a closed-form formula;
- a manual calculation;
- an actuarial identity;
- a benchmark example from the literature;
- an independently derived equivalent formulation.

Examples include identities involving present values, annuities, insurance
benefits, reserves, duration, convexity, or probability relationships.

Tests should verify mathematical correctness, not only object structure.

## Documentation style

Documentation should be concise, technical, and reproducible.

For major actuarial results, prefer the following order when practical:

1. actuarial or financial interpretation;
2. mathematical definition;
3. timing of cash flows or events;
4. formula or equation of value;
5. R implementation;
6. numerical or actuarial interpretation.

Examples should favor readable R code and should avoid unnecessary abstraction.

## Vignettes and articles

Vignettes should demonstrate complete actuarial workflows rather than act as a
catalog of functions.

A useful vignette generally moves from:

```text
actuarial problem
-> mathematical formulation
-> calculation
-> tidyactuarial implementation
-> audit or interpretation
```

The mathematics should remain visible before the software implementation.

## Data contributions

New datasets should have a clear actuarial or pedagogical purpose and include:

- provenance;
- source;
- relevant definitions;
- units;
- variable descriptions;
- licensing or redistribution information when applicable.

Do not submit proprietary, confidential, or personally identifiable data.

## Code style

Please follow the existing package style.

In particular:

- prefer clear base R or tidyverse code;
- use pipes when they improve readability;
- avoid unnecessary nested programming patterns;
- keep user-facing examples easy to inspect;
- favor explicit actuarial naming over overly generic helper abstractions.

## Questions

For questions about package behavior, documentation, or potential contributions,
open an issue in the project repository and include enough context to reproduce
the situation.
