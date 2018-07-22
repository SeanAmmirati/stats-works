## Consider the t-test of equality of means. Using the standard procedure for a t-test: 
vec1<-c(120,107,110,116,114,111,113,117,114,112)
vec2<-c(110,111,107,108,110,105,107,106,111,111)


test_equality_means <- function(norm_vec1, norm_vec2){
  sx<-var(norm_vec1)
  sy<-var(norm_vec2)
  xbar<-mean(norm_vec1)
  ybar <- mean(norm_vec2)
  n = length(norm_vec1)
  m = length(norm_vec2)
  
  tstat <- (xbar - ybar)/(sqrt((1/n + 1/m)*((n-1)*sx + (m-1)*sy)/(n+m-2)))
  p_tstat <- pt(tstat,n+m-2)
  
  return(list(tstat=tstat, prob=p_tstat))
}

vec1<-c(120,107,110,116,114,111,113,117,114,112)
vec2<-c(110,111,107,108,110,105,107,106,111,111)

test_equality_means(vec1, vec2)


## Now let's try to solve this problem with our Bayesian hats! Assuming that we have a prior distribution of mu and sigma such that 
## x| mu, sigma ~ N(mu, sigma), we want the posterior f(mu| x, sigma). Assuming a prior of mu|sigma ~ Normal(Beta, sigma/sqrt(N)) and 
## S/sigma ~ chisquared(k), we start with prior parameters Beta, n, S and k and update for each value of x as follows: 

simulatepostprob <- function(vec, prior_params=c(n=0,S=0,k=-1,B=0)){
  nnew = prior_params['n']
  Snew = prior_params['S']
  knew = prior_params['k']
  Bnew = prior_params['B']
  
  lst <- list()
  for(i in 1:length(vec)){
    
    obs <- vec[i]
    
    ninit = nnew
    Binit = Bnew
    Sinit = Snew
    kinit = knew 
    
    knew = kinit + 1
    nnew = ninit + 1 
    Bnew <- (ninit*Binit + obs)/nnew
    Snew <- Sinit + ninit*Binit^2 + obs^2 - nnew*Bnew^2
    
    if(knew == 0){
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
## By iterating for each observation, we arrive at a posterior distribution for mu| sigma and sigma. We then sample randomly from these theoretical distributions to 
## sample from the posterior distributions. If we replicate this many times, we will be able to estimate the differences between the posterior distributions of the two vectors.

rpost <- function(n,vec, prior_params=c(n=0,S=0,k=-1,B=0)){
  replicate(n,expr = simulatepostprob(vec)[length(vec)])
}

## Using uninformative prior gives similar results to frequentist t-test method
sum(rpost(1000,vec1)>rpost(1000,vec2))/1000
