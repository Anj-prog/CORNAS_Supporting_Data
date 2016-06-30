# Rscript for sampling a custom distribution and generate a count table. 

args <- commandArgs(TRUE)
infile <- args[1] # infile
s_size <- as.numeric(args[2]) # sample size
Tc_start <- as.numeric(args[3]) # the true count's Oc dist to sample from start
Tc_end <- as.numeric(args[4]) # the true count's Oc dist to sample to end
domany <- as.numeric(args[5]) # number of iterations

library("Brobdingnag")

data1 <- read.table(infile,sep="\t",header=TRUE)

cat ("Tc rep Oc\n")

# the sampling function
rMydist <- function(subset1,s_size) {
        Oc_num <- subset1$Oc
        probs <- as.numeric(as.brob(+exp(subset1$P)))
    sample(x = Oc_num, size = s_size,
           prob = probs, replace=T)
}

for (j in Tc_start:Tc_end){
subset1 <- data1[data1$Tc == j,]

for (i in 1:domany) {
        cat(j,i,rMydist(subset1,s_size),"\n")
}
}

