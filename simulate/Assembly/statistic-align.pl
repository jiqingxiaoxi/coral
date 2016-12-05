use strict; use warnings;

my $line;
my @array;
my $num=0;
my $i;
my $j;
my @single;
my @paired;
my @part_all;
my @paired_one;
my @paired_two;
my @single_one;
my @single_two;
my $before="";
my @value;
my $pos;
my @total;
my $prefix;
my $file;
my $temp;
my @list;

if(@ARGV!=4)
{
	print "perl $0 list fasta_dir sam_dir output\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "$ARGV[0]\n";
while(<LIST>)
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;
	$list[$num]=$prefix;
	$total[$num]=0;

	if($ARGV[1]=~/\/$/)
        {
                $file=$ARGV[1].$prefix."_1.fa.gz";
        }
        else
        {
                $file=$ARGV[1]."/".$prefix."_1.fa.gz";
        }
	open(IN,"gzip -dc $file |") or die "Can't open $file\n";
	while(<IN>)
	{
		$total[$num]++;
	}
	close IN;
	$total[$num]/=2;
	
	if($ARGV[2]=~/\/$/)
	{
		$file=$ARGV[2].$prefix."-self.sam.gz";
	}
	else
	{
		$file=$ARGV[2]."/".$prefix."-self.sam.gz";
	}
	for($j=0;$j<12;$j++)
	{
		$single[$num][$j]=0;
		$paired[$num][$j]=0;
		$part_all[$num][$j]=0;
	}

	open(IN,"gzip -dc $file |") or die "$file\n";
	$before="";
	while(<IN>)
	{
		$line=$_;
		@array=split("\t",$line);

		if($array[0] ne $before) ##handle before
		{
			if($before ne "")
			{
				for($j=0;$j<12;$j++)
				{
					$single[$num][$j]=$single[$num][$j]+$single_one[$j]+$single_two[$j];
					$paired[$num][$j]=$paired[$num][$j]+($paired_one[$j]&$paired_two[$j]);
					$part_all[$num][$j]=$part_all[$num][$j]+($single_one[$j]|$single_two[$j]);
				}
			}
			$before=$array[0];
		##initial
			for($j=0;$j<12;$j++)
			{
				$paired_one[$j]=0;
				$paired_two[$j]=0;
				$single_one[$j]=0;
				$single_two[$j]=0;
			}
		}

		$value[1]=length($array[9]);
		$value[2]=$value[1];
		if($array[5]=~/^\d+[SH]/)
		{
			($value[3])=$array[5]=~/^(\d+)[SH]/;
			$value[2]-=$value[3];
		}
		if($array[5]=~/\d+[SH]$/)
		{
			($value[3])=$array[5]=~/[A-Z](\d+)[SH]$/;
			$value[2]-=$value[3];
		}
		$value[6]=$value[2];
		$value[4]=($array[1]-$array[1]%64)/64%2;
		$value[5]=($array[1]-$array[1]%2)/2%2;
	
		($value[3])=$line=~/NM\:i\:(\d+)/;
		$value[6]-=$value[3];
	
		$value[7]=$value[6]/$value[1];
		$pos=find_pos($value[7]);

		if($value[5]==1)
		{
			if($value[4]==1)
			{
				if($value[2]>=50)
				{
					$paired_one[0]=1;
				}
				for($i=$pos;$i<12;$i++)
				{
					$paired_one[$i]=1;
				}
			}
			else
			{
				if($value[2]>=50)
				{
					$paired_two[0]=1;
				}
	                        for($i=$pos;$i<12;$i++)
	                        {
	                                $paired_two[$i]=1;
	                        }
	                }
		}

	##single
		if($value[4]==1)
		{
			if($value[2]>=50)
			{
				$single_one[0]=1;
			}
			for($i=$pos;$i<12;$i++)
			{
				$single_one[$i]=1;
			}
		}
		else
		{
			if($value[2]>=50)
			{
				$single_two[0]=1;
			}
	                for($i=$pos;$i<12;$i++)
	                {
	                        $single_two[$i]=1;
	                }
	        }
	}
	close IN;

	for($j=0;$j<12;$j++)
	{
        	$single[$num][$j]=$single[$num][$j]+$single_one[$j]+$single_two[$j];
                $paired[$num][$j]=$paired[$num][$j]+($paired_one[$j]&$paired_two[$j]);
		$part_all[$num][$j]=$part_all[$num][$j]+($single_one[$j]|$single_two[$j]);
	}
	$num++;
}
close LIST;

open(OUT,">$ARGV[3]") or die "Can't create $ARGV[3]\n";
print OUT "Paired:\n";
print OUT "Dataset\tTotal\(pair\)\tMatch>=50bp\tIden>=0.95\tIden>=0.9\tIden>=0.8\tIden>=0.7\tIden>=0.6\tIden>=0.5\tIden>=0.4\tIden>=0.3\tIden>=0.2\tIden>=0.1\tIden>0\n";
for($i=0;$i<$num;$i++)
{
	print OUT "$list[$i]\t$total[$i]";
	for($j=0;$j<12;$j++)
	{
		$temp=$paired[$i][$j]/$total[$i]*100;
		printf(OUT "\t%d\(%0.2f%%\)",$paired[$i][$j],$temp);
	}
	print OUT "\n";
}
print OUT "\n\n";

print OUT "All:\n";
print OUT "Dataset\tTotal\(single\)\tMatch>=50bp\tIden>=0.95\tIden>=0.9\tIden>=0.8\tIden>=0.7\tIden>=0.6\tIden>=0.5\tIden>=0.4\tIden>=0.3\tIden>=0.2\tIden>=0.1\tIden>0\n";
for($i=0;$i<$num;$i++)
{
	$temp=$total[$i]*2;
	print OUT "$list[$i]\t$temp";
	for($j=0;$j<12;$j++)
	{
		$temp=$single[$i][$j]/$total[$i]*50;
		printf(OUT "\t%d\(%0.2f%%\)",$single[$i][$j],$temp);
	}
	print OUT "\n";
}
print OUT "\n\n";

print OUT "Part\_all:\n";
print OUT "Dataset\tTotal\(pair\)\tMatch>=50bp\tIden>=0.95\tIden>=0.9\tIden>=0.8\tIden>=0.7\tIden>=0.6\tIden>=0.5\tIden>=0.4\tIden>=0.3\tIden>=0.2\tIden>=0.1\tIden>0\n";
for($i=0;$i<$num;$i++)
{
	print OUT "$list[$i]\t$total[$i]";
        for($j=0;$j<12;$j++)
	{
        	$temp=$part_all[$i][$j]/$total[$i]*100;
                printf(OUT "\t%d\(%0.2f%%\)",$part_all[$i][$j],$temp);
	}
        print OUT "\n";
}
print OUT "\n\n";
close OUT;

sub find_pos
{
	my ($in)=@_;
	if($in>=0.95)
	{
		return 1;
	}
	if($in>=0.9)
	{
		return 2;
	}
	if($in>=0.8)
	{
		return 3;
	}
	if($in>=0.7)
	{
		return 4;
	}
	if($in>=0.6)
	{
		return 5;
	}
	if($in>=0.5)
	{
		return 6;
	}
	if($in>=0.4)
	{
		return 7;
	}
	if($in>=0.3)
	{
		return 8;
	}
	if($in>=0.2)
	{
		return 9;
	}
	if($in>=0.1)
	{
		return 10;
	}
	return 11;
}
