# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal","maptools") 
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

t <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "tree.shp"))
s <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "shrub.shp"))
ts <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "tree_shrub.shp"))

e1 <- readOGR(dsn=file.path(envrmt$path_02_Ecotone_sites_shp, "e1.shp"))
e2 <- readOGR(dsn=file.path(envrmt$path_02_Ecotone_sites_shp, "e2.shp"))
e3 <- readOGR(dsn=file.path(envrmt$path_02_Ecotone_sites_shp, "e3.shp"))


rf = raster::stack(file.path(envrmt$path_002_processed, "veg_ind_study.tif"))

rf = raster::stack(file.path(envrmt$path_002_processed, "RGB_study_area.tif"))
t <- readOGR(dsn=file.path(envrmt$path_002_processed, "study.shp"))


rf  <- raster::stack(file.path(envrmt$path_002_processed, "rf_prediction_study.tif"))



## crop and mask
r2 <- crop(rf, extent(t))
r3 <- mask(r2, t)

## Check that it worked
plot(r2$veg_ind_study.1)
plot(t, add=TRUE, lwd=2)

writeRaster(r2, file.path(envrmt$path_002_processed,"RGB_study_area_clip.tif"),format="GTiff",overwrite=TRUE)

writeRaster(r2, file.path(envrmt$path_002_processed,"veg_ind_study_clip.tif"),format="GTiff",overwrite=TRUE)

writeRaster(r3, file.path(envrmt$path_002_processed,"rf_prediction_t.tif"),format="GTiff",overwrite=TRUE)
writeRaster(r3, file.path(envrmt$path_002_processed,"rf_prediction_s.tif"),format="GTiff",overwrite=TRUE)
writeRaster(r3, file.path(envrmt$path_002_processed,"rf_prediction_ts.tif"),format="GTiff",overwrite=TRUE)

writeRaster(r3, file.path(envrmt$path_002_processed,"rf_prediction_e1.tif"),format="GTiff",overwrite=TRUE)
writeRaster(r3, file.path(envrmt$path_002_processed,"rf_prediction_e2.tif"),format="GTiff",overwrite=TRUE)
writeRaster(r3, file.path(envrmt$path_002_processed,"rf_prediction_e3.tif"),format="GTiff",overwrite=TRUE)