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
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_treev2         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_tv2.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

# chm smoothing
chm_tree <- CHMsmoothing(chm_tree, filter = "Gaussian", ws = 39)
chm_shrub <- CHMsmoothing(chm_shrub, filter = "Gaussian", ws = 39)
chm_tree_shrub <- CHMsmoothing(chm_tree_shrub, filter = "Gaussian", ws = 39)



# rlidar segmentation

# tree
# treeposition
rl_t <- treepos_RL(chm = chm_tree,
                   movingWin = 23,
                   minTreeAlt = 1.5)

pt = rasterToPoints(rl_t,spatial = TRUE)
plot(pt)

#segmentation
rlt <- chmseg_RL(chm = chm_tree,
                      treepos = rl_t ,
                      maxCrownArea = 150,
                      exclusion = 0.2)


# plot with maptools
plot(chm_tree)
plot(pt, bty="l", col="red", pch=19, add = TRUE)
plot(rlt,  add = TRUE)




#shrub
# treeposition
rl_s <- treepos_RL(chm = chm_shrub,
                   movingWin = 13,
                   minTreeAlt = 0.6)

ps = rasterToPoints(rl_s,spatial = TRUE)
plot(ps)

#segmentation
rls <- chmseg_RL(chm = chm_shrub,
                 treepos = rl_s ,
                 maxCrownArea = 150,
                 exclusion = 0.2)


# plot with maptools
plot(chm_shrub)
plot(ps, bty="l", col="red", pch=19, add = TRUE)
plot(rls,  add = TRUE)




# tree shrub
# treeposition
rl_ts <- treepos_RL(chm = chm_tree_shrub,
                   movingWin = 7,
                   minTreeAlt = 0.8)

pts = rasterToPoints(rl_ts,spatial = TRUE)
plot(pts)

#segmentation
rlts <- chmseg_RL(chm = chm_tree_shrub,
                 treepos = rl_ts ,
                 maxCrownArea = 150,
                 exclusion = 0.2)


# plot with maptools
plot(chm_tree_shrub)
plot(pts, bty="l", col="red", pch=19, add = TRUE)
plot(rlts,  add = TRUE)

#write data
writeOGR(rlt, file.path(envrmt$path_002_processed, "rl_seg_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(rls, file.path(envrmt$path_002_processed, "rl_seg_s.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(rlts, file.path(envrmt$path_002_processed, "rl_seg_ts.shp"),layer="testShape",driver="ESRI Shapefile")

