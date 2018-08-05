#Begin with initializations  
set.seed(42)
library(lme4)
require(optimx)
library(nloptr)

nlopt <- function(par, fn, lower, upper, control) {
  .nloptr <<-  res <- nloptr(par, fn, lb = lower, ub = upper, 
                            opts = list(algorithm = "NLOPT_LN_BOBYQA", print_level = 1,
                                        maxeval = 1000, xtol_abs = 1e-6, ftol_abs = 1e-6))
  list(par = res$solution,
       fval = res$objective,
       conv = if (res$status > 0) 0 else res$status,
       message = res$message
  )
}

#Sets the optimizer for use with lmer functions later on 

simmod1 <- list()
simmod2 <- list()
simmod3 <- list()
simmod4 <- list()
simmod5 <- list()
simmod6 <- list()
simmod7 <- list()
simmod8 <- list()
simmod9 <- list()
simmod10 <- list()

N = 5
n = 3

gamma00 <- 0
gamma01 <- 1
gamma10 <-  -.2
gamma11 <-  -.01
sigma = .8

x0j <- 0;x1j <- 1;x2j <- 2;x3j <- 6

xmat <- t(matrix(c(rep(x0j,N),rep(x1j,N),rep(x2j,N),rep(x3j,N)),nrow = 5))

#Initial conditions that are static throughout the simulations - the true values, the number of level2 and level 1 variables, etc. Creates an x matrix which contains the initial data. Creates lists which will store the simulations' results.

for(sim in 1:10^5) {
  
  baselineBMI <- rnorm(N,28,6)
  
  
  data <- matrix(nrow = 4,ncol = 5)
  data[1,] <- baselineBMI
  
  for(i in 2:(n + 1)) {
    for(j in 1:N) {
      data[i,j] <- gamma00 + gamma01*data[1,j] + gamma10*xmat[i,j] + gamma11*data[1,j]*xmat[i,j] + rnorm(1,0,sigma)
    }
  }
  
  #Sets initializations for each simulation - samples BMI from normal distribution, and creates a dataframe which stores the simulated data.
  
  
  BMI <- as.vector(data)
  xij <- as.vector(xmat)
  i <- rep(c(0:n),5)
  j <- c(rep(1,4),rep(2,4),rep(3,4),rep(4,4),rep(5,4))
  baseline <- c(rep(baselineBMI[1],4),rep(baselineBMI[2],4),rep(baselineBMI[3],4),rep(baselineBMI[4],4),rep(baselineBMI[5],4))
  
  fulldata1 <- data.frame(BMI,xij,i,j,baseline)
  
  
  fulldata2 <- as.data.frame(fulldata1[-c(1,5,9,13,17),])
  
  fulldata3 <- fulldata2
  fulldata3[,1] <- fulldata3[,1]-fulldata3[,5]
  
  #Cleans up the data for use - creates three datasets, one with i = 0 included, one without, and one where the baseline is subtracted from each value. 
  
  model1 <- lm(BMI~xij*baseline,data = fulldata1)
  mod1coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma"))
  mod1coef[1:4,1] <- model1$coeff;mod1coef[5,1] <- summary(model1)$sigma
  
  
  model2 <- lm(BMI~xij*baseline,data = fulldata2)
  mod2coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma"))
  mod2coef[1:4,1] <- model2$coeff;mod2coef[5,1] <- summary(model2)$sigma
  
  
  model3 <- lm(BMI~xij*baseline-1,data = fulldata1)
  mod3coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma"))
  mod3coef[1:4,1] <- c(0,model3$coeff);mod3coef[5,1] <- summary(model3)$sigma
  
  
  model4 <- lm(BMI~xij*baseline-1,data = fulldata2)
  mod4coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma"))
  mod4coef[1:4,1] <- c(0,model4$coeff);mod4coef[5,1] <- summary(model4)$sigma
  
  model5 <- lm(BMI~xij*baseline-1-baseline,data = fulldata3)
  mod5coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma"))
  mod5coef[1:4,1] <- c(0,model5$coeff[1],0,model5$coeff[2]);mod5coef[5,1] <- summary(model5)$sigma
  
  
  #Stores coefficients for each model that are necessary for analysis, then puts these into a list for each simulation. 
  
  simmod1[[sim]] <- mod1coef
  simmod2[[sim]] <- mod2coef
  simmod3[[sim]] <- mod3coef
  simmod4[[sim]] <- mod4coef
  simmod5[[sim]] <- mod5coef
}

