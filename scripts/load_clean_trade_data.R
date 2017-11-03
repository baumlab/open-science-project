
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
## add TL and family information
library(rfishbase)
# Get trophic level - commenting out since it takes so long to run
#fishes <-validate_names(div$Taxa, limit=1000) # no results for alot of species
#validate_names(div$Taxa, limit=1000)
#spec <-species(fishes,fields=c('Genus', 'Vulnerability', 'Length', 'Aquarium')) # warnings because species NA could not be parsed
head(spec)
colnames(spec)
spec$Genus
#ecol<-ecology(fishes, fields=c("FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph")) # FoodTroph has the most information
head(ecol)
colnames(ecol)
str(ecol)
div$Taxa

# trying to match 
head(div)
head(spec)
head(ecol)
class(div)
class(spec)
class(ecol)

# save spec and ecol for later (since it takes so long to run)
save(spec, file="data/species_fishbase.Rdata")
save(ecol, file="data/ecology_fishbase.Rdata")

# Taxa is not matching with the fishbase names 
# sp is not working
div$Genus<-spec$Genus[match(div$Taxa, spec$sciname)]
div$Genus
head(div)
div$Vulnerability<-sp$Vulnerability[match(div$Taxa, sp$sciname)]
div$Length<-sp$Length[match(div$Taxa, sp$sciname)]
div$Aquarium<-sp$Aquarium[match(div$Taxa, sp$sciname)]

# now both are not working
div$FoodTroph<-ecol$FoodTroph[match(div$Taxa, ecol$sciname)]
div$FoodTroph
div$FoodSeTroph<-ecol$FoodSeTroph[match(div$Taxa, ecol$sciname)]
div$DietTroph<-ecol$DietTroph[match(div$Taxa, ecol$sciname)]
div$DietSeTroph<-ecol$DietSeTroph[match(div$Taxa, ecol$sciname)]



test1 <- left_join(div, ecol, c("Taxa" = "sciname"))
test2 <- left_join(div, spec, c("Taxa" = "sciname"))

test1$FoodTroph.x 
test2$Genus.x



## add range size
load('data/trade_with_obis_eoo.Rdata')
div$EOO<-trade.obis$EOO[match(div$Taxa, trade.obis$Taxa)]
str(div) # this has export (0,1), country, YEAR? (why is this not there?), data from fishbase, adn EOO

# save files
write.csv(trade, file='data/trade_taxa_all.csv')
write.csv(div, file='data/trade_top100.csv')
