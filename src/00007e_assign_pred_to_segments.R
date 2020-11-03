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

# assign value to polygons
seg <- readOGR(dsn=file.path(envrmt$path_002_processed, "lidr_seg_dal_ts.shp"))
specter  <- raster::raster(file.path(envrmt$path_002_processed,"ft_prediction.tif"))

#make dataframe with treeID
b <- seg$treeID
head(b)
b <- as.data.frame(b)
head(b)
#rownames
names(b) <- (c("treeID"))

# extract values of predicted raster and assign to segmentation polygons
a <- extract(specter, seg, fun=mean, na.rm=TRUE)
head(a)
a <- as.data.frame(a)
#rownames
names(a) <- (c("value"))
#rounding numbers
a <- a %>% mutate_at(vars(starts_with("value")), funs(round(a$value, 0)))
head(a)
#combine 2 dataframes
c <- cbind(a,b)
head(c)

#merge with polygon
oo <- merge(seg,c, by="treeID", all=T)

head(oo)
plot(oo)

# write VECTOR
writeOGR(oo, file.path(envrmt$path_002_processed, "lidr_pred.shp"),layer="testShape",driver="ESRI Shapefile")







