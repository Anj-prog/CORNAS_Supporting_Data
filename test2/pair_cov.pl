#!/usr/bin/perl

#generates the CORNAS config file

use warnings;
use strict;

my $infile = $ARGV[0];
my ($i,$j,$col) = ($ARGV[1],$ARGV[2],$ARGV[3]);
my $ar = @ARGV;
if($ar<4){die "Usage:$0 <infile> <rowA> <rowB> <col> \n";}

`echo -e "Gene Name: 1\nSample A column: 2\nSample B column: 3\n" >cornas.config`;
`awk \'\{if\(\$1 ==$i\)\{print "Sample A Coverage:",\$$col\}\}\' $infile >>cornas.config`;
`awk \'\{if\(\$1 ==$j\)\{print "Sample B Coverage:",\$$col\}\}\' $infile >>cornas.config`;
