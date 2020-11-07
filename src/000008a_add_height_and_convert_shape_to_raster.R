# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal","randomForest","doParallel","parallel","caret","CAST","dplyr","tigris","sp","mapview") 
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

vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_s.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"ft_tpos_ts_s.shp"))


chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif"))
#extent
ext_rst <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
ext <- raster::extent(ext_rst)

b <- extract(chm_tree, vp_tree, fun=max, na.rm=TRUE)
head(b)

c <- cbind(vp_tree,b)
names(c) <- (c("treeID","height"))
head(c)

#write data
writeOGR(c, file.path(envrmt$path_002_processed, "ft_tpos_h_t.shp"),layer="testShape",driver="ESRI Shapefile")

n   <-  rgdal::readOGR(file.path(envrmt$path_002_processed,"ft_tpos_h_t.shp"))
head(n)

# rasterize
gdalUtils::gdal_rasterize(src_datasource = file.path(envrmt$path_002_processed, "ft_tpos_h_t.shp"), #input buffer layer polygon
                          dst_filename = file.path(envrmt$path_002_processed, "ft_tpos_h_t.tif"), #output rasterrized
                          a ="height",
                          te = c(ext[1],ext[3],ext[2],ext[4]),
                          tr = c(xres(ext_rst),yres(ext_rst)),
                          output_Raster = T)

# load raster
rl_t = raster::raster(file.path(envrmt$path_002_processed, "ft_tpos_h_t.tif"))
plot(rl_t)
head(rl_t)

# make missing values to na
rl_t[rl_t == 0] <- NA

#write data
writeRaster(rl_t, file.path(envrmt$path_002_processed,"ft_tpos_h_t.tif"),format="GTiff",overwrite=TRUE)



