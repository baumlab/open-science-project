

# Created by Jamie McDevitt-Irwin
# Created on 11-Oct-2017

theme_set(theme_bw())
# Purpose: this code reads in OBIS data from Andrew Rhyne, find the matching species with trade, calculate EOO

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
library(dplyr)

# read full distribution data
obis<-read.csv(file='data/OBIS_dist_species.csv')
head(obis)
tail(obis)
dim(obis) #1393965, 10
levels(obis$taxa_name) #2509 species 
# decimal lat and long are both + and - values


# Before you can match in the trade data, you need one value for each species from the OBIS data
# Idea from Jimmy: Find max and min for each sp. Scale lat and lon to mean 0 and sd of 1 across all species. Sum together for each species. Proxy for range size.


# match trade data with OBIS
trade<-read.csv(file='data/trade_taxa_all.csv')
head(trade)
str(trade)
levels(trade$Taxa) #1553 species 
dim(trade) # 2296, 6 (because there are multiple species in multiple countries )

# subset obis so it only includes species within trade dataset 
test <- subset(obis,taxa_name %in% trade$Taxa)
head(test)
dim(test) #609832 occurences 

# how many species are in the obis dataset from trade? 
trade$decimalLatitude<-obis$decimalLatitude[match(trade$Taxa, obis$taxa_name)]
levels(trade$Taxa) # 1553 so all of them!!




# Calculate Extent of Occurence from OBIS data 
# subset out just decimal and species names 
test.conr <- dplyr::select(test, one_of(c("decimalLatitude", "decimalLongitude", "taxa_name")))
head(test.conr)
dim(test.conr) #609832, 3

library(red)
head(test.conr)


want = unique(test.conr$taxa_name)
haha = c()
for(i in 1:length(want)){
	ha = test.conr[test.conr$taxa_name == want[i], c(2, 1)] # 
	haha = rbind(haha, data.frame(Species = want[i], EOO = eoo(ha)))
}

head(haha)
dim(haha) #1445, 2, so it only calculated EOO for 1445 species 

# merge back to trade data
trade$EOO<-haha$EOO[match(trade$Taxa, haha$Species)]
head(trade)
dim(trade) # 2296, 8
trade$EOO # need to get rid of the NAs

library(tidyr)
test <- trade %>% drop_na(EOO)
dim(test) #2147

trade.obis <- test
trade.obis <- dplyr::select(trade.obis, -X) # get rid of the column X
head(trade.obis)
class(trade.obis)

save(trade.obis, file="data/trade_with_obis_eoo.Rdata")

