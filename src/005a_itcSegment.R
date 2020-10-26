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
require(itcSegment)


# read lidar data
LASfile <- "E:/Github/Treelines-of-the-world/data/001_org/03_Segmentation_sites/las/11225103_HH.las"
las = lidR::readLAS(LASfile)

data(las)

## function takes a while to run
se<-itcLiDAR(las$X,las$Y,las$Z,epsg=31254)
summary(se)
plot(se,axes=T)

## If we want to seperate the height of the trees by grayscales:

plot(se,col=gray((max(se$Height_m)-se$Height_m)/(max(se$Height_m)-min(se$Height_m))),axes=T)

## to save the data use rgdal function called writeOGR. For more help see rgdal package.

