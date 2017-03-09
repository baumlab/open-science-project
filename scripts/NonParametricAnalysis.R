######Created by Geoffrey Osgood
######Created on March 09, 2017


library(tidyr)
library(forecast); library(visreg); library(mgcv)


setwd("c:/Users/shark_000/Documents/OpenScienceProject/open-science-project")
setwd("/Users/IMAC3/Documents/git-jpwrobinson/open-science-project")
load("data/oil_west_clean.Rdata")
oil<-read.csv("data/oil-spill-data/noaa-incidents.csv", header=TRUE)


source('scripts/functions/ConvertOccurToCellGrid_TTAI.R')  # function from Travis Tai (UBC)
load('data/SaU_landings_clean.Rdata') ## cleaned landings
load('data/oil_west_clean.Rdata') # cleaned oil

## change oil lon to negative format
oil.west$row<-1:nrow(oil.west)  
## append cell IDs for lat-lon that match to fish data
oil.west<-CELLMATCH(oil.west)


## now need to aggregate oil spills within cells in the same year. 
oil<-aggregate(max_ptl_release_gallons ~ lat + lon + year + lonCell + latCell, oil.west, sum)
oil$ID<-with(oil, paste(latCell, lonCell, year, sep='.'))

fish$ID<-with(fish, paste(lat, lon, year, sep='.')) #ring 1 cell per spill per year.

## add oil spill to fish cell based on year. Only conside
## numeric: spill size
fish$spill.size<-oil$max_ptl_release_gallons[match(fish$ID, oil$ID)]
## logical: did spill occur in same year?
fish$spill<-ifelse(is.na(fish$spill.size), FALSE, TRUE)
pdo_year <- read.csv('data/pdo_mean_by_year.csv', header=T)
fish$pdo<-pdo_year$pdo[match(fish$year, pdo_year$year)]
###########################################
OnlySpills<-subset(fish, spill==TRUE)
fish$spill.size[is.na(fish$spill.size)]<-0
fish1<-subset(fish, year>1999) #%>% subset(spill.size == 0 | spill.size>1000)

#species<-fish1%>%subset(common_name=="Tanner, snow crabs" & eez== "USA (West Coast)") 

species<-fish1%>%subset(common_name=="Pacific geoduck" & eez== "USA (West Coast)")

table(fish1$common_name)
source('scripts/functions/create_site_code.R')
species = create_site_code(species)
head(species)
require(MASS)
require(glmmADMB)

#species$site_code=as.factor(species$site_code)

#########Exaimine oil spill frequency since 2000#####################

table(species$spill, species$site_code) #One site (145 had 2) for snow crab
table(species$year, species$site_code) #Seems to be closure in 2011/2012 for snow crab
table(species$year, species$spill)


#####Take slope of four years before oil spill, 
#####compare to slope using year -1, 0, 1, 2, after oil spill

oil<-species[species$spill==TRUE & species$spill.size>1000,]

spill_slope<-vector(length=nrow(oil[oil$spill==TRUE,]))

for (i in 1:length(spill_slope)) {

temp0<-subset(species, site_code==oil$site_code[i])
temp1<-temp0[order(temp0$year), ]
oil.spill.years<-subset(temp1, spill==TRUE)$year

	if (length(oil.spill.years)==1) {
non.spill.rows<-c(sapply((-3):(-1), function(z) {which(temp1$year==oil.spill.years)+z}))
spill.rows<-c(sapply((-1):1, function(z) {which(temp1$year==oil.spill.years)+z}))

spill.rows<-spill.rows[which(spill.rows<=nrow(temp1))]

spills<-temp1[spill.rows,]
non.spills<-temp1[non.spill.rows,]

spill_slope[i]<-(lm(non.spills$sum~non.spills$year)$coef[2]-lm(spills$sum~spills$year)$coef[2])/lm(non.spills$sum~non.spills$year)$coef[2]
} else {

non.spill.rows<-c(sapply((-3):(-1), function(z) {which(temp1$year==oil.spill.years[1])+z}))
spill.rows<-c(sapply((-1):2, function(z) {which(temp1$year==oil.spill.years[1])+z}))

spill.rows<-spill.rows[which(spill.rows<=nrow(temp1))]

spills<-temp1[spill.rows,]
non.spills<-temp1[non.spill.rows,]

spill_slope[i]<-(lm(non.spills$sum~non.spills$year)$coef[2]-lm(spills$sum~spills$year)$coef[2])/lm(non.spills$sum~non.spills$year)$coef[2]


}

}

spill_slope

non_spill_slope<-vector(length=length(sites)*100)

sites<-unique(species$site_code)

for (j in 1:100) {

for (i in 1:length(sites)) {

temp0<-subset(species, site_code==sites[i])
	if(sum(temp0$spill==TRUE)==0) {
temp1<-temp0[order(temp0$year), ]
non.oil.years<-sample(2003:2011, 1)

non.spill.rows<-c(sapply((-3):(-1), function(z) {which(temp1$year==non.oil.years[1])+z}))
spill.rows<-c(sapply((-1):2, function(z) {which(temp1$year==non.oil.years[1])+z}))

spills<-temp1[spill.rows,]
non.spills<-temp1[non.spill.rows,]

non_spill_slope[i+length(sites)*(j-1)]<-(lm(non.spills$sum~non.spills$year)$coef[2]-lm(spills$sum~spills$year)$coef[2])/lm(non.spills$sum~non.spills$year)$coef[2]

}}
}

hist(non_spill_slope, xlim=c(-10,10), freq=FALSE, ylim=c(0,0.6), col="blue")
par(new=TRUE)
hist(spill_slope, xlim=c(-10,10), freq=FALSE, ylim=c(0,0.6), col="green")

mean(non_spill_slope)
sum(non_spill_slope>mean(spill_slope))/length(non_spill_slope)