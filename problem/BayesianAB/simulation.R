simulate <- function(data, day_num, ...) {
  data %>%
    cbind(...) %>%
    crossing(day = seq_len(day_num)) %>%
    crossing(group = c('a', 'b')) %>%
    mutate(group = factor(group),
           total_num = rbinom(n(), per_day_num, 0.5),
           success_num = rbinom(n(), total_num, a_rate + b_size * (group == 'b'))) %>%
    group_by_at(vars(-day, -total_num, -success_num)) %>%
    arrange(day) %>%
    mutate(total_num = cumsum(total_num),
           success_num = cumsum(success_num)) %>%
    ungroup() %>%
    tidyr::gather(key, value, total_num, success_num) %>%
    tidyr::unite(key, group, key, sep = '_') %>%
    tidyr::spread(key, value) %>%
    mutate(expected_loss = do.call(conversion_expected_loss, .))
}

conversion_expected_loss <- function(a_total_num,
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
  if (!approximate[1] & length(a_success_num) > 1) {
    sapply(seq_along(a_alpha), function(i) {
      expected_loss(a_alpha[i], a_beta[i], b_alpha[i], b_beta[i])
    })
  } else {
    expected_loss(a_alpha, a_beta, b_alpha, b_beta, approximate = approximate)
  }
}

expected_loss <- function(a, b, c, d, approximate = FALSE) {
  v1 <- lbeta(a + 1, b) - lbeta(a, b) + h(a + 1, b, c, d,
                                          approximate = approximate,
                                          logarithmic = TRUE)
  v2 <- lbeta(c + 1, d) - lbeta(c, d) + h(a, b, c + 1, d,
                                          approximate = approximate,
                                          logarithmic = TRUE)
  exp(v1) - exp(v2)
}

h <- function(a, b, c, d, approximate = FALSE, logarithmic = FALSE) {
  if (approximate[1]) {
    u1 <- a / (a + b)
    u2 <- c / (c + d)
    v1 <- a * b / ((a + b) ^ 2 * (a + b + 1))
    v2 <- c * d / ((c + d) ^ 2 * (c + d + 1))
    pnorm(0, u2 - u1, sqrt(v1 + v2), log.p = logarithmic)
  } else {
    j <- seq(0, c - 1)
    series <- lbeta(a + j, b + d) - log(d + j) - lbeta(1 + j, d) - lbeta(a, b)
    result <- max(1 - sum(exp(series)), 0)
    if (logarithmic) {
      result <- log(result)
    }
    result
  }
}
