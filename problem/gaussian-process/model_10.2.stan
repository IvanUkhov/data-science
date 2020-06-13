// https://mc-stan.org/docs/2_23/stan-users-guide/simulating-from-a-gaussian-process.html

data {
  int<lower = 1> d;
  int<lower = 1> n;
  vector[d] x[n];
}

transformed data {
  vector[n] mu = rep_vector(0, n);
  vector[n] noise = rep_vector(0.1, n);
  matrix[n, n] K = add_diag(cov_exp_quad(x, 1.0, 1.0), noise);
  matrix[n, n] L = cholesky_decompose(K);
}

parameters {
  vector[n] z;
}

model {
  z ~ normal(0, 1);
}

generated quantities {
  vector[n] y;
  y = mu + L * z;
}