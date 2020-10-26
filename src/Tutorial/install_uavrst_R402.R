#Install uavrst package

# dependencies
require(devtools)
devtools::install_url('http://cran.r-project.org/src/contrib/Archive/spatial.tools/spatial.tools_1.6.2.tar.gz')
devtools::install_url('http://cran.r-project.org/src/contrib/Archive/velox/velox_0.2.0.tar.gz')

# uavrst package
devtools::install_github("gisma/uavRst", ref = "master",force=T)
