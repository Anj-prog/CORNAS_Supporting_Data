#!/usr/bin/perl

# script to create cornas.config file for test3 run

use warnings;
use strict;

my $tcr = $ARGV[0];
my $folddiff = $ARGV[1];
my $maleCovFile = $ARGV[2];
my $femaleCovFile = $ARGV[3];
my $inputFile = $ARGV[4];

my $ar = @ARGV;
if($ar<5){die "Usage:$0 <tcr> <folddiff> <maleCovFile> <femaleCovFile> <inputFile>\n";}

# prepare cornas.config
my @uglyname = split("\/",$inputFile);
my $filename = pop(@uglyname);
my @stuffs = split("_",$filename);
my $male = $stuffs[3];
my $female = $stuffs[2];

my $maleResult = `grep -m 1 -w "$male" $maleCovFile`;
chomp $maleResult;
my @malestuff = split("\t",$maleResult);

my $femaleResult = `grep -m 1 -w "$female" $femaleCovFile`;
chomp $femaleResult;
my @femalestuff = split("\t",$femaleResult);

open(MYOUTFILE, ">cornas.config") or die "shiet!\n";
print MYOUTFILE "Gene Name: 1\nSample A column: 2\nSample B column: 3\n";
print MYOUTFILE "Sample A Coverage: $malestuff[1]\n";
print MYOUTFILE "Sample B Coverage: $femalestuff[1]\n";
print MYOUTFILE "TCR Change: $tcr\n";
print MYOUTFILE "Fold threshold: $folddiff\n";

close(MYOUTFILE);

# run cornas
`Rscript ../cornas.R cornas.config $inputFile >cornas_all_B-F.$female._A-M.$male.out`;
