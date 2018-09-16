
library(tree)
library(randomForest)
library(MASS)
library(ggplot2)
library(class)

set.seed(43)
mydata  <-  read.csv("../Data/2015_sqf_csv.csv")
sum(is.na(mydata))
nrow(mydata)*ncol(mydata)
names(mydata)


napercol  <-  list()
for (i in 1:ncol(mydata)) {
  napercol[[i]]  <-  sum(is.na(mydata[,i]))
}

mydata <- mydata[,napercol == 0]

lvllist  <-  list()
for (i in 1:ncol(mydata)) {
  lvllist[[i]]  <-  length(levels(mydata[,i]))
}

attach(mydata)
height  <-  12*ht_feet + ht_inch
mydata  <-  data.frame(mydata,height)
mydata  <-  mydata[,(lvllist < 10) & (lvllist != 1)]
mydata  <-  mydata[,-c(1,2,3,4,15,16,18,78,79,83,84)]
mydata  <-  na.omit(mydata)
mydata  <-  mydata[mydata$age < 100,]

train  <-  sample(1:nrow(mydata), 3*nrow(mydata)/4)
mydata.test  <-  mydata[-train, ]
arrest.test  <-  mydata$arstmade[-train]

attach(mydata)


#descriptive
sum(arstmade == 'Y')/nrow(mydata)
sum(sex == "M")/nrow(mydata)
sum(forceuse != ' ')/nrow(mydata)
sum(race == 'B')/nrow(mydata)
sum(sumissue == "Y")/nrow(mydata)
sum(arstmade == "Y")/sum(sumissue == "Y")
sum(sb_other == "Y")/nrow(mydata)
sum(sb_other == "Y")/sum(searched == "Y")
sum(pf_other == "Y")/nrow(mydata)



mean(mydata$age)
black <- as.factor(race == "B")
white <- as.factor(race == "W")
nonwhite <- as.factor(race != "W")
summary(mydata)



ggplot(mydata,aes(sb_other)) +
  geom_bar(aes(fill = arstmade)) +
  ggtitle("Arrests Conditional on if Reason for Search classified as OTHER") + 
  xlab("Was the reason for search classifed as other?") + 
  ylab("Number of Incidents") + 
  scale_fill_discrete(name = "Arrest Status",labels = (c("Not Arrested","Arrested")))

ggplot(mydata,aes(arstmade)) + 
  geom_bar(aes(fill = black)) + 
  ggtitle("Bar Graph of Arrests for Blacks vs. Non-Blacks") + 
  xlab("Was the person arrested?") + 
  ylab("Numer of Incidences") + 
  scale_fill_discrete(name = "Race",labels = c("Non-Blacks","Blacks"))

ggplot(mydata,aes(black)) +
  geom_bar(fill = "red") +
  ggtitle("Blacks vs. Non-Blacks Who Were Stopped and Frisked") +
  xlab("Was the person black?") +
  ylab("Number of Incidents")

ggplot(mydata,aes(contrabn)) +
  geom_bar(aes(fill = arstmade)) +
  ggtitle("Were those with contraband arrested?") +
  xlab("Contraband")


##logistic models
logistfullmodel <- glm(arstmade~.,data = mydata[train,],family = binomial)
summary(logistfullmodel)

step(logistfullmodel)

stepwiselogmodel <- glm(formula = arstmade ~ recstat + inout + trhsloc + perobs + 
    typeofid + sumissue + offunif + frisked + searched + contrabn + 
    pistol + knifcuti + othrweap + pf_hands + pf_wall + pf_grnd + 
    pf_drwep + pf_hcuff + pf_pepsp + pf_other + radio + ac_rept + 
    rf_vcrim + rf_othsw + ac_proxm + rf_attir + cs_objcs + cs_casng + 
    cs_lkout + cs_cloth + cs_drgtr + ac_evasv + ac_assoc + rf_rfcmp + 
    rf_verbl + cs_vcrim + cs_bulge + cs_other + rf_knowl + ac_other + 
    sb_hdobj + sb_other + revcmd + rf_furt + rf_bulg + forceuse + 
    sex + race + age + weight + city + detailCM, family = binomial, 
    data = mydata[train, ])

