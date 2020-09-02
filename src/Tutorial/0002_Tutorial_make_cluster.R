require(doParallel)
require(parallel)

#run cluster

cl =  makeCluster(detectCores()-1)
registerDoParallel(cl)

#stop cluster

stopCluster(cl)
