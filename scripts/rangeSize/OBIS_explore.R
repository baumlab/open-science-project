# Created by Jamie McDevitt-Irwin
# Created on 16-October-2017


# Purpose: this code explores the obis range size data and appends it to trophic data 

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2")
theme_set(theme_bw())
# clear my environment
rm(list=ls())

load("data/trade_with_obis_eoo.Rdata") # "trade.obis"
ls()
head(trade.obis)
dim(trade.obis) #2147,7
#####################################################



# WITHOUT TROPHIC DATA
# Average total by year and then sum by country
#####################################################
# want to plot range size ~ total volume, but need to deal with different years and different countries

a<-aggregate(Total ~ Taxa+ EOO + Exporter.Country, data=trade.obis, mean, na.action=NULL)
head(a)
dim(a) #2147 by 4  # doesn't change the dimensions? # maybe there are no different years with the same taxa in teh same country?


trade.obis.mean <- aggregate(Total ~ Taxa + EOO, data = a, sum) # sum these averages across countries 
head(trade.obis.mean)
dim(trade.obis.mean) # 1445 by 3 so there are 1445 species with range sizes and volumes 
tail(trade.obis.mean)

# there doesn't seem to be any different years within the same country for one species
# nick and i confirmed with the code below
t <-trade.obis %>% group_by(Taxa, Exporter.Country) %>% summarise(a=sum(n()))
t <-data.frame(t)
summary(t)
# but why? this seems wierd 
#####################################################




# Plots!
#####################################################
# trade volume by eoo
pdf(file='figures/eoo_trade_volume_2008_09_11.pdf', height=11, width=9)
ggplot(trade.obis.mean, aes(EOO, log10(Total))) + geom_point() + ylab('log10 trade volume') + geom_smooth(method=lm, se=FALSE)
dev.off()
# there are lots of species that got a zero range size in teh EOO calculation, why and should we drop them? 
#####################################################











# WITH TROPHIC DATA 

# plot by trophic and rnage size
trade<-read.csv(file='data/trade_with_trophic_group.csv')
head(trade)


# merge with the obis data
trade$EOO<-trade.obis$EOO[match(trade$Taxa, trade.obis$Taxa)]
head(trade)
dim(trade)



# Match range size with the trade.trophic data 
#####################################################
trade.trophic<-read.csv(file='data/trade_with_trophic_group.csv')
head(trade.trophic)

trade.trophic$EOO<-trade.obis$EOO[match(trade.trophic$Taxa, trade.obis$Taxa)]
trade.trophic$range<-ifelse(is.na(trade.trophic$EOO), 'NO', 'YES')
trade.trophic$range
head(trade.trophic)
dim(trade.trophic) #393, 10
str(trade.trophic)

# subset out species without range size data
trade.trophic.obis <- dplyr::filter(trade.trophic, range=="YES", )
head(trade.trophic.obis)
head(trade.trophic.obis$range) # now only "YES"
dim(trade.trophic.obis) #393 by 10
str(trade.trophic.obis)
# all of the trophic groups also had range sizes 
#####################################################





# Average total by year and then sum by country
#####################################################
# want to plot range size ~ total volume, but need to deal with different years and different countries

a<-aggregate(Total ~ Taxa+ EOO + Exporter.Country, data=trade.trophic.obis, mean, na.action=NULL)
head(a)
dim(a) # 393 by 4  # doesn't change the dimensions? # maybe there are no different years with the same taxa in teh same country?


trade.trophic.obis.mean <- aggregate(Total ~ Taxa + EOO, data = a, sum) # sum these averages across countries 
head(trade.trophic.obis.mean)
dim(trade.trophic.obis.mean) # 244 by 3 so there are 244 species with range sizes and volumes 
tail(trade.trophic.obis.mean)

# there doesn't seem to be any different years within the same country for one species
# nick and i confirmed with the code below
t <-trade.trophic.obis %>% group_by(Taxa, Exporter.Country) %>% summarise(a=sum(n()))
t <-data.frame(t)
summary(t)
# but why? this seems wierd 
#####################################################




# Plots!
#####################################################
# trade.trophic volume by range size
pdf(file='figures/EOO_trade.trophic_volume_2008_09_11.pdf', height=11, width=9)
ggplot(trade.trophic.obis, aes(EOO, log10(Total), col=TROPHIC)) + geom_point() + ylab('log10 trade volume') + geom_smooth(method=lm, se=FALSE)
dev.off()

# this way each data point is one species and one raneg size, averaged by years and summed by countries 
#####################################################

