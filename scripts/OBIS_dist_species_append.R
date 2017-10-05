

# Created by James Robinson
# Created on 26-May-2017

theme_set(theme_bw())
# Purpose: this code reads in OBIS data from Andrew Rhyne, adds to trade dataset

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
# read full distribution data
obis<-read.csv(file='data/OBIS_dist_species.csv')
head(obis)

## calculate maximum linear range size 
## maximum linear distance (MLD) in kilometers—as a metric of geographic range size (7, 16) (Luiz et al. 2013)
## read subset Luiz Sup dataset (~500 sp.)
mld<-read.csv(file='data/luizetal_rangesize_datasetS1.csv')
mld$Taxa<-paste(mld$Genus, mld$Species)

## check number of taxa recorded in Luiz et al. and by aquarium dataset
# read aquarium data
trade<-read.csv(file='data/trade_with_trophic_group.csv')
head(trade)

trade$range_size_km<-mld$range_size_km[match(trade$Taxa, mld$Taxa)]
trade$range<-ifelse(is.na(trade$range_size_km), 'NO', 'YES')

## how many fish with range size estimates?
a<-aggregate(Total ~ range + range_size_km + Taxa + TROPHIC + Exporter.Country + YEAR, trade, sum, na.action=NULL)
a<-aggregate(Total ~ range + range_size_km + Taxa + TROPHIC + Exporter.Country, a, mean, na.action=NULL)
sum(a$Total[a$range=='NO'])/(sum(a$Total[a$range=='YES'])+ sum(a$Total[a$range=='NO']))*100
## 55% of total fish traded without data
length(a$Total[a$range=='NO'])/(length(a$Total[a$range=='YES'])+ length(a$Total[a$range=='NO']))*100
## 84% of species without data
head(a)

pdf(file='figures/range_size_km_trade_volume_2008_09_11.pdf', height=11, width=9)
ggplot(a, aes(range_size_km, log10(Total), col=TROPHIC)) + geom_point() + facet_wrap(~Exporter.Country) + ylab('log10 Trade volume')+ geom_smooth(method=lm, se=FALSE)
ggplot(a, aes(range_size_km, log10(Total), col=TROPHIC)) + geom_point() + ylab('log10 Trade volume') + geom_smooth(method=lm, se=FALSE)
dev.off()

# plot total trade volume by trophic level
pdf(file='figures/trophic_by_trade_volume_2008_09_11.pdf', height=11, width=9)
ggplot(data=a, aes(x=TROPHIC, y=log10(Total), fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")


# and by country
ggplot(data=a, aes(x=TROPHIC, y=log10(Total), fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black") +
    facet_wrap(~Exporter.Country)
dev.off()

sp.full<-aggregate(YEAR ~ Taxa + Exporter.Country, trade, unique)

trade[trade$Taxa=='Chromis viridis',]

trade[which.max(trade$Total),]
head(trade)

### We subsetted to 2008, 09, 11 years only (full records). Range size is not a good predictor of trade volume, nor does 
## differences in range size appear to affect vulnerability to high/low trade volume.