summary(stepwiselogmodel)
plot(stepwiselogmodel)


fit1 <- predict(stepwiselogmodel,newdata = mydata.test,type = "response")
fit1 <- ifelse(fit1 > .5,1,0)
sum(fit1)/nrow(mydata.test)

table1 <- table(fit1,arrest.test)
misclasserrorstepwise <- 1 - sum(diag(table1))/nrow(mydata.test)
table1
round(misclasserrorstepwise,3)

fitted3 <- ifelse(fit1 > .17,1,0)
sum(fitted3)/nrow(mydata.test)


fit2 <- predict(logistfullmodel,newdata = mydata.test,type = "response")
fitted2 <- ifelse(fit2 > .5,1,0)
sum(fitted2)/nrow(mydata.test)

table2 <- table(fitted2,arrest.test)
misclasserrorsfull <- 1 - sum(diag(table2))/nrow(mydata.test)
table2
round(misclasserrorsfull,3)


##KNN Methods

train1 <- model.matrix(arstmade~.,data = mydata[train,])
test1 <- model.matrix(arstmade~.,data = mydata.test)
knn.predict <- knn(train1,test1,arstmade[train],k = 10)

table3 <- table(knn.predict,arrest.test)
table3
KNNMisclass <- 1 - sum(diag(table3))/nrow(mydata.test)
round(KNNMisclass,3)

train2 <- model.matrix(arstmade~.,data = mydata[train,])[,7:60]
test2 <- model.matrix(arstmade~.,data = mydata.test)[,7:60]
knn.predict2 <- knn(train2,test2,arstmade[train],k = 5)

table4 <- table(knn.predict2,arrest.test)
table4
KNNMisclass2 <- 1 - sum(diag(table4))/nrow(mydata.test)
round(KNNMisclass2,3)

##tree methods

tree.arrest  <-  tree(arstmade ~ ., mydata[train,])
plot(tree.arrest,main = "Unpruned Tree")
text(tree.arrest,cex = 0.9)

cv.arrest <- cv.tree(tree.arrest,FUN = prune.misclass)
plot(cv.arrest$size, cv.arrest$dev, type = "b", xlab = "Number of Nodes",
     ylab = "Deviance",main = "Determining Best Reduction of Trees by Deviance")
points(3,cv.arrest$dev[3],col = "red")

prune.arrest <- prune.misclass(tree.arrest, best = 3)
plot(prune.arrest)
text(prune.arrest)


tree.pred <- predict(tree.arrest,newdata = mydata.test,type = "class")
table5 <- table(tree.pred,arrest.test)

misclassificationunprune <- 1 - sum(diag(table5))/nrow(mydata.test)
table5
round(misclassificationunprune,3)

pruned.pred <- predict(prune.arrest,newdata = mydata.test,type = "class")
table6 <- table(pruned.pred,arrest.test)
misclassificationprune <- 1 - sum(diag(table6))/nrow(mydata.test)
table6
round(misclassificationprune,3)

##Bagging

bag.arrest <-  randomForest(arstmade~ ., data = mydata[train,], mtry = (ncol(mydata) - 1), importance = TRUE, ntree = 300)
bag.pred <- predict(bag.arrest,newdata = mydata.test,type = "class")
table7 <- table(bag.pred,arrest.test)

misclassificationbagging <- 1 - sum(diag(table7))/nrow(mydata.test)
table7
round(misclassificationbagging,3)
varImpPlot(bag.arrest)

plot(bag.arrest,main = "Trees vs Errors")

bag.arrest2 <-  randomForest(arstmade~ ., data = mydata[train,], mtry = (ncol(mydata) - 1), importance = TRUE, ntree = 25)
bag.pred2 <- predict(bag.arrest2,newdata = mydata.test,type = "class")
table8 <- table(bag.pred2,arrest.test)

