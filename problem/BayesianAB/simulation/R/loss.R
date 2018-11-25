expected_loss <- function(...) expected_loss_kernel(lbeta_greater, ...)

expected_loss_approximate <- function(...) expected_loss_kernel(lbeta_greater_approximate, ...)

expected_loss_kernel <- function(lbeta_greater, alpha_1, beta_1, alpha_2, beta_2) {
  v1 <-
    lbeta(alpha_1 + 1, beta_1) -
    lbeta(alpha_1, beta_1) +
    lbeta_greater(alpha_1 + 1, beta_1, alpha_2, beta_2)
  v2 <-
    lbeta(alpha_2 + 1, beta_2) -
    lbeta(alpha_2, beta_2) +
    lbeta_greater(alpha_1, beta_1, alpha_2 + 1, beta_2)
  exp(v1) - exp(v2)
}

lbeta_greater <- function(alpha_1, beta_1, alpha_2, beta_2) {
  j <- seq(0, alpha_2 - 1)
  series <-
    lbeta(alpha_1 + j, beta_1 + beta_2) -
    log(beta_2 + j) -
    lbeta(1 + j, beta_2) -
    lbeta(alpha_1, beta_1)
  log(max(1 - sum(exp(series)), 0))
}

lbeta_greater_approximate <- function(alpha_1, beta_1, alpha_2, beta_2) {
  u1 <- alpha_1 / (alpha_1 + beta_1)
  u2 <- alpha_2 / (alpha_2 + beta_2)
  v1 <- alpha_1 * beta_1 / ((alpha_1 + beta_1)^2 * (alpha_1 + beta_1 + 1))
  v2 <- alpha_2 * beta_2 / ((alpha_2 + beta_2)^2 * (alpha_2 + beta_2 + 1))
  pnorm(0, u2 - u1, sqrt(v1 + v2), log.p = TRUE)
}
