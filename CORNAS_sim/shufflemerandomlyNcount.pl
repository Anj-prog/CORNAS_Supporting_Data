#!/usr/bin/perl

use strict;
use warnings;
use Math::Random::MT qw(srand rand irand);

my $popSize = $ARGV[0];
my $sampleSize = $ARGV[1];
my $endStep = $ARGV[2];
my $outfile = $ARGV[3];

my $x = @ARGV;
if($x<4){die "Usage:$0 <population size> <sample size> <max_count> <output_file> \n
NOTE: the output file may come from a previous rep run and the program will append a line to the file\n";}

#generate an array of numbers equivalent to the population size
my @population;
for (my $i=1; $i<=$popSize;$i++) {
	push @population, $i;
}

#my $datestring = localtime();
#print STDERR "complete_loading\t$datestring\n";

&fisher_yates_shuffle(\@population);

#$datestring = localtime();
#print STDERR "complete_shuffling\t$datestring\n";

#hashtable for start to end
my %occurance;
for (my $j = 1; $j <= $endStep; $j++) {
	$occurance{$j} = 0;
	#print "$j\t$occurance{$j}\n"; #debug
}

open (OUTFILE, ">>$outfile");

for (my $k=0; $k < $sampleSize;$k++){
	if (exists $occurance{$population[$k]}) {
		for (my $m = $population[$k]; $m <= $endStep; $m++) {
			my $new = $occurance{$m} + 1;
			$occurance{$m} = $new;
		}
	}
	#print "$population[$k]\n"; #debug
}

for (my $i = 1; $i <= $endStep; $i++) {
	print OUTFILE "$occurance{$i}";
	if ($i == $endStep) {
		print OUTFILE "\n";
	}else{
		print OUTFILE "\t";
	}
}

sub fisher_yates_shuffle {
	my $deck =shift;
	return unless @$deck;
	my $j = @$deck;
	#my $gen = Math::Random::MT->new();
	while (--$j) {
		my $m = int rand ($j+1);
		#my $m = $gen->irand($j+1);
		#print "$m\n";
		next if $j == $m; # needed? 
		@$deck[$j,$m] = @$deck[$m,$j];
	}
}
