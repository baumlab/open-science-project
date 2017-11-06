
# Created by James Robinson
# Created on 4-May-2017


# Purpose: this code reads in trade data from Andrew Rhyne, cleans, saves

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")
library(dplyr); library(ggplot2); library(tidyr)

# pull in trade data
trade<-read.csv('data/raw/trade/SpeciesCountryYearsEstFish_SSS_NetworkModel_Data.csv')

## remove modelled data
# trade<-trade[trade$Modeled.Data==0,]
## remove un IDd species
trade<-trade[!trade$Taxa=='',]

## remove incomplete years
# trade<-trade[trade$YEAR%in%c('2008', '2009' , '2011'),]


length(unique(trade$Taxa)) ## 2645 species!
length(unique(trade$Exporter.Country)) ## 51 countries

# examine rarest species
sp<-aggregate(Total ~ Taxa, trade, sum)
dim(sp[sp$Total<100,]) # 834 species with < 100 individuals

# examine commonest species
hist(sp$Total, plot=F)
sp.common<-sp %>% filter(Total > 78110) # top 100 species in terms of total volume 

# examine biggest exporting countries
country<-aggregate(Total ~ Exporter.Country, trade, sum)
country[country$Total>500000,]
## Belize, Dominican, Fiji, Haiti, Indonesia, Philippines, Sri Lanka all > 500,000

## create export diversity dataframe
## take top 100 then complete cases
div <- trade %>% filter(Taxa %in% sp.common$Taxa) %>% 
		distinct(Exporter.Country, Taxa) %>% ## keep unique taxa for each country (i.e. drop years)
		mutate(export = 1) %>% # assign export status as 1
		complete(Exporter.Country, nesting(Taxa), fill=list(export=0)) # add export = 0 for other countries

## check every species appears in every country as a 0 or 1
aggregate(Taxa ~ Exporter.Country, div, length)
head(div)

#----------------------------------------#----------------------------------------
								## ADDING PREDICTORS
#----------------------------------------#----------------------------------------
### Fishbase Information ###
## add TL and family information
library(rfishbase)
# Get trophic level 
fishes <-validate_names(div$Taxa, limit=1000) 
head(fishes)
str(fishes)

x <- unique(fishes)
x #78 unique fishes
# gadus morhua is not in there!!!


# Add Species Information
spec <-species(fishes,fields=c('Genus', 'Vulnerability', 'Length', 'Aquarium')) # warnings because species NA could not be parsed
head(spec)
colnames(spec)
spec$Genus # no gadus

# add back to the div table
test2 <- left_join(div, spec, c("Taxa" = "sciname"))
test2 # worked!


# Add Trophic Information
ecol<-ecology(fishes, fields=c("FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph")) # FoodTroph has the most information
head(ecol) 
colnames(ecol)
ecol$sciname # no gadus morhua

# add to the species and div table already created 
test3 <- left_join(test2, ecol, c("Taxa" = "sciname"))
head(test3)
test3$Genus
test3$FoodTroph

# rename
trade.fishbase <-test3

# save file
write.csv(trade.fishbase, file='data/clean/trade_top100_fishbase.csv')




#### Range Size Information ####
load('data/clean/trade_with_obis_eoo.Rdata')
trade.fishbase$EOO<-trade.obis$EOO[match(trade.fishbase$Taxa, trade.obis$Taxa)]
str(trade.fishbase) # this has everything but year 

# rename
trade.fishbase.eoo <-trade.fishbase

# save files
write.csv(trade, file='data/clean/trade_taxa_all.csv')
write.csv(trade.fishbase.eoo, file='data/clean/trade_top100_fishbase_eoo.csv')


