#!/usr/bin/perl

# takes tab file and makes pairings with columns

use warnings;
use strict;

my $infile = $ARGV[0];

my $ar = @ARGV;
if($ar<1){die "Usage:$0 <infile> \n";}

for (my $i=2; $i <7; $i++) {
	for (my $j=7; $j <12; $j++) {
		my $sA = $i-1;
		my $sB = $j-1;
		`awk \'\{print \$1,\$$i,\$$j\}\' B_625_625_5spc_repl1_countmatrix.tab |tail -12498 >pairsAB/B_625_625_5spc_repl1-$sA\.$sB\.tab`;

	}
}
