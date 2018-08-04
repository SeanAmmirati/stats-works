## Poisson Discrete Updater

## Basic Bayesian analysis on discrete random variables. 

## Given our data follows a Poisson distribution, finds the probability of various 
## lambdas given an observed value using discrete probabilities for discrete lambda values. 

## In this case I have generalized this to where lambda_new = lambda * t where t is the number of days. 

## Consider that the number of events, k, in t days follows a Poisson distribution with lambda = t*l.
## For example, consider that the number of accidents in t days is distributed Poisson(t*l)

## Given prior beliefs about various l values (can be seen as the daily rate), we find the posterior distribution 
## of these lambdas given new information. 

# Variables: 

## pos_lambda (vector): a vector of hypothesized lambdas to check in posterior distribution.
## prior_probs (vector): a vector of prior probabilities for the hypothesized lambdas
## X (dataframe): a dataframe of new observed values, where the first column is the total number of events and t is the 
## total number of days. For instance k=4, t=2 means there were two accidents per day, or 4 accidents in two days. k is the first column and t
## the second. 

ManualPoisson <- function(k,t,l){
  # Same as dpois(x=k,lambda = l*t), or explictly
  return(((t*l)^k)*exp(-t*l)/factorial(k))
}

PosteriorFinder <- function(k,t,plam,pp){
  # Finds the posterior and multiplicative constant for given probabilities and values.
  const <- sum(mapply(function(l,p) ManualPoisson(k,t,l)*p,plam,pp))
  post <- mapply(function(l,p) ManualPoisson(k,t,l)*p/const, plam,pp)
  return(list(const = const, post = post))
}

find_posterior <- function(pos_lambda, prior_probs, X){
  ## sanity checks
  if (sum(pos_lambda > 0) != length(pos_lambda)) {
    stop("Lambdas must all be greater than zero.")
  }
  if (sum(prior_probs) != 1) {
    stop('Priors must sum to 1, as they are probabilities.')
  }
  if (ncol(X) != 2) {
    stop("X can only have two columns (number of incidents and time)")
  }
  if (length(pos_lambda) != length(prior_probs)) {
    stop("The lambda vector and probability vector must be the same length.")
  }
  
  ## Initialize probabilities as prior probabilities. 
  probs <- prior_probs
  # Updates the posteriors for each observed value
  for (i in nrow(X)) {
    k <- X[i,1]
    t <- X[i,2]
    probs <- PosteriorFinder(k,t, pos_lambda, probs)$post
  }
  
  posterior = probs
  return(posterior)
}