#' Mandatory: Cenith V2
#'
#' @description Optional: Segmentation Alogrithm for a elevation modell 
#' @name Mandatory Cenith  
#' @export Mandatory Cenith

#' @param Mandatory if function: chm - a canopy height model or aother raster with elevation values
#' @param Mandatory if function: winfun - function for Searchwindow in float values a*b, 
#' predefinition in var is recommended
#' @param Mandatory if function: h - minimum height to detect trees
#' @param Mandatory if function: optional f - numeric, must be odd, chm fxf filter,
#' uses a spatial mean filter
#' @param Mandatory if function: optional ntx - the n count of desired tiles in x axis
#' @param Mandatory if function: optional nty - the n count of desired tiles in y axis
#' @param Mandatory if function: optional buf - buffer in cells for each tile

#note V2.0: added tieling and buffering options.

Cenith <- function(chm,a=1,b=1,h=10,f=1,ntx=0,nty=0,buf=0) {
  cat(" ",sep = "\n")
  cat("### Cenith starts TreeSegmentation ###")
  cat(" ",sep = "\n")
  if (f>1){
    cat(" ",sep = "\n")
    chm <- raster::focal(chm,w=matrix(1/(f*f),nrow=f,ncol=f))
    cat(paste0("### Cenith computes chm with mean filter ",as.factor(f)," ###",sep = "\n"))
    cat(" ",sep = "\n")}
    else {chm <- chm} # or what is to do nothing ?
  
  
  ### FILTER PATH DONE ###
  
  if (ntx>0){
    cat(" ",sep = "\n")
    tp <- cenith_tp_v2(chm,a,b,h)
    cat("### Cenith computes Treepos Layer for the Area ###",sep = "\n")
    cat("### This could take a while on big data use tiles and buffers ###",sep = "\n")
    
    cat(" ",sep = "\n")
    tiles <- cenith_tiles(chm,ntx=ntx,nty=nty,buf=buf)
    cat("### Cenith computes Tiles with Buffers for the Area ###",sep = "\n")
    plot(tiles)
    
    ### TREPOS SINGLE DONE ###
    
    
    treeseg <-cenith_seg_tiles(x=chm,tiles=tiles,tp=tp,h=h)
   
    ### TREESEG DONE ###
    
    merged <- cenith_merge(treeseg)
    
    cat(" ",sep = "\n")

    #cat(" ",sep = "\n")
    cat("#######################################",sep = "\n")
    cat("### Cenith identified ",length(merged)," Objects ###") # doesnt work to spell amount of polygons
    cat(" ",sep = "\n")
    cat("#######################################",sep = "\n")
    cat(" ",sep = "\n")
    cat("### Cenith finished ###")
    return(merged)
    
    ### to return several steps ###
    #return(list(tp=tp,polygon=polygon,tiles=tiles,treeseg=treeseg,merged=merged))
    
    #### ELSE path DONE ###
    
  } else {
  tp <- cenith_tp_v2(chm,a,b,h)
  cat("### Cenith computes Treepos Layer ###",sep = "\n")
  polygon <- cenith_seg(chm,tp,h)
  cat("### Cenith computes Tree polygon Layer ###",sep = "\n")
  cat(" ",sep = "\n")
  cat("#######################################",sep = "\n")
  cat("### Cenith returns results in lists ###",sep = "\n")
  cat("### poly = polygon layer ###",sep = "\n")
  cat("### tp =   treepos layer ###",sep = "\n")
  cat("#######################################",sep = "\n")
  cat(" ",sep = "\n")
  cat       ("################################",sep="\n")
  cat       ("   CC EEEE N   N  I TTTTT H   H ",sep="\n")
  cat       ("  C   E    NN  N  I   T   H   H ",sep="\n")
  cat       (" C    EE   N N N  I   T   HHHHH ",sep="\n")
  cat       ("  C   E    N  NN  I   T   H   H ",sep="\n")
  cat       ("   CC EEEE N   N  I   T   H   H ",sep="\n")
  cat       ("                            V2  ",sep="\n")
  cat       ("Finished segmentation           ",sep="\n")
  return(list(tp=tp, polygon=polygon))}
}
  

  
#'@examples
#'\dontrun


#'### first load envrmt
#'require(ForestTools)
#'require(uavRst)
#'require(mapview)
#'require(TileManager)
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/fs_cenith_tiles.R")))
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/fs_cenith_tp_v2.R")))
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/fs_cenith_seg_tiles.R")))
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/fs_cenith_merge.R")))
#'source(file.path(root_folder, file.path(pathdir,"Cenith_V2/fs_cenith_seg_v1.R")))
#'##load data 
#'chm <- raster::raster(file.path(root_folder, file.path(pathdir,"Cenith_V2/exmpl_chm.tif")))

#'##run Cenith
#'segm <- Cenith(chm=chm,a=0.05,b=0.6,h=8,f=3,ntx=2,nty = 2,buf = 30) 
#'plot(segm)
#'mapview(chm)+segm
#'## test for tiles=0
#'seg0 <- Cenith(chm=chm,a =0.05, b= 0.6,h=8,f=1,ntx=0,nty = 0,buf = 30)
#'plot(seg0$polygon)
#'##test for tiles default(1 shuld be same as "seg0")
#'segnull <- Cenith(chm=chm,a= 0.05, b=0.6,h=8)
#'plot(segnull$polygon)

#plot(seg0$tp)
