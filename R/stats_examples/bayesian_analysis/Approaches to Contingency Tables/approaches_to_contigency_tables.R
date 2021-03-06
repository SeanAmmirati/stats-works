
## Here we will be investigating a few ways of dealing with contingency tables. 

## The first two are standard procedures in frequentist statistics, the chi-squared test and the Fischer's Exact test. 

## Consider a contingency table that looks like this: 

cont_table <- matrix(c(5, 15, 30, 20), nrow = 2,
                     dimnames = list(c('Has traveled outside US','Has not traveled outside US'), c('Non-Artist','Artist')))
cont_table

## Consider if we ask the question -- are artists and non-artists equally likely to travel outside of the US...? 

## The first approach we can take is the chi-squared test, which is an asymptotically accurate. If each was equally likely to travel, we would
## expect a cont_table like this : 

cont_table_exp <- matrix(c(10, 10, 25, 25), nrow = 2, 
                         dimnames = list(c('Has traveled outside US','Has not traveled outside US'), c('Non-Artist','Artist')))

cont_table_exp

# If we assume that artistry and travel likelihood are independent, our sum of the differences from this expectation divided by the square root of the expectation 
# should be roughly normally distributed and so the squared differences will be approximately chi-squared distributed.
# Here, we assume that the observed counts are Poisson distributed, so that their expectation and variance are defined by E and 1/sqrt(E)
# This is because we are essentially summing independent r.v.s. As n -> infinity, this is asymptotically normal GIVEN the hypothesis of independence. 

# Because we know the row and column totals, in this case we have a degree of freedom of 1 -- when one value is known on this contingency table,
# given the row and column totals we can deduce the others. In order to calculate an (approximate) probability of this example given independence 
# (the null hypothesis), we perform the following calculation. 

zsq <- sum((cont_table - cont_table_exp)^2 / cont_table_exp)
1 - pchisq(zsq,1)

## So we would reject the notion of independence based on these observations. 

## More generally: 

chi_squared_test <- function(cont_table, 
                             cont_table_exp = t(matrix(rep(apply(cont_table,2,sum)/ncol(cont_table),ncol(cont_table)), ncol = ncol(cont_table)))){
  df <- (nrow(cont_table) - 1)*(ncol(cont_table) - 1)
  zsq <- sum((cont_table - cont_table_exp)^2 / cont_table_exp)
  probability <- 1 - pchisq(zsq, df)
  return(probability)
}

#Fischer Exact Test

# However, the chi-squared test is only asympotically accurate. If we consider the counts to be distributed as a hyper-geometric distribution, 
# we can use Fisher's Exact Test to calculate the probability of independence. 

# Given some values in the contingency table, the probability of any distribution of values given independence is as follows: 

probfun <- function(i, j, n, m){
  # i: particular coordinate (for instance, non-artist, has not traveled)
  # j: the column total for the particular coordinate (for instance, non-artists)
  # n: the row total for particular coordinate (for instance, people who have traveled)
  # m: the row total for the other coordinate (for instance, people who have not traveled)
  
  choose(m,i)*choose(n,(j - i))/choose(m + n,j)
}

# This will give us the exact probability of each coordinate. If we wanted to find the probability that non-artist, people who traveled is 
# less than or equal to five, we would do the following in this case:
sum(sapply(0:5,function(x) probfun(x, 20, 35, 35)))

# This shows that the probability of what we have observed is quite small if the columns and rows are independent. We again reject independence with 1% significance. 
# The results of this test and the chisquared test are also quite close, which is as expected. As n goes to infinity, the chisquared test converges to the Fischer's Exact test. 

# This is the hyper geometric distribution, which is included in R. The results are the same:

phyper(5,35,35,20)##same result

# These are well known tests we can make. However, we can add some bayesian analysis to the mix here! 

# Let us assume that the probability of having traveled for artists and non-artists can be modeled using a Beta distribution. That is 
# p(travel|non-artist) = p ~ Beta(alpha1, Beta1) and p(travel|artist) = q ~ Beta(alpha2, Beta2).

# We can now make an approximation to determine the probability that p < q. That is, we want the posterior distribution of p and q given
# our contingency table. Because our likelihood is multinomial, we know that the posterior distribution is also Beta distributed. After doing some 
# manipulations, we can write the posterior distribution of prob(p<q|data, hyperparameters).

## This is actually a Dirichlet probability distribution. This is the multivariate extension of the Beta distribution. 

