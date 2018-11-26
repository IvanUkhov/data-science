simulate <- function(data, day_num, ...) {
  data <- data %>%
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
    tidyr::spread(key, value)

  priors <- list('a_alpha_prior', 'a_beta_prior', 'b_alpha_prior', 'b_beta_prior')
  if (!all(map_lgl(priors, ~ . %in% names(data)))) return(data)

  data %>%
    mutate(a_alpha_posterior = a_alpha_prior + a_success_num,
           b_alpha_posterior = b_alpha_prior + b_success_num,
           a_beta_posterior = a_beta_prior + a_total_num - a_success_num,
           b_beta_posterior = b_beta_prior + b_total_num - b_success_num) %>%
    mutate(expected_loss = do.call(compute_expected_loss, .),
           greater_probability = 1 - exp(do.call(compute_greater_probability, .)))
}

compute_expected_loss <- function(...) {
  compute_posterior(expected_loss, expected_loss_approximate, ...)
}

compute_greater_probability <- function(...) {
  compute_posterior(greater_probability, greater_probability_approximate, ...)
}

compute_posterior <- function(compute_exact,
                              compute_approximate,
                              a_alpha_posterior,
                              b_alpha_posterior,
                              a_beta_posterior,
                              b_beta_posterior,
                              approximate = FALSE, ...) {
  if (!all(approximate)) {
    sapply(seq_along(a_alpha_posterior), function(i) {
      compute_exact(a_alpha_posterior[i],
                    a_beta_posterior[i],
                    b_alpha_posterior[i],
                    b_beta_posterior[i])
    })
  } else {
    compute_approximate(a_alpha_posterior,
                        a_beta_posterior,
                        b_alpha_posterior,
                        b_beta_posterior)
  }
}
