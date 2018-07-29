source("./binomial_discrete_updater.R")

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


## Now let's see the behaviors for different n and ks.
n <- c(10,50,100,150,200,300,500)
k <- lapply(n, function(n) seq(n/10,n,n/10))
lapply(1:7,function(i) sapply(1:10, function(j) posterior(k[[i]][j],n[i], posprobs, probsofprobs)))


posterior(1000,2000, posprobs, probsofprobs)
log_transf_posterior(1000,2000)
