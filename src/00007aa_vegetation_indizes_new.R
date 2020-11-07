# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION", "rgdal","doParallel") 
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
rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_002_processed, "RGB_study_area.tif")) 

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_02_Ecotone_sites_RGB, "RGB_e1.tif"))
rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_02_Ecotone_sites_RGB, "RGB_e2.tif"))
rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_02_Ecotone_sites_RGB, "RGB_e3.tif"))

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))

ir_tree_shrub  <- raster::raster(file.path(envrmt$path_002_processed, "IR_study_area.tif")) 

ir_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_IR, "IR_tree_shrub.tif")) 
ir_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_IR, "IR_tree.tif"))
ir_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_IR, "IR_shrub.tif"))

ir_tree_shrub  <- raster::raster(file.path(envrmt$path_02_Ecotone_sites_IR, "IR_e1.tif"))
ir_tree_shrub  <- raster::raster(file.path(envrmt$path_02_Ecotone_sites_IR, "IR_e2.tif"))
ir_tree_shrub  <- raster::raster(file.path(envrmt$path_02_Ecotone_sites_IR, "IR_e3.tif"))

chm_tree_shrub  <- raster::raster(file.path(envrmt$path_002_processed, "CHM_study_area_clean.tif"))

chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif"))
chm_tree     <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_tree.tif"))
chm_shrub    <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif"))

chm_tree_shrub  <- raster::raster(file.path(envrmt$path_02_Ecotone_sites_CHM, "CHM_e1.tif"))
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_02_Ecotone_sites_CHM, "CHM_e2.tif"))
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_02_Ecotone_sites_CHM, "CHM_e3.tif"))

tr <- readOGR(dsn=file.path(envrmt$path_02_Ecotone_sites_shp, "ecotone_1.shp"))
tr <- readOGR(dsn=file.path(envrmt$path_02_Ecotone_sites_shp, "ecotone_2.shp"))
tr <- readOGR(dsn=file.path(envrmt$path_02_Ecotone_sites_shp, "ecotone_3.shp"))

tr <- readOGR(dsn=file.path(envrmt$path_002_processed, "study_area_all.shp"))



## crop and mask
rgb <- crop(rgb_tree_shrub, extent(tr))
ir <- crop(ir_tree_shrub, extent(tr))
chm <- crop(chm_tree_shrub, extent(tr))

#writeRaster(rgb, file.path(envrmt$path_002_processed,"RGB_train.tif"),format="GTiff",overwrite=TRUE)




# stack
treeshrub <- stack(rgb,ir)
treeshrub <- stack(treeshrub,chm)
head(treeshrub)
#treeshrub <- treeshrub[complete.cases(treeshrub), ]

# ir indizes
ir_ind <- LEGION::vegInd_mspec(treeshrub,red= 1, green = 2, blue = 3, nir = 4, indlist = "all")

#visualize
head(ir_ind)
plot(ir_ind$NDVI)
plot(ir_ind$TDVI)
plot(ir_ind$SR)
plot(ir_ind$MSR)

# stack
ind_stk <- raster::stack(treeshrub,ir_ind)
head(ind_stk)

#write data
writeRaster(ind_stk, file.path(envrmt$path_002_processed,"veg_ind_study_all.tif"),format="GTiff",overwrite=TRUE)
ind_stk  <- raster::stack(file.path(envrmt$path_002_processed,"veg_ind_study_all.tif"))

cl =  makeCluster(detectCores()-1) #open cluster
registerDoParallel(cl)
#na to 0
ind_stk[is.na(ind_stk[])] <- 0

writeRaster(ind_stk, file.path(envrmt$path_002_processed,"veg_ind_study_allnoNA.tif"),format="GTiff",overwrite=TRUE)
ind_stk  <- raster::stack(file.path(envrmt$path_002_processed,"veg_ind_study_allnoNA.tif"))





#rgb indizes
rgb_ind <-LEGION::vegInd_RGB(rgb,1,2,3, indlist = "all")
head(rgb_ind)

#write data
writeRaster(rgb_ind, file.path(envrmt$path_002_processed,"rgb_ind_study_all.tif"),format="GTiff",overwrite=TRUE)
rgb_ind  <- raster::stack(file.path(envrmt$path_002_processed,"rgb_ind_study_all.tif"))

cl =  makeCluster(detectCores()-1) #open cluster
registerDoParallel(cl)
#na to 0
rgb_ind[is.na(rgb_ind[])] <- 0

#write data
writeRaster(rgb_ind, file.path(envrmt$path_002_processed,"rgb_ind_study_allnoNA.tif"),format="GTiff",overwrite=TRUE)
rgb_ind  <- raster::stack(file.path(envrmt$path_002_processed,"rgb_ind_study_allnoNA.tif"))


#stack
all_stk <- raster::stack(ind_stk,rgb_ind)
names(all_stk) <-c("red","green","blue","nir","chm","NDVI","TDVI","SR","MSR","VVI","VARI","NDTI","RI","CI","BI","SI","HI","TGI","GLI","NGRDI")
head(all_stk)


# write
writeRaster(all_stk, file.path(envrmt$path_002_processed,"veg_ind_study_all_na.tif"),format="GTiff",overwrite=TRUE)
all_stk       <- raster::stack(file.path(envrmt$path_002_processed, "veg_ind_study_all_na.tif"))

#require(doParallel)
#open cluster
#cl =  makeCluster(detectCores()-1)
#registerDoParallel(cl)

### define layer names and filter indizes
#ln <- c("red","green","blue","nir","chm","NDVI","TDVI","SR","MSR","VVI","VARI","NDTI","RI","CI","BI","SI","HI","TGI","GLI","NGRDI")
#fil <- filter_Stk(all_stk,fLS=("sobel"), sizes=c(9),layernames=ln)
#names(fil)

#stack
#ind_fil <- raster::stack(all_stk,fil)
#head(ind_fil)
# perform Cor Test
y <- detct_RstCor(veg,0.7)
#names(y)
# to return the Correlation Matrix
yz <- detct_RstCor(ind_stk,0.7,returnCorTab=TRUE)



# write
writeRaster(ind_fil, file.path(envrmt$path_002_processed,"veg_ind_fil_test_area.tif"),format="GTiff",overwrite=TRUE)