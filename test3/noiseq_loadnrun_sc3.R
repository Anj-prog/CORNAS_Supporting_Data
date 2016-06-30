# R script to run NOISeq given length and count files.
# length file should contain two tab columns, first one with IDs, the secound the lengths. There should be no headers.
# count files should contain only columns of the samples name as header, and the counts for all IDs. There should be no ID column.
# ensure the row order of the length file and count file are the same.

library("NOISeq")

args <- commandArgs(TRUE) 
lenfile <- args[1]
countfile <- args[2]

# load the lengths and ids
lengthstuff <- read.table(lenfile)
lengths <- as.numeric(lengthstuff$V2)
names(lengths) <- as.character(lengthstuff$V1)

# load the countfile and make the subset pair
datapair <- read.table(countfile,row.names=1,sep="\t")

testfactors <- data.frame(Tissue=c("V2","V3"))

#load into NOISeq
testdata1 <- readData(data=datapair, length=lengths, factors=testfactors)
testdata1 # output stderr for record.


# run basic RPKM analysis
mynoiseqtest1 = noiseq(testdata1 , k = 0.5, norm = "rpkm", factor = "Tissue", pnr = 0.2, nss = 5, v = 0.02, lc = 1, replicates = "no")

write.table(mynoiseqtest1@results[[1]], file=paste(countfile, "noiseq-sim.rpkm.tab", sep="_"), sep="\t", row.names=TRUE)



