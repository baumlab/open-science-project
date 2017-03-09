
# Created by Easton White
# Created on 7-Mar-2017


# Create unique site codes for each lat/long combination. There is surely a faster way to do this

create_site_code = function(data){
  all_locations=expand.grid(data$lat,data$lon)
  all_locations_unique =unique(all_locations)
  data$site_code=NULL
  for (q in 1:nrow(data)){
    data$site_code[q] = which(all_locations_unique$Var1==data$lat[q] & all_locations_unique$Var2==data$lon[q])
  }
return(data)
}