
setwd('open-science-project')
setwd('~/Documents/git-jpwrobinson/open-science-project')

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
theme_set(theme_bw())
uniques<-function(x){length(unique(x))}

load('data/fish_with_spill_grids_only.Rdata')


## consider WA geoducks only
geo<-spills[spills$common_name=='Pacific geoduck',]
geo<-geo[geo$lat > 46.01 & geo$lat < 48.89 & geo$fishing_entity=='USA',]

spill.dates<-geo[geo$spill=="TRUE",]



## appears that the patterns are exactly the same - just on different scales. likely due to SaU method and limitation at fine-scales
ggplot(geo, aes(year, sum)) + geom_line() + facet_wrap(~grid.ID, scales='free')

id.vec<-unique(geo$grid.ID)

pdf(file='figures/geoduck_WA_spill_timeseries.pdf', height=7, width=11)
par(mfrow=c(4,4), mar=c(3,4,3,3))

for(i in 1:length(id.vec)) {

	temp.dat<-geo[geo$grid.ID==id.vec[i],]
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id.vec[i])
	abline(v=temp.dat$year[temp.dat$spill==TRUE], col='red')

}
plot(1:10, 1:10, col='transparent', axes=FALSE, ylab='', xlab='')
mtext('Pacific geoduck catch in WA in spill grids\n (1970-2010)')

dev.off()




### What is a reasonable scale of analysis? SaU is at 0.5 degree, but may be disaggregated according to state-level data.
## Similarly, what is a reasonable size of spill to examine? Starting with 10,000 gallons.

bigsp.grids<-spills[which(spills$spill.size>10000),]
bigsp<-spills[spills$grid.ID %in% bigsp.grids$grid.ID,]

id.vec<-unique(bigsp$grid.ID)

pdf(file='figures/spills_over10000_timeseries_allgrids.pdf', height=7, width=11)



par(mfrow=c(6,6), mar=c(3,4,3,3))


## full time series
for(i in 1:length(id.vec)) {

	temp.dat<-bigsp[bigsp$grid.ID==id.vec[i],]
	temp.dat<-aggregate(sum ~  spill + year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id.vec[i])
	abline(v=temp.dat$year[temp.dat$spill==TRUE], col='red')

}

## zoomed into spills
for(i in 1:length(id.vec)) {

	temp.dat<-bigsp[bigsp$grid.ID==id.vec[i],]
	temp.dat<-aggregate(sum ~  spill + year, temp.dat, sum)
	yy<-temp.dat$year[temp.dat$spill==TRUE]
	temp.dat<-temp.dat[temp.dat$year>yy[1]-6,]
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id.vec[i])
	abline(v=temp.dat$year[temp.dat$spill==TRUE], col='red')

}

dev.off()


##### repeat for commonly caught species
main.species<-aggregate(grid.ID ~ common_name, bigsp, uniques)
species<-main.species$common_name[main.species$grid.ID>20]



pdf(file='figures/spills_over10000_timeseries_allgrids_majorspecies.pdf', height=7, width=11)





# by species that are caught > 20 grids
for(a in 1:length(species)){
	par(mfrow=c(6,6), mar=c(3,4,3,3))
	# temp id vector for grids with species 
	temp.species<-bigsp[bigsp$common_name==species[a],]
	id.temp<-unique(temp.species$grid.ID)

## full time series
for(i in 1:length(id.temp)) {

	temp.dat<-temp.species[temp.species$grid.ID==id.temp[i],]
	# temp.dat<-aggregate(sum ~  spill + year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', sub=id.temp[i], main=species[a])
	abline(v=temp.dat$year[temp.dat$spill==TRUE], col='red')

}

## zoomed into spills
# par(mfrow=c(6,6), mar=c(3,4,3,3))

# for(i in 1:length(id.temp)) {

# 	temp.dat<-temp.species[temp.species$grid.ID==id.temp[i],]
# 	# temp.dat<-aggregate(sum ~  spill + year, temp.dat, sum)
# 	yy<-temp.dat$year[temp.dat$spill==TRUE]
# 	temp.dat<-temp.dat[temp.dat$year>yy[1]-6,]
# 	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', sub=id.temp[i], main=species[a])
# 	abline(v=temp.dat$year[temp.dat$spill==TRUE], col='red')

# }

}

dev.off()

