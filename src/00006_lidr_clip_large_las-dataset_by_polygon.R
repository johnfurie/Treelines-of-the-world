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

library(lidR)

# read large las file via catalog
LASfile <- "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/11225103_HH.las"

#readLAS(LASfile)
ctg = catalog(LASfile)

# load bbox shapefiles for segmentation sites
tree <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tree.shp"))
shrub <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"shrub.shp"))
tree_shrub <- rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tree_shrub.shp"))




# clip las file to polygon extent

# tree
i = 1
t = tree@polygons[[1]]@Polygons[[i]]

pt = lasclip(ctg, t)

# write las file
writeLAS(pt, "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/tree.las")

# plot las file
plot(pt)




# shrub
i = 1
s = shrub@polygons[[1]]@Polygons[[i]]

ps = lasclip(ctg, s)

# write las file
writeLAS(ps, "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/shrub.las")

# plot las file
plot(ps)




# tree shrub
i = 1
ts = tree_shrub@polygons[[1]]@Polygons[[i]]

pts = lasclip(ctg, ts)

# write las file
writeLAS(pts, "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/tree_shrub.las")

# plot las file
plot(pts)



