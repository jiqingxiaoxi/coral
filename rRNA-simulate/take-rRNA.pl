##take rRNA sequence from gbk and fna file
use strict; use warnings;

my $line;
my $gi;
my $seq="";
my $out;
my $part;
my %hash;
my $start;
my $end;
my $total=0;

if(@ARGV!=3)
{
	print "perl $0 fna gbk prefix_output\n";
	exit;
}

$out=$ARGV[2]."_rRNA.fa";

open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		if($seq ne "")
		{
			$hash{$gi}=$seq;
		}
		$seq="";
		($gi)=$line=~/\>gi\|(\d+)\|/;
		next;
	}
	$line=~tr/[a-z]/[A-Z]/;
	$seq=$seq.$line;
}
close IN;
$hash{$gi}=$seq;

open(IN,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
open(OUT,">$out") or die "Can't create $out\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^VERSION/)
	{
		($gi)=$line=~/GI\:(\d+)$/;
		next;
	}
	if($line!~/^\s+rRNA\s+/)
	{
		next;
	}
	if($line=~/\</)
	{
		($start)=$line=~/\<(\d+)\.\./;
	}
	else
	{
		($start)=$line=~/rRNA\s+(\d+)\.\./;
	}
	if($line=~/\>/)
	{
		($end)=$line=~/\>(\d+)$/;
	}
	else
	{
		($end)=$line=~/\.\.(\d+)$/;
	}
	$part=substr($hash{$gi},($start-1),($end-$start+1));
	print OUT "\>$ARGV[2]\_$total\n$part\n";
	$total++;
}
close IN;
close OUT;
