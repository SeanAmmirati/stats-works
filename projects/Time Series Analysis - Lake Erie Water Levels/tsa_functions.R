## Functions used in Time Series Project -- Lake Erie Water Levels

require(randomcoloR)

sse<-function(pred, data){
  true<-as.vector(data)
  sum((pred-true)^2)
}

colors2<-distinctColorPalette(10)
addplot<-function(pred,range=1:length(lkerie),color1){
  lines(x=c(time(lkerie))[range],y=c(lkerietrain,pred)[range],col=color1,lty="dashed")
}

get.best.arima <- function(x_ts, maxord = c(1,1,1,1,1,1))
{
  best.aic <- 1e8
  n <- length(x_ts)
  for (p in 0:maxord[1]) for(d in 0:maxord[2]) for(q in 0:maxord[3])
    for (P in 0:maxord[4]) for(D in 0:maxord[5]) for(Q in 0:maxord[6])
    {
      fit <- arima(x_ts, order = c(p,d,q),
                   seas = list(order = c(P,D,Q),
                               frequency(x_ts)), method = "CSS")
      fit.aic <- -2 * fit$loglik + (log(n) + 1) * length(fit$coef)
      if (fit.aic < best.aic)
      {
        best.aic <- fit.aic
        best.fit <- fit
        best.model <- c(p,d,q,P,D,Q)
      }
    }
  list(best.aic, best.fit, best.model)
}
