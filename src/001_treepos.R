################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","sf","mapview","rgdal","ForestTools","uavRst") 
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

# source Cenith validation v2.1
source(file.path(root_folder, paste0(pathdir,"CENITH_validation_V2.1/002_cenith_val_v2_1.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_validation_V2.1/sf_cenith_val_a_v2.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_validation_V2.1/sf_cenith_val_b_v2.R")))

#source CENITH V2
source(file.path(root_folder, paste0(pathdir,"CENITH_seg_V2/000_cenith_v2.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_seg_V2/sf_cenith_tiles.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_seg_V2/sf_cenith_tp_v2.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_seg_V2/sf_cenith_seg_tiles.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_seg_V2/sf_cenith_merge.R")))
source(file.path(root_folder, paste0(pathdir,"CENITH_seg_V2/sf_cenith_seg_v1.R"))) 

chm <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif"))   
vp <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub.shp"))

compareCRS(chm,vp)

# CENITH validation V2.1
val <- cenith_val_v2_1(chm=chm,f=1,a=c(0.1,0.2,0.3),b=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9),h=c(0.5,1,2,3,4,5,10),vp=vp)

val <- cenith_val_v2_1(chm=chm,f=1,a=c(0.04),b=c(0.01,1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9),h=c(10),vp=vp)
val
maxrow <- val[which.max(val$hit),] # search max value but return only 1 value
maxhit <- maxrow$hit
val[which(val$hit==maxhit),] 

# Cenith segmentation
seg <- Cenith(chm=chm,h=4,a=0.1,b=0.6)

mapview::mapview(seg$polygon)+vp
