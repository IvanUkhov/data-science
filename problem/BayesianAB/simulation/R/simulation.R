simulate <- function(data, day_num, ...) {
  data %>%
    cbind(...) %>%
    crossing(day = seq_len(day_num)) %>%
    crossing(group = c('a', 'b')) %>%
    mutate(group = factor(group),
           total_num = rbinom(n(), per_day_num, 0.5),
           success_num = rbinom(n(), total_num, rate_a + effect_b * (group == 'b'))) %>%
    group_by_at(vars(-day, -total_num, -success_num)) %>%
    arrange(day) %>%
    mutate(total_num = cumsum(total_num),
           success_num = cumsum(success_num)) %>%
    ungroup() %>%
    tidyr::gather(key, value, total_num, success_num) %>%
    tidyr::unite(key, key, group, sep = '_') %>%
    tidyr::spread(key, value) %>%
    mutate(expected_loss = do.call(expected_loss_wrapper, .))
}

expected_loss_wrapper <- function(total_num_a,
                                  total_num_b,
                                  success_num_a,
                                  success_num_b,
                                  alpha_a = 1,
                                  alpha_b = 1,
                                  beta_a = 1,
                                  beta_b = 1,
                                  approximate = FALSE, ...) {
  alpha_a <- success_num_a + alpha_a
  alpha_b <- success_num_b + alpha_b
  beta_a <- total_num_a - success_num_a + beta_a
  beta_b <- total_num_b - success_num_b + beta_b
  if (!all(approximate)) {
    sapply(seq_along(alpha_a), function(i) {
      expected_loss(alpha_a[i], beta_a[i], alpha_b[i], beta_b[i])
    })
  } else {
    expected_loss_approximate(alpha_a, beta_a, alpha_b, beta_b)
  }
}
