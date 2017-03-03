
# Created by Easton White
# Created on 3-Mar-2017


# This code runs glm models following data cleaning from Geoff's script. The script makes various residual plots to identify model assumption violations

m1 <- glm(sum~pdo+year+spill, data=snow.crab,family=Gamma(link=log))
summary(m1)
plot(m1$fitted,m1$residuals)


m2 <- glm(sum~pdo+year+spill+lat+lon, data=snow.crab,family=Gamma(link=log))
summary(m2)
plot(m2)

plot(snow.crab$year,m2$residuals)


residual_plots <- function(model,data){
  par(mfrow=c(2,2),oma=c(2,2,1,1),mar=c(5,5,0,0))
  plot(data$lat,model$residuals)
  plot(data$lon,model$residuals)
  plot(data$year,model$residuals)
  plot(data$pdo,model$residuals)
  
}

#resid.model = residuals(m2)
#moran.mc(x = resid.model, listw = W.list, nsim = 10000)
