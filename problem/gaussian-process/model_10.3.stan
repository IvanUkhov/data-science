// https://mc-stan.org/docs/2_23/stan-users-guide/fit-gp-section.html

data {
  int<lower = 1> d;
  int<lower = 1> n;
  vector[d] x[n];
  vector[n] y;
  real<lower = 0> sigma_noise_tau;
  real<lower = 0> sigma_process_tau;
  real<lower = 0> ell_process_alpha;
  real<lower = 0> ell_process_beta;
}

transformed data {
  vector[n] mu = rep_vector(0, n);
}

parameters {
  real<lower = 0> sigma_noise;
  real<lower = 0> sigma_process;
  real<lower = 0> ell_process;
}

transformed parameters {
  vector[n] noise = rep_vector(square(sigma_noise), n);
  matrix[n, n] L = cholesky_decompose(add_diag(cov_exp_quad(x, sigma_process, ell_process), noise));
}

model {
  y ~ multi_normal_cholesky(mu, L);
  sigma_noise ~ normal(0, sigma_noise_tau);
  sigma_process ~ normal(0, sigma_process_tau);
  ell_process ~ inv_gamma(ell_process_alpha, ell_process_beta);
}

generated quantities {
  vector[n] y_hat;
  vector[n] z_hat;
  for (i in 1:n) {
    z_hat[i] = normal_rng(0, 1);
  }
  y_hat = mu + L * z_hat;
}
