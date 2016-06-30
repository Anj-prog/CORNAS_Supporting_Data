# R function to calculate the probability of an observed count given a true count according to Generalized Poisson model: P(O|T)

args <- commandArgs(TRUE)
x1 <- as.numeric(args[1]) # Oc start
x2 <- as.numeric(args[2]) # Oc end
lambda <- as.numeric(args[3]) # the mean for each Tc
mgrad <- as.numeric(args[4]) # the slope


# calculate the pweight:
pweight = 1-(sqrt(mgrad))


#the general poisson model:

# genall <- c()
for (x in x1:x2) {
	nume <- log(lambda,base=exp(1)) + (x-1)*log(lambda+pweight*x,base=exp(1)) - (lambda + pweight*x)
	denom <- c()
	if (x == 0) { # 0! = 1
		denom = 0
	}else {
		denom = sum(log(x:1,base=exp(1)))
	}
	geny = nume - denom
	#genall <-c(genall,geny)
	#output.ex2=paste(x,geny)
	#cat(output.ex2)
	cat(geny,"\n")
}

#plot(as.brob(+exp(genall)))
