# strict_check_tidyactuarial_0_1_4.R
# -------------------------------------------------------------------------
# Strict local check profile for tidyactuarial.
#
# Run from the package root:
#   source("strict_check_tidyactuarial_0_1_4.R")
#
# Purpose:
#   1. Rebuild documentation.
#   2. Time testthat files and stop if they are too slow.
#   3. Run a CRAN-like check and treat warnings as failures.
# -------------------------------------------------------------------------

stop_if_not_package_root <- function() {
  required <- c("DESCRIPTION", "R", "tests")
  missing <- required[!file.exists(required)]

  if (length(missing) > 0L) {
    stop(
      "Run this script from the package root. Missing: ",
      paste(missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

require_namespace <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      "Package `", pkg, "` is required. Install it with install.packages('",
      pkg, "').",
      call. = FALSE
    )
  }

  invisible(TRUE)
}

time_test_files <- function(
    test_dir = file.path("tests", "testthat"),
    max_seconds_per_file = 5,
    max_total_seconds = 60
) {
  require_namespace("pkgload")
  require_namespace("testthat")

  files <- list.files(
    test_dir,
    pattern = "^test.*[.][Rr]$",
    full.names = TRUE
  )

  if (length(files) == 0L) {
    warning("No test files found in ", test_dir, ".", call. = FALSE)
    return(invisible(data.frame()))
  }

  pkgload::load_all(export_all = FALSE, helpers = TRUE, quiet = TRUE)

  timing <- lapply(files, function(f) {
    gc()
    elapsed <- system.time(
      testthat::test_file(
        f,
        reporter = testthat::SilentReporter$new()
      )
    )[["elapsed"]]

    data.frame(
      file = f,
      seconds = as.numeric(elapsed),
      stringsAsFactors = FALSE
    )
  })

  timing <- do.call(rbind, timing)
  timing <- timing[order(timing$seconds, decreasing = TRUE), , drop = FALSE]
  row.names(timing) <- NULL

  cat("\nTest timing by file\n")
  cat("-------------------\n")
  print(timing, row.names = FALSE)

  slow <- timing[timing$seconds > max_seconds_per_file, , drop = FALSE]
  total <- sum(timing$seconds)

  cat("\nTotal test time: ", round(total, 2), " seconds\n", sep = "")

  if (nrow(slow) > 0L) {
    stop(
      "Some test files are too slow. Limit: ",
      max_seconds_per_file,
      " seconds per file. Slow file(s): ",
      paste(basename(slow$file), collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  if (total > max_total_seconds) {
    stop(
      "Total test time is too slow. Limit: ",
      max_total_seconds,
      " seconds. Observed: ",
      round(total, 2),
      " seconds.",
      call. = FALSE
    )
  }

  invisible(timing)
}

scan_for_heavy_patterns <- function() {
  paths <- c("R", "tests", "vignettes")
  paths <- paths[dir.exists(paths)]

  files <- unlist(lapply(
    paths,
    list.files,
    pattern = "[.](R|Rmd|qmd)$",
    recursive = TRUE,
    full.names = TRUE,
    ignore.case = TRUE
  ))

  if (length(files) == 0L) {
    return(invisible(NULL))
  }

  patterns <- c(
    "n_sim\\s*=\\s*[0-9]{4,}",
    "Sys[.]sleep\\s*\\(",
    "download[.]file\\s*\\(",
    "install[.]packages\\s*\\(",
    "setwd\\s*\\(",
    "View\\s*\\("
  )

  cat("\nScanning for heavy or CRAN-unfriendly patterns\n")
  cat("----------------------------------------------\n")

  any_hit <- FALSE

  for (pat in patterns) {
    hits <- grep(
      pattern = pat,
      x = files,
      value = TRUE
    )

    # grep files first; then print matching lines compactly
    if (length(hits) > 0L) {
      any_hit <- TRUE
      cat("\nPattern: ", pat, "\n", sep = "")

      for (f in hits) {
        lines <- readLines(f, warn = FALSE)
        idx <- grep(pat, lines)

        for (i in idx) {
          cat(f, ":", i, ": ", trimws(lines[[i]]), "\n", sep = "")
        }
      }
    }
  }

  if (!any_hit) {
    cat("No obvious heavy patterns found.\n")
  }

  invisible(NULL)
}

run_strict_check <- function(
    max_seconds_per_file = 5,
    max_total_seconds = 60,
    run_donttest = TRUE
) {
  stop_if_not_package_root()

  require_namespace("devtools")
  require_namespace("rcmdcheck")

  cat("\nStep 1: document()\n")
  cat("------------------\n")
  devtools::document(quiet = FALSE)

  cat("\nStep 2: scan heavy patterns\n")
  cat("---------------------------\n")
  scan_for_heavy_patterns()

  cat("\nStep 3: time tests\n")
  cat("------------------\n")
  timing <- time_test_files(
    max_seconds_per_file = max_seconds_per_file,
    max_total_seconds = max_total_seconds
  )

  cat("\nStep 4: full test suite\n")
  cat("-----------------------\n")
  devtools::test()

  cat("\nStep 5: CRAN-like R CMD check\n")
  cat("-----------------------------\n")

  check_args <- "--as-cran"

  if (isTRUE(run_donttest)) {
    check_args <- c(check_args, "--run-donttest")
  }

  # Treat warnings as failures. This is stricter than normal local checking.
  result <- rcmdcheck::rcmdcheck(
    path = ".",
    args = check_args,
    error_on = "warning",
    check_dir = "check",
    env = c(
      "_R_CHECK_FORCE_SUGGESTS_" = "true",
      "_R_CHECK_CRAN_INCOMING_REMOTE_" = "false"
    )
  )

  cat("\nStrict check finished.\n")
  invisible(list(
    timing = timing,
    check = result
  ))
}

run_strict_check()
