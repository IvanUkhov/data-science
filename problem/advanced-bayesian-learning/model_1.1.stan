data {
  int<lower = 1> d;
  int<lower = 1> m;
  
  vector[d] x[m];
  vector[m] y;
}

transformed data {
  vector[m] mu = rep_vector(0, m);
}

parameters {
  real<lower = 0> noise_sigma;
  real<lower = 0> process_sigma;
  real<lower = 0> process_ell;
}

model {
  vector[m] noise = rep_vector(square(noise_sigma), m);
  matrix[m, m] K = cov_exp_quad(x, process_sigma, process_ell);
  matrix[m, m] L = cholesky_decompose(add_diag(K, noise));

  y ~ multi_normal_cholesky(mu, L);
  noise_sigma ~ normal(0, 1);
  process_sigma ~ normal(0, 1);
  process_ell ~ inv_gamma(5, 5);
}
