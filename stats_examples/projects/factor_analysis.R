## This was a project done using Factor Analysis, analyzing a personality questionaire and attempting to determine if the data could be reduced
## to a small number of factors. This involves a feature reduction based on some latent variables, which we are considering to be our factors. 

data <- read.csv("C:/Users/Sean/Downloads/AS+SC+AD+DO/data.csv")
data<-data[1:40]

## There were forty questions on the questionaire, with every ten representing a "factor" of one's personality. We are using factor analysis to 
## determine whether there is statistical evidence that these groupings represent latent 'factors'. 

# In order to perform factor analysis, we must find the correlation matrix of the dataset. This makes many of the calculations quite simple. 
R<-cor(data)


## Once we have the correlation matrix, the eigenvalues will tell us the optimal number of ways to reduce the features.
eigen(R)$values

#There are numerous methods to select the number of eigenvectors/eigenvalues we want to include. Each eigenvalue represents the 
#proportion of variance explained by that eigenvector (a linear combination of the variables). We want to select eigenvectors/values such that
# we can explain a good deal of the variance with a smaller number of linear combinations of the features. 

## The first method involves choosing an arbitrary threshold. In this example, at 19 latent variables (that is, reducing the forty variables nearly
## in half) we have acheieved a threshold of variance explained greater than 60%. 
sum(eigen(R)$values[1:19])/40 ##choose 19

## Another method is to select eigenvectors such that each corresponding eigenvalue is greater than one. This means that the eigenvector of variables
## contributes more to the variance of the features than any single feature alone. Using this method, we come up with 8 linear combinations.
sum(eigen(R)$values>1) ##choose 8

## The final methodology is using a scree plot and determining where the eigenvalues level off. This is at 9 linear combinations of the features.
scree(R)##choose 9
fa.parallel(data)

## I proceed using 9 variables as indicated in the scree plot, as 19 is far too many. 

## This is where factor analysis and principle component analysis begin to differ. In PCA, we simply use the eigenvectors of the correlation matrix
## as variables, or 'principle components'. This does not account for the noise in the principle components. 

## Factor analysis considers that these components are representations of some latent variables, that which are the true 'signal' in the correlation 
## matrix, while the remainder is noise. Factor analysis is controversial because it attempts to estimate this latency by approximating correlation
## matrices. 

## There are a number of ways to estimate the latent variables involved here. For more information on how this is done, please see the word file report.  

## PCA 
eigenvectors<-eigen(R)$vectors[,1:9]
loadings<-eigenvectors%*%(diag(1,nrow=9)*(eigen(R)$values[1:9])^.5)
loading1<-as.matrix(loadings[,1],nrow=40);loading2<-as.matrix(loadings[,2],nrow=40);loading3<-as.matrix(loadings[,3],nrow=40);loading4<-as.matrix(loadings[,4],nrow=40);loading5<-as.matrix(loadings[,5],nrow=40);loading6<-as.matrix(loadings[,6],nrow=40);loading7<-as.matrix(loadings[,7],nrow=40);loading8<-as.matrix(loadings[,8],nrow=40);loading9<-as.matrix(loadings[,9],nrow=40)
hisq<-as.matrix(loading1^2+loading2^2+loading3^2+loading4^2+loading5^2+loading6^2+loading7^2+loading8^2+loading9^2,nrow=40)
psi<-as.matrix(rep(1,40))-hisq

## varimax includes a print method which makes the loading distributions easier to see.
print(varimax(loadings)$loadings,cutoff=.3,sort=T)
loadingsrot<- print(varimax(loadings)$loadings,cutoff=.3,sort=T)

##Principle Factor
hinit<-1- 1/diag(solve(R))
psiint<-1-hinit
diag(psiint,nrow=40)


New<-R-diag(psiint,nrow=40)
eigen(New)
eigenvectors2<-eigen(New)$vectors[,1:9]
loadings2<-eigenvectors2%*%(diag(1,nrow=9)*(eigen(New)$values[1:9])^.5)
loading21<-as.matrix(loadings2[,1],nrow=40);loading22<-as.matrix(loadings2[,2],nrow=40);loading23<-as.matrix(loadings2[,3],nrow=40);loading24<-as.matrix(loadings2[,4],nrow=40);loading25<-as.matrix(loadings2[,5],nrow=40);loading26<-as.matrix(loadings2[,6],nrow=40);loading27<-as.matrix(loadings2[,7],nrow=40);loading28<-as.matrix(loadings2[,8],nrow=40);loading29<-as.matrix(loadings2[,9],nrow=40)
hisq2<-as.matrix(loading21^2+loading22^2+loading23^2+loading24^2+loading25^2+loading26^2+loading27^2+loading28^2+loading29^2,nrow=40)
psi<-as.matrix(rep(1,40))-hisq
loadings2rot<-print(varimax(loadings2)$loadings,cutoff=.35)

##3
hinit2<-1- 1/diag(solve(R))
for(i in 1:100){
  New2<-R-diag((1-hinit2),nrow=40)
  eigenvectors3<-eigen(New2)$vectors[,1:9]
  loadings3<-eigenvectors3%*%(diag(1,nrow=9)*(eigen(New2)$values[1:9])^.5)
  loading31<-as.matrix(loadings3[,1],nrow=40);loading32<-as.matrix(loadings3[,2],nrow=40);loading33<-as.matrix(loadings3[,3],nrow=40);loading34<-as.matrix(loadings3[,4],nrow=40);loading35<-as.matrix(loadings3[,5],nrow=40);loading36<-as.matrix(loadings3[,6],nrow=40);loading37<-as.matrix(loadings3[,7],nrow=40);loading38<-as.matrix(loadings3[,8],nrow=40);loading39<-as.matrix(loadings3[,9],nrow=40)
  hiinit2<-as.matrix(loading31^2+loading32^2+loading33^2+loading34^2+loading35^2+loading36^2+loading37^2+loading38^2+loading39^2,nrow=40)
}
loadings3
hiinit2
loadings
loadings3rot<-print(varimax(loadings3)$loadings,cutoff=.3)


##fit 
Betahat<-solve(R)%*%loadings

