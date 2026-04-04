#' Convert between dependent and independent decrement rates
#'
#' Converts cause-specific decrement rates between dependent (observed in
#' presence of all decrements) and independent (associated single decrement)
#' forms, under a Uniform Distribution of Decrements (UDD) assumption
#' (Finan, Sections 65 and 67).
#'
#' @param rates Numeric matrix or data frame of cause-specific rates, one
#'   row per age and one column per cause. Column names are used as cause
#'   labels.
#' @param direction Conversion direction:
#'   \code{"indep_to_dep"} converts independent (absolute) rates
#'   \eqn{q'^{(j)}_x} to dependent rates \eqn{q^{(j)}_x} (default).
#'   \code{"dep_to_indep"} converts dependent rates \eqn{q^{(j)}_x} to
#'   independent rates \eqn{q'^{(j)}_x}.
#' @param assumption UDD assumption context:
#'   \code{"UDD_single"} (default) assumes UDD in each associated single
#'   decrement table (Finan, Sec. 67, second approach).
#'   \code{"UDD_multi"} assumes UDD in the multiple decrement table
#'   (Finan, Sec. 67, first approach).
#'
#' @details
#' **Independent to dependent** (\code{"indep_to_dep"}):
#'
#' Under UDD in each single decrement table (Finan, Sec. 67):
#' \deqn{q^{(j)}_x = q'^{(j)}_x \int_0^1 \prod_{i \ne j}
#'   (1 - s \, q'^{(i)}_x) \, ds.}
#'
#' For 2 causes this simplifies to:
#' \deqn{q^{(1)}_x = q'^{(1)}_x (1 - \tfrac{1}{2} q'^{(2)}_x).}
#'
#' For 3 causes:
#' \deqn{q^{(1)}_x = q'^{(1)}_x (1 - \tfrac{1}{2}(q'^{(2)}_x + q'^{(3)}_x)
#'   + \tfrac{1}{3} q'^{(2)}_x q'^{(3)}_x).}
#'
#' **Dependent to independent** (\code{"dep_to_indep"}):
#'
#' Under UDD in the multiple decrement table (Finan, Sec. 67):
#' \deqn{q'^{(j)}_x = 1 - (1 - q^{(\tau)}_x)^{q^{(j)}_x / q^{(\tau)}_x}}
#' where \eqn{q^{(\tau)}_x = \sum_j q^{(j)}_x}.
#'
#' @return A matrix of the same dimensions as \code{rates}, with
#'   converted rates. Row and column names are preserved.
#'
#' @seealso \code{\link{multi_decrement_table}} for building a full
#'   multiple decrement table.
#'
#' @examples
#' # Finan Example 67.2: independent to dependent (3 causes)
#' q_prime <- matrix(c(0.03, 0.06, 0.01), nrow = 1,
#'                   dimnames = list(NULL, c("death", "disab", "withdr")))
#' md_convert_rates(q_prime, direction = "indep_to_dep")
#'
#' # Finan Example 67.1: dependent to independent (2 causes)
#' q_dep <- matrix(c(0.168, 0.48), nrow = 1,
#'                 dimnames = list(NULL, c("death", "withdrawal")))
#' md_convert_rates(q_dep, direction = "dep_to_indep")
#'
#' # Multiple ages
#' q_prime_2 <- matrix(
#'   c(0.010, 0.013,   # death
#'     0.030, 0.050,   # disability
#'     0.100, 0.200),  # withdrawal
#'   nrow = 2, dimnames = list(c("60", "61"),
#'     c("death", "disab", "withdr"))
#' )
#' md_convert_rates(q_prime_2, direction = "indep_to_dep")
#'
#' @export
md_convert_rates <- function(
    rates,
    direction = c("indep_to_dep", "dep_to_indep"),
    assumption = c("UDD_single", "UDD_multi")
) {
  direction  <- match.arg(direction)
  assumption <- match.arg(assumption)

  rates <- as.matrix(rates)
  if (!is.numeric(rates)) stop("'rates' must be numeric.")
  if (any(rates < 0) || any(rates >= 1)) {
    stop("All rates must be in [0, 1).")
  }

  n_ages   <- nrow(rates)
  n_causes <- ncol(rates)

  result <- matrix(NA_real_, nrow = n_ages, ncol = n_causes)
  rownames(result) <- rownames(rates)
  colnames(result) <- colnames(rates)

  if (direction == "dep_to_indep") {
    # --- Dependent → Independent (Finan, Sec. 67 first approach) ---
    # q'^(j)_x = 1 - (1 - q^(τ)_x)^(q^(j)_x / q^(τ)_x)
    for (row in seq_len(n_ages)) {
      q_dep <- rates[row, ]
      q_tau <- sum(q_dep)
      if (q_tau <= 0) {
        result[row, ] <- 0
        next
      }
      for (j in seq_len(n_causes)) {
        if (q_dep[j] <= 0) {
          result[row, j] <- 0
        } else {
          ratio <- q_dep[j] / q_tau
          result[row, j] <- 1 - (1 - q_tau)^ratio
        }
      }
    }

  } else {
    # --- Independent → Dependent ---
    if (assumption == "UDD_multi") {
      # Under UDD in multi table:
      # First compute q^(τ) = 1 - prod(1 - q'^(j))
      # then q^(j) = q^(τ) * ln(p'^(j)) / ln(p^(τ))
      for (row in seq_len(n_ages)) {
        q_prime <- rates[row, ]
        p_prime <- 1 - q_prime
        p_tau   <- prod(p_prime)
        q_tau   <- 1 - p_tau

        if (q_tau <= 0) {
          result[row, ] <- 0
          next
        }

        ln_p_tau <- log(p_tau)
        for (j in seq_len(n_causes)) {
          if (q_prime[j] <= 0) {
            result[row, j] <- 0
          } else {
            result[row, j] <- q_tau * log(p_prime[j]) / ln_p_tau
          }
        }
      }

    } else {
      # Under UDD in each single decrement table (Finan, Sec. 67):
      # q^(j) = q'^(j) * int_0^1 prod_{i≠j} (1 - s*q'^(i)) ds
      # Integral computed via 100-point trapezoid
      grid_n <- 100L
      s_grid <- seq(0, 1, length.out = grid_n)
      ds     <- 1 / (grid_n - 1)

      for (row in seq_len(n_ages)) {
        q_prime <- rates[row, ]
        for (j in seq_len(n_causes)) {
          # Product of (1 - s * q'^(i)) for i ≠ j
          others <- q_prime[-j]
          integrand <- vapply(s_grid, function(s) {
            prod(1 - s * others)
          }, numeric(1))
          # Composite trapezoid
          integral <- sum(
            (utils::head(integrand, -1) + utils::tail(integrand, -1))
          ) / 2 * ds
          result[row, j] <- q_prime[j] * integral
        }
      }
    }
  }

  result
}
