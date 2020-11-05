################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR") 
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

# load files for visualization
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))


rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))


vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))


#load las file
tree <- file.path(envrmt$path_las, "tree.las")
tree_shrub <- file.path(envrmt$path_las, "tree_shrub.las")
shrub <- file.path(envrmt$path_las, "shrub.las")


# read las files
last = lidR::readLAS(tree)
lass = lidR::readLAS(shrub)
lasts = lidR::readLAS(tree_shrub)


col <- pastel.colors(200)




#find treetops

# 1. tree
ttopst <- find_trees(last, lmf(ws = 3.5))
#library(rgdal)
# write data
writeOGR(ttopst, file.path(envrmt$path_002_processed, "lidr_tpos_t.shp"),layer="testShape",driver="ESRI Shapefile")
pt   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_t.shp"))

# plot with maptools
plot(chm_tree)
plot(vp_tree, add = T)
plot(pt, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_tree)
plot(vp_tree, add = T)
plot(pt, las=1, bty="l", col="red", pch=19, add = T)

# 3d plot
x = plot(last)
add_treetops3d(x, ttopst)




  # 2. shrub
ttopss <- lidR::find_trees(lass, lmf(ws = 1.5))


# write data
writeOGR(ttopss, file.path(envrmt$path_002_processed, "lidr_tpos_s.shp"),layer="testShape",driver="ESRI Shapefile")
ps   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_s.shp"))

# plot with maptools
plot(chm_shrub)
plot(vp_shrub, add = T)
plot(ps, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_shrub)
plot(vp_shrub, add = T)
plot(ps, las=1, bty="l", col="red", pch=19, add = T)

# 3d plot
x = plot(lass)
add_treetops3d(x, ttopss)




# 3. tree shrub
ttopsts <- find_trees(lasts, lmf(ws = 6))

# write data
writeOGR(ttopsts, file.path(envrmt$path_002_processed, "lidr_tpos_ts.shp"),layer="testShape",driver="ESRI Shapefile")
pts   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"lidr_tpos_ts.shp"))

# plot with maptools
plot(chm_tree_shrub)
plot(vp_tree_shrub, add = T)
plot(pts, las=1, bty="l", col="red", pch=19, add = T)

plotRGB(rgb_tree_shrub)
plot(vp_tree_shrub, add = T)
plot(pts, las=1, bty="l", col="red", pch=19, add = T)

# 3d plot
x = plot(lasts)
add_treetops3d(x, ttopsts)




