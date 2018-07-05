rm(list = ls())
.rs.restartR()
gc()

## load all packages
lapply(.packages(all.available = TRUE), function(xx) library(xx,     character.only = TRUE)) 



