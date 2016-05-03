library("shiny")

shinyUI(fluidPage(
	title="2009 US unemployment",
	
	h2("2009 US County Level Unemployment, Poverty rate and Median Income Visualization"),

	sidebarLayout(
		
		sidebarPanel(
			selectInput("state", label = "Select the States:", multiple = F,
						choices = c("all","alabama","arizona","arkansas","california","colorado","connecticut","delaware",
									"district of columbia","florida","georgia","idaho","illinois","indiana","iowa","kansas","kentucky",
									"louisiana","maine","maryland","massachusetts","michigan","minnesota","mississippi","missouri","montana",
									"nebraska","nevada","new hampshire","new jersey","new mexico","new york","north carolina","north dakota",
									"ohio","oklahoma","oregon","pennsylvania","rhode island","south carolina","south dakota","tennessee",
									"texas","utah","vermont","virginia","washington","west virginia","wisconsin","wyoming")),
			selectInput("metric", label = "Do you want to see unemployment rate, poverty rate or median income level?", 
						choices = c("Unemployment Rate", "Poverty Rate Among All", 
									"Poverty Rate Among Under 18", "Poverty Rate 5 to 17 years old",
									"Median Income Level"))
			
			),
		mainPanel(
			plotOutput("map"),
			dataTableOutput("table")
		)
	)	
))
