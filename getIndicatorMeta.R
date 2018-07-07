## This doesn't always return all the requested columns
library(httr)
library(jsonlite)
library(tidyverse)
library(tidyr)

base = "https://api.usfundamentals.com"

compEndPoint <- paste(base, "/v1/companies/xbrl", sep = '')

indicatorEndPoint <- paste(base, "/v1/indicators/xbrl", sep = '')

metaEndPoint <- paste(base, "/v1/indicators/xbrl/meta", sep = '')


## usfundamentals.com API token. It's free to signup
tokenString <- "Ld1Mss_3E3MrtMpV3dEsEg"
indicators <- ""  ##optional
freq <- "q"
period_type <- "end_date"

body <-
  list(frequency = freq,
       period_type = period_type,
       token = tokenString)
res <- GET(metaEndPoint, query = body)
res <- content(res, "parsed", "text/csv")
res <- as.data.frame(res)
