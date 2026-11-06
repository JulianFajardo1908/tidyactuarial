# tidyactuarial 0.2.1 candidate

Adds an attributed selection of 2023 UN World Population Prospects 2024
period life tables and a short data-use vignette. The 100+ interval
remains open. Existing data and calculation functions are unchanged.
MASS is suggested for an optional example; its observations are not
copied. The UN data licence and attribution are in inst/COPYRIGHTS.

## Local check

- Windows, R 4.6.1, locale C, existing dependency library and RStudio Pandoc.
- `devtools::document()` and `devtools::test()`: 7476 passed; no failures,
  warnings or skips. Of these, 22 expectations cover the new dataset.
- `devtools::check()` ran R CMD build and R CMD check on the resulting
  0.2.1 source tarball with `--as-cran --no-manual`. The devtools
  configuration disabled CRAN incoming checks (including remote checks);
  no datasets are downloaded during checks.
- 0 errors, 0 warnings, 0 notes; 7476 installed expectations passed.
  Examples and all five vignettes, including their rebuild, passed.
- Source archive: 3022754 bytes, SHA-256
  `7AD1D7E46552109BEF3B30B487D60E5417FA86C1CD67C85C1C7E528321416125`.
  421 files matched the checkout; raw inputs, maintainer scripts and
  audit records are excluded from the archive.

Prepared for review. No CRAN submission has been made.
