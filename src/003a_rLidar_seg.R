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

# load data
chm_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree_shrub.tif")) 
chm_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_tree.tif"))
chm_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub.tif"))
chm_shrub_2     <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_CHM, "CHM_shrub_2.tif"))

# Set the loc parameter
sCHM<-CHMsmoothing(chm, filter="mean", ws=5) # smoothing CHM
loc<-FindTreesCHM(sCHM, fws=5, minht=8)      # or import a tree list

# Set the maxcrown parameter
maxcrown=10.0 

# Set the exclusion parameter
exclusion=0.3 # 30

# Compute individual tree detection canopy area
canopy<-ForestCAS(chm, loc, maxcrown, exclusion)

#==================================================================================#
# Retrieving the boundary for individual tree detection and canopy area calculation
#==================================================================================#
boundaryTrees<-canopy[[1]]
# Plotting the individual tree canopy boundary over the CHM
plot(chm, main="LiDAR-derived CHM") 
plot(boundaryTrees, add=T, border='red', bg='transparent') # adding tree canopy boundary

#============================================================================#
# Retrieving the list of individual trees detected for canopy area calculation
#============================================================================#
canopyList<-canopy[[2]] # list of ground-projected areas of individual tree canopies
summary(canopyList)     # summary 

# Spatial location of the trees
library(sp)
XY<-SpatialPoints(canopyList[,1:2])    # Spatial points
plot(XY, col="black", add=T, pch="*")  # adding tree location to the plot
