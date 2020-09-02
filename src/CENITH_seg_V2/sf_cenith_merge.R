#' Mandatory: Cenith Merge Tiles
#'
#' @description Optional: Merges Crown Tiles to a single Layer
#' 
#' 
#' 

#' @param Mandatory if function: crown_tiles - the




cenith_merge <- function(crown_tiles) {
  
  merc <- crown_tiles[[1]]
  for (k in 1:(length(crown_tiles)-1)) {
    cat(" ",sep = "\n")
    cat(paste0("### Cenith merges Crown polygon layer ",as.factor(k)," / ",as.factor(length(crown_tiles)-1)," ###",sep = "\n"))
    cat(" ",sep = "\n")
    merc <- rbind(merc,crown_tiles[[k+1]])}
  cat(" ",sep = "\n")
  cat("### Cenith aggregates Crowns on Intersects ###",sep = "\n")
  cat(" ",sep = "\n")
    lyr <- aggregate(merc,by = c("treeID","height","crownArea","winRadius"))
    return(lyr)
  
}

###example
### load functions
### first load envrmt
#require(ForestTools)
#require(uavRst)
#require(mapview)
#source(file.path(envrmt$path_Cenith,"dev_004_cenith_merge.R"))
###load data 
#crwns <- readRDS(file.path(envrmt$path_exmpl,"segs_exmpl.rds"))
###run Cenith
#merc <-cenith_merge(crwns) 
#plot(merc)

