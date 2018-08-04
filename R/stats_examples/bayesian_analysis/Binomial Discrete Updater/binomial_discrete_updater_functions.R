## Finds posterior distribution of observed values assuming that k follows a binomial distribution. p is discrete in this case. 

numerator <- function(k, n, posprobs, probsofprobs){
  ## finds the numerator -- ie P(k|p)P(p)
  ## k (integer) : the total number of observed successes. 
  ## n (integer) : the total number of observed trials.
  ## posprobs (vector): possible p values associated with the random variable k.
  ## probsofprobs (vector): this is our prior, mapping a probability to each possible probability
  
  function(p){
    ## For a particular p, this will find the posterior probability of p given observed values. This is a function generator -- given
    ## values of k and n, we can then find the probability of any particular p. 
    x <- posprobs[p]
    px <- probsofprobs[p]
    
    res <- (x^k)*((1 - x)^(n-k))*px
    return(res)
  }
}

denominator <- function(k,n, posprobs, probsofprobs){
  ## Finds the denominator, the multiplicative constant. Same for all values of p. P(k)
  sum(sapply(X = 1:length(posprobs),FUN= numerator(k,n, posprobs, probsofprobs)))
}

probabilityfinder <- function(k,n,p, posprobs, probsofprobs){
  ## Finds the posterior probability of a particular p value. 
  numerator(k,n, posprobs, probsofprobs)(p)/denominator(k,n, posprobs, probsofprobs)
}

posterior <- function(k,n, posprobs, probsofprobs){ 
  ## Finds the posterior probability mass function of the p values.
  sapply(X = 1:length(posprobs),FUN=function(p) probabilityfinder(k,n,p, posprobs, probsofprobs))
}

log_transf_numerator <- function(k,n){ 
  ## finds the numerator -- ie P(k|p)P(p), using log transform to avoid machine zeros
  ## k (integer) : the total number of observed successes. 
  ## n (integer) : the total number of observed trials.
  ## posprobs (vector): possible p values associated with the random variable k.
  ## probsofprobs (vector): this is our prior, mapping a probability to each possible probability
  function(p){
    ## For a particular p, this will find the posterior probability of p given observed values. This is a function generator -- given
    ## values of k and n, we can then find the probability of any particular p. 
    
    x <- posprobs[p]
    px <- probsofprobs[p]
    
    mx <- max(sapply(posprobs, function(pr) k*log(pr) + (n - k)*log(1 - pr)))
    
    res <- exp(k*log(x) + (n - k)*log(1 - x) - mx) * probsofprobs[p]
    return(res)
  }
}

log_transf_denominator <- function(k,n){
  ## Finds the denominator, the multiplicative constant, using log transform for machine zeros. Same for all values of p. P(k)
  
  sum(sapply(X = 1:length(posprobs),FUN= log_transf_numerator(k,n)))
}

log_transf_probabilitydist <- function(k,n,p){
  ## Finds the posterior probability of a particular p value using log transform. 
  log_transf_numerator(k,n)(p)/log_transf_denominator(k,n)
}

log_transf_posterior <- function(k,n){ 
  ## Finds the posterior probability mass function of the p values using log transform

  sapply(X = 1:length(posprobs),FUN=function(x) log_transf_probabilitydist(k,n,x))
}