### Setup project folders and set root dir

# Set project specific subfolders
cat("#--- set Folders ---#",sep = "\n")
project_folders = c("data/", 
                    "data/original/",
                    "data/original/01_Study_area_Vorarlberg/",
                    "data/original/01_Study_area_Vorarlberg/geometry/",
                    "data/original/01_Study_area_Vorarlberg/Lidar/",
                    "data/original/01_Study_area_Vorarlberg/shp/",
                    "data/original/01_Study_area_Vorarlberg/spectral/",
                    "data/001_org/",
                    "data/001_org/02_Ecotone_sites/",
                    "data/001_org/02_Ecotone_sites/CHM/",
                    "data/001_org/02_Ecotone_sites/DEM/",
                    "data/001_org/02_Ecotone_sites/DSM/",
                    "data/001_org/02_Ecotone_sites/IR/",
                    "data/001_org/02_Ecotone_sites/RGB/",
                    "data/001_org/02_Ecotone_sites/shp/",
                    "data/001_org/02_Ecotone_sites/las/",
                    "data/001_org/02_Ecotone_sites/Hillshade/",
                    "data/001_org/03_Segmentation_sites/",
                    "data/001_org/03_Segmentation_sites/CHM/",
                    "data/001_org/03_Segmentation_sites/DEM/",
                    "data/001_org/03_Segmentation_sites/DSM/",
                    "data/001_org/03_Segmentation_sites/IR/",
                    "data/001_org/03_Segmentation_sites/RGB/",
                    "data/001_org/03_Segmentation_sites/shp/",
                    "data/001_org/03_Segmentation_sites/Hillshade/",
                    "data/001_org/03_Segmentation_sites/las/",
                    "data/002_processed/",
                    "tmp/", # tmp folder for saga data
                    "repo/src/"   #for scripts
)

# Automatically set root directory, folder structure and load libraries
cat("#--- set up Environment  ---#",sep = "\n")
envrmt = createEnvi(root_folder = "E:/Github/Treelines-of-the-world", 
                    folders = project_folders, 
                    path_prefix = "path_", libs = libs,
                    alt_env_id = "COMPUTERNAME", alt_env_value = "PCRZP",
                    alt_env_root_folder = "F:/edu/Envimaster-Geomorph/")

cat("#--- use '(file.path(envrmt$...) to set path to folderstructure ---#",sep = "\n")


cat("#--- linking SAGA  ---#",sep = "\n")
cat("#--- this could take a while  ---#",sep = "\n")
saga<-linkSAGA(ver_select = TRUE)
env<-RSAGA::rsaga.env(path = saga$sagaPath)

rm(libs)
cat(" ",sep = "\n")
cat(" ",sep = "\n")
cat(" ",sep = "\n")


cat("----------------ENVIRONMENT-READY-----------------",sep = "\n")


