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
