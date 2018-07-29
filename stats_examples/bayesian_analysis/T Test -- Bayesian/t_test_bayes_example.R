source('./T\ Test\ --\ Bayes/t_test_bayes_functions.R')
## Consider the t-test of equality of means. Using the standard procedure for a t-test: 
vec1<-c(120,107,110,116,114,111,113,117,114,112)
vec2<-c(110,111,107,108,110,105,107,106,111,111)

test_equality_means(vec1, vec2)


## Now let's try to solve this problem with our Bayesian hats! Assuming that we have a prior distribution of mu and sigma such that 
## x| mu, sigma ~ N(mu, sigma), we want the posterior f(mu| x, sigma). Assuming a prior of mu|sigma ~ Normal(Beta, sigma/sqrt(N)) and 
## S/sigma ~ chisquared(k), we start with prior parameters Beta, n, S and k and update for each value of x as follows: 

## By iterating for each observation, we arrive at a posterior distribution for mu| sigma and sigma. We then sample randomly from these theoretical distributions to 
## sample from the posterior distributions. If we replicate this many times, we will be able to estimate the differences between the posterior distributions of the two vectors.

## Using uninformative prior gives similar results to frequentist t-test method
sum(rpost(1000,vec1)>rpost(1000,vec2))/1000