# If we assume uninformative priors, we set alpha = beta = -1 to get the following:
posteriorb <- function(p,q, cont_table, num = FALSE){
  if (num == TRUE) {
    if (p >= q) {
      return(0)
    }
  }
  
  obs_row_totals = apply(cont_table, 1, sum)
  obs_coordinates = c(cont_table)
  obs_rows_list = lapply(1:nrow(cont_table), function(i) cont_table[i,] - 1)
  
  # Here, ret is the probability of the contingency table given p and q -- it is a likelihood multinomial distributed. 
  # So p,q are Dirichlet distributed. 
  constant <- (prod(gamma(obs_row_totals)) / (prod(gamma(obs_coordinates))))
  ret <- constant*(p^obs_rows_list[[1]][1])*((1 - p)^obs_rows_list[[1]][2])*(q^obs_rows_list[[2]][1])*((1 - q)^obs_rows_list[[2]][2])
  return(ret)
}

## Note that this will only work for 2x2 contingency tables and assuming a prior of alpha = beta = -1 for each prior. If we wanted to include 
## prior information, we could change these for each prior, which would result in a different number being added/subtracted above. 

# The Dirichlet distribution is a continuous distribution, so determining the actual probabilities here may be difficult to do. There are alternative
# here to estimate this probability (gtools, MCMCpack, etc), but I have included a numerical approximation. 


approx <- function(f,num=FALSE, ...) {
  sum(sapply(seq(0.01,0.99,0.01),function(p) sapply(seq(0.01,0.99,0.01), function(q) f(p,q,num,...))))
}

estim <- approx(posteriorb,TRUE, cont_table = cont_table)/approx(posteriorb, cont_table = cont_table)
estim

#We estimate P(p<q) = .9965571. Here, we individual values of p,q and compare their pdf evaluations at each point. 

## Let's use another formulation that allows p and q to depend on one another. That is, it is unlikely that p and q are distributed independently -- 
## there is an underlying 'willing to travel' factor that is prevalent in both groups. We saw this when we considered the earlier tests.  
## If we assume then that p/(1-p) - q/(1-q) or the difference in their 
## odds ratios is normally distributed with mean 0 and variance sigma squared, we are allowing for some dependencies based on the value of 
## sigma squared that we select. Selecting a small value of sigmasquared introduces a higher dependency structure.
## We can then test, for a certain level of expected variance in their difference, whether they are independent or not. 

posteriorc <- function(p,q, cont_table, num = FALSE, sigmasq = 1){
  if (num == TRUE) {
    if (p >= q) {
      return(0)
    }
  }
  
  obs_rows_list = lapply(1:nrow(cont_table), function(i) cont_table[i,] - 1)
  
  logit1 <- log((p/(1 - p)))
  logit2 <- log((q/(1 - q)))
  
  ## Now our likelihood depends on the difference in logits -- it is no longer a constant given the data. This introduces 
  ## the dependence structure we want. 
  expo <- exp((-(logit1 - logit2)^2)/(2*sigmasq))
  ret <- expo*(p^obs_rows_list[[1]][1])*((1 - p)^obs_rows_list[[1]][2])*(q^obs_rows_list[[2]][1])*((1 - q)^obs_rows_list[[2]][2])
  return(ret)
}
# We then approximate the probability that p < q given various assumed sigmas in the prior. 

estimb1 <- approx(posteriorc,num = TRUE,cont_table = cont_table, sigmasq = 1)/approx(posteriorc,num = FALSE,cont_table = cont_table, sigmasq = 1)
estimb2 <- approx(posteriorc,num = TRUE,cont_table = cont_table, sigmasq = .25)/approx(posteriorc,num = FALSE,cont_table = cont_table, sigmasq = .25)
estimb3 <- approx(posteriorc,num = TRUE,cont_table = cont_table, sigmasq = 4)/approx(posteriorc,num = FALSE,cont_table = cont_table, sigmasq = 4)

# sigmasq = 1
estimb1 
#sigmasq = .25
estimb2 
#sigma sq = 4
estimb3

#sigma sq = 400000 (close to complete independence)
approx(posteriorc,num = TRUE,sigmasq = 400000)/approx(posteriorc,num = FALSE,sigmasq = 400000)

# We see that the larger the variance, the higher the probability that p <= q, that is, that the probabilities are 
# different in the two groups. When we condsidered them to be independent, in part b, we got an estimate of 
# .9965571. It makes sense, then, that as we increase the variance, and therefore the two become closer to being 
# what we would consider as independent from one another, it approaches the value when they are assumed to be independent 
# explicitly. Considering them to have a small variance (.25) will lead to the probability p < q to be smaller than any other 
# method, including the chisquare and Fischer Exact test. When we have a high variance (even at sigma sq = 4), we obtain a higher
# probability that the two probabilities are different. The conclusion then is that the two groups are different from one another. 
# When the variance is small, we are less confident that the two groups are different from one another, both in prior and posterior distribution.

