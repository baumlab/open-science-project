

# Created by Jamie McDevitt-Irwin
# Created on 05-October-2017


# Purpose: this code reads in the aquarium data and connects it to the governance indicators, so we can look at trade volume ~ indicators 

setwd("/Users/jamiemcdevitt-irwin/Documents/Git_Repos/open-science-project/")
getwd()

# read aquarium data
trade<-read.csv(file='data/trade_taxa_all.csv')
head(trade)

# total volume per country
a<-aggregate(Total ~ Exporter.Country, trade, sum, na.action=NULL)
a

# read governance data
govind <-read.csv(file='data/raw/governance_indicators_worldbank.csv')
head(govind)
colnames(govind)

#rename the headers because they are crazy
library(dplyr)
govind = govind %>% rename(Country.Name=X...Country.Name, "YR2008"=X2008..YR2008., "YR2009"=X2009..YR2009., "YR2010"=X2010..YR2010., "YR2011"=X2011..YR2011.)
head(govind)
colnames(govind)

# match trade volume to the governance data 
govind$volume<-a$Total[match(govind$Country.Name, a$Exporter.Country)]
govind

govind.vol<-govind[!is.na(govind$volume),]
govind.vol<-droplevels(govind.vol)
head(govind.vol) #Australia has 3623 (compared to old datafile)

# need to switch the "Series.Name" to columns 
# install.packages("reshape")
library(reshape)
library(ggplot2)

# try to reshape the data 
test <- reshape(govind.vol, idvar="Country.Name", timevar="Series.Code", direction="wide")
head(test)
colnames(test)

# lets look at governance effectiveness for the last year, 2011: GE.EST
ggplot(test, aes(as.numeric(YR2011.GE.EST), log10(volume.GE.EST))) + geom_point() + ylab('log10 Trade volume')+ geom_smooth(method=lm, se=TRUE)

