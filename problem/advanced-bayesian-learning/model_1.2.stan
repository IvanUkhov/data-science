data {
  int<lower = 1> d;
  int<lower = 1> m;
  
  vector[d] x[m];
  vector[m] y;
}

transformed data {
  vector[m] mu = rep_vector(0, m);
  matrix[m, d] x_;
  for (i in 1:m) {
    x_[i] = x[i]';
  }
}

parameters {
  real noise_intercept;
  vector[d] noise_slope;
  real<lower = 0> process_sigma;
  real<lower = 0> process_ell;
}

model {
  matrix[m, m] K = cov_exp_quad(x, process_sigma, process_ell);
  matrix[m, m] L = cholesky_decompose(add_diag(K, exp(noise_intercept + x_ * noise_slope)));

  y ~ multi_normal_cholesky(mu, L);
  noise_intercept ~ normal(0, 1);
  noise_slope ~ normal(0, 1);
  process_sigma ~ normal(0, 1);
  process_ell ~ inv_gamma(5, 5);
}
