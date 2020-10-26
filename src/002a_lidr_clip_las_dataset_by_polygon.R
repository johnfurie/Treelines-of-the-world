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

library(lidR)

LASfile <- "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/11225103_HH.las"
readLAS(LASfile)
ctg = catalog(LASfile)

tree <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tree.shp"))
shrub <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"shrub.shp"))
tree_shrub <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tree_shrub.shp"))
shrub_2 <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"shrub_2.shp"))

i = 1
p = tree_shrub@polygons[[1]]@Polygons[[i]]

tr = lasclip(ctg, p)


writeLAS(tr, "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/tree_shrub.las")

plot(tr)
