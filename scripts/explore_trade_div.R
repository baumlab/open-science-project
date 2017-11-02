setwd("~/Documents/git_repos/open-science-project")
library(dplyr); library(ggplot2); library(tidyr); library(lme4)

div<-read.csv('data/clean/trade_top100.csv')


lm1<-glm(export ~ FoodTroph + EOO, div, family=binomial)
summary(lm1)

library(visreg)
par(mfrow=c(1,2))
visreg(lm1, scale='response')


