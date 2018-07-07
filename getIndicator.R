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

## Get company name
## comma separated list of SEC CIK
companies <- "1166126"
resFormat <- "json"

## get indicators

indicators <- ""
#indicators <-
#  "Assets,AccountsPayableCurrent,Cash,DebtCurrent"
companies <- "1166126"
## comma separated list of periods. No info at this time.
## periods <-""
frequency <- "q"      ## y for yearly or q for quarterly
period_type <- "end_date"    ## see website for info

body <-  list(
  companies = companies,
  frequency = frequency,
  period_type = period_type,
  token = tokenString
)

## get available indicators for this company
res <- GET(indicatorEndPoint, query = body)
res <- content(res, "parsed", "text/csv")
availableIndicators <-
  as.data.frame(res)['indicator_id']   #stored list of indicators here.

if (indicators == "" ||
    !exists("indicators") || is.null(indicators)) {
  body <-
    list(
      companies = companies,
      frequency = frequency,
      period_type = period_type,
      token = tokenString
    )
} else{
  body <-
    list(
      indicators = indicators,
      companies = companies,
      frequency = frequency,
      period_type = period_type,
      token = tokenString
    )
}
res <- GET(indicatorEndPoint, query = body)
res <- content(res, "parsed", "text/csv")
res <- as.data.frame(res)
## make indicator_id colum become row names
rownames(res) <- unlist(res['indicator_id'])

## remove these columns
res['indicator_id'] = NULL
res['company_id'] = NULL

## transpose
res <- t(res) %>% as.data.frame()
#plot.ts(res,nc=2)

res.long <- cbind(rownames(res), res)
rownames(res.long) <- c()
colnames(res.long)[1] <- "quarter"
res.long <-  gather(res.long, v, value, -quarter)

## convert quarter to Date type to sort
res.long <- transform(res.long, quarter = as.Date(quarter))
res.long <- arrange(res.long, quarter)

## plot as 2 columns
write.csv(res, file = "jcp.csv")
#ggplot(res.long, aes(quarter, value, colour = v)) + geom_point()
#ggplot(na.omit(res.long), aes(quarter, value, colour = v)) + geom_point()

# linear regression. CommonStockValue to Assets and Liabilities
fit <-
  lm(
    CommonStockValue ~ Assets + Liabilities,
    data = res
  )
residuals(fit)
coefficients(fit)
summary(fit)