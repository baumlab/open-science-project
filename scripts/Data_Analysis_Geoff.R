rm(list=ls())

library(forecast)
library(tidyr)

setwd("c:/Users/shark_000/Documents/OpenScienceProject/open-science-project")
load("data/oil_west_clean.Rdata")
oil<-read.csv("data/oil-spill-data/noaa-incidents.csv", header=TRUE)

#############################
###Trying out ARIMA first####
#############################
#Check out: https://people.duke.edu/~rnau/411arim.htm
#Let's use a subset for now

sum.tax.year<-aggregate(sum ~  taxa_broad + eez + year, fish, sum)
colnames(sum.tax.year)<-c("taxa_broad", "eez", "year", "landings")

bivalves<-subset(sum.tax.year, eez=="USA (West Coast)" & taxa_broad=="bivalve")
crustaceans<-subset(sum.tax.year, eez=="USA (West Coast)" & taxa_broad=="crustacean")

###find order of differencing, AR, and MA terms##
##Differencing is essentially detrending and removing seasonality###
##We want a low zero or negative autocorrelation, but not exceeding -0.5, that's too much
## differencing
#A model with no orders of differencing assumes that the original series is stationary 
#(mean-reverting). A model with one order of differencing assumes that the original series 
#has a constant average trend (e.g. a random walk or SES-type model, with or without growth). 
#A model with two orders of total differencing assumes that the original series has a 
#time-varying trend (e.g. a random trend or LES-type model)

#Check autocorrelation
#Sharp drop in ACF suggests MA of order of dropoff - in this case MA(0)
acf(bivalves$landings)

##Sharp drop in PACF suggests AR of order of dropoff - in this case AR(1)
pacf(bivalves$landings)
plot(landings~year, data=bivalves)
##Strong autocorrelation - evidence of trend

#Check sd on models with increasing differencing

###lowest for differencing of order 1
diff_0<-Arima(bivalves$landings, order=c(0,0,0), include.constant=TRUE)
sd(residuals(diff_0))

diff_1<-Arima(bivalves$landings, order=c(0,1,0), include.constant=TRUE)
sd(residuals(diff_1))

diff_2<-arima(bivalves$landings, order=c(0,2,0))
sd(residuals(diff_2))

###

##Automatic model selection (auto.arima) suggests random walk ARIMA (0,1,0) 
#model all that is necessary
auto.arima(bivalves$landings)

#But ARIMA(1,1,0) as suggested by the PACF has similar AIC
arima_1_1_0<-arima(bivalves$landings, order=c(1,1,0))
arima_1_1_0$aic

######################################
###Repeating the above for crustaceans
######################################

##mild evidence of cycling
acf(crustaceans$landings)

##Sharp drop in PACF suggests AR of order of dropoff - in this case AR(1)
pacf(crustaceans$landings)
plot(landings~year, data=crustaceans)

#Check sd on models with increasing differencing

###lowest for differencing of order 1
diff_0<-Arima(crustaceans$landings, order=c(0,0,0), include.constant=TRUE)
sd(residuals(diff_0))

diff_1<-Arima(crustaceans$landings, order=c(0,1,0), include.constant=TRUE)
sd(residuals(diff_1))

diff_2<-arima(crustaceans$landings, order=c(0,2,0))
sd(residuals(diff_2))

###

##Automatic model selection (auto.arima) suggests random walk ARIMA (0,1,0) 
#model all that is necessary
auto.arima(crustaceans$landings)

#But ARIMA(1,1,0) as suggested by the PACF has similar AIC
arima_1_1_0<-arima(crustaceans$landings, order=c(1,1,0))
arima_1_1_0$aic
################################
#Trying out GAMs################
################################

##From get_oil_and_fish.R - too lazy to make work with source()############
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
fish1<-subset(fish, year>1999) %>% subset(spill.size == 0 | spill.size>1000)

#Add lag of one and two years
#fish$spill.lag1<-as.numeric(c(NA, fish$spill.size[-length(fish$spill.size)]))
#fish$spill.lag2<-as.numeric(c(NA, fish$spill.lag1[-length(fish$spill.lag1)]))

#fish<-fish[with(fish, order(eez, common_name, year)), ]

snow.crab<-fish1%>%subset(common_name=="Tanner, snow crabs"& eez=="USA (West Coast)") %>%
	unite(coord, c(lat, lon), remove=FALSE)

oil_coords<-snow.crab$coord[which(snow.crab$spill==TRUE)]

snow.crab_oil<-snow.crab[which(snow.crab$coord %in% oil_coords),]

for (i in unique(snow.crab$coord)) {
	#for (k in unique(snow.crab$common_name)) {
snow.crab$s[which(snow.crab$spill==TRUE)]
		temp<-subset(snow.crab, snow.crab$coord==i)	
	if (sum(temp$spill==TRUE)>0) {
		temp2<-temp[order(temp$year),]
		temp2$relative<-rep(NA, nrow(temp2))
	   for (m in (-6:5)) {


	    } 

	    if (exists("snow.crab_use")) {
	    snow.crab_use<-rbind(snow.crab_use, subset(temp2, relative!="NA"))
	} else(snow.crab_use<-subset(temp2, relative!=NA))
}}


#}

}
rm(temp2)

by(fish, INDICES=list(fish$eez, fish$common_name), FUN=subset_rows)

subset_rows(fish, e=c(unique(fish$eez)), c=unique(fish$common_name), y3=unique(fish$year))

out<-fish %>% group_by(eez, common_name, year) %>% subset_rows(.)
subset_rows(fish)

clams<-subset(fish1, common_name=="Clams" & eez=="USA (West Coast)")
subset_rows(snow.crab)


geoduck<-subset(fish1, common_name==" Pacific geoduck"& eez=="USA (West Coast)")
#shrimp<-subset(fish, common_name=="Northern shrimp")

library(mgcv)

gam.out.clam<-gam(sum~pdo+year+spill, data=clams)
gam.out.snow<-gam(sum~pdo+year+spill, data=snow.crab)
gam.out.geoduck<-gam(sum~pdo+year+spill, data=geoduck) ##Too many NAs. 
#gam.out1<-gam(sum~pdo+year+taxa_broad*spill.size, data=OnlySpills, family=Gamma(link=log))
gam.out2<-gam(sum~pdo+year+taxa_broad*spill, data=fish1, family=Gamma(link=log))

plot(gam.out.clam$residuals~gam.out.clam$fitted)
boxplot(snow.crab$sum, ylim=c(0,50))

summary(gam.out.clam)
summary(gam.out.snow)
summary(gam.out1)
summary(gam.out2)


#######################################
#######Easton and stats################
#######################################

lognormal
lat and long as fixed effects
