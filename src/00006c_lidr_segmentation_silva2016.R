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

tree <- file.path(envrmt$path_las, "tree.las")
tree_shrub <- file.path(envrmt$path_las, "tree_shrub.las")
shrub <- file.path(envrmt$path_las, "shrub.las")

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
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


#silva 2016

# tree

#treepos
ttopt <- find_trees(chm_tree, lmf(4, 2))

# segmentation
last   <- segment_trees(las_t, silva2016(
                                chm = chm_tree, 
                            treetops = ttopt, 
                          max_cr_factor = 0.6, 
                            exclusion = 0.3, 
                                   ID = "treeID"))

#plot
x = plot(last, color = "treeID", colorPalette = col)

# 3d plot
x = plot(las_t)
add_treetops3d(x, ttopt)

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
plot(poly_t, add = T)

#write data
writeOGR(poly_t, file.path(envrmt$path_002_processed, "lidr_seg_sil_t.shp"),layer="testShape",driver="ESRI Shapefile")
seg_t   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_sil_t.shp"))




# shrub

#treepos
ttops <- find_trees(chm_shrub, lmf(4, 2))

# segmentation
lass   <- segment_trees(las_s, silva2016(
                                chm =chm_shrub, 
                              treetops = ttops, 
                              max_cr_factor = 0.6, 
                                  exclusion = 0.3, 
                                          ID = "treeID"))

#plot
x = plot(lass, color = "treeID", colorPalette = col)

# 3d plot
x = plot(las_s)
add_treetops3d(x, ttops)

#polygon conversion
poly_s <-tree_hulls(
  lass,
  type = c("convex", "concave", "bbox"),
  concavity = 3,
  length_threshold = 0,
  func = NULL,
  attribute = "treeID")

#plot
plotRGB(rgb_shrub)
plot(poly_s, add = T)

#write data
writeOGR(poly_s, file.path(envrmt$path_002_processed, "lidr_seg_sil_s.shp"),layer="testShape",driver="ESRI Shapefile")
seg_s   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_sil_s.shp"))




# tree shrub

#treepos
ttopts <- find_trees(chm_tree_shrub, lmf(4, 2))

# segmentation
lasts   <- segment_trees(las_ts, silva2016(
                                              chm =chm_tree_shrub, 
                                          treetops = ttopts, 
                                      max_cr_factor = 0.6, 
                                          exclusion = 0.3, 
                                                  ID = "treeID"))

#plot
x = plot(lasts, color = "treeID", colorPalette = col)

# 3d plot
x = plot(las_ts)
add_treetops3d(x, ttopts)

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

#write data
writeOGR(poly_ts, file.path(envrmt$path_002_processed, "lidr_seg_sil_ts.shp"),layer="testShape",driver="ESRI Shapefile")
seg_ts   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_seg_sil_ts.shp"))
