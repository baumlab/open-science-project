
# Created by James Robinson
# Created on 4-May-2017


# Purpose: this code reads in trade data from Andrew Rhyne, cleans, saves

rm(list=ls()) 
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
## remove invertebrates
inverts<-c('Archaster typicus', 'Calcinus elegans', 'Clibanarius tricolor', 'Condylactis gigantea',
		'Dardanus megistos', 'Engina mendicaria', 'Entacmaea quadricolor', 'Heteractis malu', 
		'Lysmata amboinensis', 'Lysmata ankeri', 'Lysmata debelius', 'Mithraculus sculptus', 'Nassarius distortus', 
		'Nassarius venustus', 'Paguristes cadenati', 'Percnon gibbesi', 'Protoreaster nodosus',
		'Sabellastarte spectabilis', 'Stenopus hispidus', 'Stenorhynchus seticorni', 'Synchiropus ocellatus', 
		'Tectus fenestratus', 'Tectus pyramis', 'Trochus maculatus',
		'Echidna nebulosa','Elysia crispata','Heteractis crispa',
		'Sabellastarte magnifica','Stenorhynchus seticornis','Linckia laevigata')
trade<-trade[!trade$Taxa %in% inverts,]
str(trade)
head(trade)
dim(trade)

## rename some species in prep for fishbase
trade$Taxa<-as.character(trade$Taxa)
trade$Taxa[trade$Taxa=='Centropyge loricula']<-'Centropyge loriculus' ## flame angel


length(unique(trade$Taxa)) ## 2616 species!
length(unique(trade$Exporter.Country)) ## 51 countries

# examine rarest species
sp<-aggregate(Total ~ Taxa, trade, sum)
dim(sp[sp$Total<100,]) # 834 species with < 100 individuals

# examine commonest species
hist(sp$Total, plot=F)
sp.common<-sp %>% filter(Total > 57960) # top 100 species in terms of total volume 
head(sp.common)
dim(sp.common) 


# examine biggest exporting countries
country<-aggregate(Total ~ Exporter.Country, trade, sum)
country[country$Total>500000,]
## Belize, Dominican, Fiji, Haiti, Indonesia, Philippines, Sri Lanka all > 500,000

## create export diversity dataframe
## take top 100 then complete cases
div <- trade %>% filter(Taxa %in% sp.common$Taxa) %>% 
		distinct(Exporter.Country, Taxa) %>% ## keep unique taxa for each country (i.e. drop years)
		mutate(export = 1) %>% # assign export status as 1
		ungroup() %>% group_by(Taxa) %>%
		summarise(N = sum(export))
		# complete(Exporter.Country, nesting(Taxa), fill=list(export=0)) # add export = 0 for other countries
head(div)

### NEED TO FIX HERE - SPECIES CANNOT BE ASSIGNED EXPORT  = 0 IF THEY ARE NOT FOUND IN THAT COUNTRY!


## check every species appears in every country as a 0 or 1
# aggregate(Taxa ~ Exporter.Country, div, length)
# head(div)



#----------------------------------------#----------------------------------------
								## ADDING PREDICTORS
# #----------------------------------------#----------------------------------------
# ## Fishbase Information ###
# ## add TL and family information
# library(rfishbase)
# # Get trophic level 
# ## this function takes a LONG time to run (> 30 minutes)
# fishes <-validate_names(div$Taxa, limit=1000) 
# head(fishes)
# str(fishes)

# x <- unique(fishes)
# x #  100 unique fishes
# # gadus morhua is not in there!!!
# ## ^^ best comment ever 

# # Add Species Information
# spec <-species(fishes,fields=c('Genus', 'Vulnerability', 'Length', 'Aquarium')) # warnings because species NA could not be parsed
# head(spec)
# colnames(spec)
# spec$Genus # no gadus
# spec$sciname # 100 unique species

# # # add back to the div table
# # test2 <- left_join(div, spec, c("Taxa" = "sciname"))
# # test2 # worked!



# # Add Trophic Information
# ecol<-ecology(fishes, fields=c("FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph")) # FoodTroph has the most information
# head(ecol) 
# colnames(ecol)
# ecol$sciname # no gadus morhua, only 97 sci names (so only has ecology info for 92 species) 

# # add to the species and div table already created 
# # test3 <- left_join(test2, ecol, c("Taxa" = "sciname"))
# # head(test3)
# # test3$Genus
# # test3$FoodTroph
# # x <- unique(test3$Taxa)
# # x # back to the 100 

# save(spec, file='data/species_fishbase.Rdata')
# save(ecol, file='data/ecology_fishbase.Rdata')

## Add predictors from fishbase data
load('data/ecology_fishbase.Rdata')
load('data/species_fishbase.Rdata')

div$Genus<-spec$Genus[match(div$Taxa, spec$sciname)]
div$Vulnerability<-spec$Vulnerability[match(div$Taxa, spec$sciname)]
div$Length<-spec$Length[match(div$Taxa, spec$sciname)]
div$DietTroph<-ecol$DietTroph[match(div$Taxa, ecol$sciname)]
div$FoodTroph<-ecol$FoodTroph[match(div$Taxa, ecol$sciname)]


# # save file
write.csv(div, file='data/clean/trade_top100_fishbase.csv')
write.csv(trade, file='data/clean/trade_taxa_all.csv')