true <- c(gamma00,gamma10,gamma01,gamma11,sigma)

bias <- matrix(c(rep(0,25)),ncol = 5)
for(l in 1:10^5) {
  for(w in 1:5) {
    for(r in 1:5) {
      biasforeach <- (list(simmod1,simmod2,simmod3,simmod4,simmod5)[[r]][[l]][w,]-true[w])
      bias[r,w] <- bias[r,w] + biasforeach
    }
  }
}
bias <- bias/10^5

mse <- matrix(c(rep(0,25)),ncol = 5)
for(l in 1:10^5) {
  for(w in 1:5) {
    for(r in 1:5) {
      mseforeach <- (list(simmod1,simmod2,simmod3,simmod4,simmod5)[[r]][[l]][w,]-true[w])^2
      mse[r,w] <- mse[r,w] + mseforeach
    }
  }
}
mse <- mse/10^5

means <- matrix(c(rep(0,25)),ncol = 5)
for(l in 1:10^5) {
  for(w in 1:5) {
    for(r in 1:5) {
      sumcounter <- (list(simmod1,simmod2,simmod3,simmod4,simmod5))[[r]][[l]][w,]
      means[r,w] <- means[r,w] + sumcounter
    }
  }
}
means <- means/10^5

variance <- matrix(c(rep(0,25)),ncol = 5)
for(l in 1:10^5) {
  for(w in 1:5) {
    for(r in 1:5) {
      varforeach <- (list(simmod1,simmod2,simmod3,simmod4,simmod5)[[r]][[l]][w,]-means[r,w])^2
      variance[r,w] <- variance[r,w] + varforeach
    }
  }
}
variance <- variance/10^5

#This creates the inputs for the data above by calculating the bias, mse and variance (as well as the mean to find the variance) for each of the models. l here represents the simulation number, w the parameter which is being estimated, and r the model which it is being calculated for. It adds all of these values up, and then divides by the number of simulations.  

means
variance
mse
bias


gamma00table <- t(data.frame(bias[,1],variance[,1],mse[,1]));gamma00table <- gamma00table[,1:2];
gamma10table <- t(data.frame(bias[,2],variance[,2],mse[,2]))
gamma01table <- t(data.frame(bias[,3],variance[,3],mse[,3]));gamma01table <- gamma01table[,1:4]
gamma11table <- t(data.frame(bias[,4],variance[,4],mse[,4]))
sigmatable <- t(data.frame(bias[,5],variance[,5],mse[,5]))

rownames(gamma00table) <- row.names(gamma10table) <- row.names(gamma01table) <- row.names(gamma11table) <- row.names(sigmatable) <- c("Bias","Variance","MSE")

#This creates the tables that are shown at the beginning of the document from the data which was stored in the matrices

gamma00table
gamma01table
gamma10table
gamma11table
sigmatable

#lmer models
sigma  <-  .6
tao0 <- .4
tao1 <- .03
convergence1 <- list();convergence2 <- list();convergence3 <- list();convergence4 <- list();convergence5 <- list()

