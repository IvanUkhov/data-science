// Reference:
// https://discourse.mc-stan.org/t/ideas-for-modeling-systematically-skewed-outliers/636

functions {
  real skewed_generalized_t_lpdf(vector y, real mu, real sigma, real lambda, real p, real q) {
    // Reference:
    // https://cran.r-project.org/web/packages/sgt/vignettes/sgt.pdf
    int n;
    real lbeta_1;
    real lbeta_2;
    real v;
    real m;
    real delta;
    real sign;
    real result;
    n = dims(y)[1];
    lbeta_1 = lbeta(1.0 / p, q);
    lbeta_2 = lbeta(2.0 / p, q - 1.0 / p);
    v = q^(-1.0 / p) * ((3 * lambda^2 + 1) * exp(lbeta(3.0 / p, q - 2.0 / p) - lbeta_1) - 4 * lambda^2 * exp(lbeta_2 - lbeta_1)^2)^(-0.5);
    m = 2 * v * sigma * lambda * q^(1.0 / p) * exp(lbeta_2 - lbeta_1);
    result = n * (log(p) - log(2 * v * sigma * q^(1.0 / p)) - lbeta_1);
    for (i in 1:n) {
      delta = y[i] - mu + m;
      if (delta < 0) {
        sign = -1;
      } else {
        sign = 1;
      }
      result = result - log(((sign * delta)^p / q / (v * sigma)^p / (lambda * sign + 1)^p + 1)^(1.0 / p + q));
    }
    return result;
  }
}

data {
  int<lower = 0> n;
  vector[n] y;
  int prior_only;
}

parameters {
  real mu;
  real<lower = 0> sigma;
  real<lower = 0, upper = 1> beta;
  real<lower = 1.5 / 2> q;
}

transformed parameters {
  real<lower = -1, upper = 1> lambda;
  lambda = 2 * beta - 1;
}

model {
  mu ~ student_t(3, 0, 1);
  sigma ~ student_t(3, 0, 1);
  beta ~ beta(2, 2);
  q ~ gamma(2, 2 * 0.1);
  if (!prior_only) {
    target += skewed_generalized_t_lpdf(y | mu, sigma, lambda, 2, q);
  }
}
