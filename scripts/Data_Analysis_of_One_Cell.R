
# Created by Easton White
# Created on 24-Feb-2017

# This is code to look at one specific cell for one species over time. This helps focus on data analysis without thinking about spatial autocorrelation issues.


# Use fish data from script that Geoff started. I am using data cleaned in Data_Analysis_Geoff script. Basically just combined fish and oil data


# NOTE: Need to subset to after 2000 before we combine data sets (not done here)
# Here I subset data by species, location, year
snow.crab1<-subset(fish, common_name=="Tanner, snow crabs"& eez=="USA (West Coast)" & year>2000 & lat==46.25 & lon==-124.25)

# Create lag variables (did previous year have a spill or not at this location). This is the proper way to create lag variables
snow.crab1$spill.lag1<-as.numeric(c(NA, snow.crab1$spill[-length(snow.crab1$spill)]))
snow.crab1$spill.lag2<-as.numeric(c(NA,snow.crab1$spill.lag1[-length(snow.crab1$spill.lag1)]))

# Plot catch data over time with years of oil spills plotted as well
plot(snow.crab1$year,snow.crab1$sum)
#plot(snow.crab1$year[2:length(snow.crab1$year)],snow.crab1$sum[2:length(snow.crab1$sum)]/snow.crab1$sum[1:(length(snow.crab1$sum)-1)])
abline(v=snow.crab1$year[snow.crab1$spill==TRUE])

# Make variable for percent change in a given year
snow.crab1$percent_change = c(NA,snow.crab1$sum[2:length(snow.crab1$sum)]/snow.crab1$sum[1:(length(snow.crab1$sum)-1)])

# Run models with either sum or percent_change as explanatory variable. Need to use proper error distributions here
m1<-gam(sum~pdo+year+spill, data=snow.crab1,family=Gamma(link=log))
m2<-gam(sum~pdo+year+spill + spill.lag1 + spill.lag2, data=snow.crab1,family=Gamma(link=log))

summary(m1)
summary(m2)

plot(fitted(m1),residuals(m1))
plot(fitted(m2),residuals(m2))
plot(residuals(m1))
plot(residuals(m2))
acf(residuals(m2))
