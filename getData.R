## use httr 
library(httr,jsonlite,tidyverse)

base = "https://api.usfundamentals.com";
compEndPoint <- paste(base,"/v1/companies/xbrl",sep='');
indicatorEndPoint <- paste(base,"/v1/indicators/xbrl",sep='');
metaEndPoint <-paste(base,"/v1/indicators/xbrl/meta",sep='');

## usfundamentals.com API token. It's free to signup
tokenString <- "Ld1Mss_3E3MrtMpV3dEsEg"

## Get company name
## comma separated list of SEC CIK
companies <- "1166126"
resFormat <- "json"
body <- list(companies=companies, format= resFormat, token=tokenString)

res<-GET(compEndPoint,query=body)
status_code(res)
str(content(res, "parsed"))
content(res)$args
