conversion_expected_loss <- function(sA, nA,
                                     sB, nB,
                                     prior_alpha = 1, prior_beta = 1,
                                     approx = FALSE, ...) {
  if (!approx[1] & length(sA) > 1) {
    a <- sA + prior_alpha
    b <- nA - sA + prior_beta
    c <- sB + prior_alpha
    d <- nB - sB + prior_beta
    ret <- sapply(seq_along(a), function(i) {
      expected_loss(a[i], b[i], c[i], d[i], ...)
    })
    return(ret)
  }
  expected_loss(sA + prior_alpha, nA - sA + prior_beta,
                sB + prior_alpha, nB - sB + prior_beta,
                approx = approx, ...)
}

expected_loss <- function(a, b, c, d, approx = FALSE, ...) {
  v1 <- lbeta(a + 1, b) - lbeta(a, b) + h(a + 1, b, c, d, approx = approx, log_h = TRUE)
  v2 <- lbeta(c + 1, d) - lbeta(c, d) + h(a, b, c + 1, d, approx = approx, log_h = TRUE)
  exp(v1) - exp(v2)
}

h <- function(a, b, c, d, approx = FALSE, log_h = FALSE) {
  if (approx[1]) {
    u1 <- a / (a + b)
    u2 <- c / (c + d)
    var1 <- a * b / ((a + b) ^ 2 * (a + b + 1))
    var2 <- c * d / ((c + d) ^ 2 * (c + d + 1))
    return(pnorm(0, u2 - u1, sqrt(var1 + var2), log.p = log_h))
  }
  j <- seq(0, c - 1)
  log_vals <- lbeta(a + j, b + d) - log(d + j) - lbeta(1 + j, d) - lbeta(a, b)
  ret <- max(1 - sum(exp(log_vals)), 0)
  if (log_h) {
    return(log(ret))
  }
  ret
}

perform_simulation <- function(params, days = 20, per_day = 100,
                               proportion_A = .1, ...) {
  if (is.null(params$per_day)) {
    params$per_day <- per_day
  }
  if (is.null(params$proportion_A)) {
    params$proportion_A <- proportion_A
  }
  params <- cbind(params, ...)
  ret <- params %>%
    crossing(day = seq_len(days)) %>%
    crossing(type = c('A', 'B')) %>%
    mutate(type = factor(type)) %>%
    ungroup() %>%
    mutate(total = rbinom(n(), .$per_day, .5)) %>%
    mutate(success = rbinom(n(), total, .$proportion_A + effect * (type == 'B'))) %>%
    group_by(effect, replicate, type, per_day) %>%
    mutate(n = cumsum(total),
           s = cumsum(success)) %>%
    ungroup()
  ret %>%
    select(-success, -total) %>%
    tidyr::gather(metric, value, n:s) %>%
    tidyr::unite(metric2, metric, type, sep = '') %>%
    tidyr::spread(metric2, value) %>%
    mutate(expected_loss = do.call(conversion_expected_loss, .))
}

vectorized_prop_test <- function(x1, n1, x2, n2, conf.level = .95) {
  a <- x1
  b <- n1 - x1
  c <- x2
  d <- n2 - x2
  exact <- (a < 20 | b < 20 | c < 20 | d < 20)
  pvalue <- rep(NA, length(a))
  if (any(exact)) {
    pvalue[exact] <- vectorized_prop_test_exact(a[exact], b[exact], c[exact], d[exact])
  }
  if (any(!exact)) {
    pvalue[!exact] <- vectorized_prop_test_approx(a[!exact], b[!exact], c[!exact], d[!exact])
  }
  mu1 <- a / (a + b)
  mu2 <- c / (c + d)
  alpha2 <- (1 - conf.level) / 2
  DELTA <- mu2 - mu1
  WIDTH <- qnorm(alpha2)
  alpha <- (a + .5) / (a + b + 1)
  beta <- (c + .5) / (c + d + 1)
  n <- n1 + n2
  YATES <- pmin(.5, abs(DELTA) / sum(1 / n1 + 1 / n2))
  z <- qnorm((1 + conf.level) / 2)
  WIDTH <- z * sqrt(mu1 * (1 - mu1) / n1 + mu2 * (1 - mu2) / n2)
  dplyr::data_frame(estimate = DELTA,
                    conf.low = pmax(DELTA - WIDTH, -1),
                    conf.high = pmin(DELTA + WIDTH, 1),
                    p.value = pvalue)
}

vectorized_prop_test_approx <- function(a, b, c, d) {
  n1 <- a + b
  n2 <- c + d
  n <- n1 + n2
  p <- (a + c) / n
  E <- cbind(p * n1, (1 - p) * n1, p * n2, (1 - p) * n2)
  x <- cbind(a, b, c, d)
  DELTA <- a / n1 - c / n2
  YATES <- pmin(.5, abs(DELTA) / sum(1 / n1 + 1 / n2))
  STATISTIC <- rowSums((abs(x - E) - YATES)^2 / E)
  PVAL <- pchisq(STATISTIC, 1, lower.tail = FALSE)
  PVAL
}

vectorized_prop_test_exact <- function(a, b, c, d) {
  sapply(seq_along(a), function(i) {
    fisher.test(cbind(c(a[i], c[i]), c(b[i], d[i])))$p.value
  })
}
