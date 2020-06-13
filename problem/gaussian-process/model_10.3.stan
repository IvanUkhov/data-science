// https://mc-stan.org/docs/2_23/stan-users-guide/fit-gp-section.html

data {
  int<lower = 1> d;
  int<lower = 1> m;
  int<lower = 1> n;
  vector[d] x[m];
  vector[m] y;
  vector[d] x_new[n];
}

transformed data {
  vector[m] mu = rep_vector(0, m);
}

parameters {
  real<lower = 0> sigma_noise;
  real<lower = 0> sigma_process;
  real<lower = 0> ell_process;
}

transformed parameters {
  matrix[m, m] L = cholesky_decompose(add_diag(cov_exp_quad(x, sigma_process, ell_process),
                                               rep_vector(square(sigma_noise), m)));
}

model {
  y ~ multi_normal_cholesky(mu, L);
  sigma_noise ~ normal(0, 1);
  sigma_process ~ normal(0, 1);
  ell_process ~ inv_gamma(5, 5);
}

generated quantities {
  matrix[n, m] K_nm = cov_exp_quad(x_new, x, sigma_process, ell_process);
  matrix[m, m] L_inv = inverse(L);
  matrix[n, m] M = K_nm * L_inv' * L_inv;
  vector[n] mu_new = M * y;
  matrix[n, n] L_new = cholesky_decompose(add_diag(cov_exp_quad(x_new, sigma_process, ell_process) - M * K_nm',
                                                   rep_vector(1e-6, n)));

  // vector[m] y_new = multi_normal_rng(mu_new, K_new);
}
