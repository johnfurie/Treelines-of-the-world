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
source(file.path(root_folder, paste0(pathdir,"01b_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################

require(CENITH) 

# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))


vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))



# compare coordinate system of datasets
compareCRS(chm,vp)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)


# CENITH validation V2.1 different moving window sizes computed and search for max hitrate to use settings for segmentation
# tree
valt <- BestSegVal(chm = chm_tree, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(0.5,5,0.25),
                  vp = vp_shrub_2,
                  MIN = 10,
                  MAX = 500000,
                  filter = 1
                  )

# shrub
vals <- BestSegVal(chm = chm_shrub, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(0.1,2,0.1),
                  vp = vp_shrub_2,
                  MIN = 10,
                  MAX = 500000,
                  filter = 1
                  )

valts <- BestSegVal(chm = chm_tree_shrub, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(0.2,4,0.2),
                  vp = vp_shrub_2,
                  MIN = 10,
                  MAX = 500000,
                  filter = 1
) 

 
#stop cluster
stopCluster(cl)

# write table
write.table(valt, file.path(envrmt$path_002_processed,"validaton_accuracy_tree.csv"))
write.table(vals, file.path(envrmt$path_002_processed,"validaton_accuracy_shrub.csv"))
write.table(valts, file.path(envrmt$path_002_processed,"validaton_accuracy_tree_shrub.csv"))

# view table
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy_tree.csv"))
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy_shrub.csv"))
tab <- read.table(file.path(envrmt$path_002_processed,"validaton_accuracy_tree_shrub.csv"))
