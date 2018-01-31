
# Created by Jamie McDevitt-Irwin
# Created on 13-November-2017


# Purpose: add in range size data (eoo and aoo) to full dataset of trade and trophic level from fishbase

rm(list=ls()) 
# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")
library(dplyr); library(ggplot2); library(tidyr)

trade.fishbase <- read.csv(file='data/clean/trade_top100_fishbase.csv')
# this now has the response variable as n=# of exporting countries instead of export=0,1
# so one of my scripts below is commented out because it doesn't work 



#### Range Size Information ####
load('data/clean/trade_with_obis_range.Rdata')
ls()
trade.fishbase$EOO<-trade.obis$EOO[match(trade.fishbase$Taxa, trade.obis$Taxa)]
trade.fishbase$AOO<-trade.obis$AOO[match(trade.fishbase$Taxa, trade.obis$Taxa)]

str(trade.fishbase) # this has everything but year 

# rename
trade.fishbase.range <-trade.fishbase

# ## add species aggregated dataframe for number of exporting countries
# ## take top 100 then complete cases
# div<- trade.fishbase.range %>% filter(export==1) %>% group_by(Taxa) %>% mutate(n.export=length(unique(Exporter.Country)))
# div<-div[!duplicated(div$Taxa),]
# div$Exporter.Country<-NULL


# save files
#write.csv(trade.fishbase.range, file='data/clean/trade_top100_fishbase_range.csv')
write.csv(trade.fishbase.range, file='data/clean/trade_top100_nexporters.csv')