for(sim in 1:10^5) {
  baselineBMI <- rnorm(N,28,6)
  
  
  data <- matrix(nrow = 4,ncol = 5)
  data[1,] <- baselineBMI
  
  for(j in 1:N) {
    #specify the level 2 random effect first in outer loop produces same variances within groups
    u0j <- rnorm(1,0,tao0);u1j <- rnorm(1,0,tao1)
    for(i in 2:(n + 1)) {
      data[i,j] <- gamma00 + gamma01*data[1,j] + gamma10*xmat[i,j] + gamma11*data[1,j]*xmat[i,j] + rnorm(1,0,sigma) + u0j + u1j*xmat[i,j]
    }
  }
  
  BMI <- as.vector(data)
  xij <- as.vector(xmat)
  i <- rep(c(0:n),5)
  j <- c(rep(1,4),rep(2,4),rep(3,4),rep(4,4),rep(5,4))
  baseline <- c(rep(baselineBMI[1],4),rep(baselineBMI[2],4),rep(baselineBMI[3],4),rep(baselineBMI[4],4),rep(baselineBMI[5],4))
  
  fulldata1 <- data.frame(BMI,xij,i,j,baseline)
  
  fulldata2 <- as.data.frame(fulldata1[-c(1,5,9,13,17),])
  
  fulldata3 <- fulldata2
  fulldata3[,1] <- fulldata3[,1]-fulldata3[,5]
  
  model1 <- lmer(BMI~xij*baseline + (1 + xij|j),control = lmerControl(optimizer = "nloptwrap",calc.derivs = FALSE),data = fulldata1)
  mod1coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma","tao0","tao1","corr"))
  mod1coef[1:4,1] <- summary(model1)$coefficients[,1];mod1coef[5,1] <- summary(model1)$sigma;mod1coef[6:8,1] <- as.data.frame(VarCorr(model1))[1:3,"sdcor"]
  convergence1[[sim]] <- model1@optinfo$conv$opt 
  
  model2 <- lmer(BMI~xij*baseline + (1 + xij|j),control = lmerControl(optimizer = "nloptwrap",calc.derivs = FALSE),data = fulldata2)
  mod2coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma","tao0","tao1","corr"))
  mod2coef[1:4,1] <- summary(model2)$coefficients[,1];mod2coef[5,1] <- summary(model2)$sigma;mod2coef[6:8,1] <- as.data.frame(VarCorr(model2))[1:3,"sdcor"]
  convergence2[[sim]] <- model2@optinfo$conv$opt
  
  
  model3 <- lmer(BMI~xij*baseline-1 + (1 + xij|j),control = lmerControl(optimizer = "nloptwrap",calc.derivs = FALSE),data = fulldata1)
  mod3coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma","tao0","tao1","corr"))
  mod3coef[2:4,1] <- summary(model3)$coefficients[,1];mod3coef[5,1] <- summary(model3)$sigma;mod3coef[6:8,1] <- as.data.frame(VarCorr(model3))[1:3,"sdcor"]
  convergence3[[sim]] <- model3@optinfo$conv$opt
  
  
  model4 <- lmer(BMI~xij*baseline-1 + (1 + xij|j),control = lmerControl(optimizer = "nloptwrap",calc.derivs = FALSE),data = fulldata2)
  mod4coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma","tao0","tao1","corr"))
  mod4coef[2:4,1] <- summary(model4)$coefficients[,1];mod4coef[5,1] <- summary(model4)$sigma;mod4coef[6:8,1] <- as.data.frame(VarCorr(model4))[1:3,"sdcor"]
  convergence4[[sim]] <- model4@optinfo$conv$opt
  
  model5 <- lmer(BMI~xij*baseline-1-baseline + (1 + xij|j),control = lmerControl(optimizer = "nloptwrap",calc.derivs = FALSE),data = fulldata3)
  mod5coef <- data.frame(row.names = c("gamma00","gamma10","gamma01","gamma11","sigma","tao0","tao1","corr"))
  mod5coef[c(2,4),1] <- summary(model5)$coefficients[,1];mod5coef[5,1] <- summary(model5)$sigma;mod5coef[6:8,1] <- as.data.frame(VarCorr(model5))[1:3,"sdcor"]
  convergence5[[sim]] <- model5@optinfo$conv$opt
  
  simmod6[[sim]] <- mod1coef
  simmod7[[sim]] <- mod2coef
  simmod8[[sim]] <- mod3coef
  simmod9[[sim]] <- mod4coef
  simmod10[[sim]] <- mod5coef
}

