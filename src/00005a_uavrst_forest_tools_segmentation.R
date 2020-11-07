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
vp_tree_shrub_t   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_t.shp"))
vp_tree_shrub_s   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_s.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))


#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


# chm smoothing
chm_tree <- CHMsmoothing(chm_tree, filter = "Gaussian", ws = 39)
chm_shrub <- CHMsmoothing(chm_shrub, filter = "Gaussian", ws = 11)
chm_tree_shrub <- CHMsmoothing(chm_tree_shrub, filter = "Gaussian", ws = 39)





#tree


#forest tools segmentation
ftt <- chmseg_FT(
  treepos = vp_tree,
  chm = chm_tree,
  minTreeAlt = 2,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)
  
# plot with maptoo
plot(chm_tree)
plot(ftt, add = TRUE)
plot(vp_tree,las=1, bty="l", col="red", pch=19, add = TRUE)






# shrub


#forest tools segmentation
fts <- chmseg_FT(
  treepos = vp_shrub,
  chm = chm_shrub,
  minTreeAlt = 0.6,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)

# plot with maptoo
plot(chm_shrub)
plot(fts, add = TRUE)
plot(vp_shrub,las=1, bty="l", col="red", pch=19, add = TRUE)






# tree shrub

#both
#forest tools segmentation
ftts <- chmseg_FT(
  treepos = vp_tree_shrub,
  chm = chm_tree_shrub,
  minTreeAlt = 0.6,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)

# plot with maptoo
plot(chm_tree_shrub)
plot(ftts, add = TRUE)
plot(vp_tree_shrub,las=1, bty="l", col="red", pch=19, add = TRUE)


#tree
#forest tools segmentation
ftts_t <- chmseg_FT(
  treepos = vp_tree_shrub_t,
  chm = chm_tree_shrub,
  minTreeAlt = 2,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)

# plot with maptoo
plot(chm_tree_shrub)
plot(ftts_t, add = TRUE)
plot(vp_tree_shrub_t,las=1, bty="l", col="red", pch=19, add = TRUE)


#shrub
#forest tools segmentation
ftts_s <- chmseg_FT(
  treepos = vp_tree_shrub_s,
  chm = chm_tree_shrub,
  minTreeAlt = 0.6,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)

# plot with maptoo
plot(chm_tree_shrub)
plot(ftts_s, add = TRUE)
plot(vp_tree_shrub_s,las=1, bty="l", col="red", pch=19, add = TRUE)



#write data
writeOGR(ftt, file.path(envrmt$path_002_processed, "ft_seg_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(fts, file.path(envrmt$path_002_processed, "ft_seg_s.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(ftts, file.path(envrmt$path_002_processed, "ft_seg_ts.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(ftts_t, file.path(envrmt$path_002_processed, "ft_seg_ts_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(ftts_s, file.path(envrmt$path_002_processed, "ft_seg_ts_s.shp"),layer="testShape",driver="ESRI Shapefile")
