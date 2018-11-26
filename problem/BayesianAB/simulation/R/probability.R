greater_probability <- function(alpha_a, beta_a, alpha_b, beta_b) {
  j <- seq(0, alpha_b - 1)
  series <-
    lbeta(alpha_a + j, beta_a + beta_b) -
    log(beta_b + j) -
    lbeta(1 + j, beta_b) -
    lbeta(alpha_a, beta_a)
  log(max(1 - sum(exp(series)), 0))
}

greater_probability_approximate <- function(alpha_a, beta_a, alpha_b, beta_b) {
  mean_a <- alpha_a / (alpha_a + beta_a)
  mean_b <- alpha_b / (alpha_b + beta_b)
  variance_a <- alpha_a * beta_a / ((alpha_a + beta_a)^2 * (alpha_a + beta_a + 1))
  variance_b <- alpha_b * beta_b / ((alpha_b + beta_b)^2 * (alpha_b + beta_b + 1))
  pnorm(0, mean_b - mean_a, sqrt(variance_a + variance_b), log.p = TRUE)
}
