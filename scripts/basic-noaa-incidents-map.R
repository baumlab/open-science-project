
# Created by Easton White
# Created on 9-Jan-2017
# Last edited 26-Jan-2017

# Purpose: this code pulls in some simple noaa incident data and makes pretty maps of the data for oil spills

# load neccessary mapping packages
library(maps)
library(ggplot2)

# pull in noaa incidents data
setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")


oil <- read.table('data/oil-spill-data/noaa-incidents.csv',sep=',',header=T)
oil=subset(oil,is.na(oil$lat)==F) # only look at incidents with Lat and Long
oil = subset(oil, oil$threat=='Oil') #only choose oil spill incidents
oil= subset(oil,is.na(oil$max_ptl_release_gallons)==F) #only look at incidents with information on total number of gallons

# call map data files for usa and the world
usa <- map_data("usa")
world <- map_data("world")
w2hr <- map_data("world2Hires")

# create plot with ggplot
ggplot() + geom_polygon(data = w2hr, aes(x=long, y = lat, group = group)) + coord_fixed(1.3) + geom_point(data=oil,aes(x=lon,y=lat,size=0.1*log(max_ptl_release_gallons)),color='red')

# Extract only spills that occured in the ocean
source('scripts/functions/calculate_is_point_in_ocean.R')
ocean_oil = oil[calculate_is_point_in_ocean(oil_lat = oil$lat,oil_long = oil$lon),]

#subset data to only include west coast spills (n=181)
xrange = c(-190,-110); yrange=c(29,80)
usa_and_canada_spills = subset(ocean_oil,ocean_oil$lon > xrange[1] & ocean_oil$lon < xrange[2] & ocean_oil$lat > yrange[1] & ocean_oil$lat< yrange[2])

require(mapdata)
require(maptools)

# create simple map of west coast with usa and canada spills
map("worldHires", xlim=c(-190,-110),ylim=c(29,80), col="gray95", fill=TRUE)
points(usa_and_canada_spills$lon, usa_and_canada_spills$lat, pch=19, col="red", cex=0.5)

# create simple map of west coast with usa and canada spills - sized by gallons
pdf(file='figures/oil_map_spillsize.pdf', height=7, width=11)
map("worldHires", xlim=c(-190,-110),ylim=c(29,80), col="gray95", fill=TRUE)
points(usa_and_canada_spills$lon, usa_and_canada_spills$lat, pch=19, col="red", cex=pi*0.015*log10(usa_and_canada_spills$max_ptl_release_gallons)^2)
legend('topleft', legend=c('1000 gallons', '10,000 gallons', '100,000 gallons', '1,000,000 gallons'), pt.cex=c(pi*0.015*3^2, pi*0.015*4^2, pi*0.015*5^2, pi*0.015*6^2), col='red' , pch=19)
dev.off()





