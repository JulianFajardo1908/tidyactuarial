# data-raw/build_all_data.R

# ============================================================
# Build all package datasets for tidyactuarial
# ============================================================

# Run this file from the package root.

# World mortality datasets from local CSV files
source("data-raw/build_mortality_world_from_csv.R")

# Colombian mortality tables from local CSV file
source("data-raw/build_mortality_colombia_tables.R")

# Small pedagogical sample datasets
source("data-raw/build_sample_datasets.R")

# Final inspection
list.files("data", pattern = "\\.rda$", full.names = FALSE)
