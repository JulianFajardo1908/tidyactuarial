# migrate_rda_columns_actuarial_0_1_4.R
# -------------------------------------------------------------------------
# Purpose:
#   Rename columns in package data/*.rda objects so that the saved datasets
#   match the standardized actuarial notation used in tidyactuarial 0.1.4.
#
# How to use:
#   1. Put this file in data-raw/migrate_rda_columns_actuarial_0_1_4.R
#   2. Run it from the package root:
#        source("data-raw/migrate_rda_columns_actuarial_0_1_4.R")
#   3. Then run:
#        devtools::document()
#        devtools::test()
#        devtools::check()
#
# Safety:
#   - Before modifying anything, the script creates a backup in:
#       data/_backup_pre_param_migration_0_1_4
#   - If a dataset is already migrated, it is left unchanged.
#   - If an expected dataset is not present, the script warns and continues.
#
# Important:
#   This script changes the actual objects stored in data/*.rda.
#   It does not change documentation files. Documentation was handled in
#   R/data-mortality.R, R/data-samples.R, and R/data-soa08lt.R.
# -------------------------------------------------------------------------

stop_if_not_package_root <- function() {
  required <- c("DESCRIPTION", "R", "data")
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


backup_data_files <- function(
    backup_dir = file.path("data", "_backup_pre_param_migration_0_1_4")
) {
  if (!dir.exists("data")) {
    stop("Directory `data/` was not found.", call. = FALSE)
  }

  if (!dir.exists(backup_dir)) {
    dir.create(backup_dir, recursive = TRUE, showWarnings = FALSE)
  }

  rda_files <- list.files("data", pattern = "\\.rda$", full.names = TRUE)

  if (length(rda_files) == 0L) {
    warning("No .rda files were found in data/.", call. = FALSE)
    return(invisible(character(0)))
  }

  copied <- character(0)

  for (f in rda_files) {
    target <- file.path(backup_dir, basename(f))

    if (!file.exists(target)) {
      ok <- file.copy(f, target, overwrite = FALSE)

      if (ok) {
        copied <- c(copied, target)
      }
    }
  }

  message("Backup directory: ", backup_dir)

  if (length(copied) > 0L) {
    message("Backed up ", length(copied), " .rda file(s).")
  } else {
    message("Backup already existed; no .rda files were copied.")
  }

  invisible(copied)
}


load_one_rda <- function(object_name) {
  file <- file.path("data", paste0(object_name, ".rda"))

  if (!file.exists(file)) {
    warning("File not found: ", file, call. = FALSE)
    return(NULL)
  }

  env <- new.env(parent = emptyenv())
  loaded <- load(file, envir = env)

  if (!object_name %in% loaded) {
    warning(
      "File `", file, "` does not contain object `", object_name,
      "`. Loaded object(s): ", paste(loaded, collapse = ", "),
      ".",
      call. = FALSE
    )
    return(NULL)
  }

  list(
    file = file,
    env = env,
    object = get(object_name, envir = env)
  )
}


save_one_rda <- function(object_name, object, file) {
  env <- new.env(parent = emptyenv())
  assign(object_name, object, envir = env)
  save(list = object_name, file = file, envir = env, compress = "xz")
  invisible(TRUE)
}


rename_cols_base <- function(df, mapping) {
  if (!inherits(df, "data.frame")) {
    stop("Expected a data.frame/tibble object.", call. = FALSE)
  }

  old_names <- names(mapping)
  new_names <- unname(mapping)

  for (j in seq_along(mapping)) {
    old <- old_names[[j]]
    new <- new_names[[j]]

    has_old <- old %in% names(df)
    has_new <- new %in% names(df)

    if (has_old && !has_new) {
      names(df)[names(df) == old] <- new
    } else if (has_old && has_new && !identical(old, new)) {
      # If both columns exist, preserve the canonical new column and drop the old
      # duplicate only if values are identical. Otherwise stop for manual review.
      same_values <- isTRUE(all.equal(df[[old]], df[[new]], check.attributes = FALSE))

      if (same_values) {
        df[[old]] <- NULL
      } else {
        stop(
          "Both `", old, "` and `", new,
          "` exist, but their values differ. Review manually.",
          call. = FALSE
        )
      }
    }
  }

  df
}


assert_cols <- function(df, required, object_name) {
  missing <- setdiff(required, names(df))

  if (length(missing) > 0L) {
    stop(
      "After migration, object `", object_name,
      "` is missing required column(s): ",
      paste(sprintf("`%s`", missing), collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  invisible(TRUE)
}


migrate_object <- function(object_name, mapping, required = character(0)) {
  loaded <- load_one_rda(object_name)

  if (is.null(loaded)) {
    return(invisible(FALSE))
  }

  obj <- loaded$object

  if (!inherits(obj, "data.frame")) {
    warning(
      "Object `", object_name, "` is not a data.frame/tibble. Skipping.",
      call. = FALSE
    )
    return(invisible(FALSE))
  }

  old_names <- names(obj)
  obj <- rename_cols_base(obj, mapping)

  if (length(required) > 0L) {
    assert_cols(obj, required, object_name)
  }

  if (!identical(old_names, names(obj))) {
    save_one_rda(object_name, obj, loaded$file)
    message("Migrated and saved: ", loaded$file)
  } else {
    message("Already standardized: ", loaded$file)
  }

  invisible(TRUE)
}


# -------------------------------------------------------------------------
# Dataset-specific migrations
# -------------------------------------------------------------------------

migrate_mortality_world_sample_2023 <- function() {
  migrate_object(
    object_name = "mortality_world_sample_2023",
    mapping = c(
      age = "x",
      radix = "l0"
    ),
    required = c(
      "country",
      "country_code",
      "continent",
      "region",
      "year",
      "sex",
      "x",
      "mx",
      "qx",
      "px",
      "lx",
      "dx",
      "source"
    )
  )
}


migrate_mortality_world_sample_2015_2023 <- function() {
  migrate_object(
    object_name = "mortality_world_sample_2015_2023",
    mapping = c(
      age = "x",
      radix = "l0"
    ),
    required = c(
      "country",
      "country_code",
      "continent",
      "region",
      "year",
      "pandemic_period",
      "sex",
      "x",
      "mx",
      "qx",
      "px",
      "lx",
      "dx",
      "source"
    )
  )
}


migrate_cash_flows_sample <- function() {
  migrate_object(
    object_name = "cash_flows_sample",
    mapping = c(
      time = "t",
      amount = "C",
      payment = "C",
      cash_flow = "C",
      cashflow = "C"
    ),
    required = c(
      "scenario_id",
      "t",
      "C",
      "cashflow_type",
      "description"
    )
  )
}


migrate_bonds_sample <- function() {
  migrate_object(
    object_name = "bonds_sample",
    mapping = c(
      face_value = "face",
      coupon_rate = "c",
      coupon = "c",
      coupon_frequency = "k",
      payments_per_year = "k",
      maturity_years = "n",
      maturity = "n",
      yield_rate = "y",
      price = "P"
    ),
    required = c(
      "bond_id",
      "face",
      "c",
      "k",
      "n",
      "y",
      "bond_type",
      "P"
    )
  )
}


migrate_loans_sample <- function() {
  migrate_object(
    object_name = "loans_sample",
    mapping = c(
      principal = "L",
      loan_principal = "L",
      annual_effective_rate = "i",
      rate = "i",
      term_months = "n_months",
      payments_per_year = "k",
      payment = "R"
    ),
    required = c(
      "loan_id",
      "L",
      "i",
      "n_months",
      "k",
      "loan_type",
      "R"
    )
  )
}


migrate_multiple_decrement_sample <- function() {
  migrate_object(
    object_name = "multiple_decrement_sample",
    mapping = c(
      age = "x"
    ),
    required = c(
      "x",
      "q_death",
      "q_disability",
      "q_withdrawal",
      "q_total",
      "p_total"
    )
  )
}


migrate_soa08lt <- function() {
  migrate_object(
    object_name = "soa08lt",
    mapping = c(
      age = "x",
      l_x = "lx",
      d_x = "dx",
      q_x = "qx",
      p_x = "px"
    ),
    required = c(
      "x",
      "lx",
      "dx",
      "qx",
      "px"
    )
  )
}


# -------------------------------------------------------------------------
# Optional compact diagnostics
# -------------------------------------------------------------------------

print_dataset_columns <- function(objects) {
  for (object_name in objects) {
    loaded <- load_one_rda(object_name)

    if (is.null(loaded)) {
      next
    }

    obj <- loaded$object

    if (!inherits(obj, "data.frame")) {
      next
    }

    message("\n", object_name, ":")
    message("  rows: ", nrow(obj), " | cols: ", ncol(obj))
    message("  names: ", paste(names(obj), collapse = ", "))
  }

  invisible(TRUE)
}


# -------------------------------------------------------------------------
# Run migration
# -------------------------------------------------------------------------

run_rda_column_migration <- function() {
  stop_if_not_package_root()
  backup_data_files()

  objects <- c(
    "mortality_world_sample_2023",
    "mortality_world_sample_2015_2023",
    "cash_flows_sample",
    "bonds_sample",
    "loans_sample",
    "multiple_decrement_sample",
    "soa08lt"
  )

  migrate_mortality_world_sample_2023()
  migrate_mortality_world_sample_2015_2023()
  migrate_cash_flows_sample()
  migrate_bonds_sample()
  migrate_loans_sample()
  migrate_multiple_decrement_sample()
  migrate_soa08lt()

  message("\nColumn check after migration:")
  print_dataset_columns(objects)

  message("\nDone. Now run:")
  message("  devtools::document()")
  message("  devtools::test()")
  message("  devtools::check()")

  invisible(TRUE)
}


run_rda_column_migration()
