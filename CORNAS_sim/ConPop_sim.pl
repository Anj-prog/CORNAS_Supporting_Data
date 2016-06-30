#!/usr/bin/perl

# script that will calculate the population size from known PCR concentration after PCR step, and run the shufflemerandomlyNcount.pl script in the desired amount of replicates

# read a config file which have the following:
# DNA fragment population size*
# PCR product concentration in nanoMolars*
# PCR product volume in microLitres*
# PCR cycles*
# Number of sequenced reads
# Number of replicates to simulate
# Maximum count number to simulate
# Appendable output filename
# each parameter is a line, with the data separated by ":" 

use strict;
use warnings;


my $x = @ARGV;
if($x<1){die "Usage:$0 <config file> \n"};

open (DAT1,$ARGV[0]) or die "$!";

my @pathlines =split ("\/",$0);
pop @pathlines;

my $pathy = join("\/",@pathlines);

my %params;
while (<DAT1>) {
	chomp;
	unless ($_ !~ /^\#/ && $_ =~ /\:/) { #skip comment lines
		next;
	}
	my @stuff1 = split(":",$_);
	my $paramType = &CleanLine($stuff1[0]);
	my $paramData = &CleanLine($stuff1[1]);
	$params{$paramType} = $paramData; 
}

# Calculate the population size:
my $popSize;

if ($params{"DNAfragmentpopulationsize"}){
	$popSize = $params{"DNAfragmentpopulationsize"};
}else { 
	my $avogadro = 6.022141*(10**23);
	my $popSizeOri = ($avogadro*($params{"PCRproductconcentrationinnanoMolars"}/(10**9))*($params{"PCRproductvolumeinmicroLitres"}/(10**6)))/(2**$params{"PCRcycles"});
	$popSize = sprintf("%.0f",$popSizeOri);
}

print "$popSize\n"; #debug

# Calculate the coverage:
my $coverageCalc =sprintf("%.2e", ($params{"Numberofsequencedreads"}/$popSize));
print "$coverageCalc\n"; #debug

# Run the random picking script:
print "shuffling now...\n";
for (my $x = 1; $x <= $params{"Numberofreplicatestosimulate"}; $x++) {
	`perl $pathy\/shufflemerandomlyNcount.pl $popSize $params{"Numberofsequencedreads"} $params{"Maximumcountnumbertosimulate"} $params{"Appendableoutputfilename"}\.$coverageCalc\.out`;
	print "completed $x replicate!\n";
}


sub CleanLine {
	my $line = $_[0];
	$line =~ s/[ \,]//g;
	return $line;
}
