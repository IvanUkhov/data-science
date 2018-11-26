expected_loss <- function(...) {
  expected_loss_kernel(greater_probability, ...)
}

expected_loss_approximate <- function(...) {
  expected_loss_kernel(greater_probability_approximate, ...)
}

expected_loss_kernel <- function(greater_probability, alpha_a, beta_a, alpha_b, beta_b) {
  integral_1 <-
    lbeta(alpha_a + 1, beta_a) -
    lbeta(alpha_a, beta_a) +
    greater_probability(alpha_a + 1, beta_a, alpha_b, beta_b)
  integral_2 <-
    lbeta(alpha_b + 1, beta_b) -
    lbeta(alpha_b, beta_b) +
    greater_probability(alpha_a, beta_a, alpha_b + 1, beta_b)
  exp(integral_1) - exp(integral_2)
}
