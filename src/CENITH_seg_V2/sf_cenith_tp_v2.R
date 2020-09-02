#' Mandatory: tp4v - treepos 4 validation
#'
#' @description Optional: function to change parameters for FT segementation algorithm
#' return the amount of trees to validate. Optional returns the treeposLayer for a segmentation
#' 

#' @param Mandatory if function: chm - a rasterLayer with the canopy height model 
#' @param Mandatory if function: winfun - function for Searchwindow a*b in float values, 
#' predefinition in var is recommended
#' @param Mandatory if function: h - minimum height
#' @param Mandatory if function: res - logical, default=TURE, if "TRUE" the treeposlayer is returned,
#' if "FALSE" the amount of identified Trees is printed (for Validation)


cenith_tp_v2 <- function(chm,a=1,b=1,h=10, res=TRUE) {
  tpos = ForestTools::vwf(chm, 
                             winFun = function(x){x * a + b}, 
                             minHeight = h, 
                             verbose = TRUE)
  if(res==FALSE){
    cat(" ",sep = "\n")
    cat(paste0("### Cenith could identify ",as.factor(nrow(tpos))," Trees ###",sep = "\n"))
    cat(" ",sep = "\n")
  } else {
    cat(" ",sep = "\n")
    cat(paste0("### Cenith computes Treeposlayer with ",as.factor(nrow(tpos))," Trees ###",sep = "\n"))
    cat(" ",sep = "\n")
     return(tpos)}
}

###example
### load functions
### first load envrmt
#require(ForestTools)
#require(uavRst)
#source(file.path(root_folder, file.path(pathdir,"Cenith/dev002_cenith_tp_v2.R")))
###load data 
#chm <- raster::raster(file.path(envrmt$path_exmpl,"chm.tif"))
###run Cenith
#cenith_tp_v2(chm,a=0.08,b=0.1,h=8,res = FALSE) # print only result ncount trees
#tp <- cenith_tp_v2(chm,a=0.08,b=0.1,h=8) # create treeposlayer
#plot(tp)
