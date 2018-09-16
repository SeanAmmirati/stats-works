## Hotelling's t-test for multivariate normal.

prob_null <- function(data, hypothesized_mean_vector) {
  n = nrow(data)
  p = ncol(data)
  tsqobs <- hotellings_tsq_statistic(data, hypothesized_mean_vector)
  f_dist <- hotellings_f_statistic_trans(tsqobs, n, p)

  return(1 - pf(f_dist['f'], f_dist['df1'], f_dist['df2']))
}

hotellings_f_statistic_trans <- function(tsqobs, n, p) {
  f <- ((n - p)/(p*(n - 1))) * tsqobs
  df1 <- p
  df2 <- n - p
  return(c(f = f,df1 = df1,df2 = df2))
}

hotellings_tsq_statistic <- function(data, hypothesized_mean_vector) {
  sample_mean <- apply(data,2,mean)
  sample_covar <- cov(data)

  S_inv <- solve(sample_covar)
  n <- nrow(data)
  mu <- hypothesized_mean_vector

  tsqobs <- n*t(sample_mean - mu) %*% S_inv %*% (sample_mean - mu)
  return(tsqobs)
}

find_discriminant <- function(data, hypothesized_mean_vector) {
  sample_mean <- apply(data,2,mean)
  sample_covar <- cov(data)

  discriminant <- solve(sample_covar) %*% (sample_mean - hypothesized_mean_vector)
  return(discriminant)
}
