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
root_folder = alternativeEnvi(root_folder = "E:/Github/Treelines-of-the-world",                    
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

# load data
chm <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif"))   
vp <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub.shp"))

# compare coordinate system of datasets
compareCRS(chm,vp)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


# CENITH validation V2.1 different moving window sizes computed and search for max hitrate to use settings for segmentation
val <- BestSegVal(chm = chm, 
                  a = seq(0.1,0.9,0.05), 
                  b = seq(0.1,0.9,0.05),
                  h = seq(0.5,5,0.5),
                  vp = vp,
                  MIN = 0,
                  MAX = 1000,
                  filter = 1
                  )

#stop cluster

stopCluster(cl)

# write table
write.table(val, file.path(envrmt$path_002_processed,"validaton_accuracy.csv"))

# view table
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy.csv"))
