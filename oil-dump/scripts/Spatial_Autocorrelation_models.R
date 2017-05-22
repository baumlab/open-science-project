# Created by Easton White
# Created on 24-Feb-2017

# This is code to examine some autocorrelation issues, mostly drawn from Zuur et al. 2009 book "Mixed Effects Models..."

# Use fish data from script that Geoff started. I am using data cleaned in Data_Analysis_Geoff script. Basically just combined fish and oil data


# Data set to use landings_clean

geoduck<-subset(fish, common_name=="Pacific geoduck"& eez=="USA (West Coast)" & year>2000)
plot(geoduck$year,geoduck$sum)
abline(v=geoduck$year[geoduck$spill==TRUE])

gam.out.geoduck<-gam(sum~pdo+year+spill +lat+lon, data=geoduck)



# Make each lat-lon combo a different study site. Then we can use random effects to account for this like we did at Cocos (this would account for temporal autocorrelation)
table(geoduck$lat,geoduck$lon)

all_locations=expand.grid(geoduck$lat,geoduck$lon)
all_locations_unique =unique(all_locations)

geoduck$site_code=NULL
for (q in 1:nrow(geoduck)){
  geoduck$site_code[q] = which(all_locations_unique$Var1==geoduck$lat[q] & all_locations_unique$Var2==geoduck$lon[q])
}

library(MASS)
library(glmmADMB)

geoduck$site_code=as.factor(geoduck$site_code)
model = glmmadmb(formula=sum~pdo+year+spill+(1|site_code),data=geoduck,family='Gamma',extra.args="-ndi 30000",zeroInflation=FALSE)

############################

# Trying to include spatial autocorrelation in models here

# pg 171 of Zuur
f <- formula(sum ~ pdo + s(year) + spill)
gam.out.crab<-gamm(clams$sum ~ clams$pdo + s(clams$year) + clams$spill, data=crabs)
gam.out.crab1<-gamm(clams$sum ~ clams$pdo + s(clams$year) + clams$spill,method='REML' ,data=crabs,correlation=corAR1(form=~lat))

SUM=clams$sum
YEAR=clams$year
SPILL=clams$spill
PDO=clams$pdo
LAT=clams$lat 
f <- formula(SUM ~ PDO + s(YEAR) + SPILL)
gamm(f,method='REML',cor=corSpher(form=~ jitter(LAT),nugget=TRUE))
     