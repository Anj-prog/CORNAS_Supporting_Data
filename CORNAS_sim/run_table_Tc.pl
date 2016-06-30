#!/usr/bin/perl

# computes a matrix of probabilities for Tc with prob_Tc_calc.R


use warnings;
use strict;


my $maxk = $ARGV[0]; # arbitrary maximum for the truecount. practically, it should be no more than the obs(largest)/cov.
my $cov1 = $ARGV[1]; # coverage of Sample1
my $slope1 = $ARGV[2]; # slope of Sample1
my $obs1 = $ARGV[3]; # observed count (obs) start
my $obs2 = $ARGV[4]; # observed count (obs) end

my $ar = @ARGV;
if($ar<5){die "Usage:$0 <maxk> <cov1> <slope1> <obs_start> <obs_end>\n";}

# executable file path
my @pathlines =split ("\/",$0);
pop @pathlines;
my $pathy = join("\/",@pathlines);
if ($pathy) {
	$pathy .= "\/";
}


# the range of counts to calculate. current range is an integer set between obs1/cov1 and obs2/cov2:
#my $s1_trueLimit = sprintf("%.0f", ($obs1/$cov1));
#my $s2_trueLimit = sprintf("%.0f", ($obs2/$cov2));
#print "$s1_trueLimit\t$s2_trueLimit\n\n"; #debug

#force set limit:
my $s1_trueLimit = 1;
my $s2_trueLimit = $maxk;


# set within practical parameters:
if ($s1_trueLimit < 0) {
	print "$s1_trueLimit less than zero!\n";
	$s1_trueLimit = 0;
} elsif ($s1_trueLimit > $maxk){
	print "$s1_trueLimit more than maxk!\n";
	$s1_trueLimit = $maxk;
}

if ($s2_trueLimit < 0) {
	print "$s2_trueLimit less than zero!\n";
	$s2_trueLimit = 0;
} elsif ($s2_trueLimit > $maxk){
	print "$s2_trueLimit more than maxk!\n";
	$s2_trueLimit = $maxk;
}

# set upper and lower truecount limits:
my ($trueUpperLimit, $trueLowerLimit);
if ($s2_trueLimit > $s1_trueLimit) {
	$trueUpperLimit = $s2_trueLimit;
	$trueLowerLimit = $s1_trueLimit;
} else {
	$trueUpperLimit = $s1_trueLimit;
	$trueLowerLimit = $s2_trueLimit;	
}

#print "Sample A: cov=$cov1, slope=$slope1, obs=$obs1\n";
#print "Sample B: cov=$cov2, slope=$slope2, obs=$obs2\n";
#print "Truecount range: $trueLowerLimit to $trueUpperLimit\n\n";


my $script = $pathy."prob_Tc_calc.R";
open (MYOUTFILE1, ">Tc_posdist_table.$cov1.Oc.$obs1.to.$obs2.TcMax.$maxk.out");
print MYOUTFILE1 "Tc\tOc\tP\n";

for (my $i = $obs1; $i<= $obs2; $i++  ) {
my $s1_results = `Rscript $script $cov1 $slope1 $trueLowerLimit $trueUpperLimit $i $maxk 2\>\/dev\/null`;
chomp $s1_results;
my @s1_pval = split (" ",$s1_results);


#save the previous results into files
my $truec = 1;

foreach my $line1(@s1_pval) {
	if ($line1 =~ /^\+exp\((.*)\)$/) {
		my $num = sprintf("%.5f",$1);
		if ($num =~ /-inf/) {
			print MYOUTFILE1 $truec,"\t",$i,"\t","-Inf","\n";
		} else {
			print MYOUTFILE1 $truec,"\t",$i,"\t", $num,"\n";
		}		
		$truec++;
	}
}

}
close (MYOUTFILE1);

