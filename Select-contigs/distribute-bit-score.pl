##according to diff identitities, the right selection
use strict; use warnings;

my $line;
my $gi;
my @array;
my $i;
my $j;
my %turn;
my @max;
my @len;
my @ref;
my @name;
my $file;
my $num;

if(@ARGV<5)
{
	print "perl $0 fasta  source_file  prefix_output min_iden blastn_results\n";
	exit;
}

$name[0]="coral";
$name[1]="symbiodinium";
$name[2]="other";

if($ARGV[0]=~/gz$/)
{
        open (IN,"gzip -dc $ARGV[0] |") or die "Can't open $ARGV[0]\n";
}
else
{
        open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
}
$i=0;
while(<IN>)
{
        chomp;
        $line=$_;
        if($line=~/^\>/)
        {
                ($gi)=$line=~/gi\|(\d+)\|/;
		$turn{$gi}=$i;
                $len[$i]=0;
		$max[$i]=0;
		$i++;
                next;
        }
        $len[$i-1]=$len[$i-1]+length($line);
}
close IN;
$num=$i;

if($ARGV[1]=~/gz$/)
{
	open (IN,"gzip -dc $ARGV[1] |") or die "Can't open $ARGV[1]\n";
}
else
{
	open(IN,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
}
while(<IN>)
{
	$line=$_;
	if($line=~/^Contig/)
	{
		next;
	}
	@array=split("\t",$line);
	if($array[2]=~/coral/)
	{
		$ref[$turn{$array[0]}]=0;
	}
	elsif($array[2]=~/symbiodinium/)
	{
		$ref[$turn{$array[0]}]=1;
	}
	else
	{
		$ref[$turn{$array[0]}]=2;
	}
}
close IN;

for($i=4;$i<@ARGV;$i++)
{
	if($ARGV[$i]=~/gz$/)
	{
        	open (IN,"gzip -dc $ARGV[$i] |") or die "Can't open $ARGV[$i]\n";
	}
	else
	{
        	open(IN,"<$ARGV[$i]") or die "Can't open $ARGV[$i]\n";
	}
	while(<IN>)
	{
		chomp;
		$line=$_;
		if($line=~/^\#\s+Query/)
		{
			($gi)=$line=~/gi\|(\d+)\|/;
			$j=$turn{$gi};
			next;
		}
	
		if($line=~/^\#/)
		{
			next;
		}
		@array=split("\t",$line);
		if($array[2]<$ARGV[3])
		{
			next;
		}

		if($array[11]>$max[$j])
		{
			$max[$j]=$array[11];
		}
	}
	close IN;
}
for($i=0;$i<3;$i++)
{
	$file=$ARGV[2]."-".$name[$i].".txt";
	open(OUT,">$file") or die "can't create $file\n";
	print OUT "turn\tlength\tscore\n";
	for($j=0;$j<$num;$j++)
	{
		if($ref[$j]!=$i)
		{
			next;
		}
		if($max[$j]==0)
		{
			next;
		}
		print OUT "$j\t$len[$j]\t$max[$j]\n";
	}
	close OUT;
}
