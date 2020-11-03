# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal") 
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

# load files 
ind  <- raster::stack(file.path(envrmt$path_002_processed, "pca_shrub_map.tif"))
rgb  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
tr <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "train_ts.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_ts.shp"))
head(seg)

#extent
ext_rst <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif"))
ext <- raster::extent(ext_rst)


# segments dalpote lidr
# rasterize
gdalUtils::gdal_rasterize(src_datasource = file.path(envrmt$path_002_processed, "lidr_seg_dal_ts.shp"), #input buffer layer polygon
                          dst_filename = file.path(envrmt$path_002_processed, "lidr_seg_dal_ts.tif"), #output rasterrized
                          a ="treeID",
                          te = c(ext[1],ext[3],ext[2],ext[4]),
                          tr = c(xres(ext_rst),yres(ext_rst)),
                          output_Raster = T)

# load raster
ras = raster::raster(file.path(envrmt$path_002_processed, "lidr_seg_dal_ts.tif"))
plot(ras)

#stack raster
segs <- stack(ras,ind) 
segs <- stack(segs,rgb)
head(segs)




# training shapes spectral
# rasterize
gdalUtils::gdal_rasterize(src_datasource = file.path(envrmt$path_03_Segmentation_sites_shp, "train_ts.shp"), #input buffer layer polygon
                          dst_filename = file.path(envrmt$path_002_processed, "train_ras_ts.tif"), #output rasterrized
                          a ="species",
                          te = c(ext[1],ext[3],ext[2],ext[4]),
                          tr = c(xres(ext_rst),yres(ext_rst)),
                          output_Raster = T)

# load raster
rast = raster::raster(file.path(envrmt$path_002_processed, "train_ras_ts.tif"))
plot(rast)

#stack raster
train <- stack(segs,rast) 
head(train)
names(train) <- (c("lidr_seg","pca1","pca2","pca3","red","green","blue","train"))

# RASTER
writeRaster(train, file.path(envrmt$path_002_processed,"traindat_ts.tif"),format="GTiff",overwrite=TRUE)
saveRDS(train, file.path(envrmt$path_002_processed,"traindat_ts.rds"))





