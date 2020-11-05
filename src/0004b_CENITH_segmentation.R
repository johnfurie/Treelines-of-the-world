################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH") 
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

require(CENITH) 

# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))


vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)



# CENITH segmentation (use best hitrate settings from bestsegval)
# tree
segt <- TreeSeg(chm=chm_tree, 
               a=c(0.21), 
               b=c(0.9),
               h=c(2),
               MIN=10,
               MAX=50000,
               CHMfilter=3
)

# shrub
segs <- TreeSeg(chm=chm_shrub, 
               a=c(0.9), 
               b=c(0.9),
               h=c(0.1),
               MIN=10,
               MAX=50000,
               CHMfilter=3
)

# tree shrub
segts <- TreeSeg(chm=chm_tree_shrub, 
               a=c(0.3), 
               b=c(0.1),
               h=c(0.2),
               MIN=10,
               MAX=50000,
               CHMfilter=3
)
# visualization
mapview::mapview(segt)+vp_tree+chm_tree
mapview::mapview(segs)+vp_shrub+chm_shrub
mapview::mapview(segts)+vp_tree_shrub+chm_tree_shrub

# write data
writeOGR(segt, file.path(envrmt$path_002_processed, "cenith_seg_t.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(segs, file.path(envrmt$path_002_processed, "cenith_seg_s.shp"),layer="testShape",driver="ESRI Shapefile")
writeOGR(segts, file.path(envrmt$path_002_processed, "cenith_seg_ts.shp"),layer="testShape",driver="ESRI Shapefile")

# load segments
tree <-  rgdal::readOGR(file.path(envrmt$path_002_processed, "cenith_seg_t.shp"))
shrub <-  rgdal::readOGR(file.path(envrmt$path_002_processed, "cenith_seg_s.shp"))
tree_shrub <-  rgdal::readOGR(file.path(envrmt$path_002_processed, "cenith_seg_ts.shp"))
