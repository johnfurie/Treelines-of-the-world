# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal","randomForest","doParallel","parallel","caret","CAST","dplyr","tigris","sp","mapview") 
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

# load the data
rfModel <- readRDS(file.path(envrmt$path_002_processed, "rf_model.rds"))
head(rfModel)
### evaluate the model

plot(varImp(rfModel))

rfModel$selectedvars

plot_ffs(rfModel)
plot_ffs(rfModel, plotType = "selected")

pred <- predict(rfModel, dat)

cfmatrix <- caret::confusionMatrix(pred, dat$FE_DWBAGRP)
print(cfmatrix)

### predict tree species 
rs  <- raster::stack(file.path(envrmt$path_002_processed, "pca_e2_map.tif"))
rgb  <- raster::stack(file.path(envrmt$path_02_Ecotone_sites_RGB, "RGB_e2.tif"))

rs <- stack(rs,rgb)


names(rs) <- (c("pca1","pca2","pca3","red","green","blue"))
head(rs)

cl =  makeCluster(detectCores()-1) #open cluster
registerDoParallel(cl)

specter <- raster::predict(rs, rfModel)
stopCluster(cl) #close cluster

writeRaster(specter, file.path(envrmt$path_002_processed,"rf_prediction_e2.tif"), overwrite=T)

plot(specter)
plot(seg, add=T)



