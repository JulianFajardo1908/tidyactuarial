# data-raw/soa08lt.R
# Build the tidyactuarial version of the SOA Illustrative Life Table.
#
# This script is not used at package runtime. It is only used by maintainers
# to regenerate data/soa08lt.rda.

if (!requireNamespace("lifecontingencies", quietly = TRUE)) {
  stop(
    "Package 'lifecontingencies' is required to regenerate `soa08lt`.\n",
    "Install it with install.packages('lifecontingencies') and rerun this script.",
    call. = FALSE
  )
}

if (!requireNamespace("tibble", quietly = TRUE)) {
  stop("Package 'tibble' is required to regenerate `soa08lt`.", call. = FALSE)
}

if (!requireNamespace("dplyr", quietly = TRUE)) {
  stop("Package 'dplyr' is required to regenerate `soa08lt`.", call. = FALSE)
}

if (!requireNamespace("usethis", quietly = TRUE)) {
  stop("Package 'usethis' is required to save `soa08lt`.", call. = FALSE)
}

data("soa08Act", package = "lifecontingencies")

soa08lt <- tibble::tibble(
  x = as.integer(soa08Act@x),
  lx = as.numeric(soa08Act@lx)
) |>
  dplyr::arrange(.data$x) |>
  dplyr::mutate(
    dx = dplyr::if_else(
      dplyr::row_number() < dplyr::n(),
      .data$lx - dplyr::lead(.data$lx),
      .data$lx
    ),
    qx = dplyr::if_else(.data$lx > 0, .data$dx / .data$lx, 1),
    px = 1 - .data$qx
  ) |>
  dplyr::mutate(
    dx = pmax(.data$dx, 0),
    qx = pmin(pmax(.data$qx, 0), 1),
    px = pmin(pmax(.data$px, 0), 1)
  )

# Basic integrity checks before saving.
stopifnot(is.data.frame(soa08lt))
stopifnot(all(c("x", "lx", "dx", "qx", "px") %in% names(soa08lt)))
stopifnot(nrow(soa08lt) > 0)
stopifnot(!anyDuplicated(soa08lt$x))
stopifnot(all(is.finite(soa08lt$x)))
stopifnot(all(is.finite(soa08lt$lx)))
stopifnot(all(soa08lt$lx >= 0))
stopifnot(all(soa08lt$qx >= 0 & soa08lt$qx <= 1))
stopifnot(all(soa08lt$px >= 0 & soa08lt$px <= 1))

usethis::use_data(soa08lt, overwrite = TRUE, compress = "xz")
