################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel","uavRst","maptools")

# define src folder
pathdir = "repo/src/"

#set root folder for uniPC or laptop                                                        
root_folder = alternativeEnvi(root_folder =  "C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world",                    
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
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


# chm smoothing
chm_tree <- CHMsmoothing(chm_tree, filter = "Gaussian", ws = 39)
chm_shrub <- CHMsmoothing(chm_shrub, filter = "Gaussian", ws = 39)
chm_tree_shrub <- CHMsmoothing(chm_tree_shrub, filter = "Gaussian", ws = 39)


# rLidar treeposition finder

# tree
rl_t <- treepos_RL(chm = chm_tree,
                     movingWin = 23,
                     minTreeAlt = 1.5)

#convert treetop raster to point shape
pt = rasterToPoints(rl_t ,spatial = TRUE)

#Write shape
writeOGR(pt, file.path(envrmt$path_002_processed, "rl_tpos_t.shp"),layer="testShape",driver="ESRI Shapefile")
pt<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "rl_tpos_t.shp"))

# plot with maptools
plot(chm_tree)
plot(vp_tree, add = T)
plot(pt, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_tree)
plot(vp_tree, add = T)
plot(pt, las=1, bty="l", col="red", pch=19, add = T)



# 2 shrub
#forest tools treetop finder 
rl_s <- treepos_RL(chm = chm_shrub,
                   movingWin = 13,
                   minTreeAlt = 0.3)

#convert treetop raster to point shape
ps = rasterToPoints(rl_s,spatial = TRUE)

#Write shape
writeOGR(ps, file.path(envrmt$path_002_processed, "rl_tpos_s.shp"),layer="testShape",driver="ESRI Shapefile")
ps<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "rl_tpos_s.shp"))

# plot with maptools
plot(chm_shrub)
plot(vp_shrub, add = T)
plot(ps, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_shrub)
plot(vp_shrub, add = T)
plot(ps, las=1, bty="l", col="red", pch=19, add = T)




# 3 tree shrub
rl_ts <- treepos_RL(chm = chm_tree_shrub,
                   movingWin = 7,
                   minTreeAlt = 0.6)

#convert treetop raster to point shape
pts = rasterToPoints(rl_ts,spatial = TRUE)

#Write/read as shapefile
writeOGR(pts, file.path(envrmt$path_002_processed, "rl_tpos_ts.shp"),layer="testShape",driver="ESRI Shapefile")
pts<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "rl_tpos_ts.shp"))

# plot with maptools
plot(chm_tree_shrub)
plot(vp_tree_shrub, add = T)
plot(pts, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_tree_shrub)
plot(vp_tree_shrub, add = T)
plot(pts, las=1, bty="l", col="red", pch=19, add = T)




