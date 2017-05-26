
# Created by James Robinson
# Created on 4-May-2017


# Purpose: this code reads in trade data from Andrew Rhyne, cleans, saves

setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")


# pull in trade data
trade<-read.csv('data/raw/SpeciesCountryYearsEstFish_SSS_NetworkModel_Data.csv')

## remove modelled data
trade<-trade[trade$Modeled.Data==0,]
## remove un IDd species
trade<-trade[!trade$Taxa=='',]

write.csv(trade, file='data/trade_taxa_all.csv')


length(unique(trade$Taxa)) ## 2645 species!
length(unique(trade$Exporter.Country)) ## 51 countries

# examine rarest species
sp<-aggregate(Total ~ Taxa, trade, sum)
dim(sp[sp$Total<100,]) # 834 species with < 100 individuals

# examine commonest species
hist(sp$Total, plot=F)
sp %>% filter(Total > 100000)

# examine biggest exporting countries
country<-aggregate(Total ~ Exporter.Country, trade, sum)
country[country$Total>500000,]
## Belize, Dominican, Fiji, Haiti, Indonesia, Philippines, Sri Lanka all > 500,000


## examine species number by country
sp.export<-aggregate(Taxa ~ Exporter.Country, trade, function(x)length(unique(x)))
fish.export<-aggregate(Total ~ Exporter.Country, trade, sum)

ggplot(sp.export, aes(Exporter.Country, Taxa)) + 
	geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90)) + xlab('') + ylab('Number of species')

ggplot(fish.export, aes(Exporter.Country, Total)) + 
	geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90)) + xlab('') + ylab('Number of fish')

ggplot(fish.export[!fish.export$Exporter.Country %in% c('Philippines', 'Indonesia'),], aes(Exporter.Country, Total)) + 
	geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90)) + xlab('') + ylab('Number of fish')


