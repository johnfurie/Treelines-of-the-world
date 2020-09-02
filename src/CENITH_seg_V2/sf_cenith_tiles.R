#' Mandatory: Cenith Tiles
#'
#' @description Optional: creates desired x*x Tiles with Buffer for a raster object, retuns a TileSheme Object.
#' 
#' 
#' 

#' @param Mandatory if function: rst - a raster
#' @param Mandatory if function: ntx - desired count of tiles in x axis
#' @param Mandatory if function: nty - desired count of tiles in y axis
#' @param Mandatory if function: buf - the buffersize in cell
#' @param Mandatory if function: rnd - logical, the values are rounded, default=TRUE

cenith_tiles <- function(rst,ntx,nty,buf,rnd=TRUE){
  if (rnd==TRUE){
  ncelx <- ncol(rst) / ntx 
  ncely <- nrow(rst) / nty 
  
  xlen <- round(ncelx) 
  ylen <- round(ncely) 
  
  tiles  <- TileManager::TileScheme(rst, dimByCell = c(xlen, ylen), buffer = buf, bufferspill = FALSE)
  plot(tiles)
  cat(paste0("### Cenith computes ",length(tiles$tilePolygons)," Tiles ###",sep = "\n"))
  return(tiles)
  }else{
    ncelx <- ncol(rst) / ntx 
    ncely <- nrow(rst) / nty 
    
    xlen <- (ncelx) 
    ylen <- (ncely) 
    
    tiles  <- TileManager::TileScheme(rst, dimByCell = c(xlen, ylen), buffer = buf, bufferspill = FALSE)
    plot(tiles)
    cat(paste0("### Cenith computes ",length(tiles$tilePolygons)," Tiles ###",sep = "\n"))
    cat("### Cenith Values are not Rounded!, check for full cover! ###", sep="\n")
    return(tiles)}
}
  
###example
### load functions
### first load envrmt
#require(TileManager)
#source(file.path(root_folder, file.path(pathdir,"Cenith/dev001_cenith_tiles.R")))
###load data 
#chm <- raster::raster(file.path(envrmt$path_exmpl,"chm.tif"))
###run Cenith
#tiles <- cenith_tiles(rst=chm,4,4,20,rnd = TRUE)


