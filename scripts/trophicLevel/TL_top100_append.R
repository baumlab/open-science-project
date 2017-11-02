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
