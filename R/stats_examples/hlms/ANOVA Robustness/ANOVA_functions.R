sst <- function(a,n,r)
{
  a <- matrix(a,n,r)
  rowmean <- apply(a,2,mean)
  sum(n*(rowmean - mean(rowmean))^2)
}

sse <- function(a,n,r)
{
  a <- matrix(a,n,r)
  rowmean <- apply(a,2,mean)
  b <- numeric()
  for (i in 1:n) {
    b[i] <- sum((a[i,] - rowmean)^2)
  }  
  sum(b)
}
