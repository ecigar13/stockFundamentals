rm(list = ls())
gc()
cat("\f")
.rs.restartR()

## load all packages
lapply(.packages(all.available = TRUE), function(xx)
  library(xx,     character.only = TRUE))
