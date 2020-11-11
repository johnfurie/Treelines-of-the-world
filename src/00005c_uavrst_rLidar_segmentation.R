################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel", "uavRst","maptools") 

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

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
vp_tree_shrub_t   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_t.shp"))
vp_tree_shrub_s   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_s.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

tpos_ts       <- raster::stack(file.path(envrmt$path_002_processed, "ft_tpos_h_ts.tif"))
tpos_ts_t       <- raster::stack(file.path(envrmt$path_002_processed, "ft_tpos_h_ts_t.tif"))
tpos_ts_s       <- raster::stack(file.path(envrmt$path_002_processed, "ft_tpos_h_ts_s.tif"))
tpos_t       <- raster::stack(file.path(envrmt$path_002_processed, "ft_tpos_h_t.tif"))
tpos_s       <- raster::stack(file.path(envrmt$path_002_processed, "ft_tpos_h_s.tif"))

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

# chm smoothing
chm_tree <- CHMsmoothing(chm_tree, filter = "Gaussian", ws = 15)
chm_shrub <- CHMsmoothing(chm_shrub, filter = "Gaussian", ws = 39)
chm_tree_shrub <- CHMsmoothing(chm_tree_shrub, filter = "Gaussian", ws = 15)


# rlidar segmentation
#tree
#segmentation
rlt <- chmseg_RL(chm = chm_tree,
                      treepos = tpos_t ,
                      maxCrownArea = 10000,
                      exclusion = 0.4)


# plot with maptools
plot(chm_tree)
plot(vp_tree, bty="l", col="red", pch=19, add = TRUE)
plot(rlt,  add = TRUE)




#shrub

#segmentation
rls <- chmseg_RL(chm = chm_shrub,
                 treepos = tpos_s ,
                 maxCrownArea = 5000,
                 exclusion = 0.4)


# plot with maptools
plot(chm_shrub)
plot(vp_shrub, bty="l", col="red", pch=19, add = TRUE)
plot(rls,  add = TRUE)




# tree shrub

#both
#segmentation
rlts <- chmseg_RL(chm = chm_tree_shrub,
                    treepos = tpos_ts ,
                    maxCrownArea = 5000,
                    exclusion = 0.4)



# plot with maptools
plot(chm_tree_shrub)
plot(vp_tree_shrub, bty="l", col="red", pch=19, add = TRUE)
plot(rlts,  add = TRUE)

#tree
#segmentation
rlts_t <- chmseg_RL(chm = chm_tree_shrub,
                 treepos = tpos_ts_t ,
                 maxCrownArea = 5000,
                 exclusion = 0.4)


# plot with maptools
plot(chm_tree_shrub)
plot(vp_tree_shrub_t, bty="l", col="red", pch=19, add = TRUE)
plot(rlts_t,  add = TRUE)

#shrub
#segmentation
rlts_s <- chmseg_RL(chm = chm_tree_shrub,
                  treepos = tpos_ts_s ,
                  maxCrownArea = 5000,
                  exclusion = 0.4)


# plot with maptools
plot(chm_tree_shrub)
plot(vp_tree_shrub_s, bty="l", col="red", pch=19, add = TRUE)
plot(rlts_s,  add = TRUE)

#write data
writeOGR(rlt, file.path(envrmt$path_002_processed, "rl_seg_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(rls, file.path(envrmt$path_002_processed, "rl_seg_s.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(rlts, file.path(envrmt$path_002_processed, "rl_seg_ts.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(rlts_t, file.path(envrmt$path_002_processed, "rl_seg_ts_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(rlts_s, file.path(envrmt$path_002_processed, "rl_seg_ts_s.shp"),layer="testShape",driver="ESRI Shapefile")

