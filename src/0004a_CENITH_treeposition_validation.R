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
root_folder = alternativeEnvi(root_folder = "C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world",                    
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
vp_tree         <-  rgdal::readOGR("C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world/repo/treeposition_pointshapes/ft_tpos_tv2.shp")
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))

vp_tree_shrub_s <- rgdal::readOGR("C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world/repo/data_exchange/tree_positions_final/vector/ft_tpos_ts_s.shp")


# compare coordinate system of datasets
compareCRS(chm_tree_shrub,vp_tree_shrub)
chm_tree_shrub@crs@projargs <- "+proj=tmerc +lat_0=0 +lon_0=10.3333333333333 +k=1 +x_0=0 +y_0=-5000000 +ellps=bessel +units=m +no_defs"
#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

n <- readOGR("C:/Users/Niklas/Documents/GitHub/Treelines-of-the-world/repo/data_exchange/tree_positions_final/vector/ft_tpos_ts.shp")
plot(n)
# CENITH validation V2.1 different moving window sizes computed and search for max hitrate to use settings for segmentation
# tree
valt <- BestSegVal(chm = chm_tree, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(2,20,1),
                  vp = vp_tree,
                  MIN = 10,
                  MAX = 500000,
                  filter = 3
                  )

# shrub
vals <- BestSegVal(chm = chm_shrub, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(0.1,2,0.1),
                  vp = vp_shrub,
                  MIN = 10,
                  MAX = 500000,
                  filter = 3
                  )

valts_s <- BestSegVal(chm = chm_tree_shrub, 
                  a = seq(0.1,0.9,0.1), 
                  b = seq(0.1,0.9,0.1),
                  h = seq(0.2,5,0.2),
                  vp = vp_tree_shrub_s,
                  MIN = 10,
                  MAX = 500000,
                  filter = 3
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
