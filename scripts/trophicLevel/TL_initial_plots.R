
# Created by Jamie McDevitt-Irwin
# Created on 12-October-2017

# Purpose: intial plots of trophic level (from CREP data) ~ trade volume 

# clear environment
rm(list=ls()) 
library(ggplot2); theme_set(theme_bw())

setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")
setwd("~/Documents/git_repos/open-science-project")

# read aquarium data
trade.trophic<-read.csv(file='data/trade_with_trophic_group.csv')
load("data/trade_with_obis_eoo.Rdata")

head(trade.trophic); head(trade.obis)
trade.trophic$EOO<-trade.obis$EOO[match(trade.trophic$Taxa, trade.obis$Taxa)]

library(lme4)
m<-glmer(log10(Total) ~ scale(sqrt(EOO)) + 
	 (1 | YEAR / Exporter.Country) + (1 + scale(sqrt(EOO)) | TROPHIC), trade.trophic, family=Gamma)
summary(m)
ranef(m)

## aggregate for the plots 
total<-aggregate(Total ~ TROPHIC + YEAR, trade.trophic, sum, na.action=NULL)
total.country<-aggregate(Total ~ TROPHIC + YEAR + Exporter.Country, trade.trophic, sum, na.action=NULL)
nspecies<-aggregate(Taxa ~ YEAR + TROPHIC, trade.trophic, function(x) length(unique(x)), na.action=NULL)



# plot total trade volume by trophic level
pdf(file='figures/trophic_by_trade_volume_2008_09_11.pdf', height=11, width=9)
ggplot(data=total, aes(x=TROPHIC, y=log10(Total), fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black") +
    facet_wrap(~YEAR) +
    scale_x_discrete(labels=NULL)
dev.off()

# plot total trade volume by country
pdf(file='figures/trophic_by_trade_volume_country_2008_09_11.pdf', height=11, width=9)
ggplot(data=total.country, aes(x=TROPHIC, y=log10(Total), fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black") +
    facet_wrap(~Exporter.Country)+
    scale_x_discrete(labels=NULL)
dev.off()


pdf(file='figures/trophic_by_species_2008_09_11.pdf', height=11, width=9)
ggplot(data=nspecies, aes(x=TROPHIC, y=Taxa, fill=TROPHIC)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black") +
    facet_wrap(~YEAR) +
    labs(y = 'Number of species')+
    scale_x_discrete(labels=NULL)
dev.off()
    
