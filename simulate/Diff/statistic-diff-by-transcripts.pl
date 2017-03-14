use strict; use warnings;

my $line;
my @array;
my @store;
my $value;
my %up;
my %down;
my @ref;
my @list;
my $file;
my $i;
my $j;
my $gi;
my @total;
my %one;
my %two;
my %three;
my %four;
my %five;
my $name;
my @result;

if(@ARGV!=4)
{
	print "perl $0 diff_dir  suffix  source_file  output\n";
	print "    suffix: like 0.95-Sailfish, all-RSEM and so on\n";
	exit;
}

$list[0]="1_10";
$list[1]="1_5";
$list[2]="2_10";
$list[3]="2_5";

open(IN,"<$ARGV[2]") or die "can't open $ARGV[2]\n";
while(<IN>)
{
	$line=$_;
	if($line=~/^Contig/)
	{
		next;
	}
	@array=split("\t",$line);
	$ref[$array[0]]=$array[2];
}
close IN;

open(OUT,">$ARGV[3]") or die "Can't create $ARGV[3]\n";
print OUT "Data\tUp_number\tDown_number\tStable_number\tN_0.05\tN_0.02\tN_0.01\tN_0.005\tN_0.001\tA_0.05\tA_0.02\tA_0.01\tA_0.005\tA_0.001\tUs_0.05\tUs_0.02\tUs_0.01\tUs_0.005\tUs_0.001\tUp_0.05\tUp_0.02\tUp_0.01\tUp_0.005\tUp_0.001\tDs_0.05\tDs_0.02\tDs_0.01\tDs_0.005\tDs_0.001\tDp_0.05\tDp_0.02\tDp_0.01\tDp_0.005\tDp_0.001\n";
for($i=0;$i<4;$i++)
{
	$file="/lustre/home/clslzy/bjia/test_pipeline/".$list[$i]."-source.txt";
	foreach $value (keys %up)
	{
		delete($up{$value});
	}
	foreach $value (keys %down)
	{
		delete($down{$value});
	}
	open(IN,"<$file") or die "Can't open $file\n";
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

	foreach $line (keys %one)
	{
		delete($one{$line});
		delete($two{$line});
		delete($three{$line});
		delete($four{$line});
		delete($five{$line});
	}	

	if($ARGV[0]=~/\/$/)
	{
		$file=$ARGV[0].$list[$i]."-".$ARGV[1]."-result.txt";
	}
	else
	{
		$file=$ARGV[0]."/".$list[$i]."-".$ARGV[1]."-result.txt";
	}                                        

	open(IN,"<$file") or die "Can't open $file\n";
	while(<IN>)
	{
		chomp;
		$line=$_;
		if($line!~/^\"gi/)
		{
			next;
		}
		@array=split("\t",$line);
		($gi)=$array[0]=~/gi\|(\d+)\|/;
		$name=$ref[$gi];
		if($array[4] eq "NA")
		{
			$one{$name}="NULL";
			$two{$name}="NULL";
			$three{$name}="NULL";
			$four{$name}="NULL";
			$five{$name}="NULL";
			next;
		}

		if($array[4]>=0.05)
		{
			if(exists $one{$name})
			{
				if($one{$name} ne "stable")
				{
					$one{$name}="NULL";
				}
			}
			else
			{
				$one{$name}="stable";
			}
		}
		else
		{
			if($array[1]>0)
                        {
                                if(exists $one{$name})
                                {
                                        if($one{$name} ne "up")
                                        {
                                                $one{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $one{$name}="up";
                                }
                        }
                        else
                        {
                                if(exists $one{$name})
                                {
                                        if($one{$name} ne "down")
                                        {
                                                $one{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $one{$name}="down";
                                }
                        }
		}
		
		if($array[4]>=0.02)
                {
                        if(exists $two{$name})
                        {
                                if($two{$name} ne "stable")
                                {
                                        $two{$name}="NULL";
                                }
                        }
                        else
                        {
                                $two{$name}="stable";
                        }
                }
                else
                {
                        if($array[1]>0)
                        {
                                if(exists $two{$name})
                                {
                                        if($two{$name} ne "up")
                                        {
                                                $two{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $two{$name}="up";
                                }
                        }
                        else
                        {
                                if(exists $two{$name})
                                {
                                        if($two{$name} ne "down")
                                        {
                                                $two{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $two{$name}="down";
                                }
                        }
                }

		if($array[4]>=0.01)
                {
                        if(exists $three{$name})
                        {
                                if($three{$name} ne "stable")
                                {
                                        $three{$name}="NULL";
                                }
                        }
                        else
                        {
                                $three{$name}="stable";
                        }
                }
                else
                {
                        if($array[1]>0)
                        {
                                if(exists $three{$name})
                                {
                                        if($three{$name} ne "up")
                                        {
                                                $three{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $three{$name}="up";
                                }
                        }
                        else
                        {
                                if(exists $three{$name})
                                {
                                        if($three{$name} ne "down")
                                        {
                                                $three{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $three{$name}="down";
                                }
                        }
                }

		if($array[4]>=0.005)
                {
                        if(exists $four{$name})
                        {
                                if($four{$name} ne "stable")
                                {
                                        $four{$name}="NULL";
                                }
                        }
                        else
                        {
                                $four{$name}="stable";
                        }
                }
                else
                {
                        if($array[1]>0)
                        {
                                if(exists $four{$name})
                                {
                                        if($four{$name} ne "up")
                                        {
                                                $four{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $four{$name}="up";
                                }
                        }
                        else
                        {
                                if(exists $four{$name})
                                {
                                        if($four{$name} ne "down")
                                        {
                                                $four{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $four{$name}="down";
                                }
                        }
                }

		if($array[4]>=0.001)
                {
                        if(exists $five{$name})
                        {
                                if($five{$name} ne "stable")
                                {
                                        $five{$name}="NULL";
                                }
                        }
                        else
                        {
                                $five{$name}="stable";
                        }
                }
                else
                {
                        if($array[1]>0)
                        {
                                if(exists $five{$name})
                                {
                                        if($five{$name} ne "up")
                                        {
                                                $five{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $five{$name}="up";
                                }
                        }
                        else
                        {
                                if(exists $five{$name})
                                {
                                        if($five{$name} ne "down")
                                        {
                                                $five{$name}="NULL";
                                        }
                                }
                                else
                                {
                                        $five{$name}="down";
                                }
                        }
                }
	}
	close IN;

	for($j=0;$j<5;$j++)
	{
		$result[$j]=0;
	}

	for($j=0;$j<3;$j++)
	{
		$total[$j]=0;
	}
	
	for($j=0;$j<6;$j++)
	{
		$store[$j]=0;
	}

	foreach $name (keys %one)
	{
		if(exists $up{$name})
		{
			$total[0]++;
		}
		elsif(exists $down{$name})
		{
			$total[1]++;
		}
		else
		{
			$total[2]++;
		}
	
		if($one{$name} eq "NULL")
		{
			$result[0]++;
			next;
		}
		if($one{$name} eq "up")
		{
			if(exists $up{$name})
			{
				$store[0]++;
			}
			else
			{
				$store[1]++;
			}
			next;
		}

		if($one{$name} eq "down")
		{
			if(exists $down{$name})
			{
				$store[2]++;
			}
			else
			{
				$store[3]++;
			}
			next;
		}
		
		if(exists $up{$name})
		{
			$store[5]++;
		}
		elsif(exists $down{$name})
		{
			$store[5]++;
		}
		else
		{
			$store[4]++;
		}
	}
	$result[5]=($store[0]+$store[2]+$store[4])/($total[0]+$total[1]+$total[2])*100;
	$result[10]=$store[0]/$total[0]*100;
	$result[15]=$store[0]/($store[0]+$store[1])*100;
	$result[20]=$store[2]/$total[1]*100;
	$result[25]=$store[2]/($store[2]+$store[3])*100;

	for($j=0;$j<6;$j++)
	{
		$store[$j]=0;
	}
	foreach $name (keys %two)
        {
		if($two{$name} eq "NULL")
                {
                        $result[1]++;
                        next;
                }
                if($two{$name} eq "up")
                {
                        if(exists $up{$name})
                        {
                                $store[0]++;
                        }
                        else
                        {
                                $store[1]++;
                        }
                        next;
                }

                if($two{$name} eq "down")
                {
                        if(exists $down{$name})
                        {
                                $store[2]++;
                        }
                        else
                        {
                                $store[3]++;
                        }
                        next;
                }
                
                if(exists $up{$name})
                {
                        $store[5]++;
                }
                elsif(exists $down{$name})
                {
                        $store[5]++;
                }
                else
                {
                        $store[4]++;
                }
        }
        $result[6]=($store[0]+$store[2]+$store[4])/($total[0]+$total[1]+$total[2])*100;
        $result[11]=$store[0]/$total[0]*100;
        $result[16]=$store[0]/($store[0]+$store[1])*100;
        $result[21]=$store[2]/$total[1]*100;
        $result[26]=$store[2]/($store[2]+$store[3])*100;

	for($j=0;$j<6;$j++)
	{
		$store[$j]=0;
	}
	foreach $name (keys %three)
        {
                if($three{$name} eq "NULL")
                {
                        $result[2]++;
                        next;
                }
                if($three{$name} eq "up")
                {
                        if(exists $up{$name})
                        {
                                $store[0]++;
                        }
                        else
                        {
                                $store[1]++;
                        }
                        next;
                }

                if($three{$name} eq "down")
                {
                        if(exists $down{$name})
                        {
                                $store[2]++;
                        }
                        else
                        {
                                $store[3]++;
                        }
                        next;
                }
                
                if(exists $up{$name})
                {
                        $store[5]++;
                }
                elsif(exists $down{$name})
                {
                        $store[5]++;
                }
                else
                {
                        $store[4]++;
                }
        }
        $result[7]=($store[0]+$store[2]+$store[4])/($total[0]+$total[1]+$total[2])*100;
        $result[12]=$store[0]/$total[0]*100;
        $result[17]=$store[0]/($store[0]+$store[1])*100;
        $result[22]=$store[2]/$total[1]*100;
        $result[27]=$store[2]/($store[2]+$store[3])*100;

	for($j=0;$j<6;$j++)
	{
		$store[$j]=0;
	}
	foreach $name (keys %four)
        {
                if($four{$name} eq "NULL")
                {
                        $result[3]++;
                        next;
                }
                if($four{$name} eq "up")
                {
                        if(exists $up{$name})
                        {
                                $store[0]++;
                        }
                        else
                        {
                                $store[1]++;
                        }
                        next;
                }

                if($four{$name} eq "down")
                {
                        if(exists $down{$name})
                        {
                                $store[2]++;
                        }
                        else
                        {
                                $store[3]++;
                        }
                        next;
                }
                
                if(exists $up{$name})
                {
                        $store[5]++;
                }
                elsif(exists $down{$name})
                {
                        $store[5]++;
                }
                else
                {
                        $store[4]++;
                }
        }
        $result[8]=($store[0]+$store[2]+$store[4])/($total[0]+$total[1]+$total[2])*100;
        $result[13]=$store[0]/$total[0]*100;
        $result[18]=$store[0]/($store[0]+$store[1])*100;
        $result[23]=$store[2]/$total[1]*100;
        $result[28]=$store[2]/($store[2]+$store[3])*100;

	for($j=0;$j<6;$j++)
	{
		$store[$j]=0;
	}
	foreach $name (keys %five)
        {
                if($five{$name} eq "NULL")
                {
                        $result[4]++;
                        next;
                }
                if($five{$name} eq "up")
                {
                        if(exists $up{$name})
                        {
                                $store[0]++;
                        }
                        else
                        {
                                $store[1]++;
                        }
                        next;
                }

                if($five{$name} eq "down")
                {
                        if(exists $down{$name})
                        {
                                $store[2]++;
                        }
                        else
                        {
                                $store[3]++;
                        }
                        next;
                }
                
                if(exists $up{$name})
                {
                        $store[5]++;
                }
                elsif(exists $down{$name})
                {
                        $store[5]++;
                }
                else
                {
                        $store[4]++;
                }
        }
        $result[9]=($store[0]+$store[2]+$store[4])/($total[0]+$total[1]+$total[2])*100;
        $result[14]=$store[0]/$total[0]*100;
        $result[19]=$store[0]/($store[0]+$store[1])*100;
        $result[24]=$store[2]/$total[1]*100;
        $result[29]=$store[2]/($store[2]+$store[3])*100;

	$total[3]=$total[0]+$total[1]+$total[2];
	print OUT $list[$i];
	for($j=0;$j<3;$j++)
	{
		$value=$total[$j]/$total[3]*100;
		printf(OUT "\t%d\(%0.2f%%\)",$total[$j],$value);
	}

	for($j=0;$j<30;$j++)
	{
		if($result[$j]=~/\./)
		{
			printf(OUT "\t%0.2f",$result[$j]);
		}
		else
		{
			print OUT "\t$result[$j]";
		}
	}
	print OUT "\n";
}
close OUT;
