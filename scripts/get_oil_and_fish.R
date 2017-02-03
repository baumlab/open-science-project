setwd('open-science-project')

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
