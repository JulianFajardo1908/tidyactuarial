test_that("VaR uses a left quantile with atoms, not linear interpolation", {
  loss <- c(0, 100, 100, 300)
  out <- value_at_risk(loss, level = c(0.5, 0.75, 0.9))
  expect_equal(out$value_at_risk, c(100, 100, 300))
  expect_equal(out$level, c(0.5, 0.75, 0.9))
})

test_that("VaR accepts simulations and analytic continuous severities", {
  sims <- simulate_aggregate(collective_risk_spec(
    frequency_spec("binomial", size = 1, prob = 1),
    severity_spec("degenerate", value = 50)
  ), 30, seed = 8)
  expect_equal(value_at_risk(sims, level = 0.95)$value_at_risk, 50)
  x <- severity_spec("exponential", rate = 0.01)
  expect_equal(value_at_risk(x, 0.95)$value_at_risk,
               stats::qexp(0.95, rate = 0.01))
})

test_that("VaR does not renormalize unresolved aggregate tails", {
  grid <- structure(list(grid = tibble::tibble(
    loss = c(0, 100), probability = c(0.5, 0.45)),
    tail_probability = 0.05), class = "tidyact_aggregate_distribution")
  expect_equal(value_at_risk(grid, 0.90)$value_at_risk, 100)
  expect_error(value_at_risk(grid, 0.98), "uncomputed aggregate tail")
})

test_that("VaR refuses invalid levels and missing simulation columns", {
  expect_error(value_at_risk(c(0, 1), level = 1), "level")
  expect_error(value_at_risk(c(0, 1), level = -0.1), "level")
  expect_error(value_at_risk(tibble::tibble(a = 1:3)), "value")
})
