# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal","randomForest","doParallel","parallel") 
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
dat1 <- readRDS(file.path(envrmt$path_002_processed,"traindat_study.rds"))
plot(dat1)
head(dat1)


a <- as.data.frame(dat1)
dat <- a
head(dat)
gc()
# make missing values to na
dat$train[dat$train == 0] <- NA
dat$red[dat$red == 0] <- NA
dat$green[dat$green == 0] <- NA
dat$blue[dat$blue == 0] <- NA
dat$pca1[dat$pca1 == 0] <- NA
dat$pca2[dat$pca2 == 0] <- NA
dat$pca3[dat$pca3 == 0] <- NA

# remove rows with na
dat <- dat[complete.cases(dat), ]

dat$train <- as.factor(dat$train)
write.table(dat, file.path(envrmt$path_002_processed,"traindat_study.csv"))
dat <- read.table(file.path(envrmt$path_002_processed,"traindat_study.csv"))
# prepare spatial folds
index = CAST::CreateSpacetimeFolds(dat,spacevar = "train", k = 5)


# train control for rf model - with LLO-CV based on forest sections
tC = caret::trainControl(method = "cv", number =  5,  classProbs = TRUE, index = index$index, indexOut = index$indexOut )

# training the model note that more than 50k objekts are nt possible with 16gb ram

cl =  makeCluster(detectCores()-2)
registerDoParallel(cl)

rfModel = CAST::ffs(dat[1:7], 
                    dat$train, 
                    method = "rf", withinSE = FALSE,
                    importance = TRUE, trainControl = tC)
stopCluster(cl)


saveRDS(rfModel,file.path(envrmt$path_002_processed, "rf_model.rds"))


