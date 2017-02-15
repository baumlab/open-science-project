rm(list=ls())

library(forecast)

setwd("c:/Users/shark_000/Documents/OpenScienceProject/open-science-project")
load("data/oil_west_clean.Rdata")
fish<-read.csv("data/oil-spill-data/noaa-incidents.csv", header=TRUE)

str(oil.west)

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
#Things to do:
#1. develop script for relating spatial scales between SoA data and oil data
#2. decide on how to incorporate environmental variables - detrending (splines), regression
#3. decide on how to incorporate spatial scale/correlation 
