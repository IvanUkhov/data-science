simulate <- function(data, day_num, ...) {
  data %>%
    cbind(...) %>%
    crossing(day = seq_len(day_num)) %>%
    crossing(group = c('a', 'b')) %>%
    mutate(group = factor(group),
           total_num = rbinom(n(), daily_num, 0.5),
           success_num = rbinom(n(), total_num, a_rate + b_effect * (group == 'b'))) %>%
    group_by_at(vars(-day, -total_num, -success_num)) %>%
    arrange(day) %>%
    mutate(total_num = cumsum(total_num),
           success_num = cumsum(success_num)) %>%
    ungroup() %>%
    tidyr::gather(key, value, total_num, success_num) %>%
    tidyr::unite(key, group, key, sep = '_') %>%
    tidyr::spread(key, value) %>%
    mutate(expected_loss = do.call(expected_loss_wrapper, .))
}

expected_loss_wrapper <- function(a_total_num,
                                  b_total_num,
                                  a_success_num,
                                  b_success_num,
                                  a_alpha = 1,
                                  b_alpha = 1,
                                  a_beta = 1,
                                  b_beta = 1,
                                  approximate = FALSE, ...) {
  a_alpha <- a_success_num + a_alpha
  b_alpha <- b_success_num + b_alpha
  a_beta <- a_total_num - a_success_num + a_beta
  b_beta <- b_total_num - b_success_num + b_beta
  if (!all(approximate)) {
    sapply(seq_along(a_alpha), function(i) {
      expected_loss(a_alpha[i], a_beta[i], b_alpha[i], b_beta[i])
    })
  } else {
    expected_loss_approximate(a_alpha, a_beta, b_alpha, b_beta)
  }
}
