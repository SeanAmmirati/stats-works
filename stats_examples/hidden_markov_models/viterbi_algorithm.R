## This investigates HMMs (Hidden Markov Models) with two possible states and six possible emissions using the viterbi algorithm.

## Given a Markov process with two states (state 1 and state 2) and an arbitrary number of possible observed emissions , with transition probabilities
## and emission probabilities given for each state, we can find the most likely sequence of states given some observed emissions. 
## That is the goal of this exercise. 

## This takes less time to run than considering all possible sequences of states -- we only need to consider the state probabilities forwards, rejecting 
## paths that are unlikely at each point. 

## The example which the following function defaults to is the case of a fair and loaded die, each with some probability of values 1-6. 
## The roller does not show you what die he is using, but we know that he will generally switch between the two die with some transition probs.
## The goal is then to find the most likely sequence of fair and loaded die given the observed sequence of emissions (for example 1,2,2,1,3).

viterbialgorithm <- function(values, initprobstates = c(.5,.5), 
                             probvectorstate1 = c(rep(1/6,6)), probvectorstate2 = c(rep(1/10,5),1/2), 
                             Ps1s2 = 0.05, Ps2s1 = .1){
  ## values (vector): a series of observed values of two emissions.
  ## initprobstates (vector, len 2): the probabilities of entering the system in either state. (assuming .5, .5 is the least informative)
  ## probvectorstate1 (vector): the emission probabilities of the first state.
  ## probvectorstate2 (vector): the emission probabilities of the second state. 
  ## Ps1s2 (numeric): probability of entering state 2 from state 1. 
  ## Ps2s1 (numeric): probability of entering state 1 from state 2. 
  

  iterations <- length(values)
  
  initprobstate1 = initprobstates[1]
  initprobstate2 = initprobstates[2]
  
  P11 <- 1 - Ps1s2
  P22 <- 1 - Ps2s1
  
  if (iterations < 1) {
    stop("Length of vector must be a positive integer.")
  }
  
  # Initializes the ret list for the first sequence. 
  ret <- list(c(s0 = 0,s1 = -Inf, s2 = -Inf, st = 0, prevst = NA))
  
  ## Creates the transition matrix. 
  transmatrix <- matrix(c(0,0,0,initprobstate1,P11,Ps2s1,initprobstate2,Ps1s2,P22),ncol = 3)
  
  maxfun <- function(potentialstate, prevvector){
    ## potentialstate (integer): integer referring to the potential state (1 or 2)
    ## prevvector (vector): previous probability of states. 
    
    trans <- transmatrix[, potentialstate + 1]
    mx <- max(prevvector[1:3] + log(trans))
    prevst <- which.max(prevvector[1:3] + log(trans)) - 1
    return(list(val = mx,state = prevst))
  }
  
  for (i in 1:iterations) {
    maxst1 <- maxfun(1,ret[[i]])
    maxst2 <- maxfun(2,ret[[i]])
    ekst1 <- log(probvectorstate1[values[i]])
    ekst2 <- log(probvectorstate2[values[i]])
    
    V1 <- maxst1[['val']] + ekst1
    V2 <- maxst2[['val']] + ekst2
    
    
    end <- which.max(c(V1,V2)) 
    ret[[i + 1]] <- c(s0 = -Inf, s1 = V1, s2 = V2, st = end, prevst = c(maxst1[['state']],maxst2[['state']]))
  }
  
  finalstate <- ret[[iterations + 1]]['st']
  path <- c(rep(0,iterations + 1))
  path[iterations + 1] <- finalstate
  
  for (i in (iterations):2) {
    path[i] <- ret[[i + 1]][5:6][path[i + 1]]
  }
  
  res <- as.data.frame(ret[-1])
  colnames(res) <- c(values)
  
  return(list(steps = res,path = path))
}

## Example with a fair and loaded die. 
observed <- c(6,5,1,1,6,6,4,5,3,1,3,2,6,5,1,2,4,5,3,6,6,6,4,6,3,1,6,3,6,6,6,3,1,6,2,3,2,6,4,5,5,2,3,6,2,6,6,6,6,6,6,2,5,1,5,1,6,3,1)

results <- viterbialgorithm(observed)
resultswords <- c("Fair","Loaded")[results$path]
resultswords

## So this tells us that given the observed die rolls, the most likely sequence of states is as shown above. 

## This did not have to be done manually -- we can use the HMM package to do this. It will serve as a check. 

require(HMM)
mod <- initHMM(c("Fair","Loaded"),c(1,2,3,4,5,6),startProbs = c(.5,.5),transProbs = rbind(c(.95,.05),c(.1,.90)),emissionProbs = rbind(c(rep(1/6,6)),c(rep(1/10,5),1/2)))
viterbi(mod,observed) == resultswords
## :) 