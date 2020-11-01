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
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))


# compare coordinate system of datasets
compareCRS(chm_tree,vp_tree)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


# chm smoothing
chm_tree <- CHMsmoothing(chm_tree, filter = "Gaussian", ws = 39)
chm_shrub <- CHMsmoothing(chm_shrub, filter = "Gaussian", ws = 39)
chm_tree_shrub <- CHMsmoothing(chm_tree_shrub, filter = "Gaussian", ws = 39)





#tree

# treeposition
ft_t <- treepos_FT(chm = chm_tree,
                   minTreeAlt = 1.5,
                   maxCrownArea = 5000)

pt = rasterToPoints(ft_t$treeID,spatial = TRUE)
plot(pt)

#forest tools segmentation
ftt <- chmseg_FT(
  treepos = ft_t,
  chm = chm_tree,
  minTreeAlt = 1.5,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)
  
# plot with maptoo
plot(chm_tree)
plot(ftt, add = TRUE)
plot(pt,las=1, bty="l", col="red", pch=19, add = TRUE)

plot(vp_tree, add = TRUE)




# shrub

# treeposition
ft_s <- treepos_FT(chm = chm_shrub,
                   minTreeAlt = 0.6,
                   maxCrownArea = 5000)

ps = rasterToPoints(ft_s$treeID,spatial = TRUE)
plot(ps)

#forest tools segmentation
fts <- chmseg_FT(
  treepos = ft_s,
  chm = chm_shrub,
  minTreeAlt = 0.6,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)

# plot with maptoo
plot(chm_shrub)
plot(fts, add = TRUE)
plot(ps,las=1, bty="l", col="red", pch=19, add = TRUE)

plot(vp_shrub, add = TRUE)




# tree shrub
# treeposition
ft_ts <- treepos_FT(chm = chm_tree_shrub,
                   minTreeAlt = 1.3,
                   maxCrownArea = 5000)

pts = rasterToPoints(ft_ts$treeID,spatial = TRUE)
plot(pts)

#forest tools segmentation
ftts <- chmseg_FT(
  treepos = ft_ts,
  chm = chm_tree_shrub,
  minTreeAlt = 1.3,
  format = "polygons",
  winRadius = 1.5,
  verbose = FALSE)

# plot with maptoo
plot(chm_tree_shrub)
plot(ftts, add = TRUE)
plot(pts,las=1, bty="l", col="red", pch=19, add = TRUE)

plot(vp_tree_shrub, add = TRUE)

#write data
writeOGR(ftt, file.path(envrmt$path_002_processed, "ft_seg_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(fts, file.path(envrmt$path_002_processed, "ft_seg_s.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(ftts, file.path(envrmt$path_002_processed, "ft_seg_ts.shp"),layer="testShape",driver="ESRI Shapefile")
