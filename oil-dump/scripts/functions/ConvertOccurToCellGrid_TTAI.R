
##################
#
#
## Convert occurence lat-lon to 0.5x0.5 cell grid
#
#   2016/05/31
#   
#
##################



# rm(list=ls())
library(plyr)

## You can read in the code below to generate the cell sequence data
Cell<-c(1:(720*360))  ## CellSequence number from 1 to (#lonCells X # latCells); Read from left to right across lon then lat
lon<-rep(seq(-179.75,179.75,0.5),times=360) # lon coordinates for each cell
lat<-rep(seq(89.75,-89.75,-0.5),each=720)   # lon coordinates for each cell

ll<-as.data.frame(cbind(Cell,lon,lat))    # lat-lon cell sequence reference dataframe; coordinates are located in centre of cell


CELLMATCH<-function(x){   ## Just enter the data frame into CELLMATCH(DATA)
  #Out.Dat<-data.frame(Cell=vector(length=0), Catch=vector(length=0), Repeat=vector(length=0))

  ddply(x,names(x),.progress="text",function(y){   ## (species dataset, the columns the function will be applied to...I usually just use names cause I want to maintain all the columns, function)
    lon<-y$lon   ## lon
    lat<-y$lat   ## lat
    DataRow<-y$row  ## Include this to double check data matching
    lonGrid<-c(min(ll$lon[which(ll$lon>=lon)]),      ## The two lon values for which the species lon falls between
               max(ll$lon[which(ll$lon<=lon)]))
    latGrid<-c(min(ll$lat[which(ll$lat>=lat)]),
               max(ll$lat[which(ll$lat<=lat)]))
    lonIndex<-unique(lonGrid[which(abs(lonGrid-lon)==min(abs(lonGrid-lon)))])    ## The lon for which the species is closest to 
    latIndex<-unique(latGrid[which(abs(latGrid-lat)==min(abs(latGrid-lat)))])
    
    Celllon<-which(ll$lon %in% lonIndex)     ## The cells that coresponds to that lon
    Celllat<-which(ll$lat %in% latIndex)
    
    CellIndex<-Celllon[Celllon %in% Celllat]  ## The cell(s) where the Celllon and Celllat overlap
    if(length(CellIndex)==1){
      data.frame(CellRef = CellIndex, lonCell = ll$lon[CellIndex], latCell = ll$lat[CellIndex], 
                 DataRowID = DataRow)   ## Output the lat-lon Cell number, lon, lat in a new column; DataRowID reference
    } else {
      if(length(CellIndex)>1){
        ## Selecting which borders to choose as a 'tie-breaker': Right = min(lon), Left = max(lon), Top = min(lat), Bottom = max(lat)
        sub.ll<-ll[CellIndex,]
        
        sub.ll<-sub.ll[which(sub.ll$lon==min(sub.ll$lon)),] ## Change these to select which borders break the tie
        sub.ll<-sub.ll[which(sub.ll$lat==min(sub.ll$lat)),] ## Same
        
        data.frame(CellRef = sub.ll$Cell, lonCell = sub.ll$lon, latCell = sub.ll$lat,
                   DataRowID = DataRow)   ## Output the Cell number in a new column
        
      } else {
        ## If there are no cells referenced output zeros
        data.frame(CellRef = vector(length=0), lonCell = vector(length=0), latCell = vector(length=0),
                   DataRowID = DataRow)
      }
    }
  })
}













