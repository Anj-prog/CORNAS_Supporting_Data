# CORNAS Sim Package #
The package only works on Unix-based systems and contains files used in the CORNAS paper. It is presented here to replicate the results discussed. For the actual working program, please see [CORNAS](https://github.com/joel-lzb/CORNAS).

The package contains the following essential files:

1. `conpop.config`
2. `ConPop_sim.pl`
3. `shufflemerandomlyNcount.pl`
4. `countdistNmodel.R`
5. `run_dpois_table_Oc.pl`
6. `dpois_calc_Oc.R`
7. `run_dpois_table_Tc.pl`
8. `dpois_calc_Tc.R`
		
NOTE: all the files above must be in the same directory.

The required program prerequisites:

1. Perl (v5.10.1 or higher)
2. Perl function Math::Random::MT
3. R (3.0.0 or higher)
4. R package Brobdingnag (1.2-4 or higher)

NOTE: Ensure Rscript can be called in the environment.

The program is optimized for parellel computing with the Sun Grid Engine (SGE), and have the following additional scripts as examples:

1. `phase_1_run.sh`
2. `phase_2_run.sh`



## Section 1: HOWTO ##
There are two Phases:

### Phase 1: Simulate the counts from sequencing
1. Edit the `conpop.config` file to suite experimental target.

2. Due to the length of time it may take to run a large simulation, it is best to break replicates into multiple runs, each with its own `conpop.config`, with the same experimental parameters. These can later be combined for **Phase 2**.

3. Run the following command for each configuration. If using SGE, the `phase_1_run.sh` can be edited and run similarly.

			perl ConPop_sim.pl conpop.config
	
4. Compile the multiple runs of a single coverage together:

			cat conpop_sim_test* > conpop_sim_test_all

### Phase 2: Calculate the model parameters for a coverage and tabulate probabilities
1. Run the following R script as follows on **Phase 1 (4)** result:

			Rscript countdistNmodel.R conpop_sim_test_all

	The script will generate the following files:

		1. conpop_sim_test_all.meansvarsd.out
		2. conpop_sim_test_all.lm.out

2. The following script is run to calculate the probabilities of observed counts given a true count; P(O=x|T=k). For the command example below, we used a coverage of 0.01, with a calculated mean/var of 0.967 (taken from `conpop_sim_test_all.lm.out` result) for true counts 1 to 1000:

			perl run_table_Oc.pl conpop_sim_test_all.meansvarsd.out 0.01 0.967 1 1000
	
	The script will generate a file that contains the probability values for each observed count-true count pair; e.g.: `Oc_genpois_table.0.01.Tc.1.to.1000.out`.
	
3. The following script is run to calculate the probabilities of true counts given an observed count; P(T=k|O=x). For the command example below, we used a coverage of 0.01, with a calculated mean/var of 0.967 (taken from `conpop_sim_test_all.lm.out` result) for observed counts 0 to 1000, with a maximal true count limit of 1 million:

			perl run_table_Tc.pl 1000000 0.01 0.967 0 1000
	

	
## Section 2: File information ##

This section details the separate files and their functions.

### Section 2.1: `conpop.config`
This is the main configuration file for starting a new simulation run. **Section 2.2** requires this file. It has two parts that requires input:

PART A -> options to set the population size by either:

		1. exact size.
		2. simulate population size from known library preparation procedure.

PART B -> fields to simulate the random selection for sequencing and output file name.


### Section 2.2: `ConPop_sim.pl`

		Usage:perl ConPop_sim.pl <config file>

This script calculates the required parameters for the **Section 2.3** script to make the necessary simulation. It also tracks the number of replicates completed.


### Section 2.3: `shufflemerandomlyNcount.pl`

		Usage:perl shufflemerandomlyNcount.pl <population size> <sample size> <max_count> <output_file> 

NOTE: the output file may come from a previous replicated run and the program will append a line to the file.


### Section 2.4: `countdistNmodel.R`

		Usage: Rscript countdistNmodel.R <infile>

The `infile` is the `output_file` of **Section 2.3**. It can be a catenation of multiple output files that are replicates. This script calculates the required statistics and linear model functions. It generates two outputs:

1. `infile.meansvarsd.out` -> tab-delimited file where each line is a true count made from 1 to `max_count` (see **Section 2.2**) and the columns denote:

	1. mean
	2. variance
	3. standard deviation
	4. minimum observed count
	5. maximum observed count
		
2.  `infile.lm.out` -> The linear models for:

	1. True count vs Observed count
	2. Mean vs Variance



### Section 2.5: `run_table_Oc.pl`

		Usage:perl run_table_Oc.pl <infile.out.meanvarsd.out> <cov> <slope> <Tc_start> <Tc_end>

This script computes a matrix of probabilities for observed counts (Oc) with `prob_Oc_calc.R` (**Section 2.6**). It takes the `infile.meansvarsd.out` output of `countdistNmodel.R` and a tab-delimited file with the following columns:

1. Observed count (Oc)
2. True count (Tc)
3. Probability of Oc given Tc (P)

The slope information is obtained from the `infile.lm.out` output of `countdistNmodel.R` as the GRADIENT(M).


### Section 2.6: `prob_Oc_calc.R`

		Usage: Rscript prob_Oc_calc.R <Oc_start> <Oc_end> <lambda> <pweight>

This script contains the General Poisson model function (Consul and Jain, 1973) to calculate the probability of an observed count. The `lambda` is the mean of the distribution, while `pweight` is the mean/var relationship. These parameters are generated and controlled by the script in **Section 2.5**.


### Section 2.7: `run_table_Tc.pl`

		Usage:perl run_table_Tc.pl <max Tc> <cov> <slope> <obs_start> <obs_end>

This script computes a matrix of probabilities for true counts (Tc) with `prob_Tc_calc.R` (**Section 2.8**).

It generates a tab-delimited file with the following columns:

1. True count (Tc)
2. Observed count (Oc)
3. Probability of Tc given Oc (P)

The slope information is obtained from the `infile.lm.out` output of `countdistNmodel.R` as the GRADIENT(M).


### Section 2.8: `prob_Tc_calc.R`

		Usage: Rscript prob_Tc_calc.R <cov> <slope> <Tc start> <Tc end> <Oc> <max Tc>

This script computes the posterior distribution for true counts given an observed count. These parameters are generated and controlled by the script in **Section 2.7**.




## Section 3: References ###

Consul, P. C. and Jain, G. C. (1973). A generalization of the poisson distribution. Technometrics, 15(4), 791–799.



## Section 4: AUTHORS & COPYRIGHT ##

CORNAS was developed by Joel Low Zi-Bin, Tsung Fei Khang & Martti T. Tammi.

Copyright is under MIT license (see LICENSE.txt).
