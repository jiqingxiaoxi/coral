##statistic the identity, contigs to contigs
use strict; use warnings;

my $line;
my $value;
my @array;
my $pos;
my $max;
my @whole;
my $i;
my $total; 
my @len;
my $gi;

if(@ARGV!=3)
{
	print "perl $0 fasta blastn output\n";
	exit;
}

open(IN,"gzip -dc $ARGV[0] |") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		($gi)=$line=~/gi\|(\d+)\|/;
		$len[$gi]=0;
	}
	else
	{
		$len[$gi]=$len[$gi]+length($line);
	}
}
close IN;

$total=$gi+1;
$max=0; 
for($i=0;$i<8;$i++)
{
	$whole[$i]=0;
}

open(IN,"gzip -dc $ARGV[1] |") or die "Can't open $ARGV[1]\n";
while(<IN>)
{
	$line=$_;
	if($line=~/^\#\s+Query/)
	{
		($gi)=$line=~/gi\|(\d+)\|/;

		if($max==0)
		{
			next;
		}
		$pos=find_pos($max);
		for($i=$pos;$i<8;$i++)
		{
			$whole[$i]++;
		}
		$max=0;
		next;
	}

	if($line=~/^\#/)
	{
		next;
	}
	@array=split("\t",$line);
	if($array[0] eq $array[1])
	{
		next;
	}
	if($array[2]*$array[3]/$len[$gi]>$max)
	{
		$max=$array[2]*$array[3]/$len[$gi];
	}
}
close IN;
$pos=find_pos($max);
for($i=$pos;$i<8;$i++)
{
	$whole[$i]++;
}

open(OUT,">$ARGV[2]") or die "Can't create $ARGV[2]\n";
print OUT "Iden=100\%\tIden>=98\%\tIden>=95\%\tIden>=90\%\tIden>=85\%\tIden>=80\%\tIden>=75\%\tIden>=70\%\tTotal\_contigs\n";
for($i=0;$i<8;$i++)
{
	$value=$whole[$i]/$total*100;
        printf(OUT "%d\(%0.2f%%\)\t",$whole[$i],$value);
}
print OUT "$total\n";
close OUT;

sub find_pos
{
	my ($in)=@_;
	
	if($in==100)
	{
		return 0;
	}
	if($in>=98)
	{
		return 1;
	}
	if($in>=95)
	{
		return 2;
	}
	if($in>=90)
	{
		return 3;
	}
	if($in>=85)
	{
		return 4;
	}
	if($in>=80)
	{
		return 5;
	}
	if($in>=75)
	{
		return 6;
	}
	if($in>=70)
	{
		return 7;
	}
	return 8;
}
