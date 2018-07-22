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
