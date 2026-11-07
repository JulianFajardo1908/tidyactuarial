# From the package root: Rscript data-raw/build-pet-lifetables.R FILE.csv
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1L, file.exists("data-raw/provenance.csv"))
z <- utils::read.csv(args[1], check.names = FALSE,
                     colClasses = c(rep("character", 3), "integer", "character",
                                    "logical", "integer", "integer", rep("numeric", 9)),
                     na.strings = "")
g <- split(z, z$table_id)
stopifnot(nrow(z) == 57L, identical(unname(vapply(g, nrow, 0L)), c(18L, 18L, 21L)),
          !anyDuplicated(z[c("table_id", "x")]), all(z$qx >= 0 & z$qx <= 1),
          all(z$lx > 0), all(z$ex_ci_low <= z$ex & z$ex <= z$ex_ci_high),
          max(abs(z$Tx / z$lx - z$ex)) < .005)
for (x in g) {
  n <- nrow(x)
  annual <- seq_len(n - 1L)
  stopifnot(identical(x$x, 0:(n-1L)), identical(x$open_interval, x$x == n-1L),
            all(diff(x$lx) <= 0),
            max(abs(1 - x$lx[-1] / x$lx[annual] - x$qx[annual])) < .00051)
}
pet_lifetables <- tibble::as_tibble(z)
save(pet_lifetables, file = "data/pet_lifetables.rda", compress = "xz", version = 2)
