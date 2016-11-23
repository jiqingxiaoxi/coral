use strict; use warnings;

my $line;
my @array;
my $i;
my $j;
my @average_paired;
my @average_single;
my @sd_paired;
my @sd_single;
my $temp;
my @max;
my @total;
my $flag;
my $num;
my @name;

if(@ARGV!=2)
{
	print "perl $0 input_align_statistic_result  output\n";
	exit;
}

$name[0]="coral";
$name[1]="symbiodinium";
$name[2]="others_all";
$name[3]="others_max";

for($i=0;$i<8;$i++)
{
	for($j=0;$j<4;$j++)
	{
		$average_paired[$j][$i]=0;
		$sd_paired[$j][$i]=0;
		$average_single[$j][$i]=0;
                $sd_single[$j][$i]=0;
	}
}

open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
$num=0;
while(<IN>)
{
	$line=$_;
	@array=split("\t",$line);
	if($line=~/^\d\_\d+/)
	{
		if($line=~/Paired/)
		{
			$flag=1;
			$num++;
		}
		else
		{
			$flag=0;
		}
		for($i=0;$i<8;$i++)
		{
			$total[$i]=0;
			$max[$i]=0;
		}
		$total[8]=0;
		next;
	}

	if($line=~/^Ref/)
	{
		next;
	}
	if($line=~/^coral/)
	{
		for($i=0;$i<8;$i++)
		{
			($temp)=$array[2+$i]=~/\((.+)\%/;
			if($flag==1)
			{
				$average_paired[0][$i]+=$temp;
			}
			else
			{
				$average_single[0][$i]+=$temp;
			}
		}
		next;
	}

	if($line=~/^symbiodinium/)
	{
		for($i=0;$i<8;$i++)
                {
                        ($temp)=$array[2+$i]=~/\((.+)\%/;
                        if($flag==1)
                        {
                                $average_paired[1][$i]+=$temp;
                        }
                        else
                        {
                                $average_single[1][$i]+=$temp;
                        }
                }
                next;
        }

	if($line=~/^\w+\_/)
	{
		for($i=0;$i<8;$i++)
                {
                        ($temp)=$array[2+$i]=~/^(\d+)\(/;
			$total[$i]+=$temp;

			($temp)=$array[2+$i]=~/\((.+)\%/;
			if($temp>$max[$i])
			{
				$max[$i]=$temp;
			}
		}
		$total[8]+=$array[1];
		next;
	}

	if($flag==1)
	{
		for($i=0;$i<8;$i++)
		{
			$average_paired[3][$i]+=$max[$i];
			$average_paired[2][$i]=$average_paired[2][$i]+$total[$i]/$total[8]*100;
		}
		$flag=2;
	}
	elsif($flag==0)
	{
		for($i=0;$i<8;$i++)
                {
                        $average_single[3][$i]+=$max[$i];
                        $average_single[2][$i]=$average_paired[2][$i]+$total[$i]/$total[8]*100;
                }
                $flag=2;
        }
	else
	{
		next;
	}
}
close IN;

for($i=0;$i<4;$i++)
{
        for($j=0;$j<8;$j++)
        {
                $average_single[$i][$j]/=$num;
		$average_paired[$i][$j]/=$num;
	}
}

open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
        $line=$_;
        @array=split("\t",$line);
        if($line=~/^\d\_\d+/)
        {
                if($line=~/Paired/)
                {
                        $flag=1;
                }
                else
                {
                        $flag=0;
                }
                for($i=0;$i<8;$i++)
                {
                        $total[$i]=0;
                        $max[$i]=0;
                }
                $total[8]=0;
                next;
        }

        if($line=~/^Ref/)
        {
                next;
        }
        if($line=~/^coral/)
        {
                for($i=0;$i<8;$i++)
                {
                        ($temp)=$array[2+$i]=~/\((.+)\%/;
                        if($flag==1)
                        {
                                $sd_paired[0][$i]=$sd_paired[0][$i]+($temp-$average_paired[0][$i])**2;
                        }
                        else
                        {
                                $sd_single[0][$i]=$sd_single[0][$i]+($temp-$average_single[0][$i])**2;
                        }
                }
                next;
        }

        if($line=~/^symbiodinium/)
        {
                for($i=0;$i<8;$i++)
                {
                        ($temp)=$array[2+$i]=~/\((.+)\%/;
                        if($flag==1)
                        {
				$sd_paired[1][$i]=$sd_paired[1][$i]+($temp-$average_paired[1][$i])**2;
                        }
                        else
                        {
				$sd_single[1][$i]=$sd_single[1][$i]+($temp-$average_single[1][$i])**2;
                        }
                }
                next;
        }

        if($line=~/^\w+\_/)
        {
                for($i=0;$i<8;$i++)
                {
                        ($temp)=$array[2+$i]=~/^(\d+)\(/;
                        $total[$i]+=$temp;

                        ($temp)=$array[2+$i]=~/\((.+)\%/;
                        if($temp>$max[$i])
                        {
                                $max[$i]=$temp;
                        }
                }
                $total[8]+=$array[1];
                next;
        }

        if($flag==1)
        {
                for($i=0;$i<8;$i++)
                {
                        $sd_paired[3][$i]=$sd_paired[3][$i]+($max[$i]-$average_paired[3][$i])**2;
                        $sd_paired[2][$i]=$sd_paired[2][$i]+($total[$i]/$total[8]*100-$average_paired[2][$i])**2;
                }
                $flag=2;
        }
        elsif($flag==0)
        {
                for($i=0;$i<8;$i++)
                {
			$sd_single[3][$i]=$sd_single[3][$i]+($max[$i]-$average_single[3][$i])**2;
                        $sd_single[2][$i]=$sd_single[2][$i]+($total[$i]/$total[8]*100-$average_single[2][$i])**2;
                }
                $flag=2;
        }
        else
        {
                next;
        }
}
close IN;

for($i=0;$i<4;$i++)
{
	for($j=0;$j<8;$j++)
	{
		$sd_paired[$i][$j]=($sd_paired[$i][$j]/$num)**0.5;
		$sd_single[$i][$j]=($sd_single[$i][$j]/$num)**0.5;
	}
}

open(OUT,">$ARGV[1]") or die "Can't create $ARGV[1]\n";
print OUT "Iterms\t>=50bp\t>=95\%\t>=90\%\t>=80\%\t>=70\%\t>=60\%\t>=50\%\>0%\n";
print OUT "Paired:average\n";
for($i=0;$i<4;$i++)
{
	print OUT $name[$i];
	for($j=0;$j<8;$j++)
	{
		printf(OUT "\t%0.3f",$average_paired[$i][$j]);
	}
	print OUT "\n";
}

print OUT "Paired\:sd\n";
for($i=0;$i<4;$i++)
{
        print OUT $name[$i];
        for($j=0;$j<8;$j++)
        {
                printf(OUT "\t%0.3f",$sd_paired[$i][$j]);
        }
        print OUT "\n";
}

print OUT "\n\n";
print OUT "Single:average\n";
for($i=0;$i<4;$i++)
{
        print OUT $name[$i];
        for($j=0;$j<8;$j++)
        {
                printf(OUT "\t%0.3f",$average_single[$i][$j]);
        }
        print OUT "\n";
}

print OUT "Single\:sd\n";
for($i=0;$i<4;$i++)
{
        print OUT $name[$i];
        for($j=0;$j<8;$j++)
        {
                printf(OUT "\t%0.3f",$sd_single[$i][$j]);     
        }
        print OUT "\n";
}
close OUT;
