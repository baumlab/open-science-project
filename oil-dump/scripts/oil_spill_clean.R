
# Created by James Robinson
# Created on 17-Jan-2017


# Purpose: this code pulls in some simple noaa incident data and makes summary figures


# pull in noaa incidents data
setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")

# library(scales); library(stringr); theme_set(theme_bw()); library(mapdata); library(maptools)

# oil <- read.table('data/oil-spill-data/noaa-incidents.csv',sep=',',header=T)
# oil<-subset(oil,is.na(oil$lat)==F) # only look at incidents with Lat and Long
# oil <- subset(oil, oil$threat=='Oil') #only choose oil spill incidents
# oil<- subset(oil,is.na(oil$max_ptl_release_gallons)==F) #only look at incidents with information on total number of gallons


# #-----------------------------------STARTING DATE CLEANING------------------------------------------#
# ## convert date to Date format 
# ## need to add 0s to date + months 
# oil$Date<-as.character(oil$open_date)

# ### add year, month, day data
# dates<-ldply(strsplit(oil$Date, '/'))
# oil$day<-dates$V2
# oil$month<-dates$V1
# oil$year<-ifelse(dates$V3<20, paste("20", dates$V3, sep=""), paste('19', dates$V3, sep=''))

# ## add 0s to start of single digit days and months
# oil$month<-ifelse(nchar(oil$month)==1, paste(0, oil$month, sep=""), oil$month)
# oil$day<-ifelse(nchar(oil$day)==1, paste(0, oil$day, sep=""), oil$day)

# oil$Date<-with(oil, paste(year, month, day, sep='-'))

# ### change to date format for plotting
# oil$Date<-as.Date(oil$Date, format="%Y-%m-%d")

# ## remove surplus date columns
# oil$Day<-NULL; oil$day<-NULL; oil$month<-NULL

# ## change year to numeric
# oil$year<-as.numeric(oil$year)

# #-----------------------------------FINISHED DATE CLEANING------------------------------------------#

# neg<-function(x) -x 
# ## subset to west coast
# oil.west<-oil[oil$lat>29 & oil$lat<80 &  oil$lon>neg(190) & oil$lon<neg(110),]


# ## save Rdata file
# save(oil.west, file='data/oil_west_clean.Rdata')

load('data/oil_west_clean.Rdata')

# plot of spill size over time
pdf(file='figures/oil_spills_overtime.pdf', height=7, width=11)
ggplot(oil.west, aes(Date, log10(max_ptl_release_gallons))) + geom_point()
dev.off()

# histogram of spill sizes 
pdf(file='figures/oil_spills_histogram.pdf', height=7, width=11)
ggplot(oil.west, aes((max_ptl_release_gallons))) + geom_histogram() + scale_x_continuous(labels=comma)
dev.off()

hist(oil.west$max_ptl_release_gallons, plot=F, breaks=seq(1, 100000000, 10000))	

length(unique(oil.west$id)[oil.west$max_ptl_release_gallons<1000])


# create simple map of west coast with usa and canada spills - sized by gallons
pdf(file='figures/oil_map_spillsize_WA.pdf', height=7, width=11)
w2hr <- map_data("world2Hires")
WA<-w2hr[w2hr$long< 240 & w2hr$long> 230 & w2hr$lat<49 & w2hr$lat>45.5,]

# create plot with ggplot
oil.west$lon<-oil.west$lon+360
oil.WA<-oil.west[oil.west$lon< 240 & oil.west$lon> 230 & oil.west$lat<49 & oil.west$lat>45.5,]
ggplot() + geom_polygon(data = WA, aes(x=long, y = lat, group = group)) + coord_fixed(1.3) + geom_point(data=oil.WA,aes(x=lon,y=lat,size=0.1*log(max_ptl_release_gallons)),color='red')
dev.off()


