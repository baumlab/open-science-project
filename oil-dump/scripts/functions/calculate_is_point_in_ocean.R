

# Created by Easton White
# Created on 9-Jan-2017
# Last edited 13-Jan-2017

# Purpose: this code runs a function which takes lat and long coordinates to determine if a particular point or vector of points occurs over the ocean (as opposed to land)

calculate_is_point_in_ocean = function(oil_lat,oil_long){
  library(maptools)
  data(wrld_simpl)
  pts <- suppressMessages(SpatialPoints(as.data.frame(cbind(oil_long,oil_lat)), proj4string=CRS(proj4string(wrld_simpl))))
  ## Find which points fall over the ocean by comparing them to world map
  ii <- suppressMessages(is.na(over(pts, wrld_simpl)$FIPS))
  return(ii)
}