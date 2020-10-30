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
source(file.path(root_folder, paste0(pathdir,"01b_environment_setup_with_SAGA.R")))    

#############################################################################################
#############################################################################################

# load packages                                
require(lidR)

# read lidar data
LASfile <- file.path(envrmt$path_las, "11225103_HH.las")

tree <- file.path(envrmt$path_las, "tree.las")
tree_shrub <- file.path(envrmt$path_las, "tree_shrub.las")
shrub <- file.path(envrmt$path_las, "shrub.las")



las = lidR::readLAS(tree)
las = lidR::readLAS(shrub)
las = lidR::readLAS(tree_shrub)


# Using Li et al. (2012)
las <- segment_trees(las, li2012(R = 3, speed_up = 5))
plot(las, color = "treeID")

#li2012(
      dt1 = 1.5, dt2 = 2, R = 2, Zu = 15, hmin = 2, speed_up = 10)
