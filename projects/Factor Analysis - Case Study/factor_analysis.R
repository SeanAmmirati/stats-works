require(psych)

## This was a project done using Factor Analysis, analyzing a personality questionaire and attempting to determine if the data could be reduced
## to a small number of factors. This involves a feature reduction based on some latent variables, which we are considering to be our factors. 

tmp <- tempfile()
download.file("http://personality-testing.info/_rawdata/AS+SC+AD+DO.zip", tmp)
data <- read.csv(unz(tmp, 'AS+SC+AD+DO/data.csv'))
unlink(tmp)

data <- data[,1:40]
data
## There were forty questions on the questionaire, with every ten representing a "factor" of one's personality. We are using factor analysis to 
## determine whether there is statistical evidence that these groupings represent latent 'factors'. 

# In order to perform factor analysis, we must find the correlation matrix of the dataset. This makes many of the calculations quite simple. 
R <- cor(data)


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
sum(eigen(R)$values > 1) ##choose 8

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
eigenvectors <- eigen(R)$vectors[,1:9]
loadings <- eigenvectors %*% (diag(1,nrow = 9)*(eigen(R)$values[1:9])^.5)
hisq <- apply(apply(loadings, 2, function(x) x^2), 1, sum)
psi <- rep(1,40) - hisq

## varimax includes a print method which makes the loading distributions easier to see.
print(varimax(loadings)$loadings,cutoff = .3,sort = T)
loadingsrot <- print(varimax(loadings)$loadings,cutoff = .3,sort = T)

##Principle Factor
hinit <- 1 - 1/diag(solve(R))
psiint <- 1 - hinit
diag(psiint,nrow = 40)


New <- R - diag(psiint,nrow = 40)
eigen(New)
eigenvectors2 <- eigen(New)$vectors[,1:9]
loadings2 <- eigenvectors2 %*% (diag(1,nrow = 9)*(eigen(New)$values[1:9])^.5)
hisq2 <- apply(apply(loadings2, 2, function(x) x^2), 1, sum)
psi <- rep(1,40) - hisq
loadings2rot <- print(varimax(loadings2)$loadings,cutoff = .35)

##3
hinit2 <- 1 - 1/diag(solve(R))
for (i in 1:100) {
  New2 <- R - diag((1 - hinit2),nrow = 40)
  eigenvectors3 <- eigen(New2)$vectors[,1:9]
  loadings3 <- eigenvectors3 %*% (diag(1,nrow = 9)*(eigen(New2)$values[1:9])^.5)
  hinit2 <- apply(apply(loadings3, 2, function(x) x^2), 1, sum)
}
hisq3 = hinit2 
loadings3
hisq3
loadings
loadings3rot <- print(varimax(loadings3)$loadings,cutoff = .3)


##fit 
Betahat <- solve(R) %*% loadings

