# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal","randomForest","doParallel","parallel","RStoolbox", "mapview","factoextra") 
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

#load indices
ind = raster::stack(file.path(envrmt$path_002_processed, "veg_ind_new31.tif"))
head(ind)

#set colnames
#names(ind) <- (c("red","green","blue","nir","NDVI","TDVI","SR","MSR"))
names(ind) <-c("red","green","blue","nir","chm","NDVI","TDVI","SR","MSR","VVI","VARI","NDTI","RI","CI","BI","SI","HI","TGI","GLI","NGRDI")

head(ind)

#get rid of last raster
#ind <- ind[[1:7]]

#calculate PCA
pca = RStoolbox::rasterPCA(ind,maskCheck = T, spca = T, nComp = 3)                    
head(pca)
mapview(pca$map)


#visualize eigenvalue
eigvalue.pca <- factoextra::get_eigenvalue(pca$model)
plot(eigvalue.pca)

#save PCA file
saveRDS(pca,file = file.path(envrmt$path_002_processed,"pca_train.rds"))
#read PCA
pca <- readRDS(file.path(envrmt$path_002_processed, "pca_train.rds"))

#write PCA maps
#writeRaster(pca$map$PC1, filename = file.path(envrmt$path_002_processed, "pca1_study.tif"), overwrite=TRUE)
#writeRaster(pca$map$PC2, filename = file.path(envrmt$path_002_processed, "pca2_study.tif"), overwrite=TRUE)
#writeRaster(pca$map$PC3, filename = file.path(envrmt$path_002_processed, "pca3_study.tif"), overwrite=TRUE)

#stack
a <- stack(pca$map$PC1,pca$map$PC2,pca$map$PC3)
writeRaster(a, filename = file.path(envrmt$path_002_processed, "pca_train_map.tif"), overwrite=TRUE)

#save PCA file
saveRDS(a,file = file.path(envrmt$path_002_processed,"pca_train_map.rds"))
