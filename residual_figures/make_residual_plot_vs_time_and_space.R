# Created by Easton White
# Created on 3-Mar-2017


# This code runs GAM models following data cleaning from Geoff's script. The script also plots residuals vs time and space to identify spatial or temporal autocorrelation

# Subset models for more recent years and run GAMs for each species
clams=subset(clams,clams$year>1999)
snow.crab=subset(snow.crab,snow.crab$year>1999)
geoduck= subset(geoduck,geoduck$year>1999)
gam.out.clam<-gam(sum~pdo+year+spill +lat+lon, data=clams, family=Gamma(link=log))
gam.out.snow<-gam(sum~pdo+year+spill +lat +lon , data=snow.crab, family=Gamma(link=log))
gam.out.geoduck<-gam(sum~pdo+year+spill+lat+lon, data=geoduck, family=Gamma(link=log)) #

summary(gam.out.clam)


clams$residuals = gam.out.clam$residuals
snow.crab$residuals = gam.out.snow $residuals
geoduck$residuals = as.numeric(model$residuals)


require(ggplot2)
ggplot() + geom_point(data=geoduck,aes(x=lon,y=lat,col=log(abs(residuals))),size=4) + facet_wrap(~year)

ggplot(data=geoduck,aes(x=year,y=residuals,col=as.factor(abs(lat*lon)))) + geom_point(size=2) + geom_smooth(method = 'loess',se = F) 


#require(geosphere)
#clams2005
#pw=dist(as.data.frame(cbind(clams2005$lon, clams2005$lat)))

#dist(as.matrix(cbind(clams2005$lon, clams2005$lat)),as.matrix(cbind(clams2005$lon, clams2005$lat)), a=6378137, f=1/298.257223563)

#dist(clams$lat,clams$lon)



