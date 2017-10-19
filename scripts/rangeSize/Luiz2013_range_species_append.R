
# Created by James Robinson (moved by JMI on 11-Oct-2017 because it was saved under OBIS)
# Created on 26-May-2017
#####################################################

theme_set(theme_bw())
# Purpose: this code reads in Luiz et al. 2013 range size dataset, adds to trade and trade.trophic dataset, then makes plots by range size

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
library("dplyr")

## calculate maximum linear range size 
## maximum linear distance (MLD) in kilometers—as a metric of geographic range size (7, 16) (Luiz et al. 2013)
## read subset Luiz Sup dataset (~500 sp.)
mld<-read.csv(file='data/luizetal_rangesize_datasetS1.csv')
mld$Taxa<-paste(mld$Genus, mld$Species)

# trade data
trade<-read.csv(file='data/trade_taxa_all.csv')
head(trade)
dim(trade) #2296, 8

# read aquarium data with tropihc groups 
trade.trophic<-read.csv(file='data/trade_with_trophic_group.csv')
head(trade.trophic)

### Note: We subsetted to 2008, 09, 11 years only (full records). 
#####################################################


# WITHOUT TROPHIC DATA
# Match range size with the trade.trophic data 
#####################################################

trade$range_size_km<-mld$range_size_km[match(trade$Taxa, mld$Taxa)]
trade$range<-ifelse(is.na(trade$range_size_km), 'NO', 'YES')
trade$range
head(trade)
dim(trade) # 2296, 8 


# subset out species without range size data
trade.range <- dplyr::filter(trade, range=="YES", )
head(trade.range)
head(trade.range$range) # now only "YES"
dim(trade.range) # 342 by 8 
str(trade.range)

#####################################################




# Average total by year and then sum by country
#####################################################
# want to plot range size ~ total volume, but need to deal with different years and different countries

a<-aggregate(Total ~ Taxa+ range_size_km + Exporter.Country, data=trade.range, mean, na.action=NULL)
head(a)
dim(a) # 342 by 4  # doesn't change the dimensions? # maybe there are no different years with the same taxa in teh same country?


trade.range.mean <- aggregate(Total ~ Taxa + range_size_km , data = a, sum) # sum these averages across countries 
head(trade.range.mean)
dim(trade.range.mean) # 222 by 3, so 222 species with range sizes 
tail(trade.range.mean)


# there doesn't seem to be any different years within the same country for one species
# nick and i confirmed with the code below
t <-trade.range %>% group_by(Taxa, Exporter.Country) %>% summarise(a=sum(n()))
data.frame(t)
# but why? this seems wierd 
#####################################################



# Plots!
#####################################################
# trade volume by range size
pdf(file='figures/range_size_km_trade_volume_2008_09_11.pdf', height=11, width=9)
ggplot(trade.range.mean, aes(range_size_km, log10(Total))) + geom_point() + ylab('log10 trade volume') + geom_smooth(method=lm, se=FALSE)
dev.off()

# this way each data point is one species and one raneg size, averaged by years and summed by countries 
#####################################################

















# WITH TROPHIC DATA
# Match range size with the trade.trophic data 
#####################################################

trade.trophic$range_size_km<-mld$range_size_km[match(trade.trophic$Taxa, mld$Taxa)]
trade.trophic$range<-ifelse(is.na(trade.trophic$range_size_km), 'NO', 'YES')
trade.trophic$range
head(trade.trophic)
dim(trade.trophic) #393, 10
str(trade.trophic)

# subset out species without range size data
trade.trophic.range <- dplyr::filter(trade.trophic, range=="YES", )
head(trade.trophic.range)
head(trade.trophic.range$range) # now only "YES"
dim(trade.trophic.range) #214 by 10
str(trade.trophic.range)

#####################################################




# Average total by year and then sum by country
#####################################################
# want to plot range size ~ total volume, but need to deal with different years and different countries

a<-aggregate(Total ~ Taxa+ range_size_km + TROPHIC + Exporter.Country, data=trade.trophic.range, mean, na.action=NULL)
head(a)
dim(a) #214 by 5  # doesn't change the dimensions? # maybe there are no different years with the same taxa in teh same country?


trade.trophic.range.mean <- aggregate(Total ~ Taxa + range_size_km + TROPHIC , data = a, sum) # sum these averages across countries 
head(trade.trophic.range.mean)
dim(trade.trophic.range.mean) # 126, so there are 126 distinct taxa with range sizes
tail(trade.trophic.range)
#####################################################






# Plots!
#####################################################
# trade.trophic volume by range size
pdf(file='figures/range_size_km_trade.trophic_volume_2008_09_11.pdf', height=11, width=9)
ggplot(a, aes(range_size_km, log10(Total), col=TROPHIC)) + geom_point() + ylab('log10 trade volume') + geom_smooth(method=lm, se=FALSE)
dev.off()

# this way each data point is one species and one raneg size, averaged by years and summed by countries 
#####################################################
