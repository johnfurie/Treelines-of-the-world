################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel", "uavRst","maptools","lidR") 
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



# read lidar data
LASfile <- file.path(envrmt$path_las, "11225103_HH.las")

tree <- file.path(envrmt$path_03_Segmentation_sites_las, "tree.las")
tree_shrub <- file.path(envrmt$path_03_Segmentation_sites_las, "tree_shrub.las")
shrub <- file.path(envrmt$path_03_Segmentation_sites_las, "shrub.las")

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
vp_tree_shrub_t   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_t.shp"))
vp_tree_shrub_s   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_s.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))

chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))

las_t = lidR::readLAS(tree)
las_s = lidR::readLAS(shrub)
las_ts = lidR::readLAS(tree_shrub)


col <- pastel.colors(200)

#chm <- grid_canopy(las, 0.5, p2r(0.3))
#ker <- matrix(1,3,3)
#chm <- raster::focal(chm, w = ker, fun = mean, na.rm = TRUE)

#ttops <- find_trees(chm, lmf(4, 2))
#las   <- segment_trees(las, dalponte2016(chm, ttops))
#plot(las, color = "treeID", colorPalette = col)


#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


#li 2012

# tree

# segmentation
last   <- segment_trees(las_t, li2012(
                                      dt1 = 1.5, 
                                      dt2 = 2, 
                                      R = 1, 
                                      Zu = 15, 
                                      hmin = 5, 
                                      speed_up = 100))

#plot
x = plot(last, color = "treeID", colorPalette = col)


#polygon conversion
poly_t <-tree_hulls(
  last,
  type = c("convex", "concave", "bbox"),
  concavity = 3,
  length_threshold = 0,
  func = NULL,
  attribute = "treeID")

#plot
plotRGB(rgb_tree)
plot(poly_t ,add = T, border = "red", lwd =3)
plot(vp_tree, add = T)

#write data
writeOGR(poly_t, file.path(envrmt$path_002_processed, "lidr_seg_li_t.shp"),layer="testShape",driver="ESRI Shapefile")
seg_t   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_li_t.shp"))




# shrub

# segmentation
lass   <- segment_trees(las_s, li2012(
                                      dt1 = 1, 
                                      dt2 = 2, 
                                        R = 1, 
                                        Zu = 5, 
                                      hmin = 0.2, 
                                  speed_up = 10))

#plot
#x = plot(lass, color = "treeID", colorPalette = col)


#polygon conversion
poly_s <-tree_hulls(
  lass,
  type = c("convex", "concave", "bbox"),
  concavity = 3,
  length_threshold = 0,
  func = NULL,
  attribute = "treeID")

#plot
#plotRGB(rgb_shrub)
#plot(poly_s, add = T)
#plot(vp_tree_shrub, add = T)

#write data
writeOGR(poly_s, file.path(envrmt$path_002_processed, "lidr_seg_li_s.shp"),layer="testShape",driver="ESRI Shapefile")
seg_s   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_li_s.shp"))




# tree shrub

#both
# segmentation
lasts   <- segment_trees(las_ts, li2012(
                                      dt1 = 1.5, 
                                      dt2 = 2, 
                                        R = 2, 
                                        Zu = 15, 
                                         hmin = 0.6, 
                                      speed_up = 10))

#plot
x = plot(lasts, color = "treeID", colorPalette = col)

#polygon conversion
poly_ts <-tree_hulls(
  lasts,
  type = c("convex", "concave", "bbox"),
  concavity = 3,
  length_threshold = 0,
  func = NULL,
  attribute = "treeID")

#plot
plotRGB(rgb_tree_shrub)
plot(poly_ts, add = T)
plot(vp_tree_shrub, add = T)

#write data
writeOGR(poly_ts, file.path(envrmt$path_002_processed, "lidr_seg_li_ts.shp"),layer="testShape",driver="ESRI Shapefile")
seg_ts   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_li_ts.shp"))





#tree
# segmentation
lasts_t   <- segment_trees(las_ts, li2012(
  dt1 = 1.5, 
  dt2 = 2, 
  R = 2, 
  Zu = 15, 
  hmin = 2, 
  speed_up = 10))

#plot
x = plot(lasts_t, color = "treeID", colorPalette = col)

#polygon conversion
poly_ts_t <-tree_hulls(
  lasts_t,
  type = c("convex", "concave", "bbox"),
  concavity = 3,
  length_threshold = 0,
  func = NULL,
  attribute = "treeID")

#plot
plotRGB(rgb_tree_shrub)
plot(poly_ts_t, add = T)
plot(vp_tree_shrub_t, add = T)

#write data
writeOGR(poly_ts_t, file.path(envrmt$path_002_processed, "lidr_seg_li_ts_t.shp"),layer="testShape",driver="ESRI Shapefile")
seg_ts_t   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_li_ts_t.shp"))




#shrub
# segmentation
lasts_s   <- segment_trees(las_ts, li2012(
  dt1 = 1.5, 
  dt2 = 2, 
  R = 2, 
  Zu = 15, 
  hmin = 0.6, 
  speed_up = 10))

#plot
x = plot(lasts_s, color = "treeID", colorPalette = col)

#polygon conversion
poly_ts_s <-tree_hulls(
  lasts_s,
  type = c("convex", "concave", "bbox"),
  concavity = 3,
  length_threshold = 0,
  func = NULL,
  attribute = "treeID")

#plot
plotRGB(rgb_tree_shrub)
plot(poly_ts_s, add = T)
plot(vp_tree_shrub_s, add = T)

#write data
writeOGR(poly_ts_s, file.path(envrmt$path_002_processed, "lidr_seg_li_ts_s.shp"),layer="testShape",driver="ESRI Shapefile")
seg_ts_s   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_li_ts_s.shp"))