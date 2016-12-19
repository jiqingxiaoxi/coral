use strict; use warnings;

my $line;
my @array;
my @store;
my $value;
my %up;
my %down;
my @ref;
my @list;
my @file;
my @express;
my @diff;
my $pos;
my $i;
my $j;
my $k;
my $m;
my $n;
my $gi;
my @total;
my @out;

if(@ARGV!=4)
{
	print "perl $0 contig_source_file diff_dir cluste\(0.9_or_0.95\)  output\n";
	exit;
}

$list[0]="1_10";
$list[1]="1_5";
$list[2]="2_10";
$list[3]="2_5";
$express[0]="RSEM";
$express[1]="Sailfish";
$diff[0]="DESeq2";
$diff[1]="edgeR";
$diff[2]="limma";

open(OUT,">$ARGV[3]") or die "Can't create $ARGV[3]\n";
print OUT "Data\&handle\tNA_number\tUp_number\tDown_number\tStable_number\tA_0.05\tA_0.02\tA_0.01\tA_0.005\tA_0.001\tUs_0.05\tUs_0.02\tUs_0.01\tUs_0.005\tUs_0.001\tUp_0.05\tUp_0.02\tUp_0.01\tUp_0.005\tUp_0.001\tDs_0.05\tDs_0.02\tDs_0.01\tDs_0.005\tDs_0.001\tDp_0.05\tDp_0.02\tDp_0.01\tDp_0.005\tDp_0.001\n";
for($i=0;$i<4;$i++)
{
	$file[0]="/lustre/home/clslzy/bjia/test_pipeline/".$list[$i]."-source.txt";
	foreach $value (keys %up)
	{
		delete($up{$value});
	}
	foreach $value (keys %down)
	{
		delete($down{$value});
	}
	open(IN,"<$file[0]") or die "Can't open $file[0]\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^tran/)
		{
			next;
		}
		@array=split("\t",$line);
		if($array[2]>1)
		{
			$up{$array[0]}=1;
		}
		elsif($array[2]<1)
		{
			$down{$array[0]}=1;
		}
	}
	close IN;

##contig's ref
	open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
	while(<IN>)
	{
		chomp;
		$line=$_;
		@array=split("\t",$line);
		$ref[$array[0]]=$array[1];
	}
	close IN;

##file_list
	$value=0;
	for($j=0;$j<3;$j++)
	{
		for($k=0;$k<2;$k++)
		{
			if($ARGV[1]=~/\/$/)
			{
				$file[$value]=$ARGV[1].$diff[$j]."/".$list[$i]."-".$ARGV[2]."-".$express[$k]."-result.txt";
				$out[$value]=$list[$i]."-".$express[$k]."-".$diff[$j];
				$value++;
			}
			else
			{
				$file[$value]=$ARGV[1]."/".$diff[$j]."/".$list[$i]."-".$ARGV[2]."-".$express[$k]."-result.txt";
                                $out[$value]=$list[$i]."-".$express[$k]."-".$diff[$j];
                                $value++;
                        }
		}
	}

	for($j=0;$j<6;$j++)
	{
		for($k=0;$k<5;$k++)
		{
			for($value=0;$value<6;$value++)
			{
				$store[$k][$value]=0;
			}
		}

		for($k=0;$k<4;$k++)
		{
			$total[$k]=0;
		}

		if($j<2) ##p_value in different diff file
		{
			$m=5;
			$n=2; ##fold change
		}
		elsif($j<4)
		{
			$m=3;
			$n=2;
		}
		else
		{
			$m=4;
			$n=1;
		}

		open(IN,"<$file[$j]") or die "Can't open $file[$j]\n";
		while(<IN>)
		{
			chomp;
			$line=$_;
			if($line!~/^\"gi/)
			{
				next;
			}
			@array=split("\t",$line);
			if($array[$m] eq "NA")
			{
				$total[0]++;
				next;
			}
			($gi)=$array[0]=~/gi\|(\d+)\|/;
			$pos=find_pos($array[$m]);

			if(exists $up{$ref[$gi]})
			{
				for($k=$pos+1;$k<5;$k++)
				{
					$store[$k][5]++;
				}
				for($k=0;$k<=$pos;$k++)
				{
					if($array[$n]>0)
					{
						$store[$k][0]++;
					}
					else
					{
						$store[$k][3]++;
					}
				}
				$total[1]++;
			}
			elsif(exists $down{$ref[$gi]})
			{
				for($k=$pos+1;$k<5;$k++)
                                {
                                        $store[$k][5]++;
                                }
                                for($k=0;$k<=$pos;$k++)
                                {
                                        if($array[$n]>0)
                                        {
                                                $store[$k][1]++;
                                        }
                                        else
                                        {
                                                $store[$k][2]++;
                                        }
                                }
                                $total[2]++;
                        }
			else
			{
				for($k=$pos+1;$k<5;$k++)
                                {
                                        $store[$k][4]++;
                                }
                                for($k=0;$k<=$pos;$k++)
                                {
                                        if($array[$n]>0)
                                        {
                                                $store[$k][1]++;
                                        }
                                        else
                                        {
                                                $store[$k][3]++;
                                        }
                                }
                                $total[3]++;
                        }
		}
		close IN;
		$total[4]=$total[0]+$total[1]+$total[2]+$total[3];
		print OUT $out[$j];
		for($k=0;$k<4;$k++)
		{
			$value=$total[$k]/$total[4]*100;
			printf(OUT "\t%d\(%0.2f%%\)",$total[$k],$value);
		}
	##accurate
		for($k=0;$k<5;$k++)
		{
			$value=($store[$k][0]+$store[$k][2]+$store[$k][4])/($store[$k][0]+$store[$k][1]+$store[$k][2]+$store[$k][3]+$store[$k][4]+$store[$k][5])*100;
			printf(OUT "\t%0.2f%%",$value);
		}
	##up genes sensitivity
		for($k=0;$k<5;$k++)
		{
			$value=$store[$k][0]/$total[1]*100;
			printf(OUT "\t%0.2f%%",$value);
		}
	##up genes precision
		for($k=0;$k<5;$k++)
                {
			if($store[$k][0]+$store[$k][1]==0)
			{
				print OUT "\tNULL";
			}
			else
			{
                        	$value=$store[$k][0]/($store[$k][0]+$store[$k][1])*100;
                        	printf(OUT "\t%0.2f%%",$value);
			}
                }
	##down genes sensitivity
                for($k=0;$k<5;$k++)
                {
                        $value=$store[$k][2]/$total[2]*100;
                        printf(OUT "\t%0.2f%%",$value);
                }
        ##down genes precision
                for($k=0;$k<5;$k++)
                {
			if($store[$k][2]+$store[$k][3]==0)
			{
				print OUT "\tNULL";
			}
			else
			{
                        	$value=$store[$k][2]/($store[$k][2]+$store[$k][3])*100;
                        	printf(OUT "\t%0.2f%%",$value);
			}
                }
		print OUT "\n";
	}
}

sub find_pos
{
	my ($in)=@_;
	if($in<0.001)
	{
		return 4;
	}
	if($in<0.005)
	{
		return 3;
	}
	if($in<0.01)
	{
		return 2;
	}
	if($in<0.02)
	{
		return 1;
	}
	if($in<0.05)
	{
		return 0;
	}
	return -1;
}
