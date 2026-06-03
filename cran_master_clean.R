# cran_master_clean.R
# ============================================================
# Master CRAN preparation script for tidyactuarial
# ============================================================
#
# Run this script from the root directory of the package:
#
#   source("cran_master_clean.R")
#
# This version assumes that all .rda files already exist in data/.
# It does NOT rebuild datasets from data-raw/.
# It does NOT submit to CRAN automatically.

# ============================================================
# 0. User options
# ============================================================

RUN_DOCUMENT      <- TRUE
RUN_TESTS         <- TRUE
RUN_EXAMPLES      <- TRUE
RUN_VIGNETTES     <- TRUE
RUN_RDA_CHECK     <- TRUE
RUN_URL_CHECK     <- TRUE
RUN_SPELL_CHECK   <- TRUE
RUN_GOODPRACTICE  <- FALSE
RUN_LOCAL_CHECK   <- TRUE
RUN_AS_CRAN_CHECK <- TRUE
RUN_BUILD         <- TRUE
RUN_WIN_DEVEL     <- FALSE
RUN_RELEASE       <- FALSE

INSTALL_MISSING_HELPERS <- TRUE

# ============================================================
# 1. Helpers
# ============================================================

section <- function(title) {
  cat("\n")
  cat("============================================================\n")
  cat(title, "\n")
  cat("============================================================\n")
}

msg <- function(...) {
  cat("\n", paste0(...), "\n", sep = "")
}

require_or_install <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    if (isTRUE(INSTALL_MISSING_HELPERS)) {
      install.packages(pkg)
    } else {
      stop("Package `", pkg, "` is required but is not installed.", call. = FALSE)
    }
  }
  invisible(TRUE)
}

stop_if_not_package_root <- function() {
  if (!file.exists("DESCRIPTION")) {
    stop("DESCRIPTION not found. Run this script from the package root.", call. = FALSE)
  }
  if (!dir.exists("R")) {
    stop("R/ directory not found. Run this script from the package root.", call. = FALSE)
  }
}

set_description_field <- function(field, value, file = "DESCRIPTION") {
  dcf <- read.dcf(file, all = TRUE)
  dcf[1, field] <- value
  write.dcf(dcf, file = file, keep.white = TRUE)
  invisible(TRUE)
}

ensure_r_depends <- function(required = "R (>= 4.1.0)", file = "DESCRIPTION") {
  dcf <- read.dcf(file, all = TRUE)

  if (!"Depends" %in% colnames(dcf) || is.na(dcf[1, "Depends"]) || !nzchar(dcf[1, "Depends"])) {
    dcf[1, "Depends"] <- required
    write.dcf(dcf, file = file, keep.white = TRUE)
    msg("Added Depends: ", required)
    return(invisible(TRUE))
  }

  depends <- dcf[1, "Depends"]

  if (!grepl("R\\s*\\(", depends)) {
    dcf[1, "Depends"] <- paste(required, depends, sep = ", ")
    write.dcf(dcf, file = file, keep.white = TRUE)
    msg("Prepended R dependency to Depends: ", dcf[1, "Depends"])
    return(invisible(TRUE))
  }

  msg("Depends already contains an R version. Please verify it is compatible with native pipe `|>` if used:")
  msg(depends)
  invisible(TRUE)
}

add_build_ignore <- function(pattern, file = ".Rbuildignore") {
  current <- character(0)
  if (file.exists(file)) {
    current <- readLines(file, warn = FALSE)
  }

  if (!pattern %in% current) {
    writeLines(c(current, pattern), con = file)
    msg("Added to .Rbuildignore: ", pattern)
  } else {
    msg("Already in .Rbuildignore: ", pattern)
  }

  invisible(TRUE)
}

