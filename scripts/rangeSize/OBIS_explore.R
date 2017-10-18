# Created by Jamie McDevitt-Irwin
# Created on 16-October-2017


# Purpose: this code explores the obis range size data and appends it to trophic data 

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
theme_set(theme_bw())
# clear my environment
rm(list=ls())

load("data/trade_with_obis_eoo.Rdata") # "trade.obis"
ls()
head(trade.obis)


# plot total by range size
ggplot(trade.obis, aes(EOO, log10(Total))) + geom_point() + ylab('log10 Trade volume')+ geom_smooth(method=lm, se=FALSE)



# how many fish with range size estimates?
a<-aggregate(Total ~ EOO + Taxa +  Exporter.Country + YEAR, trade.obis, sum, na.action=NULL)
head(a)
a<-aggregate(Total ~ EOO + Taxa +  Exporter.Country, a, mean, na.action=NULL)
head(a)


ggplot(a, aes(EOO, log10(Total))) + geom_point() + ylab('log10 Trade volume')+ geom_smooth(method=lm, se=FALSE)


# plot by trophic and rnage size
trade<-read.csv(file='data/trade_with_trophic_group.csv')
head(trade)


# merge with the obis data
trade$EOO<-trade.obis$EOO[match(trade$Taxa, trade.obis$Taxa)]
head(trade)
dim(trade)



# how many fish with range size estimates?
b<-aggregate(Total ~ EOO + Taxa + Exporter.Country + YEAR + TROPHIC, trade, sum, na.action=NULL)
head(b) # did this actually change anything
dim(b)
b<-aggregate(Total ~ EOO + Taxa + Exporter.Country + TROPHIC, b, mean, na.action=NULL)
head(b)
dim(b)

ggplot(b, aes(EOO, log10(Total), col=TROPHIC)) + geom_point() + ylab('log10 Trade volume')+ geom_smooth(method=lm, se=FALSE)


