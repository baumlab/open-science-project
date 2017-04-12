
# Created by Easton White
# Created on 9-Jan-2017
# Last edited 13-Jan-2017

# Purpose: this code calculates the meters to the nearest coastline given lat and long coordinates. 
# Currently this code is **very very** slow

calculate_meters_to_coast = function(oil_lat,oil_long){
  require(geosphere)
  require(maptools)
  data(wrld_simpl)
  pts <- suppressMessages(SpatialPoints(as.data.frame(cbind(oil_long,oil_lat)), proj4string=CRS(proj4string(wrld_simpl))))
  
  dist <- suppressMessages(geosphere::dist2Line(pts,wrld_simpl))
  return(as.numeric(dist[,1]))
}

