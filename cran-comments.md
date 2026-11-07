# tidyactuarial 0.2.1 candidate

Adds an attributed selection of 2023 UN World Population Prospects 2024
period life tables, three published dog/cat tables, and a short data-use
vignette. Open intervals remain explicitly identified. Existing data and
calculation functions are unchanged.
MASS is suggested for an optional example; its observations are not
copied. The UN and veterinary data licences and attribution are in
inst/COPYRIGHTS.

## Local check

- Windows, R 4.6.1, locale C, existing dependency library and RStudio Pandoc.
- `devtools::document()` and `devtools::test()`: 7490 passed; no failures,
  warnings or skips. Of these, 36 expectations cover the new datasets.
- `devtools::check()` ran R CMD build and R CMD check on the resulting
  0.2.1 source tarball with `--as-cran --no-manual`. The devtools
  configuration disabled CRAN incoming checks (including remote checks);
  no datasets are downloaded during checks.
- 0 errors, 0 warnings, 0 notes; 7490 installed expectations passed.
  Examples and all five vignettes, including their rebuild, passed.
- Source archive: 3028467 bytes, SHA-256
  `9E94C890D7E5CADFF3EB93A0D7E9BAC53B818AE1E7ECA092A14997417A341040`.
  425 files matched the checkout; raw inputs, maintainer scripts and
  audit records are excluded from the archive.

Prepared for review. No CRAN submission has been made.
