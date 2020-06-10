data {
  int<lower = 1> d;
  int<lower = 1> n;
  matrix[n, d] x;
}

transformed data {
  vector[n] mu = rep_vector(0, n);
  vector[d] x_[n];
  for (i in 1:n) {
    x_[i] = x[i]';
  }
}

parameters {
  vector[n] y;
  real intercept_n;
  vector[d] slope_n;
  real<lower = 0> ell_f;
  real<lower = 0> sigma_f;
}

transformed parameters {
  vector[n] sigma_n_squared = exp(intercept_n + x * slope_n);
  matrix[n, n] K = cov_exp_quad(x_, sigma_f, ell_f) + diag_matrix(sigma_n_squared);
  matrix[n, n] L = cholesky_decompose(K);
}

model {
  y ~ multi_normal_cholesky(mu, L);
  intercept_n ~ normal(0, 1);
  slope_n ~ normal(0, 1);
  ell_f ~ inv_gamma(5, 5);
  sigma_f ~ normal(0, 1);
}
