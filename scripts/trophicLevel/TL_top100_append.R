# Created by Jamie McDevitt-Irwin
# Created on 26-October-2017

# Purpose: this code reads in CREP trophic data and Fishbase data and appends to just hte top 100 fish taxa exported (should make fishbase faster)

# clear environment
rm(list=ls()) 

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")

# read aquarium data
trade100<-read.csv(file='data/trade_top100.csv')
head(trade100)

# read CREP species data
load('data/TMPspecies.Rdata')
ls()
head(species_table)


# match in trophic levels
trade100$TROPHIC<-species_table$TROPHIC_MONREP[match(trade100$Taxa, species_table$TAXONNAME)]
## trophic groups for 2268 species. missing for 5245 species.

trade100.trophic<-trade100[!is.na(trade100$TROPHIC),]
trade100.trophic<-droplevels(trade100.trophic)
head(trade100.trophic)
dim(trade100.trophic) # only has data for 28 species 



write.csv(trade100.trophic, file='data/trade100_with_trophic_group.csv')



## try fish base
# install.packages("devtools")
library(devtools)
devtools::install_github("ropensci/rfishbase")
library("rfishbase")

trade100$Taxa

# check for misspellings or alternate names 
x <- synonyms(trade100$Taxa) # 46 warnings saying no results for query

# check for alternate versions of a scientific name and return the names FishBase recognizes as valid 
fishes <-validate_names(trade100$Taxa, limit=1000) # more than 50 warnings, no match for species
fishes # how many have NA

fishes<-fishes[!is.na(fishes)]
fishes # 77 species have names within fishbase 



# Get trophic level 
test <-ecology(fishes,fields=c("FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph"))
test # FoodTroph has the most information

fishes.troph<-test[!is.na(test$FoodTroph),]
fishes.troph # 75 species have trophic level data!!





