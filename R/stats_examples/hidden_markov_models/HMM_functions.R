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


## Hidden Markov Chain functions: 
## Assuming a HMM with transition probabilities, emission probabilities, and an initial probability of starting in each state, finds the 
## probability of a sequence of observed emissions (forward algo) and the probability of a particular observation k in the sequence (backwards-forwards)


forwardalgor <- function(obs, trans,emissions,init){
  alphas <- list(1,init*emissions[,obs[1]])
  
  for (i in 3:(length(obs) + 1)) {
    alphasum <- as.numeric(t(trans) %*% alphas[[i - 1]])
    alphas[[i]] <- emissions[,obs[i - 1]] * alphasum
  }
  print("Sequences:")
  print(alphas)
  print("Final Probability")
  return(sum(alphas[[length(obs)]]))
}

# Example from Word Document: forwardalgor(c(1,2,1,1,2,2,1,1),rbind(c(.9,.1),c(.95,.05)),rbind(c(.5,.5),c(.25,.75)),c(.5,.5))


bkforwardalgor <- function(obs, k, trans,emissions,init){
  alphas <- list(1,init*emissions[,obs[1]]/sum(init*emissions[,obs[1]]))
  betas <- list(rep(1,nrow(trans)))
  
  print(betas)
  for (i in 3:(k + 1)) {
    alphasum <- as.numeric(t(trans) %*% alphas[[i - 1]])
    alphas[[i]] <- emissions[,obs[i - 1]] * alphasum
    alphas[[i]] <- alphas[[i]]/sum(alphas[[i]])
  }
  for (i in 2:(length(obs) - k + 1)) {
    betasum <- emissions[,obs[length(obs) - i + 2]]*betas[[i - 1]]
    betas[[i]] <- as.numeric(trans %*% betasum)
    betas[[i]] <- betas[[i]]/sum(betas[[i]])
  }
  pointalph <- alphas[[(k + 1)]]
  pointbet <- betas[[(length(obs) - k + 1)]]
  
  return(list(forward = alphas, backward = betas, probstates = pointalph*pointbet/sum(pointalph*pointbet)))
}


