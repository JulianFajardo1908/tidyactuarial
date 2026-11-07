# tidyactuarial 0.2.1 candidate

Adds an attributed selection of 2023 UN World Population Prospects 2024
period life tables, three published dog/cat tables, and a short data-use
vignette. Open intervals remain explicitly identified and existing data
objects are unchanged. Previously validated multiple-life improvements
are also included: e_xy accepts distinct tables and a canonical status
selector, and annuity_multi uses each life's years of observed support.
Legacy cohort calls retain compatibility. See NEWS for the exact scope.
MASS is suggested for an optional example; its observations are not
copied. The UN and veterinary data licences and attribution are in
inst/COPYRIGHTS.

## Local check

- Windows, R 4.6.1, locale C, existing dependency library and RStudio Pandoc.
- `devtools::document()` and `devtools::test()`: 7618 passed; no failures,
  warnings or skips. 36 expectations cover the new datasets and 128
  cover the included multiple-life changes.
- `devtools::check()` ran R CMD build and R CMD check on the resulting
  0.2.1 source tarball with `--as-cran --no-manual`. The devtools
  configuration disabled CRAN incoming checks (including remote checks);
  no datasets are downloaded during checks.
- 0 errors, 0 warnings, 0 notes; 7618 installed expectations passed.
  Examples and all five vignettes, including their rebuild, passed.
- Source archive: 3032579 bytes, SHA-256
  `C10DFB9B4CEBC085749BF4F3522E48C49BA8D8F1AA18B31A5328A335836979E9`.
  427 files matched the checkout; raw inputs, maintainer scripts and
  audit records are excluded from the archive.

Prepared for review. No CRAN submission has been made.
