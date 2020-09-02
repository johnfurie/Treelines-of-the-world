################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal") 
# define src folder
pathdir = "repo/src/"

#set root folder for uniPC or laptop                                                        
root_folder = alternativeEnvi(root_folder = "E:/Github/Treelines-of-the-world",                    
                              alt_env_id = "COMPUTERNAME",                                  
                              alt_env_value = "PCRZP",                                      
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           
#source environment script                                                                  
source(file.path(root_folder, paste0(pathdir,"0000c_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################

# Load data / visualize / check projection on Rasterlayer

# RASTER-DATA
chm <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
plot(chm)
mapview(chm)
crs(chm)
# EPSG: 31254
# proj4 <- "+proj=tmerc +lat_0=0 +lon_0=10.33333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs" 
chm_proj <- projectRaster(chm, crs= proj4)

# load data / visualize / check projection on Rasterbrick
rgb <- raster::brick(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
plotRGB(rgb)
mapview::viewRGB(rgb)
crs(rgb) # see above

# VECTOR-DATA
tree <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "tree.shp"))
plot(tree)
mapview::viewRGB(rgb)+tree
crs(tree)
seg_proj <- spTransform(tree, CRSobj = proj4)

# view table
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy.csv"))

# WRITE-DATA

# RASTER
writeRaster(chm, file.path(envrmt$path_002_processed,"chm_tree_proj.tif"),format="GTiff",overwrite=TRUE)
# VECTOR
writeOGR(tree, file.path(envrmt$path_002_processed, "tree_proj.shp"),layer="testShape",driver="ESRI Shapefile")
# write table
write.table(val, file.path(envrmt$path_002_processed,"validaton_accuracy.csv"))