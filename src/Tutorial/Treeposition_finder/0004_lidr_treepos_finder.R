################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI") 
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

# load packages                                
require(lidR)

#load las file
tree <- file.path(envrmt$path_las, "tree.las")
tree_shrub <- file.path(envrmt$path_las, "tree_shrub.las")
shrub <- file.path(envrmt$path_las, "shrub.las")
shrub_2 <- file.path(envrmt$path_las, "shrub_2.las")

# load chm raster for visuLIZATION
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))
chm_shrub_2     <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub_2.tif"))

# read las files
last = lidR::readLAS(tree)
lass = lidR::readLAS(shrub)
lasts = lidR::readLAS(tree_shrub)
lass2 = lidR::readLAS(shrub_2)

col <- pastel.colors(200)

#find treetops

# 1. tree
ttopst <- find_trees(last, lmf(ws = 5))

x = plot(last)
add_treetops3d(x, ttopst)

writeOGR(ttopst, file.path(envrmt$path_002_processed, "lidr_tpos_t.shp"),layer="testShape",driver="ESRI Shapefile")
pt   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_t.shp"))

plot(chm_tree)
plot(pt, add = T)


# 2. shrub
ttopss <- find_trees(lass, lmf(ws = 5))

x = plot(lass)
add_treetops3d(x, ttopss)

writeOGR(ttopss, file.path(envrmt$path_002_processed, "lidr_tpos_s.shp"),layer="testShape",driver="ESRI Shapefile")
ps   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_s.shp"))

plot(chm_shrub)
plot(ps, add = T)


# 3. tree shrub
ttopsts <- find_trees(lasts, lmf(ws = 5))

x = plot(lasts)
add_treetops3d(x, ttopsts)

writeOGR(ttopsts, file.path(envrmt$path_002_processed, "lidr_tpos_ts.shp"),layer="testShape",driver="ESRI Shapefile")
pts   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_ts.shp"))

plot(chm_tree_shrub)
plot(pts, add = T)


# 4. shrub 2
ttopss2 <- find_trees(lass2, lmf(ws = 5))

x = plot(lass2)
add_treetops3d(x, ttopss2)

writeOGR(ttopss2, file.path(envrmt$path_002_processed, "lidr_tpos_s2.shp"),layer="testShape",driver="ESRI Shapefile")
ps2   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_s2.shp"))

plot(chm_shrub_2)
plot(ps2, add = T)



