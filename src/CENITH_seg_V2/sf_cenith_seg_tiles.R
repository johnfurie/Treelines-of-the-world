#' Mandatory: Cenith Segementation for Tiles
#'
#' @description Optional:Computes TreeCrowns for Tiles
#' 
#' 
#' 

#' @param Mandatory if function: chm - a chm rasterlayer
#' @param Mandatory if function: tiles - a tileShema class object, created by "Cenith_tiles" function
#' @param Mandatory if function: tp - a treeposlayer
#' @param Mandatory if function: h - height



cenith_seg_tiles <- function(x=chm,tiles,tp,h) {
  
  lapply(seq(1:length(tiles$tilePolygons)),function (i){
    cat(" ",sep = "\n")
    cat(paste0("### Cenith computes Crowns for Tile ",as.factor(i)," / ",length(tiles$tilePolygons)," ###",sep = "\n"))
  tmpcrop <- crop(x,tiles$buffPolygons[i,])
  crownlyr <- seg <- uavRst::chmseg_FT(tmpcrop,
                                       treepos = tp,
                                       format = "polygons",
                                       minTreeAlt = h,
                                       verbose = TRUE)
  crs(crownlyr) <- crs(x)
  ids <- na.omit(over(tp,crownlyr))
  ids$rownames <- as.numeric(row.names(ids))
  crownlyr@data$treeID <- ids$rownames
  crownlyr <- crop(crownlyr,tiles$nbuffPolygons[i,])
  
return(crownlyr)})

}

###example
### load functions
### first load envrmt
#require(ForestTools)
#require(uavRst)
###load data 
#tilshem <-readRDS(file.path(envrmt$path_exmpl,"tilshem.rds"))
#chm <- raster::raster(file.path(envrmt$path_exmpl,"chm.tif"))
#tp <- readRDS(file.path(envrmt$path_exmpl,"tp_exmpl.rds"))
  
###run Cenith
#segs <- cenith_seg_tiles(x=chm,tiles=tilshem,tp=tp,h=8) 
#plot(segs[[1]])
