#' Mandatory: ft_seg - Forest Tools segementation
#'
#' @description Optional: computes a segementation using a treeposLayer
#' 

#' @param Mandatory if function: chm - a rasterLayer with the canopy height model
#' @param Mandatory if function: tp - the treeposLayer
#' @param Mandatory if function: h - minimum height


cenith_seg <- function (chm,tp,h){
  seg <- uavRst::chmseg_FT(chm = chm,
                        treepos = tp,
                        format = "polygons",
                        minTreeAlt = h,
                        verbose = TRUE)
  return(seg)
}

###example
### load functions
### first load envrmt
#require(ForestTools)
#require(uavRst)
#source(file.path(envrmt$path_Cenith,"002_cenith_seg_v1.R"))
###load data 
#echm <- raster::raster(file.path(envrmt$path_exmpl,"chm.tif"))
#etp <- readOGR(file.path(envrmt$path_exmpl,"exp_tp.shp"),"exp_tp")
###run Cenith
#seg <-cenith_seg(chm=echm,tp=etp,h=8) 

#plot(seg)
