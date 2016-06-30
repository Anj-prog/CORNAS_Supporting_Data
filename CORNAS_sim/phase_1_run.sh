#!/bin/sh

#$ -cwd
#$ -N phase_1_run 
#$ -j y
#$ -V

# may want to run a few of these in parallel

date
perl ConPop_sim.pl conpop.config
date
