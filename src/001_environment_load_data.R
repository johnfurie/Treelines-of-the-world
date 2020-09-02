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
root_folder = alternativeEnvi(root_folder = "E:/Treelines-of-the-world",                    
                              alt_env_id = "COMPUTERNAME",                                  
                              alt_env_value = "PCRZP",                                      
                              alt_env_root_folder = "F:/edu/Envimaster-Geomorph")           
#source environment script                                                                  
source(file.path(root_folder, paste0(pathdir,"0000b_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################

chm <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))                                
rgb <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))  

rgbstudy <- raster::raster(file.path(envrmt$path_spectral, "RGB_study_area.tif")) 



seg <- uavRst::chmseg_ITC(chm = chm,EPSG = "31254", movingWin = 39, minTreeAlt = 1)
plot(seg)
mapview(chm)+seg

writeRaster(chm,filename=file.path(envrmt$path_002_processed,"chm_tree_proj.tif"),format="GTiff",overwrite=TRUE)
writeOGR(obj=seg,dsn= file.path(envrmt$path_002_processed, "seg_tree.shp"),layer="testShape",driver="ESRI Shapefile")

chmn <- raster::raster(file.path(envrmt$path_002_processed, "chm_tree_proj.tif")) 
crs(chmn)
segn <- readOGR(dsn=file.path(envrmt$path_002_processed, "seg_tree.shp"))
crs(segn)
mapview(chmn)+segn

##segmentation
ITC<- uavRst::chmseg_ITC(chm = chm,
                 EPSG =25832,
                 movingWin = 13,
                 TRESHSeed = 0.1,
                 TRESHCrown = 0.9,
                 minTreeAlt = 0.3,
                 maxCrownArea = 600)

