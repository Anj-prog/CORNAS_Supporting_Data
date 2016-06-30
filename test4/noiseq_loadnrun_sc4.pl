#!/usr/bin/perl

# script to create noiseq comparison files for sc4 run

use warnings;
use strict;
  
my $CovFile = $ARGV[0];
my $inputFile = $ARGV[1];
my $sampA = $ARGV[2];
my $sampB = $ARGV[3];


my $ar = @ARGV;
if($ar<4){die "Usage:$0 <coverage_file.tab> <countfile> <A> <B>\n";}

my @uglyname = split("\/",$inputFile);
my $filename = pop(@uglyname);

my $AResult = `grep -m 1 -w "$sampA" $CovFile`;
chomp $AResult;
my @Astuff = split("\t",$AResult);

my $BResult = `grep -m 1 -w "$sampB" $CovFile`;
chomp $BResult;
my @Bstuff = split("\t",$BResult);

`awk \'\{print \$1, \$$Astuff[1], \$$Bstuff[1]\}\' $inputFile >$Astuff[0].$Bstuff[0].counts.tab`;

# run noiseq
`Rscript ../noiseq_sc4.R kidneyliver_lengths.list $Astuff[0].$Bstuff[0].counts.tab`;
