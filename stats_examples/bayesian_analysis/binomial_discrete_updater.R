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
## Example: consider if we observed 11 events -- as an example, the number of thunderstorms in a month. We want to estimate the probability of a thunderstorm
## given the new data. Assuming weather each day is independent (which is a simplifying assumption), we can assume that the number of thunderstorms in n days can be modeled by 
## a binomial distribution. If we believe prior to this that the distribution looks as it does below (with the highest belief in 35 and 45%), we can now find the 
## posterior of the probabilities after observing the 11 thunderstorms as follows: 

posprobs <- c(.05,.15,.25,.35,.45,.55,.65,.75,.85,.95)
probsofprobs <- c(.07,.13,.26,.26,.13,.07,.02,.02,.02,.02)
length(posprobs) == length(probsofprobs)

posterior(11,27,posprobs, probsofprobs)

## So we now believe with 52% probability that the actual p value is .45. This means the data supports the assumption of 45% chance of thunderstorms a day, given our prior beliefs
## and the independence of events.

## Now let's see the behaviors for different n and ks.
n <- c(10,50,100,150,200,300,500)
k <- lapply(n, function(n) seq(n/10,n,n/10))
lapply(1:7,function(i) sapply(1:10, function(j) posterior(k[[i]][j],n[i], posprobs, probsofprobs)))

# Each list represents n = 10,50,100,150,200,300,500, and each column represents possible ks from n/10 to n.
# We see what is expected with Bayesian probabilities -- as n increases, our confidence in probabilities becomes stronger -- we get values that are nearly 1 for the observations
# which have p = k/n and 0 otherwise. This shows that the prior does not matter in these cases, as we get more observations, the data will overwhelm the prior. 
# For small values of n, we see the opposite -- it is highly skewed by our prior, so that we are not so confident that p = k/n if p was not deemed probable prior.

posterior(1000,2000, posprobs, probsofprobs)
## Notice that we have many machine zeros for large n. This interferes with our calculations, and gives us NaNs for the calculations. 
## The following uses a log transformation to avoid machine zeros and get a : 

log_transf_numerator <- function(k,n){ 
  function(p){
    x <- posprobs[p]
    px <- probsofprobs[p]
    
    mx <- max(sapply(posprobs, function(pr) k*log(pr) + (n - k)*log(1 - pr)))
    
    res <- exp(k*log(x) + (n - k)*log(1 - x) - mx) * probsofprobs[p]
    return(res)
  }
}

log_transf_denominator <- function(k,n){
  sum(sapply(X = 1:length(posprobs),FUN= log_transf_numerator(k,n)))
}

log_transf_probabilitydist <- function(k,n,p){
  log_transf_numerator(k,n)(p)/log_transf_denominator(k,n)
}

log_transf_posterior <- function(k,n){ 
  sapply(X = 1:length(posprobs),FUN=function(x) log_transf_probabilitydist(k,n,x))
}

posterior(1000,2000)
log_transf_posterior(1000,2000)
