
# Created by Easton White
# Created on 3-Mar-2017


# Data comes from data cleaning from Geoff's script
# The code looks at how the difference between residuals of different location changes with distance between those locations for a particular year

#geoduck 
geoduck2010=subset(geoduck,geoduck$year==2010)

require(flexclust)
# calculate pairwise distances between points
pairwise_distance=dist2(cbind(geoduck2010$lon,geoduck2010$lat),cbind(geoduck2010$lon,geoduck2010$lat))
hist(pairwise_distance)

# calculate pairwise differences between residuals
resid_diff=dist2(geoduck2010$residuals,geoduck2010$residuals)

resid_and_dist = as.data.frame(cbind(c(pairwise_distance),c(resid_diff)))
colnames(zed)=c('pairwise_distance','resid_diff')

ggplot(data=resid_and_dist,aes(x=c(pairwise_distance),y=c(resid_diff))) + geom_point(alpha=0.2) + geom_smooth(method='loess')


#test= aggregate(zed$r,by=list(zed$y),FUN=mean)
#plot(test)