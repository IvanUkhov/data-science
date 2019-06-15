data {
  int<lower=0> n;
  real effect[n];
  real<lower=0> sigma[n];
}

parameters {
  real mu;
  real<lower=0> tau;
  vector[n] eta;
}

transformed parameters {
  vector[n] theta = mu + tau * eta;
}

model {
  target += normal_lpdf(eta | 0, 1);
  target += normal_lpdf(effect | theta, sigma);
}
