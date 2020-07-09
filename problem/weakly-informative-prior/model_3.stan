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
  alpha ~ cauchy(0, 1);
  beta ~ cauchy(0, 1);
  sigma ~ cauchy(0, 1);
  y ~ normal(beta * x + alpha, sigma);
}