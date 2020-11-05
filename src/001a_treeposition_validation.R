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
root_folder = alternativeEnvi(root_folder = "C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world",                    
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
chm_tree        <- raster::raster("C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world/data/001_org/03_Segmentation_sites/CHM/CHM_tree.tif")
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))
chm_shrub_2     <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub_2.tif"))

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub_t.shp"))
vp_tree         <-  rgdal::readOGR("C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world/data/001_org/03_Segmentation_sites/shp/tpos_tree.shp")
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))
vp_shrub_2      <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub_2.shp"))


# compare coordinate system of datasets
compareCRS(chm_tree,vp_tree)
chm_tree@crs@projargs <- "+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs"

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


# CENITH validation V2.1 different moving window sizes computed and search for max hitrate to use settings for segmentation
val <- BestSegVal(chm = chm_tree, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(2,20,1),
                  vp = vp_tree,
                  MIN = 10,
                  MAX = 500000,
                  filter = 3
                  )

#stop cluster

stopCluster(cl)

# write table
write.table(val, file.path(envrmt$path_002_processed,"validaton_accuracy_tree_scrub.csv"))

# view table
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy_shrub.csv"))
