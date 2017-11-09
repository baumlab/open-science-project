# Created by Jamie McDevitt-Irwin
# Created on 9-November-2017


# Purpose: this code explores the obis range size data for the top 100 species

# setwd("~/Desktop/Research/open-science-project")
# setwd("~/Documents/git-jpwrobinson/open-science-project")
# setwd("~/Documents/git_repos/open-science-project")

setwd("~/Documents/git_repos/open-science-project")
library("ggplot2"); library(dplyr)
theme_set(theme_bw())
# clear my environment
rm(list=ls())

trade100_fishbase_eoo <- read.csv("data/clean/trade_top100_fishbase_eoo.csv") # "trade.obis"
ls()
head(trade100_fishbase_eoo)
dim(trade100_fishbase_eoo) # 4500, 16
#####################################################


#####################################################
# Which species have EOO as 0?  
eoo_0 = trade100_fishbase_eoo %>% filter(EOO== "0")
eoo_0$Taxa # only Gobiodon atrangulatus


# Why does it have a range size of 0? Only one lat/long in OBIS?
obis<-read.csv(file='data/raw/species-preds/OBIS_dist_species.csv')
head(obis)
# filter Gobiodon atrangulatus
obis_g.atrangulatus = obis %>% filter(scientificName== "Gobiodon atrangulatus")
obis_g.atrangulatus # only has two datapoints, so this makes its range a zero (should we get rid of it?)
#####################################################


#####################################################
# How many species have range size data? 
dim(trade100_fishbase_eoo)
trade100_fishbase_eoo$EOO
eoo_NA = trade100_fishbase_eoo %>% filter(EOO== NA)
eoo_NA

eoo_NA <- trade100_fishbase_eoo %>% # filter out all the NA's so then you can count the unique Taxa
  filter(!is.na(EOO))

x <- unique(eoo_NA$Taxa)
x # 74 species have EOO values 
#####################################################