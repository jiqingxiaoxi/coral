##take transcripts from gff and fna file
use strict; use warnings;

my $line;
my $seq="";
my $part;
my @total;
my @array;
my $out;
my $name;
my %hash;

if(@ARGV!=3)
{
	print "perl $0 fna gff prefix_output\n";
	exit;
}

$total[0]=0; ##less than 300bp
$total[1]=0; ##more than 300bp
$out=$ARGV[2]."_mRNA.fa";

open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		if($seq ne "")
		{
			$hash{$name}=$seq;
		}
		$seq="";
		($name)=$line=~/\>([\w\d\_\.]+) /;
		next;
	}
	$line=~tr/[a-z]/[A-Z]/;
	$seq=$seq.$line;
}
close IN;
$hash{$name}=$seq;

open(IN,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
open(OUT,">$out") or die "Can't create $out\n";
while(<IN>)
{
	$line=$_;
	@array=split("\t",$line);
	if(@array<6)
	{
		next;
	}
	if($array[2] ne "CDS")
	{
		next;
	}
	if($array[4]-$array[3]+1<300)
	{
		$total[0]++;
		next;
	}

	$part=substr($hash{$array[0]},($array[3]-1),($array[4]-$array[3]+1));
	print OUT "\>$ARGV[2]\_$total[1]\n$part\n";
	$total[1]++;
}
close IN;
close OUT;

print "There are $total[0] \< 300bps and $total[1] \>=300bps\n";
