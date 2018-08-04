## Poisson Glm -- Finding the coefficients manually by iteration. 

library(datasets)
data(discoveries)

disc <- data.frame(count=as.numeric(discoveries),
                   year=seq(0,(length(discoveries)-1),1)
)
glm.fit <- glm(formula = count ~ year, family = "poisson", data = disc)
summary(glm.fit)

# Here, we see the coefficients that R predicts. 
# Using the Fischer equations for the Poisson, we can estimate this ourselves. Here I do 50 iterations, updating b0 and b1 accordingly
find_poisson_coefficients <- function(b0_init, b1_init, n_iterations, df) {
  year = df['year']
  count = df['count']
  
  b0 = b0_init
  b1 = b1_init
  n = 1
  
  while(n < n_iterations){
    I00 <- sum(exp(b0+b1*year))
    I01 <- sum(exp(b0+b1*year)*year)
    I10<- I01
    I11 <- sum(exp(b0+b1*year)*year^2)
    
    A <- matrix(c(I00,I10,I01,I11),nrow=2)
    
    C1 <- sum(count-exp(b0+b1*year))
    C2 <- sum((count-exp(b0+b1*year))*year)
    C <- matrix(c(C1,C2),2)
    
    delta=solve(A,C)
    
    b0=b0+delta[1,]
    b1=b1+delta[2,]
    n=n+1
  }
  
  return(list(b0, b1))
}

find_poisson_coefficients(b0_init = 10, b1_init = .1, n_iterations = 50, df = disc)
##We can see that the parameters I have estimated by iterating the above method 50 times are very close to the estimates provided by R. 

## We can find the deviance as follows: 

Deviance<-function(zk,muhatk)
  return(2*sum(zk*log(ifelse((zk/muhatk==0),1,zk/muhatk))-(zk-muhatk)))


#In this case... 
muk<-exp(predict(glm.fit))
zk<-count

