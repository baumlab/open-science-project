
setwd('open-science-project')
setwd('~/Documents/git-jpwrobinson/open-science-project')

rm(list=ls())

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
theme_set(theme_bw())
library(scales); library(sp); library(rgdal); library(raster); library(maps); library(mapdata); library(maptools)
library(maptools); library(prettymapr)
require(plotrix)
uniques<-function(x){length(unique(x))}

load('data/SaU_landings_clean.Rdata')


### Examining changing spatial size on trends in catch
grid.shifter<-function(dataset, resolution){
### Assign each catch value a grid cell, of varying resolutions. 

## Get smallest grids (0.5 resolution) with total catch over time
tot.catch<-aggregate(sum ~ lat + lon + ID, dataset, sum)
tot.catch$lon<-ifelse(tot.catch$lon<0, tot.catch$lon+360, tot.catch$lon)
pts<-data.frame(lat=tot.catch$lat, lon=tot.catch$lon, ID=tot.catch$ID)

coordinates(pts) <- ~lon+lat
rast <- raster(ncol = 10, nrow = 10)
extent(rast) <- extent(pts)
# rasterize(pts, rast, pts$catch, fun = sum)

## create spatial object from lat lon info
sites <- SpatialPointsDataFrame(data.frame('lon' = tot.catch[,"lon"], 'lat' = tot.catch[,'lat']), data.frame(ID=tot.catch$ID))
proj <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
proj4string(sites) <- proj

## set resolution for grid size and extent, create raster files with grid IDs for each cell
rast <-raster(xmn=sites@bbox[1,1], xmx=sites@bbox[1,2], ymn=sites@bbox[2,1], ymx=sites@bbox[2,2], 
              crs = proj, res=resolution)
# tt<-rasterize(sites, rast, sites$catch, fun = sum)

xy <- matrix( 1:length(rast) ,dim(rast)[1],dim(rast)[2])

# Turn the matrix into a raster
rast <- raster(xy)
# Give it lat/lon coords
ext.rast <- extent(sites)
extent.rast <-c(sites@bbox[1,1], sites@bbox[1,2],sites@bbox[2,1],sites@bbox[2,2])
extent(rast) <- extent.rast
# ... and assign a projection
projection(rast) <-proj

test<-extract(rast,sites)
sites <- cbind(as.data.frame(sites), test)
sites$grid.ID<-paste(sites$test, resolution,sep='.')

return(sites)}

## now get IDs to assign each catch datum a grid cell, for different resolutions
grids05<-grid.shifter(fish, resolution=0.5)
grids1<-grid.shifter(fish, resolution=1)
grids2<-grid.shifter(fish, resolution=2)
grids3<-grid.shifter(fish, resolution=3)
grids4<-grid.shifter(fish, resolution=4)
grids5<-grid.shifter(fish, resolution=5)

## now add grid IDs to master fish dataset
fish$grid05<-grids05$grid.ID[match(fish$ID, grids05$ID)]
fish$grid1<-grids1$grid.ID[match(fish$ID, grids1$ID)]
fish$grid2<-grids2$grid.ID[match(fish$ID, grids2$ID)]
fish$grid3<-grids3$grid.ID[match(fish$ID, grids3$ID)]
fish$grid4<-grids4$grid.ID[match(fish$ID, grids4$ID)]
fish$grid5<-grids5$grid.ID[match(fish$ID, grids5$ID)]

## now examine temporal trends across different spatial aggregations, for top 5 species OR widespread species 
tot.sp<-aggregate(sum ~  common_name, fish, sum)
arrange(tot.sp, -sum)
top5<- c('Pacific cupped oyster', 'Tanner, snow crabs', 'Red king crab', 'Marine crabs', 'Pacific geoduck')

top<-fish[fish$common_name%in%top5,]
top$lon<-ifelse(top$lon<0, top$lon+360, top$lon)

## examine just ALASKA 
# WA<-top[top$lon< 240 & top$lon> 230 & top$lat<49 & top$lat>45.5,]
AL<-top[top$lon> 186 & top$lon< 219 & top$lat<64.5 & top$lat>60,]

## aggregate at each spatial resolution. mean catch per species each year
time05<-aggregate(sum ~ common_name + year + grid05, AL, mean)
time1<-aggregate(sum ~ common_name + year + grid1, AL, mean)
time2<-aggregate(sum ~ common_name + year + grid2, AL, mean)
time3<-aggregate(sum ~ common_name + year + grid3, AL, mean)
time4<-aggregate(sum ~ common_name + year + grid4, AL, mean)
time5<-aggregate(sum ~ common_name + year + grid5, AL, mean)
## get grid IDs for plotting
id05<-unique(time05$grid05)
id1<-unique(time1$grid1)
id2<-unique(time2$grid2)
id3<-unique(time3$grid3)
id4<-unique(time4$grid4)
id5<-unique(time5$grid5)

### now plot trends 

## Tanner snow crabs - ALASKA

## 1 degree resolution
row<-round(sqrt(length(id1)), digits=0) + 1
par(mfrow=c(row, row), mar=c(1,1,1,1), xpd=TRUE)
# full time series
for(i in 1:length(id1)) {

	temp.dat<-time1[time1$grid1==id1[i] & time1$common_name=='Tanner, snow crabs',]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id1[i], cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}
mtext(1, text='Tanner, snow crabs 1 km resolution',  cex=1.2, outer=F, line=3)

## 2 degree resolution
row<-round(sqrt(length(id2)), digits=0) + 1
par(mfrow=c(row, row), mar=c(1,1,1,1))
# full time series
for(i in 1:length(id2)) {

	temp.dat<-time2[time2$grid2==id2[i] & time2$common_name=='Tanner, snow crabs',]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id2[i], cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}
