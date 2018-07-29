test_equality_means <- function(norm_vec1, norm_vec2){
  sx <- var(norm_vec1)
  sy <- var(norm_vec2)
  xbar <- mean(norm_vec1)
  ybar <- mean(norm_vec2)
  n = length(norm_vec1)
  m = length(norm_vec2)
  
  tstat <- (xbar - ybar)/(sqrt((1/n + 1/m)*((n - 1)*sx + (m - 1)*sy)/(n + m - 2)))
  p_tstat <- pt(tstat,n + m - 2)
  
  return(list(tstat = tstat, prob = p_tstat))
}


simulatepostprob <- function(vec, prior_params=c(n = 0,S = 0,k = -1,B = 0)){
  nnew = prior_params['n']
  Snew = prior_params['S']
  knew = prior_params['k']
  Bnew = prior_params['B']
  
  lst <- list()
  for (i in 1:length(vec)) {
    
    obs <- vec[i]
    
    ninit = nnew
    Binit = Bnew
    Sinit = Snew
    kinit = knew 
    
    knew = kinit + 1
    nnew = ninit + 1 
    Bnew <- (ninit*Binit + obs)/nnew
    Snew <- Sinit + ninit*Binit^2 + obs^2 - nnew*Bnew^2
    
    if (knew == 0) {
      sampchi <- 0
      sigma <- 0
    }else{
      ## We randomly sample a value for sigma|x first 
      sampchi <- sum(rnorm(knew,0,1)^2)
      sigma <- sqrt(Snew/sampchi)
    }
    ## Using sigma, we sample for mu|x, sigma. 
    mu <- rnorm(1,obs + Bnew, sigma / sqrt(nnew))
    lst[[i]] <- mu
  }
  return(unlist(lst))
}

rpost <- function(n,vec, prior_params=c(n = 0,S = 0,k = -1,B = 0)){
  replicate(n,expr = simulatepostprob(vec)[length(vec)])
}


