#!/usr/bin/perl
use warnings;
use strict;

my $searchlist = $ARGV[0];
my $infile = $ARGV[1];
my $option = "-w";

if (scalar @ARGV <2) {
	die "USAGE:grep_fromlist.pl <searchfile.list> <filetosearchin> [-v (default=-w]\n";
}

if (scalar @ARGV >= 3) {
	my @arguments = @ARGV[2..$#ARGV];
	$option = join (" ",@arguments);
}

#print $option;

my @results;

open (SEARCHDAT, $searchlist ) or die "$!";

while (<SEARCHDAT>){
	chomp;
	my @results = `grep $option "$_" $infile`;
	print @results;
}
