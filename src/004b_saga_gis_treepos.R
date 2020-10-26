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

vp_tree_shrub   <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree_shrub_t.shp"))
vp_tree         <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_tree.shp"))
vp_shrub        <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub.shp"))
vp_shrub_2      <-  rgdal::readOGR(file.path(envrmt$path_03_Segmentation_sites_shp,"tpos_shrub_2.shp"))

# required packages
require(uavRst)
require(link2GI)

# create and check the links to the GI software
giLinks<-uavRst::linkGI()
if (giLinks$saga$exist & giLinks$otb$exist & giLinks$grass$exist) {
  
  # project folder
  projRootDir<-tempdir()
  
  # create subfolders please mind that the pathes are exported as global variables
  paths<-link2GI::initProj(projRootDir = projRootDir,
                           projFolders = c("data/","data/ref/","output/","run/","las/"),
                           global = TRUE,
                           path_prefix = "path_")
  
  data(chm_seg)
  
  # calculate treepos using uavRst generic approach
  tPos <- uavRst::treepos_GWS(chm = chm_tree,
                              minTreeAlt = 2,
                              maxCrownArea = 150,
                              join = 1,
                              thresh = 0.35,
                              split=TRUE,
                              cores=1,
                              giLinks = giLinks )
}