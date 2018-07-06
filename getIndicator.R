## This doesn't always return all the requested columns
library(httr)
library(jsonlite)
library(tidyverse)
library(tidyr)

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
indicators<- "Assets,AssetCurrent,Liabilities,Revenues,OperatingIncomeLoss,PropertyPlantAndEquipmentNet"  
companies <- "1166126"
## comma separated list of periods. No info at this time.
## periods <-""
frequency <-"q"      ## y for yearly or q for quarterly
period_type<-"end_date"    ## see website for info

body <- list(indicators=indicators,companies=companies, frequency=frequency,period_type=period_type, token=tokenString)
res<-GET(indicatorEndPoint,query=body)

status_code(res)
csvRes <- content(res,"parsed","text/csv")
csvRes
dfRes <-as.data.frame(csvRes)

## make indicator_id colum become row names
rownames(dfRes)<- unlist(dfRes['indicator_id'])

## remove these columns
dfRes['indicator_id'] = NULL
dfRes['company_id']=NULL

## transpose
dfRes<-t(dfRes) %>% as.data.frame()
plot.ts(dfRes,nc=2)

dfRes.long<- cbind(rownames(dfRes),dfRes) 
rownames(dfRes.long) <- c()
colnames(dfRes.long)[1] <- "quarter"
dfRes.long <- gather(dfRes.long,v,value,Assets:PropertyPlantAndEquipmentNet)

## convert quarter to Date type to sort
dfRes.long<-transform(dfRes.long,quarter=as.Date(quarter))
dfRes.long<- arrange(dfRes.long,quarter)

## plot as 2 columns

ggplot(dfRes.long,aes(quarter,value,colour = v))+ geom_line(size=1)

## get indicator metadata
