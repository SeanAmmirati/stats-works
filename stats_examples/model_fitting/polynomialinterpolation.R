## Doing a test of polynomial interpolation vs linear regression to show the Bias/Variance tradeoff using ggplot. 

salaries <- seq(10000,250000,by=1000)
age<-rnorm(length(salaries),40,10)
age
salaries
require(ggplot2)
require(scales)
require(gridExtra)

savings <- .40*salaries + rnorm(length(salaries),mean=10000,sd=10000)+.20*age
savings <- sapply(savings, function(x){ifelse(x<0,0,x)})
df <- as.data.frame(cbind(salaries,savings,age))
exampledf <- df[sample(1:length(salaries),size=20,replace=FALSE),]
unique(exampledf$salaries)
head(df)
grid.table(df)


plt <- ggplot(data=exampledf)
plt <- plt + geom_point(aes(x=salaries,y=savings))
plt <- plt+ggtitle(label = "Savings by Salary")+xlab("Salary")+ylab("Savings")
plt <- plt + scale_y_continuous(labels = comma)+scale_x_continuous(labels=comma)

plt1 <- plt + stat_smooth(aes(x = salaries, y = savings), method = "lm",
               formula = y ~ poly(x, 15), se = FALSE) + coord_cartesian(ylim = c(min(savings)-100, max(savings)+100))
plt2 <- plt + stat_smooth(aes(x = salaries, y = savings),col='red', method = "lm",
                         formula = y ~ poly(x, 18), se = FALSE) + coord_cartesian(ylim = c(min(savings)-100, max(savings)+100))
plt3<-plt + stat_smooth(aes(x=salaries,y=savings),method = "lm", col = "purple")

plt1 <- plt1 +ggtitle('Using polynomial interpolation with 15 degrees')
plt2 <- plt2 +ggtitle('Using polynomial interpolation with 18 degrees')
plt3 <- plt3 +ggtitle('Using linear regression')

plt1
plt2
plt3

newsamp <- df[sample(1:length(salaries),size=20,replace=FALSE),]

plt1 + geom_point(col='green',data=newsamp, aes(x=salaries,y=savings)) + stat_smooth(aes(x = salaries, y = savings), data=newsamp, method = "lm",
                   formula = y ~ poly(x, 15), se = FALSE) + coord_cartesian(ylim = c(min(savings)-100, max(savings)+100))

plt2+ geom_point(col='green',data=newsamp, aes(x=salaries,y=savings)) + stat_smooth(aes(x = salaries, y = savings), data=newsamp, method = "lm",
                                                                        formula = y ~ poly(x, 18), se = FALSE) + coord_cartesian(ylim = c(min(savings)-100, max(savings)+100))

plt3 + geom_point(col='green',data=newsamp, aes(x=salaries,y=savings)) + stat_smooth(aes(x = salaries, y = savings), data=newsamp, method = "lm") + coord_cartesian(ylim = c(min(savings)-100, max(savings)+100))


  
  
