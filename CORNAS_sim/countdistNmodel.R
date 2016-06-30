# R script to calculate the mean, var, sd, min and max for the shufflemerandomlyNcount.pl output.
# NOTE: catenate the total amount of replicates you want in a file for the run.

args <- commandArgs(TRUE)
infile1 <- args[1]
data.ex1=read.table(infile1,sep="\t")
output.mean = apply(data.ex1,2,mean)
output.var = apply(data.ex1,2,var)
output.sd = apply(data.ex1,2,sd)
output.min = apply(data.ex1,2,min)
output.max = apply(data.ex1,2,max)
output.ex1=rbind(output.mean,output.var,output.sd,output.min,output.max)
write(output.ex1,file=paste(infile1,".meanvarsd.out",sep=""),ncolumns=5,append=FALSE,sep="\t")

# further calculate the linear model function:
data.ex1 <- read.table(file=paste(infile1,".meanvarsd.out",sep=""),sep="\t")
rname <- row.names(data.ex1)
attach(data.ex1)
rnameN <- as.numeric(rname)
lmout <- lm(V1~rnameN)
lmout2 <- lm(V1~V2)
sink(file=paste(infile1,".lm.out",sep=""))
cat("***True Count vs Observed Count output***",end="\n")
summary(lmout)
cat("x_INTERCEPT(C)",lmout[[1]][[1]],sep=" ",end="\n")
cat("x_GRADIENT(M)",lmout[[1]][[2]],sep=" ",end="\n")
cat ("\n")
cat("***Mean vs Var output***",end="\n")
summary(lmout2)
cat("m_INTERCEPT(C)",lmout2[[1]][[1]],sep=" ",end="\n")
cat("m_GRADIENT(M)",lmout2[[1]][[2]],sep=" ",end="\n")

sink()

