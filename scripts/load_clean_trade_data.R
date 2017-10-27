
# Created by James Robinson
# Created on 4-May-2017


# Purpose: this code reads in trade data from Andrew Rhyne, cleans, saves

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")
library(dplyr); library(ggplot2)

# pull in trade data
trade<-read.csv('data/raw/SpeciesCountryYearsEstFish_SSS_NetworkModel_Data.csv')

## remove modelled data
# trade<-trade[trade$Modeled.Data==0,]
## remove un IDd species
trade<-trade[!trade$Taxa=='',]
## remove incomplete years
trade<-trade[trade$YEAR%in%c('2008', '2009' , '2011'),]

write.csv(trade, file='data/trade_taxa_all.csv')


length(unique(trade$Taxa)) ## 2645 species!
length(unique(trade$Exporter.Country)) ## 51 countries

# examine rarest species
sp<-aggregate(Total ~ Taxa, trade, sum)
dim(sp[sp$Total<100,]) # 834 species with < 100 individuals

# examine commonest species
hist(sp$Total, plot=F)
sp %>% filter(Total > 78110) # top 100 species in terms of total volume 


# examine biggest exporting countries
country<-aggregate(Total ~ Exporter.Country, trade, sum)
country[country$Total>500000,]
## Belize, Dominican, Fiji, Haiti, Indonesia, Philippines, Sri Lanka all > 500,000

## create export diversity dataframe
div <- trade %>% group_by(Taxa) %>% summarise(N = n())
# take top 100 most common species
sp.common<-sp %>% filter(Total > 78110) 
div <- div %>% filter(Taxa %in% sp.common$Taxa)
head(div) # N is the number of countries the species is exported from? 
dim(div)
## 

write.csv(div, file='data/trade_top100.csv')

## examine species number by country
sp.export<-aggregate(Taxa ~ Exporter.Country, trade, function(x)length(unique(x)))
fish.export<-aggregate(Total ~ Exporter.Country, trade, sum)

ggplot(sp.export, aes(Exporter.Country, Taxa)) + 
	geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90)) + xlab('') + ylab('Number of species')

ggplot(fish.export, aes(Exporter.Country, Total)) + 
	geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90)) + xlab('') + ylab('Number of fish')

ggplot(fish.export[!fish.export$Exporter.Country %in% c('Philippines', 'Indonesia'),], aes(Exporter.Country, Total)) + 
	geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90)) + xlab('') + ylab('Number of fish')


