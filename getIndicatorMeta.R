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

## get indicators
"
comma separated list of indicators
Assets
AssetsCurrent
CashAndCashEquivalentsAtCarryingValue
Liabilities
LiabilitiesCurrent
NetCashProvidedByUsedInFinancingActivities (yearly only)
NetCashProvidedByUsedInInvestingActivities (yearly only)
NetCashProvidedByUsedInOperatingActivities (yearly only)
OperatingIncomeLoss
PropertyPlantAndEquipmentNet
Revenues
"
indicators<- "Assets,AssetCurrent,Liabilities,OperatingIncomeLoss,PropertyPlantAndEquipmentNet"  
companies <- "1166126"
## comma separated list of periods. No info at this time.
## periods <-""
frequency <-"q"      ## y for yearly or q for quarterly
period_type<-"yq"    ## see website for info.

body <- list(indicators=indicators,companies=companies, frequency=frequency,period_type=period_type, token=tokenString)

res<-GET(indicatorEndPoint,query=body)
status_code(res)

content(res)
## get indicator metadata
