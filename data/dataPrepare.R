# Run this script, and you will get the input data frame which is used in the web app.
# Assume that R is running from where the script is.
source("../helper.R")
installAndRequireLibs(c("data.table","plyr","dplyr","maps", "RColorBrewer"))
data(unemp)
data(county.fips)

poverty <- read.csv("povertyEst2009.csv", colClasses="character")
poverty <- poverty[c("State.FIPS","County.FIPS","Postal","Name","Poverty.Estimate.All.Ages",
					 "Poverty.Percent.All.Ages","Poverty.Percent.Under.Age.18",
					 "Poverty.Percent.Ages.5.17","Median.Household.Income")]

poverty[["fips"]] <- as.integer(paste0(poverty[["State.FIPS"]], poverty[["County.FIPS"]]))

temp <- inner_join(unemp, poverty, by="fips")
temp <- inner_join(temp, county.fips, by="fips")


mydf <- temp[c("fips","pop","unemp","Poverty.Percent.All.Ages","Poverty.Percent.Under.Age.18","Poverty.Percent.Ages.5.17","Median.Household.Income","polyname")]

mydf[c("pop","Poverty.Percent.All.Ages","Poverty.Percent.Under.Age.18","Poverty.Percent.Ages.5.17")]<-lapply(
	mydf[c("pop","Poverty.Percent.All.Ages","Poverty.Percent.Under.Age.18","Poverty.Percent.Ages.5.17")], as.numeric) 
mydf[["Median.Household.Income"]] <- as.numeric(sub(",","",mydf[["Median.Household.Income"]]))


saveRDS(mydf, file="unemploymentPovertyIncome2009FIPS.rds")
rm(list=ls())
