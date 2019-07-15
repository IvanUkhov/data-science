data {
  int<lower = 0> m;
  vector[m] x;
  int<lower = 0> n[m];
  int<lower = 0> y[m];
}

parameters {
  real alpha;
  real beta;
}

transformed parameters {
  vector<lower = 0, upper = 1>[m] theta;
  theta = inv_logit(alpha + beta * x);
}

model {
  y ~ binomial(n, theta);
}
