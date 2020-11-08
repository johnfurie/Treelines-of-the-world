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

# assign value to polygons
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "cenith_seg_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "cenith_seg_s.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "cenith_seg_ts.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "cenith_seg_ts_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "cenith_seg_ts_s.shp"))

seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "ft_seg_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "ft_seg_s.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "ft_seg_ts.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "ft_seg_ts_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "ft_seg_ts_s.shp"))

seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "rl_seg_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "rl_seg_s.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "rl_seg_ts.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "rl_seg_ts_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "rl_seg_ts_s.shp"))

seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_s.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_ts.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_ts_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_ts_s.shp"))

seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_sil_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_sil_s.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_sil_ts.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_sil_ts_t.shp"))
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_sil_ts_s.shp"))


rgb_t  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_s  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))
rgb_ts  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif"))

vp_t <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "ft_tpos_t.shp"))
vp_s <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "ft_tpos_s.shp"))
vp_ts <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "ft_tpos_ts.shp"))
vp_ts_t <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "ft_tpos_ts_t.shp"))
vp_ts_s <- readOGR(dsn=file.path(envrmt$path_03_Segmentation_sites_shp, "ft_tpos_ts_s.shp"))


specter  <- raster::raster(file.path(envrmt$path_002_processed,"rf_prediction_small5.tif"))

specter  <- raster::raster(file.path(envrmt$path_002_processed, "CHM_study_area_clean.tif"))

seg$X_mean <- as.integer(seg$X_mean)
head(seg)
plot(seg)

# write VECTOR
writeOGR(seg, file.path(envrmt$path_002_processed, "lidr_seg_sil_ts_s.shp"),layer="testShape",driver="ESRI Shapefile")


#make dataframe with treeID
b <- seg$
head(b)
b <- as.data.frame(b)
head(b)
#rownames
names(b) <- (c("treeID"))

# extract values of predicted raster and assign to segmentation polygons
a <- extract(specter, seg, fun=mean, na.rm=TRUE)
head(seg)
a <- as.data.frame(a)
#rownames
names(a) <- (c("value"))
#rounding numbers
seg$X_mean <- seg$X_mean %>% mutate_at(vars(starts_with("X_mean")), funs(round(seg$X_mean, 0)))
head(a)
#combine 2 dataframes
c <- cbind(a,b)
head(c)

#merge with polygon
oo <- merge(seg,c, by="treeID", all=T)

head(oo)
plot(oo)

# write VECTOR
writeOGR(oo, file.path(envrmt$path_002_processed, "lidr_pred.shp"),layer="testShape",driver="ESRI Shapefile")







