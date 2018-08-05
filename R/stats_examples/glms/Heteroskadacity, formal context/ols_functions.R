# ols and weighted ols prediction functions

ols_preds <- function(X, y) { 
  return(solve(t(X) %*% X) %*% t(X) %*% y)
}

weighted_ols_preds <- function(X, y, W) {
  return(solve(t(X) %*% W %*% X) %*% t(X) %*% W %*% y)
}

