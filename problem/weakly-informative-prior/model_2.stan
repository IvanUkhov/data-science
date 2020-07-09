data {
  int<lower = 1> n;
  vector[n] x;
  vector[n] y;
}

parameters {
  real alpha;
  real beta;
  real<lower = 0> sigma;
}

model {
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  y ~ normal(beta * x + alpha, sigma);
}