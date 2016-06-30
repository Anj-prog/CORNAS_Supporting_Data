#!/bin/sh

#$ -cwd
#$ -N phase_2_run 
#$ -j y
#$ -V

date
Rscript countdistNmodel.R conpop_sim_test1.0.01.all
perl run_table_Oc.pl conpop_sim_test1.0.01.all.meansvarsd.out 0.01 0.967  1 1000
perl run_table_Tc.pl 1000000 0.01 0.967 0 1000
date
