args <- commandArgs(TRUE)
infile <- args[1] # infile
folddiff <- as.numeric(args[2]) # to select the count with a different fold.
outfile <- args[3] #output filename prefix
numpairs <- args[4] #number of output pairs/files

library("Brobdingnag")

data1 <- read.table(infile,header=TRUE)

# get unique Tc numbers:
tc_avail <- sort(unique(data1$Tc))

# random pairing for each Tc based on fold diff:
pickyfit <- function(tcA,folddiff,data1) {
	sampA <- data1[data1$Tc == tcA,]

	# take sample B's count as the folddiff of sample A, and resample (so not the same as sample A's)	
	tcB <- round(tcA*folddiff)
	subsetB <- data1[data1$Tc == tcB,]
	sampB <-subsetB[sample(nrow(subsetB)),]
	resultcom <- paste(sampA$Tc,sampA$Oc,sampB$Tc,sampB$Oc)
	return(resultcom)
}

#function to print out the reps into separate rep files.
printcol <- function(eachtc,numpairs) {
	for (b in 1:numpairs){
		pairfile <- paste(outfile,as.character(b),sep=".")
		write(eachtc[b], file=pairfile,append=TRUE,sep=" ")
	}
}

lappresults <- lapply(tc_avail, FUN=function(x) pickyfit(x,folddiff,data1)) 
lapply(lappresults, FUN=function(x) printcol(x,numpairs))

