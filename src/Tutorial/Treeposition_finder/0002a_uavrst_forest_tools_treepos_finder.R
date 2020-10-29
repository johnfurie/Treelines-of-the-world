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
root_folder = alternativeEnvi(root_folder = "E:/Github/Treelines-of-the-world",                    
                              alt_env_id = "COMPUTERNAME",                                  
                              alt_env_value = "PCRZP",                                      
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           
#source environment script                                                                  
source(file.path(root_folder, paste0(pathdir,"0000b_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################

# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))
chm_shrub_2     <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub_2.tif"))

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))
rgb_shrub_2     <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub_2.tif"))

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))
vp_shrub_2      <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub_2.shp"))




#forest tools treetop finder 

# 1 tree
ft_t <- treepos_FT(chm = chm_tree,
                   minTreeAlt = 2,
                   maxCrownArea = 5000)

#convert treetop raster to point shape
pt = rasterToPoints(ft_t$treeID,spatial = TRUE)

#Write shape
writeOGR(pt, file.path(envrmt$path_002_processed, "ft_tpos_t.shp"),layer="testShape",driver="ESRI Shapefile")
pt<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "ft_tpos_t.shp"))

# plot with maptools
plot(chm_tree)
plot(vp_tree, add = T)
plot(pt, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_tree)
plot(vp_tree, add = T)
plot(pt, las=1, bty="l", col="red", pch=19, add = T)




# 2 shrub
#forest tools treetop finder 
ft_s <- treepos_FT(chm = chm_shrub,
                   minTreeAlt = 0.6,
                   maxCrownArea = 5000)

#convert treetop raster to point shape
ps = rasterToPoints(ft_s$treeID,spatial = TRUE)

#Write shape
writeOGR(ps, file.path(envrmt$path_002_processed, "ft_tpos_s.shp"),layer="testShape",driver="ESRI Shapefile")
ps<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "ft_tpos_s.shp"))

# plot with maptools
plot(chm_shrub)
plot(vp_shrub, add = T)
plot(ps, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_shrub)
plot(vp_shrub, add = T)
plot(ps, las=1, bty="l", col="red", pch=19, add = T)




# 3 tree shrub
ft_ts <- treepos_FT(chm = chm_tree_shrub,
                     minTreeAlt = 1,
                     maxCrownArea = 5000)

#convert treetop raster to point shape
pts = rasterToPoints(ft_ts$treeID,spatial = TRUE)

#Write/read as shapefile
writeOGR(pts, file.path(envrmt$path_002_processed, "ft_tpos_ts.shp"),layer="testShape",driver="ESRI Shapefile")
pts<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "ft_tpos_ts.shp"))

# plot with maptools
plot(chm_tree_shrub)
plot(vp_tree_shrub, add = T)
plot(pts, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_tree_shrub)
plot(vp_tree_shrub, add = T)
plot(pts, las=1, bty="l", col="red", pch=19, add = T)




# 4 shrub 2
#forest tools treetop finder 
ft_s2 <- treepos_FT(chm = chm_shrub_2,
                   minTreeAlt = 1,
                   maxCrownArea = 5000)

#convert treetop raster to point shape
ps2 = rasterToPoints(ft_s2$treeID,spatial = TRUE)

#Write point shape
writeOGR(ps2, file.path(envrmt$path_002_processed, "ft_tpos_s2.shp"),layer="testShape",driver="ESRI Shapefile")
ps2<-  rgdal::readOGR(file.path(envrmt$path_002_processed, "ft_tpos_s2.shp"))

# plot with maptools
plot(chm_shrub_2)
plot(vp_shrub_2, add = T)
plot(ps2, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_shrub_2)
plot(vp_shrub_2, add = T)
plot(ps2, las=1, bty="l", col="red", pch=19, add = T)

