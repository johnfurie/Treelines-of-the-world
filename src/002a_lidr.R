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
require(rlas)
require(rLiDAR)
require(rgeos)

# read lidar data
LASfile <- "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/11225103_HH.las"

las = lidR::readLAS(LASfile)


shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"shrub.shp"))

crs <- "+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel
+towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs" 
gc()

crs(shrub)
crs(las)
shrub_las <- lasclip(las, "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/shp/shrub.shp")
lascheck(las)
lasclipRectangle(las, xleft = -41963, ybottom = 216372, xright = -41913, ytop = 216422)

shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"shrub.shp"))
epsg(las)
wkt(las)

sp::wkt(crs(las))
crs <- sp::CRS("+init=epsg:31245")
projection(shrub) <- crs
sf::st_crs(las)$input

projection(las) <- 31254
a <- spTransform()

epsg(object) <- 
proj4 <- "+proj=tmerc +lat_0=0 +lon_0=10.33333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs" 
