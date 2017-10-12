

# Created by Jamie McDevitt-Irwin
# Created on 11-Oct-2017

theme_set(theme_bw())
# Purpose: this code reads in OBIS data from Andrew Rhyne, adds to trade.trophic dataset

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
# read full distribution data
obis<-read.csv(file='data/OBIS_dist_species.csv')
head(obis)
tail(obis)
dim(obis)
# decimal lat and long are both + and - values


# Before you can match in the trade data, you need one value for each species from the OBIS data
# Idea from Jimmy: Find max and min for each sp. Scale lat and lon to mean 0 and sd of 1 across all species. Sum together for each species. Proxy for range size.

# Match OBIS data with trade data
trade.trophic <- read.csv(file='data/trade_with_trophic_group.csv')
dim(trade.trophic) #393 8











# # match in obis
# trade.trophic$obis_decLatitude<-obis$decimalLatitude[match(trade.trophic$Taxa, obis$scientificName)]
# head(trade.trophic)
# trade.trophic$obis_decLongitude<-obis$decimalLongitude[match(trade.trophic$Taxa, obis$scientificName)]
# head(trade.trophic)

# # rename so we aren't confused 
# trade.trophic.obis <-trade.trophic
# head(trade.trophic.obis)
# dim(trade.trophic.obis)


# Try to plot the data onthe map 
# install.packages("maps")
library(ggplot2)
library(maps)
#Using GGPLOT, plot the Base World Map
mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() + mapWorld
mp
class(mp)



# plot the bubbles 
mp <- mp + geom_point(data = obis, aes(x=decimalLongitude, y= decimalLatitude))
mp



#need to figure out how to use this data










