# R function to calculate the probability of a true count given an observed count according to a posterior distribution: P(T|O)

library("Brobdingnag")
options(max.print=100000000) #need to set to more than maxk

Pval_Tc3_brob_v2 <- function (b,s,k1,k2,x,maxk) { #log
	# b = coverage
	# s = gradient
	# k = true count
	# x = observed count
	# maxk = arbitrary maximum true count

	if (k1 < x) { # for Tc less than x, return(0)
		pvalall <- as.brob(0)
		if ((x-k1) != 1) {
			for (i in k1:(x-2)) {
				pvalall <- cbrob(pvalall, as.brob(0)) # creates as.brob(+exp(-Inf))
			}
		}
		k1 = x
	}
	
	k <- c(k1:k2)

		numerator = as.brob(exp(1))^(log(k, base=exp(1)) + (x-1)*log(b*k*sqrt(s)+x*(1-sqrt(s)),base=exp(1)) + (-b*k*sqrt(s)))
		if (x == 0) { 
			mink = 1 #true count cannot be zero
		} else {
			mink = x #since pvals aren't significant if true count less than observed counts (practically not possible), just take from observed counts onwards.
		}
		j <- c(mink:maxk)
		denominator_all <- as.brob(exp(1))^(log(j, base=exp(1)) + (x-1)*log(b*j*sqrt(s)+x*(1-sqrt(s)),base=exp(1)) + (-b*j*sqrt(s)))
		pvaltc = numerator/sum(denominator_all,na.rm=TRUE)
		
		
	if (exists("pvalall") == 1) {
		pvalall <- cbrob(pvalall, pvaltc)
		return(pvalall)
	} else {
		return(pvaltc)
	}	
}



args <- commandArgs(TRUE)
b <- as.numeric(args[1]) # coverage
s <- as.numeric(args[2]) # coverage's slope/gradient
k1 <- as.numeric(args[3]) # true counts (a range)
k2 <- as.numeric(args[4]) # true counts (a range)
x <- as.numeric(args[5]) # observed count
maxk <- as.numeric(args[6]) # arbitrary maximum true count


newstuff <- Pval_Tc3_brob_v2(b,s,k1,k2,x,maxk)
print(newstuff)

