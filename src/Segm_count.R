## function to count polygons per algorithm and count points inside polygons

################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel", "uavRst","rLiDAR") 

# define src folder
pathdir = "repo/src/"

#set root folder for uniPC or laptop                                                        
root_folder = alternativeEnvi(root_folder = "C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world",                    
                              alt_env_id = "COMPUTERNAME",                                  
                              alt_env_value = "PCRZP",                                      
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           
#source environment script                                                                  
source(file.path(root_folder, paste0(pathdir,"01b_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################


#################### function for segment number and outside points and plot; use function for individual check, use function below for automated table making ############################################
## NOTE: function has not error handling ###

SegCount <- function(polygon, points, plot){
  
  #load needed packages
  require(raster)
  require(sp)
  require(rgdal)
  
  
  polygon <- rgdal::readOGR(polygon)
  #polygon segments have no CRS therefore assign CRS from points
  polygon@proj4string@projargs <- as.character(crs(points))
  
  #count number of polygon segments and validation points
  numSeg <- length(polygon$treeID)
  numPts <- length(points$treeID)
  
  #checks how many points per polygon
  x <-  over(points, polygon)
  tab <- as.data.frame(table(x$treeID))
  colnames(tab) <- c("TreeSegm", "ValPoints")
  
  #calculate outsiders by subtracting number points in polyons of from number ob val points
  outsiders <- numPts - sum(tab$ValPoints) 
  
  #plot
  if(plot == TRUE){
    plot(polygon)
    plot(points, add=T)
  }
  
  #output
  print(paste0("Number of segments:", numSeg))
  print(paste0("Points outside of segments:", outsiders))
  print("Points per segment:")
  return(tab)
}

##############################################################

SegCountTab <- function(polygon, points){
  
  #load needed packages
  require(raster)
  require(sp)
  require(rgdal)
  
  #get alogrithm name
  if(length(grep("dalponte",polygon)) == 1){
    Algorithm <- "Dalponte"
  } else if(length(grep("rLidar",polygon) == 1)){
    Algorithm <- "rLiDAR"
  } else if(length(grep("silva",polygon) == 1)){
    Algorithm <- "Silva"
  } else if(length(grep("foresttools",polygon) == 1)){
    Algorithm <- "ForestTools"
  } else if(length(grep("cenith",polygon) == 1)){
    Algorithm <- "CENITH"
  }
  
  #read polygon
  polygon <- rgdal::readOGR(polygon)
  #polygon segments have no CRS therefore assign CRS from points
  polygon@proj4string@projargs <- as.character(crs(points))
  
  #count number of polygon segments and validation points
  
  
  TreeSegm <- length(polygon[,1])
  valPoints <- length(points$treeID)
  
  #checks how many points per polygon
  x <-  over(points, polygon)
  tab <- as.data.frame(table(x[,1]))
  colnames(tab) <- c("TreeSegm", "ValPoints")
  
  inside <-  sum(tab$ValPoints)
  #calculate outsiders by subtracting number points in polyons of from number ob val points
  outside <- valPoints - sum(tab$ValPoints) 
  
  df <- as.data.frame(cbind(Algorithm, TreeSegm, inside, outside, valPoints))
  
  return(df)
}
##############################################################################################################

##load validation points

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
vp_tree_shrub_t   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_t.shp"))
vp_tree_shrub_s   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_s.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

# Dalponte

dal_shrub <- list.files(paste0(file.path(envrmt$path_002_processed),"/dalponte/"), pattern = "*dal_s.shp", full.names = T)
dal_tree <- list.files(paste0(file.path(envrmt$path_002_processed),"/dalponte/"), pattern = "*dal_t.shp", full.names = T)
dal_ts <- list.files(paste0(file.path(envrmt$path_002_processed),"/dalponte/"), pattern = "*dal_ts.shp", full.names = T)
dal_ts_s <- list.files(paste0(file.path(envrmt$path_002_processed),"/dalponte/"), pattern = "*dal_ts_s.shp", full.names = T)
dal_ts_t <- list.files(paste0(file.path(envrmt$path_002_processed),"/dalponte/"), pattern = "*dal_ts_t.shp", full.names = T)

# Silva

sil_shrub <- list.files(paste0(file.path(envrmt$path_002_processed),"/silva/"), pattern = "*sil_s.shp", full.names = T)
sil_tree <- list.files(paste0(file.path(envrmt$path_002_processed),"/silva/"), pattern = "*sil_t.shp", full.names = T)
sil_ts <- list.files(paste0(file.path(envrmt$path_002_processed),"/silva/"), pattern = "*sil_ts.shp", full.names = T)
sil_ts_s <- list.files(paste0(file.path(envrmt$path_002_processed),"/silva/"), pattern = "*sil_ts_s.shp", full.names = T)
sil_ts_t <- list.files(paste0(file.path(envrmt$path_002_processed),"/silva/"), pattern = "*sil_ts_t.shp", full.names = T)

# rLiDAR

rl_shrub <- list.files(paste0(file.path(envrmt$path_002_processed),"/rLidar/"), pattern = "*seg_s.shp", full.names = T)
rl_tree <- list.files(paste0(file.path(envrmt$path_002_processed),"/rLidar/"), pattern = "*seg_t.shp", full.names = T)
rl_ts <- list.files(paste0(file.path(envrmt$path_002_processed),"/rLidar/"), pattern = "*_ts.shp", full.names = T)
rl_ts_s <- list.files(paste0(file.path(envrmt$path_002_processed),"/rLidar/"), pattern = "*_ts_s.shp", full.names = T)
rl_ts_t <- list.files(paste0(file.path(envrmt$path_002_processed),"/rLidar/"), pattern = "*_ts_t.shp", full.names = T)

# Forest Tools

ft_shrub <- list.files(paste0(file.path(envrmt$path_002_processed),"/foresttools/"), pattern = "*seg_s.shp", full.names = T)
ft_tree <- list.files(paste0(file.path(envrmt$path_002_processed),"/foresttools/"), pattern = "*seg_t.shp", full.names = T)
ft_ts <- list.files(paste0(file.path(envrmt$path_002_processed),"/foresttools/"), pattern = "*_ts.shp", full.names = T)
ft_ts_s <- list.files(paste0(file.path(envrmt$path_002_processed),"/foresttools/"), pattern = "*_ts_s.shp", full.names = T)
ft_ts_t <- list.files(paste0(file.path(envrmt$path_002_processed),"/foresttools/"), pattern = "*_ts_t.shp", full.names = T)

# CENITH

#cen_shrub <- list.files(paste0(file.path(envrmt$path_002_processed),"/cenith_seg/"), pattern = "*_s.shp", full.names = T)
#cen_tree <- list.files(paste0(file.path(envrmt$path_002_processed),"/cenith_seg/"), pattern = "*_t.shp", full.names = T)
#cen_ts <- list.files(paste0(file.path(envrmt$path_002_processed),"/cenith_seg/"), pattern = "*_ts.shp", full.names = T)
#cen_ts_s <- list.files(paste0(file.path(envrmt$path_002_processed),"/cenith_seg/"), pattern = "*_ts_s.shp", full.names = T)
#cen_ts_t <- list.files(paste0(file.path(envrmt$path_002_processed),"/cenith_seg/"), pattern = "*_ts_t.shp", full.names = T)

### create list depending on vegetation

shrub_list <- list(dal_shrub, sil_shrub, rl_shrub, ft_shrub)
tree_list <- list(dal_tree, sil_tree, rl_tree, ft_tree)
ts_list <- list(dal_ts, sil_ts, rl_ts, ft_ts)
ts_s_list <- list(dal_ts_s, sil_ts_s, rl_ts_s, ft_ts_s)
ts_t_list <- list(dal_ts_t, sil_ts_t, rl_ts_t, ft_ts_t)

### apply SegCountTab to all

shrub_out <- do.call(rbind,lapply(shrub_list, FUN = SegCountTab, points=vp_shrub))
tree_out <- do.call(rbind,lapply(tree_list, SegCountTab, points=vp_tree))
ts_out <- do.call(rbind,lapply(ts_list, SegCountTab, points=vp_tree_shrub))
ts_s_out <- do.call(rbind,lapply(ts_s_list, SegCountTab, points=vp_tree_shrub_s))
ts_t_out <- do.call(rbind, lapply(ts_t_list, SegCountTab, points=vp_tree_shrub_t))

write.table(shrub_out, file.path(envrmt$path_002_processed,"shrub_final.csv"))
write.table(tree_out, file.path(envrmt$path_002_processed,"tree_final.csv"))
write.table(ts_out, file.path(envrmt$path_002_processed,"tree_shrub_final.csv"))
write.table(ts_s_out, file.path(envrmt$path_002_processed,"tree_shrub_s_final.csv"))
write.table(ts_t_out, file.path(envrmt$path_002_processed,"tree_shrub_t_final.csv"))
