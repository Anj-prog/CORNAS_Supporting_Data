#!/usr/bin/perl

# script to create cornas.config file for sc4 run

use warnings;
use strict;
  
my $tcr = $ARGV[0];
my $folddiff = $ARGV[1];
my $CovFile = $ARGV[2];
my $inputFile = $ARGV[3];
my $sampA = $ARGV[4];
my $sampB = $ARGV[5];


my $ar = @ARGV;
if($ar<5){die "Usage:$0 <tcr> <folddiff> <coverage_file.tab> <countfile> <A> <B>\n";}

# prepare cornas.config
my @uglyname = split("\/",$inputFile);
my $filename = pop(@uglyname);

my $AResult = `grep -m 1 -w "$sampA" $CovFile`;
chomp $AResult;
my @Astuff = split("\t",$AResult);

my $BResult = `grep -m 1 -w "$sampB" $CovFile`;
chomp $BResult;
my @Bstuff = split("\t",$BResult);

open(MYOUTFILE, ">cornas.config") or die "shiet!\n";
print MYOUTFILE "Gene Name: 1\nSample A column: $Astuff[1]\nSample B column: $Bstuff[1]\n";
print MYOUTFILE "Sample A Coverage: $Astuff[2]\n";
print MYOUTFILE "Sample B Coverage: $Bstuff[2]\n";
print MYOUTFILE "TCR Change: $tcr\n";
print MYOUTFILE "Fold threshold: $folddiff\n";

close(MYOUTFILE);

# run cornas
`Rscript ../cornas.R cornas.config $inputFile >cornas_all_$Astuff[0].$Bstuff[0].out`;
