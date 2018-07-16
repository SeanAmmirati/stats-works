## This is an example using 'fake' data for the difference between lmer (which assumes a constant (independent) covariance matrix for the error terms)
## and geepack (general estimating equations, which can handle an unknown convariance structure))

## This example highlights the power of using a GEE model over a HLM model when the covariance structure differs at different levels of the data. 
## The GEE model can be seen as a population estimating model -- i.e., it is preferable when we are trying to make inferences about the population
## rather than the individuals in the sample. 

## The problem is formulated as follows: consider 6 athletes with characteristics given by: 
athlete<-c(1,1,1,2,2,2,2,3,3,3,4,4,4,5,5,6,6,6)
age<-c(38,40,43,53,55,56,58,37,40,42,41,45,46,54,58,57,60,62)
club<-c(0,0,1,1,1,1,1,1,1,0,0,1,0,1,1,1,1,1)
time<-c(95,94,93,96,98,91,93,83,82,82,91,94,99,105,111,90,89,95)
logtime<-log(time)

## This is an example of a repeated measures problem. 

## We create a dataframe from these elements:

df<-data.frame(athlete,age,club,time,logtime)
df

## Now, we want to estimate the (log) time based on age and club. However, the data is clearly correlated -- each individual will have different 
## specifications. Consider that we believe that the average (log) time will be different for each individual, as a baseline. This is a mixed model
## more specifically a Random Intercept model. This is highlighted by the following equations. 

mod1<-lmer(logtime~club+log(age)+(1|athlete),data=df,REML=FALSE)
mod2<-lmer(logtime~log(age)+(1|athlete),data=df,REML=FALSE)

summary(mod1)
summary(mod2)

## However, this assumes that the covariance structure of the errors at each level are independent. This assumption is too simplifying -- 
## it is likely that future times will be correlated with the past times for any individual. GEEs are robust to this: if we give it some 
## covariance structure that is not independence, it will be more consistent asymptotically than the HLM. This is illustrated by using the 
## GEE below. 

mod3<-geeglm(logtime~club+log(age),data=df,id=athlete,family=gaussian,corstr="exchangeable")
mod4<-geeglm(logtime~log(age),data=df,id=athlete,family=gaussian,corstr="exchangeable")

summary(mod3)
summary(mod4)

## The main shift in inference here is from likelihood models (which are generally prefered) to a semi-parametric model that depends only on the
## first two moments. GEEs are better estimators of a population-level variance -- they cannot account for individual differences as well as a HLM 
## could. In this example, however, we see that the GEE finds the log(age) value significant where the previous model had not. Depending on the 
## goal of the analysis, the GEE will produce better estimates asymptotically at the cost of sample-level inference. In this case, it seems clear that 
## the GEE is the better alternative, as the covariance structure differs significantly from independence. 