use strict; use warnings;

my $line;
my @array;
my %turn;
my $num=0;
my $i;
my $j;
my @single;
my @paired;
my @paired_one;
my @paired_two;
my @single_one;
my @single_two;
my $before="";
my @value;
my $pos;
my @name;
my %total;
my $prefix;
my $file;
my $temp;

if(@ARGV!=2)
{
	print "perl $0 list output_prefix\(coral or symbiodinium\)\n";
	exit;
}

$temp=$ARGV[1]."-align-result.txt";
open(OUT,">$temp") or die "Can't create $temp\n";
open(LIST,"<$ARGV[0]") or die "$ARGV[0]\n";
while(<LIST>)
{
	chomp;
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;

	foreach $i (keys %turn)
	{
		delete($turn{$i});
		delete($total{$i});
	}

	$num=0;
	open(FA,"gzip -dc /lustre/home/clslzy/bjia/simulate/$line |") or die "Can't open $line\n";
	while(<FA>)
	{
		$line=$_;
		if($line!~/^\>/)
		{
			next;
		}
		($temp)=$line=~/^\>([\w\_]+)\_\d+\//;
		if(exists $turn{$temp})
		{
			$total{$temp}++;
		}
		else
		{
			$turn{$temp}=$num;
			$name[$num]=$temp;
			$num++;
			$total{$temp}=1;
		}
	}
	close FA;

	for($i=0;$i<$num;$i++)
	{
		for($j=0;$j<8;$j++)
		{
			$single[$i][$j]=0;
			$paired[$i][$j]=0;
		}
	}

	$file="/lustre/home/clslzy/bjia/test_pipeline/Map/".$prefix."-".$ARGV[1].".sam.gz";
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
				for($i=0;$i<$num;$i++)
				{
					for($j=0;$j<8;$j++)
					{
						$single[$i][$j]=$single[$i][$j]+$single_one[$i][$j]+$single_two[$i][$j];
						$paired[$i][$j]=$paired[$i][$j]+($paired_one[$i][$j]&$paired_two[$i][$j]);
					}
				}
			}
			$before=$array[0];
		##initial
			for($i=0;$i<$num;$i++)
			{
				for($j=0;$j<8;$j++)
				{
					$paired_one[$i][$j]=0;
					$paired_two[$i][$j]=0;
					$single_one[$i][$j]=0;
					$single_two[$i][$j]=0;
				}
			}
		}

		($temp)=$array[0]=~/^(.+)\_\d+$/;
		if(! exists $turn{$temp})
		{
			print "$temp\n";
			print $line;
			exit;
		}
		$value[0]=$turn{$temp}; 
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
					$paired_one[$value[0]][0]=1;
				}
				for($i=$pos;$i<8;$i++)
				{
					$paired_one[$value[0]][$i]=1;
				}
			}
			else
			{
				if($value[2]>=50)
				{
					$paired_two[$value[0]][0]=1;
				}
	                        for($i=$pos;$i<8;$i++)
	                        {
	                                $paired_two[$value[0]][$i]=1;
	                        }
	                }
		}

	##single
		if($value[4]==1)
		{
			if($value[2]>=50)
			{
				$single_one[$value[0]][0]=1;
			}
			for($i=$pos;$i<8;$i++)
			{
				$single_one[$value[0]][$i]=1;
			}
		}
		else
		{
			if($value[2]>=50)
			{
				$single_two[$value[0]][0]=1;
			}
	                for($i=$pos;$i<8;$i++)
	                {
	                        $single_two[$value[0]][$i]=1;
	                }
	        }
	}
	close IN;

	for($i=0;$i<$num;$i++)
	{
		for($j=0;$j<8;$j++)
		{
	        	$single[$i][$j]=$single[$i][$j]+$single_one[$i][$j]+$single_two[$i][$j];
	                $paired[$i][$j]=$paired[$i][$j]+($paired_one[$i][$j]&$paired_two[$i][$j]);
		}
	}

	print OUT "$prefix\:Paired:\n";
	print OUT "Ref\tTotal\(pair\)\tMatch>=50bp\tIden>=0.95\tIden>=0.9\tIden>=0.8\tIden>=0.7\tIden>=0.6\tIden>=0.5\tIden>0\n";
	for($i=0;$i<$num;$i++)
	{
		print OUT "$name[$i]\t$total{$name[$i]}";
		for($j=0;$j<8;$j++)
		{
			$temp=$paired[$i][$j]/$total{$name[$i]}*100;
			printf(OUT "\t%d\(%0.2f%%\)",$paired[$i][$j],$temp);
		}
		print OUT "\n";
	}
	print OUT "\n\n";

	print OUT "$prefix\:All:\n";
	print OUT "Ref\tTotal\(single\)\tMatch>=50bp\tIden>=0.95\tIden>=0.9\tIden>=0.8\tIden>=0.7\tIden>=0.6\tIden>=0.5\tIden>0\n";
	for($i=0;$i<$num;$i++)
	{
		$temp=$total{$name[$i]}*2;
	        print OUT "$name[$i]\t$temp";
	        for($j=0;$j<8;$j++)
	        {
			$temp=$single[$i][$j]/$total{$name[$i]}*50;
	                printf(OUT "\t%d\(%0.2f%%\)",$single[$i][$j],$temp);
	        }
	        print OUT "\n";
	}
	print OUT "\n\n";
}
close LIST;
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
	return 7;
}
