
# Created by Jamie McDevitt-Irwin
# Created on 12-October-2017

# Purpose: intial plots of trophic level (from CREP data) ~ trade volume 

# clear environment
rm(list=ls()) 

setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")

# read aquarium data
trade.trophic<-read.csv(file='data/trade_with_trophic_group.csv')
head(trade.trophic)


## aggregate for the plots 
a<-aggregate(Total ~ Taxa + TROPHIC + Exporter.Country + YEAR, trade.trophic, sum, na.action=NULL)
a<-aggregate(Total ~ Taxa + TROPHIC + Exporter.Country, a, mean, na.action=NULL)
head(a)


# plot total trade volume by trophic level
pdf(file='figures/trophic_by_trade_volume_2008_09_11.pdf', height=11, width=9)
ggplot(data=a, aes(x=TROPHIC, y=log10(Total), fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()

# plot total trade volume by country
pdf(file='figures/trophic_by_trade_volume_country_2008_09_11.pdf', height=11, width=9)
ggplot(data=a, aes(x=TROPHIC, y=log10(Total), fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black") +
    facet_wrap(~Exporter.Country)
dev.off()

    
