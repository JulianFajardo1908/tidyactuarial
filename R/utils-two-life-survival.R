# Validate the observed annual basis without imposing a starting-life state.
# Missing or extinct initial lives retain the consumer's established policy.
.two_life_table <- function(lt) {
  if (!is.data.frame(lt) || !all(c("x", "lx") %in% names(lt)))
    stop("Life table must contain columns `x` and `lx`.", call. = FALSE)
  if (!nrow(lt) || !is.numeric(lt$x) || any(!is.finite(lt$x)) ||
      any(lt$x != round(lt$x)) || any(abs(lt$x) > .Machine$integer.max) ||
      anyDuplicated(lt$x) || any(diff(sort(as.double(lt$x))) != 1))
    stop("Life table must have unique consecutive finite integer ages.", call. = FALSE)
  ord <- order(lt$x)
  lx <- lt$lx[ord]
  if (!is.numeric(lx) || any(!is.finite(lx)) || any(lx < 0) || any(diff(lx) > 0))
    stop("`lx` must be finite, nonnegative and nonincreasing by age.", call. = FALSE)
  for (column in intersect(c("px", "qx"), names(lt))) {
    z <- lt[[column]][ord]
    if (!is.numeric(z) || any(is.nan(z)) ||
        any(!is.finite(z) & !is.na(z)) || any(z < 0 | z > 1, na.rm = TRUE))
      stop("Invalid mortality probabilities in `", column, "`.", call. = FALSE)
    if (length(lx) > 1L) {
      j <- seq_len(length(lx) - 1L)
      j <- j[lx[j] > 0]
      expected <- if (column == "px") lx[j + 1L]/lx[j] else (lx[j]-lx[j + 1L])/lx[j]
      if (any(abs(z[j] - expected) > 1e-10, na.rm = TRUE))
        stop("Inconsistent `lx` and mortality probabilities.", call. = FALSE)
    }
  }
  if (all(c("px", "qx") %in% names(lt)) &&
      any(abs(lt$px + lt$qx - 1) > 1e-10, na.rm = TRUE))
    stop("Inconsistent mortality probabilities `px` and `qx`.", call. = FALSE)
  invisible(NULL)
}

# Tables and controls are validated by callers, once per valuation.
.two_life_survival <- function(lt_x, lt_y, x, y, t, frac, status) {
  px <- t_px(lt_x, x = x, t = t, frac = frac, check = FALSE)
  py <- t_px(lt_y, x = y, t = t, frac = frac, check = FALSE)
  if (is.na(px) || is.na(py)) return(NA_real_)
  if (status == "joint") px * py else px + py - px * py
}
