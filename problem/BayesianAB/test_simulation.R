source('simulation.R')

test_that('simulate works properly', {
  set.seed(0)
  data <- data_frame(replication = seq_len(10)) %>%
    simulate(day_num = 7,
             per_day_num = 10000,
             a_rate = 0.001,
             b_size = -0.0001,
             a_alpha = 10,
             b_alpha = 10,
             a_beta = 90,
             b_beta = 90,
             approximate = TRUE)
  expect_equal(nrow(data), 10 * 7)
  expect_true(abs(sum(data$expected_loss) - 0.01946671) < 1e-6)
})
