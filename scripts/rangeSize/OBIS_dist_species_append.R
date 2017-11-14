

# Created by Jamie McDevitt-Irwin
# Created on 11-Oct-2017

theme_set(theme_bw())
rm(list=ls()) 
# Purpose: this code reads in OBIS data from Andrew Rhyne, find the matching species with trade, calculate EOO

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
library(dplyr)

# read full distribution data
obis<-read.csv(file='data/raw/species-preds/OBIS_dist_species.csv')
head(obis)
tail(obis)
dim(obis) #1393965, 10
levels(obis$taxa_name) #2509 species 
# decimal lat and long are both + and - values
# Before you can match in the trade data, you need one value for each species from the OBIS data
#####################################################



# match trade data with OBIS
#####################################################
trade<-read.csv(file='data/clean/trade_taxa_all.csv')
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
#####################################################




# Calculate Extent of Occurence from OBIS data 
#####################################################
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
dim(haha) # 2509, 2, so it only calculated EOO for 2509

# merge back to trade data
trade$EOO<-haha$EOO[match(trade$Taxa, haha$Species)]
head(trade)
dim(trade) # 7887    7
trade$EOO # need to get rid of the NAs

library(tidyr)
test <- trade %>% drop_na(EOO)
dim(test) # 7636    7

trade.eoo <- test
trade.eoo <- dplyr::select(trade.eoo, -X) # get rid of the column X
head(trade.eoo)
class(trade.eoo)
trade.eoo$EOO # there are still alot with zero range size?
trade.eoo$Modeled.Data # this number has increased because now we have included the modeled data 


#####################################################


# Calculate Area of Occurence from OBIS data 
#####################################################
# need to use the obis data with lat, long

want = unique(test.conr$taxa_name)
haha2 = c()
for(i in 1:length(want)){
	ha = test.conr[test.conr$taxa_name == want[i], c(2, 1)] # 
	haha2 = rbind(haha2, data.frame(Species = want[i], AOO = aoo(ha)))
}

head(haha2)
dim(haha2)


# merge back to trade data
trade.eoo$AOO<-haha2$AOO[match(trade.eoo$Taxa, haha2$Species)]
head(trade.eoo)
dim(trade.eoo) # 7636    7
trade.eoo$AOO # doesn't look like there are any NA's because they were already dropped during EOO na.omit

library(tidyr)
test <- trade.eoo %>% drop_na(AOO)
dim(test) # 7636    7 # didn't drop anything

trade.obis <- test
dim(trade.obis) # 7636    8
head(trade.obis)
class(trade.obis)
trade.obis$EOO # there are still alot with zero range size?
trade.obis$AOO
trade.obis$Modeled.Data # this number has increased because now we have included the modeled data 

save(trade.obis, file="data/clean/trade_with_obis_range.Rdata")
