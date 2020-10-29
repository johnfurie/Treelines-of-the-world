################################## Setup environment#########################################

# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI") 
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

# load packages                                
require(lidR)

# read lidar data
LASfile <- file.path(envrmt$path_las, "11225103_HH.las")

tree <- file.path(envrmt$path_las, "tree.las")
tree_shrub <- file.path(envrmt$path_las, "tree_shrub.las")
shrub <- file.path(envrmt$path_las, "shrub.las")
shrub_2 <- file.path(envrmt$path_las, "shrub_2.las")


las = lidR::readLAS(tree)
las = lidR::readLAS(shrub)
las = lidR::readLAS(tree_shrub)
las = lidR::readLAS(shrub_2)

# silva 2016
col <- pastel.colors(200)

chm <- grid_canopy(las, res = 0.5, p2r(0.3))
ker <- matrix(1,3,3)
chm <- raster::focal(chm, w = ker, fun = mean, na.rm = TRUE)

ttops <- find_trees(chm, lmf(4, 2))
las   <- segment_trees(las, silva2016(chm, ttops))
plot(las, color = "treeID", colorPalette = col)

#silva2016(chm, treetops, max_cr_factor = 0.6, exclusion = 0.3, ID = "treeID")