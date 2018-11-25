context('simulate')

test_that('the expected loss is correct', {
  set.seed(0)
  data <- data_frame(replication = seq_len(20)) %>%
    simulate(day_num = 14,
             per_day_num = 10000,
             rate_a = 0.01,
             effect_b = 0,
             alpha_a = 100,
             alpha_b = 100,
             beta_a = 990,
             beta_b = 990)
  expect_equal(nrow(data), 20 * 14)
  expect_true(abs(sum(data$expected_loss) - 0.1529044) < 1e-6)
})

test_that('the approximate expected loss is correct', {
  set.seed(0)
  data <- data_frame(replication = seq_len(10)) %>%
    simulate(day_num = 7,
             per_day_num = 10000,
             rate_a = 0.001,
             effect_b = -0.0001,
             alpha_a = 10,
             alpha_b = 10,
             beta_a = 90,
             beta_b = 90,
             approximate = TRUE)
  expect_equal(nrow(data), 10 * 7)
  expect_true(abs(sum(data$expected_loss) - 0.01946671) < 1e-6)
})