mtext(1, text='Tanner, snow crabs 2 km resolution',  cex=1.2, outer=F, line=3)

## 3 degree resolution
row<-round(sqrt(length(id3)), digits=0) + 1
par(mfrow=c(row, row), mar=c(1,1,1,1))
# full time series
for(i in 1:length(id3)) {

	temp.dat<-time3[time3$grid3==id3[i] & time3$common_name=='Tanner, snow crabs',]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id3[i], cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}
mtext(1, text='Tanner, snow crabs 3 km resolution',  cex=1.2, outer=F, line=3)



## 4 degree resolution
row<-round(sqrt(length(id4)), digits=0) + 1
par(mfrow=c(row, row), mar=c(1,1,1,1))
# full time series
for(i in 1:length(id4)) {

	temp.dat<-time4[time4$grid4==id4[i] & time4$common_name=='Tanner, snow crabs',]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id4[i], cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}
mtext(1, text='Tanner, snow crabs 4 km resolution',  cex=1.2, outer=F, line=3)


## 5 degree resolution
row<-round(sqrt(length(id5)), digits=0) + 1
par(mfrow=c(row, row), mar=c(1,1,1,1))
# full time series
for(i in 1:length(id5)) {

	temp.dat<-time5[time5$grid5==id5[i] & time5$common_name=='Tanner, snow crabs',]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id5[i], cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}
mtext(1, text='Tanner, snow crabs 5 km resolution',  cex=1.2, outer=F, line=3)



### appears no change in catch data at 5 degree resolution!

## examine 5 degrees across dataset

time5<-aggregate(sum ~ common_name + year + grid5, top, mean)
id5<-unique(time5$grid5[time5$common_name=='Tanner, snow crabs'])

## 5 degree resolution
row<-round(sqrt(length(id5)), digits=0) + 1
par(mfrow=c(row, row), mar=c(1,1,1,1))
# full time series
for(i in 1:length(id5)) {

	temp.dat<-time5[which(time5$grid5==id5[i] & time5$common_name=='Tanner, snow crabs'),]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=id5[i], cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}
mtext(1, text='Tanner, snow crabs 5 km resolution',  cex=1.2, outer=F, line=3)



### examine EEZ vs. sample of 0.5 grid cells
eez<-aggregate(sum ~ common_name + year + eez, top, mean)
# id.eez<-unique(eez$grid05[eez$common_name=='Tanner, snow crabs'])

pdf(file='figures/EEZ_vs_05degree_catch_trends.pdf', height=7, width=11)
### FOR CANADA PACIFIC
layout(matrix(c(1,2,3,4), byrow=FALSE, ncol=1))

par(mar=c(2,3,1,3))
	with(eez[which(eez$eez=='Canada (Pacific)' & eez$common_name=='Pacific geoduck'),], 
		plot(year, sum, type='l', xlab='Year', ylab='Catch (tonnes)', main='Canada (Pacific)', cex.axis=1, axes=FALSE))
	axis(2, cex=0.8); axis(1, labels=NA)

	eez.id<-unique(top$grid05[top$eez=='Canada (Pacific)' & top$common_name=='Pacific geoduck'])
# full time series
for(i in 1:3) {
	ran.id<-sample(eez.id, 1)
	temp.dat<-top[which(top$grid05==ran.id & top$common_name=='Pacific geoduck'),]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=unique(top$ID[top$grid05==ran.id]), cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8)
	if(i ==3) {axis(1)} else {axis(1, labels=NA)}
}

### FOR USA ALASKA
layout(matrix(c(1,2,3,4), byrow=FALSE, ncol=1))

par(mar=c(2,2,2,2))
	with(eez[which(eez$eez=='USA (Alaska, Subarctic)' & eez$common_name=='Pacific geoduck'),], 
		plot(year, sum, type='l', xlab='Year', ylab='Catch (tonnes)', main='USA (Alaska, Subarctic)', cex.axis=1, axes=FALSE))
	axis(2, cex=0.8); axis(1, labels=NA)

	eez.id<-unique(top$grid05[top$eez=='USA (Alaska, Subarctic)' & top$common_name=='Pacific geoduck'])
# full time series
for(i in 1:3) {
	ran.id<-sample(eez.id, 1)
	temp.dat<-top[which(top$grid05==ran.id & top$common_name=='Pacific geoduck'),]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=unique(top$ID[top$grid05==ran.id]), cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}


### FOR USA PACIFIC
layout(matrix(c(1,2,3,4), byrow=FALSE, ncol=1))

par(mar=c(2,2,2,2))
	with(eez[which(eez$eez=='USA (West Coast)' & eez$common_name=='Pacific geoduck'),], 
		plot(year, sum, type='l', xlab='Year', ylab='Catch (tonnes)', main='USA (West Coast)', cex.axis=1, axes=FALSE))
	axis(2, cex=0.8); axis(1, labels=NA)

	eez.id<-unique(top$grid05[top$eez=='USA (West Coast)' & top$common_name=='Pacific geoduck'])
# full time series
for(i in 1:3) {
	ran.id<-sample(eez.id, 1)
	temp.dat<-top[which(top$grid05==ran.id & top$common_name=='Pacific geoduck'),]
	temp.dat<-aggregate(sum ~  year, temp.dat, sum)
	plot(temp.dat$year, temp.dat$sum, type='l', xlab='Year', ylab='Catch (tonnes)', main=unique(top$ID[top$grid05==ran.id]), cex.axis=0.5, axes=FALSE)
	axis(2, cex=0.8); axis(1, labels=NA)
}

dev.off()



















