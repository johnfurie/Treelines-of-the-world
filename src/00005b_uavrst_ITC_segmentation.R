################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel") 

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



# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_treev2         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_tv2.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

# chm smoothing
chm_tree <- CHMsmoothing(chm_tree, filter = "Gaussian", ws = 19)
chm_shrub <- CHMsmoothing(chm_shrub, filter = "Gaussian", ws = 19)
chm_tree_shrub <- CHMsmoothing(chm_tree_shrub, filter = "Gaussian", ws = 19)


# ITC
#
# tree
itct <- chmseg_ITC(
  chm = chm_tree,
  EPSG = 31254,
  movingWin = 31,
  TRESHSeed = 0.45,
  TRESHCrown = 0.55,
  minTreeAlt = 2,
  maxCrownArea = 10000)

# plot with maptoo
plot(chm_tree)
plot(vp_tree,las=1, bty="l", col="red", pch=19, add = TRUE)
plot(itct, add = TRUE)

plot(chm_tree)
plot(vp_treev2, add = TRUE)
plot(itct, add = TRUE)




# shrub
itcs <- chmseg_ITC(
  chm = chm_shrub,
  EPSG = 31254,
  movingWin = 11,
  TRESHSeed = 0.45,
  TRESHCrown = 0.55,
  minTreeAlt = 0.4,
  maxCrownArea = 10000)


# plot with maptoo
plot(chm_shrub)
plot(vp_shrub,las=1, bty="l", col="red", pch=19, add = TRUE)
plot(itcs, add = TRUE)

plotRGB(rgb_shrub)


# tree shrub
itcts <- chmseg_ITC(
  chm = chm_tree_shrub,
  EPSG = 31254,
  movingWin = 33,
  TRESHSeed = 0.45,
  TRESHCrown = 0.55,
  minTreeAlt = .8,
  maxCrownArea = 10000)


# plot with maptoo
plot(chm_tree_shrub)
plot(vp_tree_shrub,las=1, bty="l", col="red", pch=19, add = TRUE)
plot(itcts, add = TRUE)

stopCluster(cl)

#write data
writeOGR(itct, file.path(envrmt$path_002_processed, "itc_seg_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(itcs, file.path(envrmt$path_002_processed, "itc_seg_s.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(itcts, file.path(envrmt$path_002_processed, "itc_seg_ts.shp"),layer="testShape",driver="ESRI Shapefile")
