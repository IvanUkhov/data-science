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
  y ~ normal(beta * x + alpha, sigma);
}