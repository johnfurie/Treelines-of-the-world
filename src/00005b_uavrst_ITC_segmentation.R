################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel","uavRst") 

# define src folder
pathdir = "repo/src/"

#set root folder for uniPC or laptop                                                        
root_folder = alternativeEnvi(root_folder = "E:/Github/Treelines-of-the-world",                    
                              alt_env_id = "COMPUTERNAME",                                  
                              alt_env_value = "PCRZP",                                      
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           
#source environment script                                                                  
source(file.path(root_folder, paste0(pathdir,"01b_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################



# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))


vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

# ITC

# tree 33
itct <- chmseg_ITC(
  chm = chm_tree,
  EPSG = 31254,
  movingWin = 36,
  TRESHSeed = 0.45,
  TRESHCrown = 0.55,
  minTreeAlt = 2,
  maxCrownArea = 10000)

# plot with maptoo
plot(chm_tree)
plot(vp_tree, add = TRUE)
plot(itct, add = TRUE)




# shrub
itcs <- chmseg_ITC(
  chm = chm_shrub,
  EPSG = 31254,
  movingWin = 11,
  TRESHSeed = 0.45,
  TRESHCrown = 0.55,
  minTreeAlt = 2,
  maxCrownArea = 10000)

# plot with maptoo
plot(chm_shrub)
plot(vp_shrub, add = TRUE)
plot(itcs, add = TRUE)




# tree shrub
itcts <- chmseg_ITC(
  chm = chm_tree_shrub,
  EPSG = 31254,
  movingWin = 29,
  TRESHSeed = 0.45,
  TRESHCrown = 0.55,
  minTreeAlt = 2,
  maxCrownArea = 10000)

# plot with maptoo
plot(chm_tree_shrub)
plot(vp_tree_shrub, add = TRUE)
plot(itcts, add = TRUE)

#view PROBLEM
mapview(itc)+vp_tree +chm_tree