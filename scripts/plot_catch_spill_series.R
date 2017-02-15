
setwd('open-science-project')
setwd('~/Documents/git-jpwrobinson/open-science-project')

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
theme_set(theme_bw())

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
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)')
	abline(v=temp.dat$year[temp.dat$spill==TRUE], col='red')

}
plot(1:10, 1:10, col='transparent', axes=FALSE, ylab='', xlab='')
mtext('Pacific geoduck catch in WA in spill grids\n (1970-2010)')

dev.off()




