installAndRequireLibs <- function(libs){
	libsMissing <- libs[!libs %in% row.names(installed.packages())]
	if(length(libsMissing)>0)install.packages(libs)
	for(lib in libs)library(lib,character.only = T)
}

PovertyMap <- function(state, metric, mydf, legendTex, legendColor){
	if(state=="all"){
		map("county", lty=0, fill=T, col=mydf[[metric]], 
			projection="polyconic",
			resolution=0, myborder=0, mar=c(0,0,0,0))
		map("state", col = "white", fill = FALSE, add = TRUE,
			lty = 1, lwd = 1, projection = "polyconic", 
			myborder = 0, mar = c(0,0,0,0))
	}else{
		map("county", region=state, lty=0, fill=T, col=mydf[[metric]][grepl(state,mydf$polyname)], 
			projection="polyconic",
			resolution=0, myborder=0, mar=c(0,0,0,0))
	    map("county", region=state, col="white", fill = FALSE, add=T,
	        lty=1, lwd=1, projection="polyconic",
	        myborder=0, mar=c(0,0,0,0))
	}
	legend("bottomleft", legend=legendTex, fill=legendColor)
}

PovertyTable <- function(state, numCol,mydf ){
	if(state=="all"){
		mytable <- mydf[c("polyname",numCol)]
	}else{
		mytable <- subset(mydf, grepl(state,polyname))[c("polyname",numCol)]
	}
	mytable <- mytable[order(mytable[[numCol]], decreasing=T),]
}