# require libs for setup           
require(raster)                   
require(envimaR)                              
require(link2GI)                             

# define needed libs                                                          
libs = c("link2GI","lidR","LEGION") 
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

# load files 

rgb_tree_shrub  <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree_shrub.tif")) 
rgb_tree        <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_tree.tif"))
rgb_shrub       <- raster::stack(file.path(envrmt$path_03_Segmentation_sites_RGB, "RGB_shrub.tif"))

ir_tree_shrub  <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_IR, "IR_tree_shrub.tif")) 
ir_tree        <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_IR, "IR_tree.tif"))
ir_shrub       <- raster::raster(file.path(envrmt$path_03_Segmentation_sites_IR, "IR_shrub.tif"))




# stack
tree <- stack(rgb_tree,ir_tree)
head(tree)
plot(tree)

# ir indizes
ir_ind <- LEGION::vegInd_mspec(tree,red= 1, green = 2, blue = 3, nir = 4, indlist = "all")

#visualize
head(ir_ind)
plot(ir_ind$NDVI)
plot(ir_ind$TDVI)
plot(ir_ind$SR)
plot(ir_ind$MSR)

# stack
ind_stk <- raster::stack(tree,ir_ind)
head(ind_stk)

#rgb indizes
rgb_ind <-LEGION::vegInd_RGB(rgb_tree,1,2,3, indlist = "all")
head(rgb_ind)

#stack
all_stk <- raster::stack(ind_stk,rgb_ind)
head(all_stk)

# write
writeRaster(all_stk, file.path(envrmt$path_002_processed,"veg_ind.tif"),format="GTiff",overwrite=TRUE)

### define layer names and filter indizes
ln <- c("red","green","blue","nir","NDVI","TDVI","SR","MSR","VVI","VARI","NDTI","RI","CI","BI","SI","HI","TGI","GLI","NGRDI")
fil <- filter_Stk(all_stk,fLS="all",sizes=c(3,5),layernames=ln)
names(fil)


ind_fil <- raster::stack(ind,fil)

# perform Cor Test
y <- detct_RstCor(ind,0.7)
names(y)
# to return the Correlation Matrix
yz <- detct_RstCor(ind,0.7,returnCorTab=TRUE)



# write
writeRaster(ind, file.path(envrmt$path_002_processed,"veg_ind.tif"),format="GTiff",overwrite=TRUE)