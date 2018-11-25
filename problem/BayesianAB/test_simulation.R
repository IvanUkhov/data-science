source('simulation.R')

test_that('The expected loss is correct', {
  set.seed(0)
  data <- data_frame(replicate = seq_len(10)) %>%
    mutate(proportion_A = 0.001, effect = -0.0001, per_day = 10000) %>%
    crossing(prior_alpha = 10) %>%
    mutate(prior_beta = 90) %>%
    perform_simulation(days = 7, approx = TRUE)
  expect_equal(nrow(data), 10 * 7)
  expect_true(abs(sum(data$expected_loss) - 0.01946671) < 1e-6)
})