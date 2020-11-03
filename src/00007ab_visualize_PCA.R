# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION","rgdal","randomForest","doParallel","parallel","RStoolbox", "mapview","factoextra","ggplot2","corrplot") 
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

#read PCA
pca <- readRDS(file.path(envrmt$path_002_processed, "pca_shrub.rds"))

#visualize eigenvalue
eigval_pca <- factoextra::get_eigenvalue(pca$model)
eigval_pca
plot(eigval_pca)

##plot variances of each veg indice visualized in bars
barplot_var <- factoextra::fviz_eig(pca$model, choice = c("variance"), ylim=c(0,80), geom = c("bar", "line"), barfill = "#9DC3E6", 
                                    linecolor = "#000000", hjust = 0, addlabels = FALSE,ncp=11, main = "variance", 
                                    ggtheme = ggplot2::theme_gray())+
  ggplot2::theme(plot.title = element_text(hjust=0.5), axis.text = element_text(size = 38),axis.title.x = element_text(size = 38, margin = margin(t = 40, r = 0, b = 0, l = 0)), 
                 axis.title.y = element_text(size = 38, margin = margin(t = 0, r = 40, b = 0, l = 0)), title = element_text(size = 42))

barplot_var

#write plot as png
png(file.path(envrmt$path_002_processed, "barplotPCA_var.png"), res = 500, width=20, height = 20, units = "in") #setup png device

#print barplot
print(barplot_var)

#deactivate png device and default back to "R plot window"
dev.off() 




##plot variances of each veg indice visualized in bars
barplot_eig <- factoextra::fviz_eig(pca$model, choice = c("eigenvalue"), ylim=c(0,80), geom = c("bar", "line"), barfill = "#9DC3E6", 
                                    linecolor = "#000000", hjust = 0,ncp=11, addlabels = FALSE, main = "eigenvalue", 
                                    ggtheme = ggplot2::theme_gray())+
  ggplot2::theme(plot.title = element_text(hjust=0.5), axis.text = element_text(size = 38),axis.title.x = element_text(size = 38, margin = margin(t = 40, r = 0, b = 0, l = 0)), 
                 axis.title.y = element_text(size = 38, margin = margin(t = 0, r = 40, b = 0, l = 0)), title = element_text(size = 42))

barplot_eig

#write plot as png
png(file.path(envrmt$path_002_processed, "barplotPCA_eigval.png"), res = 500, width=20, height = 20, units = "in") #setup png device

#print barplot
print(barplot_eig)

#deactivate png device and default back to "R plot window"
dev.off()



#get variable contribution
var_pca <- factoextra::get_pca_var(pca$model) 

rownames(var_pca$contrib) <- c("red","green","blue","nir","NDVI","TDVI","SR","MSR")

colnames(var_pca$contrib) <- gsub(".", " ", colnames(var_pca$contrib), fixed = TRUE)
corrplot::corrplot(var_pca$contrib,is.corr = FALSE, method = "circle", type = "full", col = NULL, #plot variable contribution to grids
                   outline = TRUE, diag = TRUE, tl.col = "#000000", tl.cex = 3)

#write corrplot
png(file.path(envrmt$path_002_processed, "pointplotPCA.png"), res=500, width=20, height = 20, units = "in")

#print corrplot
print(corrplot::corrplot(var_pca$contrib,is.corr = FALSE, method = "circle", type = "full", col = NULL,
                         outline = TRUE, diag = TRUE, tl.col = "#000000", tl.cex = 3))
dev.off()



#plot stats of veg indices 
stats <- factoextra::fviz_pca_var(pca$model, col.var = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                                  alpha.var = "1",# add transparency according to cos2-values
                                  repel = TRUE,habillage ="none")+
  ggplot2::theme(plot.title = element_text(hjust=0.5), axis.text = element_text(size = 16),axis.title.x = element_text(size = 16, margin = margin(t = 40, r = 0, b = 0, l = 0)), 
                 axis.title.y = element_text(size = 16, margin = margin(t = 0, r = 40, b = 0, l = 0)), title = element_text(size = 24))

stats

#write stats of pca
png(file.path(envrmt$path_002_processed, "statsPCA.png"), res=350, width=10, height = 10, units = "in")

#print stats of pca
print(stats)
dev.off()


