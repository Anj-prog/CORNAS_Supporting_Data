#!/usr/bin/perl

# computes a matrix of probabilities for Oc with prob_Oc_calc.R


use warnings;
use strict;

my $infile1 = $ARGV[0]; # output from countdistNmodel.R, e.g. conpop_0.01cov_sim_100Kcount_total_2000reps.out.meanvarsd.out
my $cov1 = $ARGV[1]; # coverage
my $mgrad = $ARGV[2]; # mean/var of sim taken from .out.lm.out
my $tc1 = $ARGV[3]; # true count start
my $tc2 = $ARGV[4]; # true count end


my $ar = @ARGV;
if($ar<5){die "Usage:$0 <infile.out.meanvarsd.out> <cov> <slope> <Tc_start> <Tc_end>\n";}

# executable file path
my @pathlines =split ("\/",$0);
pop @pathlines;
my $pathy = join("\/",@pathlines);
if ($pathy) {
	$pathy .= "\/";
}


my $script = $pathy."prob_Oc_calc.R";
open (MYOUTFILE1, ">Oc_genpois_table.$cov1.Tc.$tc1.to.$tc2.out");
print MYOUTFILE1 "Oc\tTc\tP\n";

my @means = `awk \'\{print \$1\}\' $infile1`;

if ($tc2 > scalar(@means)) { # if chosen parameter overshoots the number of Tc generated, revert to max Tc.
	$tc2 = scalar(@means);
} 

for (my $i = ($tc1-1); $i< $tc2; $i++) {
my $obs1 = 0;
my $obs2 = $i+1; #observed count can't be more than true count
chomp $means[$i];
my @s1_results = `Rscript $script $obs1 $obs2 $means[$i] $mgrad 2\>\/dev\/null`;


#save the previous results into files
my $obsc = 0;

foreach my $line1(@s1_results) {
	chomp $line1;
	print MYOUTFILE1 $obsc,"\t",$i+1,"\t", $line1,"\n";	
	$obsc++;
}

}
close (MYOUTFILE1);

