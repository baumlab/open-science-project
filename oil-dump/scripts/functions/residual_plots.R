
# Created by Easton White
# Created on 3-Mar-2017


# This code runs glm models following data cleaning from Geoff's script. The script makes various residual plots to identify model assumption violations


residual_plots <- function(model,data){
  par(mfrow=c(3,2),oma=c(2,2,1,1),mar=c(5,5,0,0))
  plot(data$lat,model$residuals,col=rgb(0.5,0.5,0.5,0.5),pch=16)
  plot(data$lon,model$residuals,col=rgb(0.5,0.5,0.5,0.5),pch=16)
  plot(data$year,model$residuals,col=rgb(0.5,0.5,0.5,0.5),pch=16)
  plot(data$pdo,model$residuals,col=rgb(0.5,0.5,0.5,0.5),pch=16)
  plot(density(model$residuals))
  
}

#resid.model = residuals(m2)
#moran.mc(x = resid.model, listw = W.list, nsim = 10000)
