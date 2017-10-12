# Created by James Robinson
# Created on 26-May-2017

# Purpose: this code reads in CREP trophic data and Fishbase data 

# clear environment
rm(list=ls()) 

setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")

# read aquarium data
trade<-read.csv(file='data/trade_taxa_all.csv')
head(trade)

# read CREP species data
load('data/TMPspecies.Rdata')
ls()
head(species_table)


# match in trophic levels
trade$TROPHIC<-species_table$TROPHIC_MONREP[match(trade$Taxa, species_table$TAXONNAME)]
## trophic groups for 2268 species. missing for 5245 species.

trade.trophic<-trade[!is.na(trade$TROPHIC),]
trade.trophic<-droplevels(trade.trophic)



write.csv(trade.trophic, file='data/trade_with_trophic_group.csv')


# which countries have 0 NA values? **must compare countries when ALL SPECIES TRADED have trophic groups

aggregate(TROPHIC ~ Exporter.Country, trade, function(x){sum(is.na(x))}, na.action=NULL)
# all countries have NAs. 

a<-aggregate(Total ~ Exporter.Country, trade, sum, na.action=NULL)
b<-aggregate(Total ~ Exporter.Country, trade[!is.na(trade$TROPHIC),], sum,na.action=NULL)
b$total<-a$Total[match(b$Exporter.Country, a$Exporter.Country)]
b$prop.trophic<-round(b$Total/b$total*100, 2)
hist(b$prop.trophic)

## many missing trophic level estimates. What else can we use?
# Fishbase: only two of our species were found
# http://www.documentation.ird.fr/hor/PAR00000515 (try this out)




## try fish base
# install.packages("devtools")
library(devtools)
devtools::install_github("ropensci/rfishbase")
library("rfishbase")

trade$Taxa
fishes <-validate_names(trade$Taxa)  # some warnings about names being misapplied to other species but returns the best match
fishes # only found two of our fish
test <-ecology(fishes,fields=c("FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph"))
fish
