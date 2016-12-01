##statistic the identity, assembly contigs align to Ref transcripts
use strict; use warnings;

my $line;
my $value;
my @array;
my $pos;
my @max;
my @local;
my @whole;
my $prefix;
my $file;
my $num=0;
my @list;
my $i;
my @total; ##the number of contigs

if(@ARGV!=3)
{
	print "perl $0 file_list blastn_dir output\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<LIST>)
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;
	$list[$num]=$prefix;

	$max[0]=0; ##local
	$max[1]=0; ##whole;
	$total[$num]=0;
	for($i=0;$i<8;$i++)
	{
		$local[$num][$i]=0;
		$whole[$num][$i]=0;
	}
	
	if($ARGV[1]=~/\/$/)
        {
                $file=$ARGV[1].$prefix.".blastn.gz";
        }
        else
        {
                $file=$ARGV[1]."/".$prefix.".blastn.gz";
        }
	open(IN,"gzip -dc $file |") or die "Can't open $file\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^\#\s+Query/)
		{
			$total[$num]++;
			($value)=$line=~/len\=(\d+)\s+path/;

			if($max[0]==0)
			{
				next;
			}
			$pos=find_pos($max[0]);
			for($i=$pos;$i<8;$i++)
			{
				$local[$num][$i]++;
			}
			$pos=find_pos($max[1]);
			for($i=$pos;$i<8;$i++)
			{
				$whole[$num][$i]++;
			}
			$max[0]=0;
			$max[1]=0;
			next;
		}

		if($line=~/^\#/)
		{
			next;
		}
		@array=split("\t",$line);
		if($array[2]>$max[0])
		{
			$max[0]=$array[2];
		}
		if($array[2]*$array[3]/$value>$max[1])
		{
			$max[1]=$array[2]*$array[3]/$value;
		}
	}
	close IN;
	$pos=find_pos($max[0]);
	for($i=$pos;$i<8;$i++)
	{
		$local[$num][$i]++;
	}
	$pos=find_pos($max[1]);
	for($i=$pos;$i<8;$i++)
	{
		$whole[$num][$i]++;
	}
	
	$num++;
}
close LIST;

open(OUT,">$ARGV[2]") or die "Can't create $ARGV[2]\n";
print OUT "Dataset\tIden=100\%\tIden>=98\%\tIden>=95\%\tIden>=90\%\tIden>=85\%\tIden>=80\%\tIden>=75\%\tIden>=70\%\tTotal\_contigs\n";
print OUT "Identitities based on local alignment\:\n";
for($pos=0;$pos<$num;$pos++)
{
	print OUT $list[$pos];
	for($i=0;$i<8;$i++)
	{
		$value=$local[$pos][$i]/$total[$pos]*100;
		printf(OUT "\t%d\(%0.2f%%\)",$local[$pos][$i],$value);
	}
	print OUT "\t$total[$pos]\n";
}
print OUT "\n\nIdentitities based on whole alignment\:\n";
for($pos=0;$pos<$num;$pos++)
{
        print OUT $list[$pos];
        for($i=0;$i<8;$i++)
        {
                $value=$whole[$pos][$i]/$total[$pos]*100;
                printf(OUT "\t%d\(%0.2f%%\)",$whole[$pos][$i],$value);
        }
        print OUT "\t$total[$pos]\n";
}
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
