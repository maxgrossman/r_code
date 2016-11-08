# code: IstanbulPortStoreFinder.R
# purpose: take google place api results of stores near istanbul ports and make them shps
# comments: hardcoded, yea yea yea....

setwd("place/i/have/files")
require(jsonlite)
require(rgdal)
require(raster)

# get lists of the jsons
porth <- list.files(".","porth_")
porth <- lapply(porth,function(x) fromJSON(x))
portI <- list.files(".","PortOfIstanbul")
portI <- lapply(portI,function(x) fromJSON(x))

# make them spatial polygons
porth <- lapply(porth,
       function(x)
         SpatialPointsDataFrame(
           SpatialPoints(
             cbind(x$results$geometry$location$lng,x$results$geometry$location$lat),
             CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")),
           data=data.frame(x$results$name)))
portI <- lapply(portI,
                function(x)
                  SpatialPointsDataFrame(
                    SpatialPoints(
                      cbind(x$results$geometry$location$lng,x$results$geometry$location$lat),
                      CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")),
                    data=data.frame(x$results$name)
                  ))
# put them in single lists
ports_list <- c(portI,porth)

# merge together, write to file
writeOGR(do.call(bind, ports_list),
         ".","portprox.shops",driver="ESRI Shapefile")

# make ports spdf

i_port <- SpatialPointsDataFrame(
  SpatialPoints(
    cbind(28.97834,41.0228),
    CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")),
  data=data.frame(port="Port of Istanbul"))
h_port <- SpatialPointsDataFrame(
  SpatialPoints(
    cbind(29.013889,41.003333),
    CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")),
  data=data.frame(port="Port of Haydarpasa,"))

writeOGR(i_port,".","portIstanbul",driver="ESRI Shapefile")
writeOGR(h_port,".","portHaydarpasa",driver="ESRI Shapefile")
