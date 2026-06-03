# fix_mortality_colombia_tables_rda.R
# -------------------------------------------------------------------------
# One-off fix for data/mortality_colombia_tables.rda
#
# Run this from the package root:
#   source("data-raw/fix_mortality_colombia_tables_rda.R")
# -------------------------------------------------------------------------

file <- file.path("data", "mortality_colombia_tables.rda")

if (!file.exists(file)) {
  stop("File not found: data/mortality_colombia_tables.rda", call. = FALSE)
}

# Backup outside data/ to avoid R CMD check warnings
backup_dir <- file.path("data-raw", "_backup_rda_migration_0_1_4")

if (!dir.exists(backup_dir)) {
  dir.create(backup_dir, recursive = TRUE, showWarnings = FALSE)
}

backup_file <- file.path(backup_dir, "mortality_colombia_tables.rda")

if (!file.exists(backup_file)) {
  file.copy(file, backup_file, overwrite = FALSE)
}

env <- new.env(parent = emptyenv())
loaded <- load(file, envir = env)

if (!"mortality_colombia_tables" %in% loaded) {
  stop(
    "The file does not contain an object named `mortality_colombia_tables`.",
    call. = FALSE
  )
}

mortality_colombia_tables <- get("mortality_colombia_tables", envir = env)

if (!inherits(mortality_colombia_tables, "data.frame")) {
  stop("`mortality_colombia_tables` must be a data.frame or tibble.", call. = FALSE)
}

rename_if_present <- function(df, old, new) {
  if (old %in% names(df) && !new %in% names(df)) {
    names(df)[names(df) == old] <- new
  } else if (old %in% names(df) && new %in% names(df)) {
    same_values <- isTRUE(all.equal(df[[old]], df[[new]], check.attributes = FALSE))

    if (same_values) {
      df[[old]] <- NULL
    } else {
      stop(
        "Both `", old, "` and `", new,
        "` exist but differ. Review manually.",
        call. = FALSE
      )
    }
  }

  df
}

mortality_colombia_tables <- rename_if_present(
  mortality_colombia_tables,
  "table",
  "table_id"
)

mortality_colombia_tables <- rename_if_present(
  mortality_colombia_tables,
  "age",
  "x"
)

mortality_colombia_tables <- rename_if_present(
  mortality_colombia_tables,
  "mu",
  "mu_x"
)

mortality_colombia_tables <- rename_if_present(
  mortality_colombia_tables,
  "qx_calculated",
  "qx_calc"
)

mortality_colombia_tables <- rename_if_present(
  mortality_colombia_tables,
  "qx_difference",
  "qx_diff"
)

required <- c(
  "table_id",
  "sex",
  "x",
  "lx",
  "dx",
  "qx",
  "px",
  "mu_x",
  "ex",
  "source",
  "qx_calc",
  "qx_diff"
)

missing <- setdiff(required, names(mortality_colombia_tables))

if (length(missing) > 0L) {
  stop(
    "After migration, missing column(s): ",
    paste(missing, collapse = ", "),
    ".",
    call. = FALSE
  )
}

save(
  mortality_colombia_tables,
  file = file,
  compress = "xz"
)

message("Done. Updated: ", file)
message("Backup saved at: ", backup_file)
message("Columns now are:")
message(paste(names(mortality_colombia_tables), collapse = ", "))
