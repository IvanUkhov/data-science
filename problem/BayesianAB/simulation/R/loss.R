expected_loss <- function(...) {
  expected_loss_kernel(probability_greater, ...)
}

expected_loss_approximate <- function(...) {
  expected_loss_kernel(probability_greater_approximate, ...)
}

expected_loss_kernel <- function(probability_greater, alpha_a, beta_a, alpha_b, beta_b) {
  integral_1 <-
    lbeta(alpha_a + 1, beta_a) -
    lbeta(alpha_a, beta_a) +
    probability_greater(alpha_a + 1, beta_a, alpha_b, beta_b)
  integral_2 <-
    lbeta(alpha_b + 1, beta_b) -
    lbeta(alpha_b, beta_b) +
    probability_greater(alpha_a, beta_a, alpha_b + 1, beta_b)
  exp(integral_1) - exp(integral_2)
}

probability_greater <- function(alpha_a, beta_a, alpha_b, beta_b) {
  j <- seq(0, alpha_b - 1)
  series <-
    lbeta(alpha_a + j, beta_a + beta_b) -
    log(beta_b + j) -
    lbeta(1 + j, beta_b) -
    lbeta(alpha_a, beta_a)
  log(max(1 - sum(exp(series)), 0))
}

probability_greater_approximate <- function(alpha_a, beta_a, alpha_b, beta_b) {
  mean_a <- alpha_a / (alpha_a + beta_a)
  mean_b <- alpha_b / (alpha_b + beta_b)
  variance_a <- alpha_a * beta_a / ((alpha_a + beta_a)^2 * (alpha_a + beta_a + 1))
  variance_b <- alpha_b * beta_b / ((alpha_b + beta_b)^2 * (alpha_b + beta_b + 1))
  pnorm(0, mean_b - mean_a, sqrt(variance_a + variance_b), log.p = TRUE)
}
