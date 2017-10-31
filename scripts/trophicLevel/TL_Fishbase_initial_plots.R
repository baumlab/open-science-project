
# Created by Jamie McDevitt-Irwin
# Created on 30-October-2017

# Purpose: plots of trophic data from FishBase

# clear environment
rm(list=ls()) 
library(ggplot2); theme_set(theme_bw())

setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")

trade.100 <- read.csv('data/trade_top100.csv')
head(trade.100)

ggplot(trade.100, aes(FoodTroph, export, col=FoodTroph)) + geom_point() + ylab('Exported?') 
ggplot(trade.100, aes(FoodTroph, export, col=FoodTroph)) + geom_point() + ylab('Exported?') +facet_wrap(~Exporter.Country)

ggplot(trade.100, aes(EOO, export, col=EOO)) + geom_point() + ylab('Exported?')
ggplot(trade.100, aes(EOO, export, col=EOO)) + geom_point() + ylab('Exported?')+facet_wrap(~Exporter.Country)


# when its not faceted by country it looks the points are mirrored on the 1 and 0, is that just how the data is set up? think about this.