misclassificationbagging2 <- 1 - sum(diag(table8))/nrow(mydata.test)
table8
round(misclassificationbagging2,3)
varImpPlot(bag.arrest2)

##Random Forest

RF.arrest <- randomForest(arstmade~ ., data = mydata[train,], mtry = 9, importance = TRUE, ntree = 300)
RF.pred <- predict(RF.arrest,newdata = mydata.test,type = "class")
table9 <- table(RF.pred,arrest.test)
misclassRF <- 1 - sum(diag(table9))/nrow(mydata.test)
table9
round(misclassRF,3)
varImpPlot(RF.arrest,main = "Imporance of Variables")


RF2.arrest <- randomForest(arstmade~ ., data = mydata[train,], mtry = (ncol(mydata) - 1)/2, importance = TRUE, ntree = 300)
RF2.pred <- predict(RF2.arrest,newdata = mydata.test,type = "class")
table10 <- table(RF2.pred,arrest.test)
misclassRF2 <- 1 - sum(diag(table10))/nrow(mydata.test)
table10
round(misclassRF2,3)
varImpPlot(RF2.arrest)

plot(RF2.arrest)

RF3.arrest <- randomForest(arstmade~ ., data = mydata[train,], mtry = (ncol(mydata) - 1)/2, importance = TRUE, ntree = 40)
RF3.pred <- predict(RF3.arrest,newdata = mydata.test,type = "class")
table11 <- table(RF3.pred,arrest.test)
misclassRF3 <- 1 - sum(diag(table11))/nrow(mydata.test) 
table11
round(misclassRF3,3)

Method <- c("Full Logistic Model","Reduced Logistic Model","10-NN Full Model","5-NN Reduced Model","Pruned Tree","Unpruned Tree","Bagging (n=300)","Bagging (n=25)","Random Forest I (n=300)","Random Forest II (n=300)","Random Forest III (n=40)")

TestError  <-  c(misclasserrorsfull,
             misclasserrorstepwise,
             KNNMisclass,KNNMisclass2,misclassificationprune,misclassificationunprune,misclassificationbagging,misclassificationbagging2,misclassRF,misclassRF2,misclassRF3)


TestError <- round(TestError,3)

data.frame(Method,TestError)


#error: Yes when No 
Er1 <- table1[2,1]/sum(table1[2,])
Er2 <- table2[2,1]/sum(table2[2,])
Er3 <- table3[2,1]/sum(table3[2,])
Er4 <- table4[2,1]/sum(table4[2,])
Er5 <- table5[2,1]/sum(table5[2,])
Er6  <-  table6[2,1]/sum(table6[2,])
Er7  <-  table7[2,1]/sum(table7[2,])
Er8  <-  table8[2,1]/sum(table8[2,])
Er9  <-  table9[2,1]/sum(table9[2,])
Er10  <-  table10[2,1]/sum(table10[2,])
Er11 <- table11[2,1]/sum(table11[2,])

#error: No when Yes
Er21 <- table1[1,2]/sum(table1[1,])
Er22 <- table2[1,2]/sum(table2[1,])
Er23 <- table3[1,2]/sum(table3[1,])
Er24 <- table4[1,2]/sum(table4[1,])
Er25 <- table5[1,2]/sum(table5[1,])
Er26 <- table6[1,2]/sum(table6[1,])
Er27 <- table7[1,2]/sum(table7[1,])
Er28 <- table8[1,2]/sum(table8[1,])
Er29 <- table9[1,2]/sum(table9[1,])
Er210 <- table10[1,2]/sum(table10[1,])
Er211 <- table11[1,2]/sum(table11[1,])

FalsePositive <- round(c(Er1,Er2,Er3,Er4,Er5,Er6,Er7,Er8,Er9,Er10,Er11),3)
FalseNegative <- round(c(Er21,Er22,Er23,Er24,Er25,Er26,Er27,Er28,Er29,Er210,Er211),3)

data.frame(Method,TestError,FalsePositive,FalseNegative)


