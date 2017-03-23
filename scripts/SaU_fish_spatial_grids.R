


setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")

theme_set(theme_bw()) 
library(scales); library(sp); library(rgdal); library(raster); library(maps); library(mapdata); library(maptools)
library(maptools); library(prettymapr)
require(plotrix)

load('data/SaU_landings_clean.Rdata')

## Map figures for spatial landings data

tot.catch<-aggregate(sum ~ lat + lon + year + ID, fish, sum)
cols<-c('#d7191c','#fdae61','#abdda4','#2b83ba')
col_seq<-data.frame(seq(min((tot.catch[,'sum'])), max((tot.catch[,'sum'])),0.01))
col_seq$cols<-colorRampPalette(c(cols))(dim(col_seq)[1])
col_seq[,1]<-round(col_seq[,1], 2)
tot.catch$sum.col<-col_seq$cols[match(round(tot.catch[,'sum'],2), col_seq[,1])]


pts<-data.frame(lat=tot.catch$lat, lon=tot.catch$lon, ID=tot.catch$ID, catch=tot.catch$sum, col=tot.catch$sum.col)
pts$lon<-ifelse(pts$lon>0, pts$lon-360, pts$lon)

coordinates(pts) <- ~lon+lat
# plot(pts, lwd=0.5)
# axis(2); axis(1)


rast <- raster(ncol = 10, nrow = 10)
extent(rast) <- extent(pts)
rasterize(pts, rast, pts$catch, fun = mean)




rast <- raster(ncol = 10, nrow = 10)
extent(rast) <- extent(pts)
rasterize(pts, rast, pts$col, fun = mean)






tot.catch$lon<-ifelse(tot.catch$lon>0, tot.catch$lon-360, tot.catch$lon)
sites <- SpatialPointsDataFrame(data.frame('lon' = tot.catch[,"lon"], 'lat' = tot.catch[,'lat']), data.frame(catch=tot.catch$sum, col=tot.catch$sum.col))
proj <- CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
proj4string(sites) <- proj

## set resolution for grid size and extent 

rast <-raster(xmn=sites@bbox[1,1], xmx=sites@bbox[1,2], ymn=sites@bbox[2,1], ymx=sites@bbox[2,2], 
              crs = proj, res=0.5)
tt<-rasterize(sites, rast, sites$catch, fun = mean)


world360<-readShapePoly("data/Shapes_Merge/Shapes_Merge.shp")
mat<-matrix(c(1,1,1,1,2,2,3,3), byrow=TRUE, nrow=2)
layout(mat)

par(mfrow=c(2,2), mar=c(2,2,2,2))
plot(world360, xlim=c(-150,-110 ),ylim=c(29,50))
plot(tt,  lwd=0.5, add=TRUE)
plot(world360, xlim=c(-150,-110),ylim=c(29,50), add=TRUE)

plot(world360, xlim=c(-150,-110),ylim=c(45,60))
plot(tt,  lwd=0.5, add=TRUE)
plot(world360, xlim=c(-150,-110),ylim=c(45,60), add=TRUE)

plot(world360, xlim=c(-200,-130),ylim=c(50, 60))
plot(tt,  lwd=0.5, add=TRUE)
plot(world360, xlim=c(-200,-130),ylim=c(50, 60), add=TRUE)


