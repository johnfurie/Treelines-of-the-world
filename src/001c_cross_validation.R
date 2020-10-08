################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","CENITH","doParallel","parallel") 

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

require(CENITH) 

# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))
chm_shrub_2     <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub_2.tif"))

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))
vp_shrub_2      <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub_2.shp"))

# compare coordinate system of datasets
compareCRS(chm_tree_shrub,vp_tree_shrub)
compareCRS(chm_tree,vp_tree )
compareCRS(chm_shrub,vp_shrub)
compareCRS(chm_shrub_2,vp_shrub_2)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

# make lists
chms <- list(chm_shrub,chm_shrub_2,chm_tree,chm_tree_shrub)
vps  <- list(vp_shrub,vp_shrub_2,vp_tree,vp_tree_shrub)

# CENITH validation V2.1 different moving window sizes computed and search for max hitrate to use settings for segmentation
val <- TreeSegCV( sites  = chms, 
                  a      = 0.1, 
                  b      = 0.1,
                  h      = 0.25,
                  vps    = vps,
                  MIN    = 10,
                  MAX    = 50000,
                  CHMfilter = 1
                  )

#stop cluster

stopCluster(cl)

# write table
write.table(val, file.path(envrmt$path_002_processed,"validaton_accuracy.csv"))

# view table
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy.csv"))
