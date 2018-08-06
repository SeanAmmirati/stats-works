library(lme4)

EDEGlobal.Base<-rnorm(17,2.67,0.81)
BingeFreq.Base.reg<-rlnorm(17, meanlog = log(16.82^2/((8.62^2)+(16.82)^2)^.5), sdlog = (2*log(16.82)-2*log(16.82^2/((8.62^2)+(16.82)^2)^.5))^.5)
BingeFreq.Base.tran<-log(BingeFreq.Base.reg)

EDEGlobal.Mid<-rnorm(17,1.74,0.53)
BingeFreq.Mid.reg<-rlnorm(17, meanlog = log(1.35^2/((2^2)+(1.35)^2)^.5), sdlog = (2*log(1.35)-2*log(1.35^2/((2^2)+(1.35)^2)^.5))^.5)
BingeFreq.Mid.tran<-log(BingeFreq.Mid.reg)

EDEGlobal.End<-rnorm(17,1.60,0.63)
BingeFreq.End.reg<-rlnorm(17, meanlog = log(3.29^2/((7.9^2)+(3.29)^2)^.5), sdlog = (2*log(3.29)-2*log(3.29^2/((7.9^2)+(3.29)^2)^.5))^.5)
BingeFreq.End.tran<-log(BingeFreq.End.reg)

EDEGlobal.Follow<-rnorm(17,1.58,0.98)
BingeFreq.Follow.reg<-rlnorm(17, meanlog = log(1.33^2/((2.47^2)+(1.33)^2)^.5), sdlog = (2*log(1.33)-2*log(1.33^2/((2.47^2)+(1.33)^2)^.5))^.5)
BingeFreq.Follow.tran<-log(BingeFreq.Follow.reg)

BingeFreq.reg<-cbind(BingeFreq.Base.reg,BingeFreq.Mid.reg,BingeFreq.End.reg,BingeFreq.Follow.reg)

barplot(c(mean(BingeFreq.Base.reg),mean(BingeFreq.Mid.reg),mean(BingeFreq.End.reg),mean(BingeFreq.Follow.reg)),names.arg=c("Base","Mid","End","Follow-Up"),col=c("blue","red","green","yellow"))

time<-c(rep(0,17),rep(5,17),rep(10,17),rep(22,17))
timesq<-time^2
timec<-time^3

data<-data.frame(cbind(EDEGlobal<-c(EDEGlobal.Base,EDEGlobal.Mid,EDEGlobal.End,EDEGlobal.Follow),BingeFrequency<-c(BingeFreq.Base.tran,BingeFreq.Mid.tran,BingeFreq.End.tran,BingeFreq.Follow.tran),time))

summary(lm(data[,1]~timesq+data[,3]))
summary(lm(data[,2]~time+timesq+timec))

negativeurgancy2<-ifelse(time!=0,(data[,2]+.8*time-0.08*timesq-0.002*timec)/(0.05*time-0.04),data[,2]/-.04)
negativeurgancy3<-negativeurgancy2+rnorm(68,0,.9)

summary(lm(data[,2]~time+timesq+timec+negativeurgancy3*time))
data<-data.frame(data,negativeurgancy3)


ll1<-lmer(BingeFrequency~timec+timesq+time+(1|time))
ll2<-lmer(BingeFrequency~timec+timesq+time+negativeurgancy3+(1|time))
ll3<-lmer(EDEGlobal~timesq+time+negativeurgancy3+(1|time))
ll4<-lmer(EDEGlobal~timesq+time+(1|time))
ll5<-lmer(EDEGlobal~timec+timesq+time+(1|time))

anova(ll1,ll2)
anova(ll3, ll4)
anova(ll4,ll5)

summary(ll2)
summary(ll4)
