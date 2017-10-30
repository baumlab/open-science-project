setwd('open-science-project/scripts')

library(rgdal)
library(dplyr)
library(readr)
library(beepr)

reefs <- readOGR("../data/DataPack-14_001_WCMC008_CoralReef2010_v1_3/01_Data", "14_001_WCMC008_CoralReef2010_v1_3")
beep()

reef_df <- as_data_frame(reefs@data)

total_areas <- 
  reef_df %>% 
    group_by(SOVEREIGN, COUNTRY) %>% 
    summarise(total_area = sum(AREA_KM2)) %>% 
    ungroup() %>% 
    mutate(units = 'km^2')

write_csv(total_areas, '../data/reef_area_by_country.csv')