true <- c(gamma00,gamma10,gamma01,gamma11,sigma,tao0,tao1)

bias <- matrix(c(rep(0,35)),ncol = 7)
for(l in 1:10^5) {
  for(w in 1:7) {
    for(r in 1:5) {
      biasforeach <- (list(simmod6,simmod7,simmod8,simmod9,simmod10)[[r]][[l]][w,]-true[w])
      bias[r,w] <- bias[r,w] + biasforeach
    }
  }
}
bias <- bias/10^5

mse <- matrix(c(rep(0,35)),ncol = 7)
for(l in 1:10^5) {
  for(w in 1:7) {
    for(r in 1:5) {
      mseforeach <- (list(simmod6,simmod7,simmod8,simmod9,simmod10)[[r]][[l]][w,]-true[w])^2
      mse[r,w] <- mse[r,w] + mseforeach
    }
  }
}
mse <- mse/10^5

means <- matrix(c(rep(0,35)),ncol = 7)
for(l in 1:10^5) {
  for(w in 1:7) {
    for(r in 1:5) {
      sumcounter <- (list(simmod6,simmod7,simmod8,simmod9,simmod10))[[r]][[l]][w,]
      means[r,w] <- means[r,w] + sumcounter
    }
  }
}
means <- means/10^5
true
means
variance <- matrix(c(rep(0,35)),ncol = 7)
for(l in 1:10^5) {
  for(w in 1:7) {
    for(r in 1:5) {
      varforeach <- (list(simmod6,simmod7,simmod8,simmod9,simmod10)[[r]][[l]][w,]-means[r,w])^2
      variance[r,w] <- variance[r,w] + varforeach
    }
  }
}

variance <- variance/10^5

gamma00table2 <- t(data.frame(bias[,1],variance[,1],mse[,1]));gamma00table2 <- gamma00table2[,1:2];
gamma10table2 <- t(data.frame(bias[,2],variance[,2],mse[,2]))
gamma01table2 <- t(data.frame(bias[,3],variance[,3],mse[,3]));gamma01table2 <- gamma01table2[,1:4]
gamma11table2 <- t(data.frame(bias[,4],variance[,4],mse[,4]))
sigmatable2 <- t(data.frame(bias[,5],variance[,5],mse[,5]))
tao0table <- t(data.frame(bias[,6],variance[,6],mse[,6]))
tao1table <- t(data.frame(bias[,7],variance[,7],mse[,7]))

row.names(gamma00table2) <- row.names(gamma10table2) <- row.names(gamma01table2) <- row.names(gamma11table2) <- row.names(sigmatable2) <- row.names(tao0table) <- row.names(tao1table) <- c("Bias","Variance","MSE")

##Result Tables 
options(scipen = 999)
colnames(gamma00table) <- colnames(gamma00table2) <- c("Model 1","Model 2")
colnames(gamma10table) <- colnames(gamma10table2) <- colnames(gamma11table) <- colnames(gamma11table2) <- colnames(sigmatable) <- colnames(sigmatable2) <- colnames(tao0table) <- colnames(tao1table) <- c("Model 1","Model 2","Model 3","Model 4","Model 5")
colnames(gamma01table) <- colnames(gamma01table2) <- c("Model 1","Model 2","Model 3","Model 4")
#Models 1-5
signif(gamma00table,3)
signif(gamma01table,3)
signif(gamma10table,3)
signif(gamma11table,3)
signif(sigmatable,3)

#Models 6-10
signif(gamma00table2,3)
signif(gamma01table2,3)
signif(gamma10table2,3)
signif(gamma11table2,3)
signif(sigmatable2,3)
signif(tao0table,3)
signif(tao1table,3)

