setwd('open-science-project')
setwd('/Users/jpwrobinson/Documents/git_repos/open-science-project')


library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

sea <- read_csv('data/sea-around-us/Jamie_Shellfish_NA.csv')

oil <- 
  read_csv('../data/incidents.csv') %>% 
  filter(threat == 'Oil') %>% 
  mutate(year = year(as.Date(open_date)))

west_oil <- 
  oil %>% 
  filter(lon < (-110), lon > (-190))

combined <- full_join(sea, west_oil, by = 'year') %>% 
  mutate(lat_diff = abs(lat.x - lat.y), lon_diff = abs(lon.x - lon.y)) %>% 
  filter(lat_diff <= 0.25 & lon_diff <= 0.25)

# Just out of interest what does yield ~ spill size look like?
ggplot(data = combined, aes(x = max_ptl_release_gallons, y = sum)) + 
  geom_line() + 
  facet_wrap(~ common_name)



### James alternative merge method based on assigning oil lat-lon a grid cell ref

source('scripts/functions/ConvertOccurToCellGrid_TTAI.R')  # function from Travis Tai (UBC)
load('data/SaU_landings_clean.Rdata') ## cleaned landings
load('data/oil_west_clean.Rdata') # cleaned oil

## change oil lon to negative format
oil.west$row<-1:nrow(oil.west)  
## append cell IDs for lat-lon that match to fish data
oil.west<-CELLMATCH(oil.west)

## now need to aggregate oil spills within cells in the same year. 
oil<-aggregate(max_ptl_release_gallons ~ lat + lon + year + lonCell + latCell, oil.west, sum)
oil$ID<-with(oil, paste(latCell, lonCell, year, sep='.'))

fish$ID<-with(fish, paste(lat, lon, year, sep='.'))
## add oil spill to fish cell based on year. Only considering 1 cell per spill per year.

## numeric: spill size
fish$spill.size<-oil$max_ptl_release_gallons[match(fish$ID, oil$ID)]
## logical: did spill occur in same year?
fish$spill<-ifelse(is.na(fish$spill.size), 'FALSE', 'TRUE')



dim(fish[fish$spill=='TRUE',])

