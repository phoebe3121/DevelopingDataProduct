source("helper.R")

library(data.table)
library(dplyr)
library(plyr)
library(maps)
library(RColorBrewer)
library(colorspace)
library(mapproj)
#installAndRequireLibs(c("data.table","dplyr","plyr","maps","RColorBrewer","colorspace"))

mydf <- readRDS(file="data/unemploymentPovertyIncome2009FIPS.rds")

## CREATE PARAMETERS NEEDED IN THE POVERTY PERCENT GRAPH
PovertyCut <- c(0,5,10,15,20,25,30,40,100)
PovertyCutTex <- c("<5%","5-10%","10-15%","15-20%","20-25%","25-30%","30-40%",">40%")

PovertyPercentColor <- brewer.pal(8, name="YlOrRd")

mydf$PovertyPercentAllColors <- PovertyPercentColor[
	as.numeric(
		cut(
			mydf$Poverty.Percent.All.Ages, PovertyCut
		)
	)
	]
mydf$PovertyPercentUnder18Colors <- PovertyPercentColor[
	as.numeric(
		cut(
			mydf$Poverty.Percent.Under.Age.18, PovertyCut
		)
	)
	]
mydf$PovertyPercent5to17Colors <- PovertyPercentColor[
	as.numeric(
		cut(
			mydf$Poverty.Percent.Ages.5.17, PovertyCut
		)
	)
	]

## CREATE PARAMETERS NEEDED IN THE UNEMPLOYMENT RATE GRAPH
UnempCut <- c(0,2,4,6,8,10,15,20,100)
UnempCutTex <- c("<2%","2-4%","4-6%","6-8%","8-10%","10-15%","15-20%",">20%")

UnempColor <- brewer.pal(8,name="YlOrRd")

mydf$unempColors <- UnempColor[
	as.numeric(
		cut(
			mydf$unemp, UnempCut)
		)
	]

## CREATE PARAMETERS NEEDED IN THE MEDIAN INDOME GRAPH
IncomeCut <- c(10000,20000,30000,35000,40000,45000,50000,60000,80000,100000,max(mydf$Median.Household.Income))
IncomeCutTex <- c("<$10K","$10K-20K","$20K-30K","$30K-40K","$40K-50K","$50K-60K","$60K-70K","$70K-80K","$80K-90K","$90K-100K",">$100K")

IncomeColor <- brewer.pal(11, name="RdBu")
mydf$incomeColors <- IncomeColor[
	as.numeric(
		cut(
			mydf$Median.Household.Income, IncomeCut
			)
		)
	]


shinyServer(function(input, output) {

	output$map <- renderPlot({	
		metric <-switch(input$metric,
						"Unemployment Rate" = 
							list("unempColors", UnempCutTex, UnempColor),
						"Poverty Rate Among All" = 
							list("PovertyPercentAllColors", PovertyCutTex, PovertyPercentColor), 
						"Poverty Rate Among Under 18" = 
							list("PovertyPercentUnder18Colors", PovertyCutTex, PovertyPercentColor), 
						"Poverty Rate 5 to 17 years old" = 
							list("PovertyPercent5to17Colors", PovertyCutTex, PovertyPercentColor),
						"Median Income Level" = 
							list("incomeColors", IncomeCutTex, IncomeColor))
		PovertyMap(state=input$state, metric=metric[[1]], mydf=mydf, legendTex=metric[[2]], legendColor=metric[[3]])
	})
	
	output$table <- renderDataTable({
		metric <-switch(input$metric,
						"Unemployment Rate" = "unemp",
						"Poverty Rate Among All" = "Poverty.Percent.All.Ages", 
						"Poverty Rate Among Under 18" = "Poverty.Percent.Under.Age.18", 
						"Poverty Rate 5 to 17 years old" = "Poverty.Percent.Ages.5.17",
						"Median Income Level" = "Median.Household.Income")
		PovertyTable(state=input$state, numCol=metric, mydf=mydf)
	})
		
})





