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

require(uavRst)
require(link2GI)
##- linkages
##- create and check the links to the GI software
giLinks<-uavRst::linkGI(linkItems = c("saga","gdal"))
if (giLinks$saga$exist ) {
  
  ##- project folder
  projRootDir<-tempdir()
  
  ##- create subfolders please mind that the pathes are exported as global variables
  paths<-link2GI::initProj(projRootDir = projRootDir,
                           projFolders = c("data/","data/ref/","output/","run/","las/"),
                           global = TRUE,
                           path_prefix = "path_")
  ##- overide trailing backslash issue
  path_run<-ifelse(Sys.info()["sysname"]=="Windows", sub("/$", "",path_run),path_run)
  setwd(path_run)
  unlink(paste0(path_run,"*"), force = TRUE)
  
  ##- get the data
  data(chm_seg)
  data(trp_seg)
  
  ##- tree segmentation
  crowns_GWS <- chmseg_GWS( treepos = vp_tree,
                            chm = chm_tree,
                            minTreeAlt = 10,
                            neighbour = 0,
                            thVarFeature = 1.,
                            thVarSpatial = 1.,
                            thSimilarity = 0.003,
                            giLinks = giLinks )[[2]]
  
  ##- visualize it
  raster::plot(crowns_GWS)
}