assert_files_exist <- function(paths) {
  missing <- paths[!file.exists(paths)]
  if (length(missing) > 0L) {
    stop(
      "Missing required file(s):\n",
      paste0(" - ", missing, collapse = "\n"),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

load_dataset_safely <- function(name) {
  data(list = name, envir = .GlobalEnv)
  if (!exists(name, envir = .GlobalEnv)) {
    stop("Dataset could not be loaded: ", name, call. = FALSE)
  }
  invisible(TRUE)
}

safe_call <- function(expr, label) {
  section(label)
  force(expr)
  invisible(TRUE)
}

# ============================================================
# 2. Validate package root
# ============================================================

section("1. Package root")

stop_if_not_package_root()

msg("Working directory:")
print(getwd())

# ============================================================
# 3. Helper packages
# ============================================================

section("2. Helper packages")

required_helpers <- c("devtools", "rcmdcheck")
for (pkg in required_helpers) require_or_install(pkg)

if (isTRUE(RUN_URL_CHECK)) require_or_install("urlchecker")
if (isTRUE(RUN_SPELL_CHECK)) require_or_install("spelling")
if (isTRUE(RUN_GOODPRACTICE)) require_or_install("goodpractice")

# ============================================================
# 4. DESCRIPTION and .Rbuildignore
# ============================================================

section("3. DESCRIPTION and .Rbuildignore")

set_description_field("LazyData", "true")
set_description_field("LazyDataCompression", "xz")

# Keep R >= 4.1.0 if the package uses the native pipe |> in examples or code.
ensure_r_depends("R (>= 4.1.0)")

add_build_ignore("^data-raw$")
add_build_ignore("^mortality_csv$")
add_build_ignore("^sample_data_csv$")
add_build_ignore("^cran_master_clean\\.R$")
add_build_ignore("^cran_master_release\\.R$")
add_build_ignore("^cran_master_release_v2\\.R$")
add_build_ignore("^cran_release_protocol\\.R$")
add_build_ignore("^README_cran_checklist\\.md$")

# ============================================================
# 5. Required .rda files
# ============================================================

section("4. Required .rda files")

expected_rda <- file.path(
  "data",
  c(
    "mortality_world_sample_2023.rda",
    "mortality_world_sample_2015_2023.rda",
    "mortality_colombia_tables.rda",
    "cash_flows_sample.rda",
    "bonds_sample.rda",
    "loans_sample.rda",
    "multiple_decrement_sample.rda"
  )
)

assert_files_exist(expected_rda)

msg("All expected .rda files are present:")
print(basename(expected_rda))

msg("Data file sizes:")
print(file.info(expected_rda)[, c("size", "mtime")])

# ============================================================
# 6. Load datasets
# ============================================================

section("5. Dataset loading")

datasets_expected <- c(
  "mortality_world_sample_2023",
  "mortality_world_sample_2015_2023",
  "mortality_colombia_tables",
  "cash_flows_sample",
  "bonds_sample",
  "loans_sample",
  "multiple_decrement_sample"
)

for (dataset_name in datasets_expected) {
  load_dataset_safely(dataset_name)
  msg("Loaded: ", dataset_name)
}

msg("Dataset dimensions:")
print(data.frame(
  dataset = datasets_expected,
  rows = vapply(datasets_expected, function(x) nrow(get(x, envir = .GlobalEnv)), integer(1)),
  cols = vapply(datasets_expected, function(x) ncol(get(x, envir = .GlobalEnv)), integer(1))
))

# ============================================================
# 7. Documentation
# ============================================================

if (isTRUE(RUN_DOCUMENT)) {
  safe_call(devtools::document(), "6. roxygen documentation")
} else {
  msg("RUN_DOCUMENT = FALSE. Skipping devtools::document().")
}

expected_rd <- file.path("man", paste0(datasets_expected, ".Rd"))
missing_rd <- expected_rd[!file.exists(expected_rd)]

if (length(missing_rd) > 0L) {
  warning(
    "Some dataset .Rd files are missing:\n",
    paste0(" - ", missing_rd, collapse = "\n"),
    call. = FALSE
  )
} else {
  msg("All expected dataset .Rd files exist.")
}

# ============================================================
# 8. Tests, examples, vignettes
# ============================================================

if (isTRUE(RUN_TESTS)) {
  safe_call(devtools::test(), "7. Tests")
} else {
  msg("RUN_TESTS = FALSE. Skipping tests.")
}

if (isTRUE(RUN_EXAMPLES)) {
  safe_call(devtools::run_examples(), "8. Examples")
} else {
  msg("RUN_EXAMPLES = FALSE. Skipping examples.")
}

if (isTRUE(RUN_VIGNETTES)) {
  safe_call(devtools::build_vignettes(), "9. Vignettes")
} else {
  msg("RUN_VIGNETTES = FALSE. Skipping vignettes.")
}

# ============================================================
# 9. Data compression check
# ============================================================

if (isTRUE(RUN_RDA_CHECK)) {
  section("10. .rda compression check")
  print(tools::checkRdaFiles("data"))
} else {
  msg("RUN_RDA_CHECK = FALSE. Skipping tools::checkRdaFiles().")
}

# ============================================================
# 10. Extra diagnostics
# ============================================================

if (isTRUE(RUN_URL_CHECK)) {
  safe_call(urlchecker::url_check(), "11. URL check")
} else {
  msg("RUN_URL_CHECK = FALSE. Skipping URL check.")
}

if (isTRUE(RUN_SPELL_CHECK)) {
  safe_call(spelling::spell_check_package(), "12. Spelling check")
} else {
  msg("RUN_SPELL_CHECK = FALSE. Skipping spelling check.")
}

if (isTRUE(RUN_GOODPRACTICE)) {
  safe_call(goodpractice::gp(), "13. goodpractice")
} else {
  msg("RUN_GOODPRACTICE = FALSE. Skipping goodpractice::gp().")
}

# ============================================================
# 11. R CMD check
# ============================================================

if (isTRUE(RUN_LOCAL_CHECK)) {
  safe_call(devtools::check(document = FALSE), "14. Local R CMD check")
} else {
  msg("RUN_LOCAL_CHECK = FALSE. Skipping local check.")
}

if (isTRUE(RUN_AS_CRAN_CHECK)) {
  safe_call(devtools::check(document = FALSE, args = "--as-cran"), "15. R CMD check --as-cran")
} else {
  msg("RUN_AS_CRAN_CHECK = FALSE. Skipping --as-cran check.")
}

# ============================================================
# 12. Build source tarball
# ============================================================

if (isTRUE(RUN_BUILD)) {
  section("16. Build source tarball")
  tarball <- devtools::build()
  msg("Built tarball:")
  print(tarball)

  msg("Tarball size:")
  print(file.info(tarball)[, c("size", "mtime")])
} else {
  msg("RUN_BUILD = FALSE. Skipping devtools::build().")
}

# ============================================================
# 13. Optional Windows devel check
# ============================================================

if (isTRUE(RUN_WIN_DEVEL)) {
  safe_call(devtools::check_win_devel(), "17. Windows devel check")
} else {
  msg("RUN_WIN_DEVEL = FALSE. Skipping devtools::check_win_devel().")
}

# ============================================================
# 14. Optional CRAN release
# ============================================================

section("18. CRAN release")

if (isTRUE(RUN_RELEASE)) {
  devtools::release()
} else {
  msg("RUN_RELEASE = FALSE. No CRAN submission was made.")
  msg("If all checks are clean, run manually:")
  msg("devtools::release()")
}

section("Finished")
msg("Review the full output.")
msg("Do NOT submit to CRAN if there are ERRORs or WARNINGs.")
msg("If there are NOTEs, fix them or explain them in cran-comments.md.")
