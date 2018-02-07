setwd("~/Documents/git_repos/open-science-project")
rm(list=ls())
library(ggplot2); library(dplyr); library(lme4); library(MuMIn); library(visreg)
theme_set(theme_bw())
source('scripts/functions/scaling_function.R')
source('scripts/functions/plot-cor-functions.R')

trade <- read.csv("data/clean/trade_top100_fishbase_range.csv") 
trade$X.1<-NULL; trade$X<-NULL; trade$DietTroph<-NULL
## check collinearity
temp<-trade %>% select(FoodTroph, Length, Vulnerability, AOO, EOO)
pairs(na.omit(temp), upper.panel=panel.cor, diag.panel=panel.hist, lower.panel=panel.smooth2)

# plot observed relationships so we expect model predictions
# trade %>% group_by(Genus, FoodTroph) %>% summarise(sum=sum(export)) %>%
ggplot(trade, aes(FoodTroph, N)) + geom_point() + labs(y="n. species")

# trade %>% group_by(Genus, Vulnerability) %>% summarise(sum=sum(export)) %>%
ggplot(trade, aes(Vulnerability, N)) + geom_point() + labs(y="n. species")



# trade.all <- trade %>% group_by(Genus, Vulnerability, FoodTroph) %>% summarise(sum=sum(export))
scaled<-scaler(trade, ID=c('Taxa', 'Genus', 'N')); dim(scaled)


## Model m1 - n countries exporting each species
m1<-glmer(N ~  FoodTroph + 
					 Length + 
					Vulnerability + 
					AOO +
					EOO +
					(1 | Genus) ,
					# (1 | Exporter.Country), 
					scaled, family='poisson')
summary(m1)
# P(N) increases with trophic level. But model is terrible (R2 < 10%)
# What are we missing?
r.squaredGLMM(m1)
par(mfrow=c(2,2)); visreg(m1)

