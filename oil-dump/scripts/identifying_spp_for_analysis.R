setwd('open-science-project')

library(readr)
library(dplyr)
library(ggplot2)
library(beepr)

sea <- 
  read_csv('data/sea-around-us/Jamie_Shellfish_NA.csv')

# What shellfish are in the SAU data?
distinct(sea, taxon_name, common_name) %>% as.data.frame


filter(sea, year == '2013') %>% 
  ggplot(data = .) + 
    geom_point(mapping = aes(x = lon, y = lat, colour = sum), shape = 15) +
    theme_void() + 
    borders('world', colour = NA, fill = 'darkgrey') +  
    scale_colour_gradientn(colours = (rainbow(7, start = 0))) + 
    coord_quickmap(xlim = c(-200, -110), ylim = c(35, 65)) + 
    facet_wrap(~ common_name)
beep()

