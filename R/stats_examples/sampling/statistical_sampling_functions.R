Varms <- function(m,M,sumbet,Swithin){
  # Considering the variance of the mean calculated by sampling mi people from the ith group
  # with total population Mi in the ith group, where sum(mi) = n and sum(Mi) = N. 
  # m (vector of integers): represents number of subjects in each group sampled. 
  # M (vector of integers): represents total population of each group 
  # sumbet (numeric): SUM of squares BETWEEN. The total sum of squared deviations between the 
  # groups. Calculated as sum (mi * groupmean - grandmean)
  # Swithin (numeric): S within. This is the calculated variances within each group. Summed. 
  
  # This will produce the true variance of the mean within, between and total in groups
  # when sampled randomly within groups and a predetermined number from each group. 
  # This assumes that the total number in the population is known for each group.
  
  n <- sum(m)
  N <- sum(M)
  
  betw <- (1/sum(M)^2)*(N^2 / n) * (1 - (n/N)) * (1/(N - 1)) * sumbet
  withn <- (1/sum(M)^2)*(N / n)*sum(((M^2)/m)*(1 - (m/M)) * Swithin)
  return(c(between = betw, within = withn, total_variance = betw + withn))
}

VarStrat <- function(mvec,Mvec,Si){
  ## FInds the variance of the mean of a stratified sampling schema with finite population correction. 
  ## Use this for smaller sample sizes (when n/N is large). 
  # mvec (vector) : a vector of number of people sampled from each group. 
  # Mvec (vector) : a vector of total population of each sampled group
  # Si (vector) : the standard deviation of each sampled group.
  M <- sum(Mvec)
  m <- sum(mvec)
  
  res <- sum(((Mvec/M)^2)*(1 - (mvec/Mvec))*(Si/mvec))
  return(res)
}

VarStratNoFinPop <- function(mvec,Mvec,Si){
  ## FInds the variance of the mean of a stratified sampling schema with no finite population correction. 
  ## Use this for larger sample sizes (when n/N is small). 
  # mvec (vector) : a vector of number of people sampled from each group. 
  # Mvec (vector) : a vector of total population of each sampled group
  # Si (vector) : the standard deviation of each sampled group.
  M <- sum(Mvec)
  m <- sum(mvec)
  
  res <- sum(((Mvec/M)^2)*(Si/mvec))
  return(res)
}
