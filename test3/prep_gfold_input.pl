#!/user/bin/perl
use warnings;
use strict;

my $x=@ARGV;
if($x<2){die "Usage:$0 <dir_path> <lenfile> \n";}

my $readdir = $ARGV[0];
my $lenfile = $ARGV[1];

opendir (DIR1, $readdir) or die "$!";
my @realfiles;
while (my $files = readdir(DIR1)) {
	unless ($files !~ /^\.+/){
		next;
	}
	push @realfiles, $files;
}
close(DIR1);

if (scalar @realfiles == 0){
	die "No files in $readdir !\n";
}

open (MYLEN, $lenfile) or die "No such lenfile!\n";
my %lengths;
while (<MYLEN>){
	chomp $_;
	my @items = split(" ",$_);
	$lengths{$items[0]} = $items[1];
}
close(MYLEN);


foreach my $jfile(@realfiles) {
	my @parts = split("_",$jfile);
	my $fem = $parts[2];
	my $mal = $parts[3];
	open(MYINFILE,"$readdir\/$jfile") or die "No such file!\n";	
	open(MYFEM,">sample_F$fem.read_cnt");
	open(MYMAL,">sample_M$mal.read_cnt");

	while (<MYINFILE>) {
		chomp $_;
		$_ =~ s/\"//g;
		my @stuff = split("\t",$_);
		
		print MYFEM "$stuff[0]\tNA\t$stuff[1]\t$lengths{$stuff[0]}\t$stuff[1]\n";
		print MYMAL "$stuff[0]\tNA\t$stuff[2]\t$lengths{$stuff[0]}\t$stuff[2]\n";
	}
	close(MYFEM);
	close(MYMAL);

}

