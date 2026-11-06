# From the package root: Rscript data-raw/build-mortality-regions.R FILE.csv
# FILE.csv must come from prepare-wpp2024.py and the pinned originals.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1L, file.exists("data-raw/wpp2024-areas.csv"))
z <- utils::read.csv(args[1L], check.names = FALSE, fileEncoding = "UTF-8",
                     colClasses = c("integer", rep("character", 5), "integer",
                                    "character", "integer", "character", "integer",
                                    "logical", rep("numeric", 9)), na.strings = "")
groups <- split(seq_len(nrow(z)), interaction(z$location_code, z$sex, drop = TRUE))
stopifnot(nrow(z) == 28785L, length(groups) == 285L, all(z$year == 2023L),
          length(unique(z$location_code[z$level == "country"])) == 67L,
          all(z$lx > 0), all(z$qx >= 0 & z$qx <= 1),
          max(abs(z$qx + z$px - 1)) < 1e-8,
          max(abs(z$Tx / z$lx - z$ex)) < .0002)
for (idx in groups) {
  x <- z[idx, ]
  stopifnot(identical(x$x, 0:100), x$lx[1] == 1e5, all(diff(x$lx) <= 0),
            identical(x$open_interval, x$x == 100L),
            identical(x$age_span, c(rep(1L, 100), -1L)),
            x$age_interval[101] == "100+", x$qx[101] == 1, x$px[101] == 0,
            x$Tx[101] == x$Lx[101],
            max(abs(-diff(x$lx) - x$dx[1:100])) < .0016,
            max(abs(-diff(x$Tx) - x$Lx[1:100])) < .0016,
            max(abs(x$lx[1:100] * x$qx[1:100] - x$dx[1:100])) < .002,
            max(abs(x$mx[1:100] * x$Lx[1:100] - x$dx[1:100])) < .002)
}
# For open rows we preserve the publisher's dx rather than harmonizing it.
mortality_regions <- tibble::as_tibble(z)
save(mortality_regions, file = "data/mortality_regions.rda",
     compress = "xz", version = 2)
