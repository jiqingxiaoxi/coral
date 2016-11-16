use strict; use warnings;

my $line;
my $seq="";
my $i=0;
my $out;

if(@ARGV!=2)
{
	print "perl $0 input_fa output_prefix\n";
	exit;
}

$out=$ARGV[1]."_mRNA.fa";
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
open(OUT,">$out") or die "Can't create $out\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		if($seq ne "")
		{
			if(length($seq)>=300)
			{
				print OUT "\>$ARGV[1]\_$i\n$seq\n";
				$i++;
			}
		}
		$seq="";
		next;
	}
	$line=~tr/[a-z]/[A-Z]/;
	$seq=$seq.$line;
}
close IN;

if(length($seq)>=300)
{
	print OUT "\>$ARGV[1]\_$i\n$seq\n";
	$i++;
}
close OUT;
print "There are $i >=300bps\n";
