
# Created by James Robinson
# Created on 4-May-2017


# Purpose: this code reads in trade data from Andrew Rhyne, cleans, saves

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")
library(dplyr); library(ggplot2); library(tidyr)

# pull in trade data
trade<-read.csv('data/raw/SpeciesCountryYearsEstFish_SSS_NetworkModel_Data.csv')

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

#----------------------------------------#----------------------------------------
								## ADDING PREDICTORS
#----------------------------------------#----------------------------------------
## add TL and family information
library(rfishbase)
# Get trophic level - THIS NEEDS FINISHING. VALIDATE DIDN"T FINISH FOR JR
fishes <-validate_names(div$Taxa, limit=1000)
sp <-species(fishes,fields=c('Genus', 'Vulnerability', 'Length', 'Aquarium'))
ecol<-ecology(fishes, fields=c("FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph"))

div$Genus<-sp$Genus[match(div$Taxa, sp$Taxa)]
div$Vulnerability<-sp$Vulnerability[match(div$Taxa, sp$Taxa)]
div$Length<-sp$Length[match(div$Taxa, sp$Taxa)]
div$Aquarium<-sp$Aquarium[match(div$Taxa, sp$Taxa)]
div$FoodTroph<-sp$FoodTroph[match(div$Taxa, sp$Taxa)]
div$FoodSeTroph<-sp$FoodSeTroph[match(div$Taxa, sp$Taxa)]
div$DietTroph<-sp$DietTroph[match(div$Taxa, sp$Taxa)]
div$DietSeTroph<-sp$DietSeTroph[match(div$Taxa, sp$Taxa)]

## add range size
load('data/trade_with_obis_eoo.Rdata')
div$EOO<-trade.obis$EOO[match(div$Taxa, trade.obis$Taxa)]

# save files
write.csv(trade, file='data/trade_taxa_all.csv')
write.csv(div, file='data/trade_top100.csv')
