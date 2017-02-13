use strict; use warnings;

my $line;
my @array;
my $i;
my $j;
my @value;
my $file;
my @db;
my @result;
my @threshold;
my %three;
my %four;
my %five;
my %six;
my %seven;
my %eight;
my %nine;
my %ten;

if(@ARGV!=2)
{
	print "perl $0 prefix_input  output\n";
	exit;
}

$db[0]="SSU-1";
$db[1]="SSU-2";
$db[2]="LSU";
$db[3]="bacteria";
$db[4]="archaea";
$db[5]="fungi";
$db[6]="all";
$db[7]="0.95";
$db[8]="0.9";
$threshold[0]=30;
$threshold[1]=40;
$threshold[2]=50;
$threshold[3]=60;
$threshold[4]=70;
$threshold[5]=80;
$threshold[6]=90;
$threshold[7]=100;

open(OUT,">$ARGV[1]") or die "Can't create $ARGV[1]\n";
print OUT "Num_Match";
for($j=0;$j<@db;$j++)
{
	print OUT "\t$db[$j]";
}
print OUT "\n";
##every threshold
for($i=0;$i<8;$i++)
{
	for($j=0;$j<@db;$j++)
	{
		$result[$i][$j]=0;
	}
}
##every db
for($j=0;$j<@db;$j++)
{
	if($j==6)
	{
		foreach $line (keys %three)
		{
			delete($three{$line});
		}
		foreach $line (keys %four)
		{
			delete($four{$line});
		}
		foreach $line (keys %five)
		{
			delete($five{$line});
		}
		foreach $line (keys %six)
		{
			delete($six{$line});
		}
		foreach $line (keys %seven)
		{
			delete($seven{$line});
		}
		foreach $line (keys %eight)
		{
			delete($eight{$line});
		}
		foreach $line (keys %nine)
		{
			delete($nine{$line});
		}
		foreach $line (keys %ten)
		{
			delete($ten{$line});
		}
	}
	$file=$ARGV[0]."-".$db[$j].".sam.gz";
	open(IN,"gzip -dc $file |") or die "$file\n";
	while(<IN>)
	{
		$line=$_;
		@array=split("\t",$line);
		if(@array<10)
		{
			next;
		}
		$value[0]=length($array[9]);
		if($array[5]=~/^\d+[SH]/)
		{
			($value[1])=$array[5]=~/^(\d+)[SH]/;
			$value[0]-=$value[1];
		}
		if($array[5]=~/\d+[SH]$/)
		{
			($value[1])=$array[5]=~/[A-Z](\d+)[SH]$/;
			$value[0]-=$value[1];
		}
		($value[1])=$line=~/NM\:i\:(\d+)/;
		$value[0]-=$value[1];
		if($value[0]>=$threshold[0])
		{
			if(exists $three{$array[0]})
			{
				if($three{$array[0]}!=$j)
				{
					$three{$array[0]}=-1;
				}
			}
			else
			{
				$three{$array[0]}=$j;
			}
		}
		else
		{
			next;
		}
		
		if($value[0]>=$threshold[1])         
                {        
                        if(exists $four{$array[0]})
                        {
				if($four{$array[0]}!=$j)
				{
					$four{$array[0]}=-1;
				}
                        }
			else
			{
				$four{$array[0]}=$j;
			}
                }        
                else
                {
                        next;
                }

		if($value[0]>=$threshold[2])         
                {        
                        if(exists $five{$array[0]})
                        {
				if($five{$array[0]}!=$j)
				{
					$five{$array[0]}=-1;
				}
                        }
			else
			{
				$five{$array[0]}=$j;
			}
                }        
                else
                {
                        next;
                }

                if($value[0]>=$threshold[3])
                {
                        if(exists $six{$array[0]})
                        {
				if($six{$array[0]}!=$j)
				{
					$six{$array[0]}=-1;
				}
                        }
			else
			{
				$six{$array[0]}=$j;
			}
                }
                else
                {
                        next;
                }

		if($value[0]>=$threshold[4])         
                {        
                        if(exists $seven{$array[0]})
                        {
				if($seven{$array[0]}!=$j)
				{
					$seven{$array[0]}=-1;
				}
                        }
			else
			{
				$seven{$array[0]}=$j;
			}
                }        
                else
                {
                        next;
                }

                if($value[0]>=$threshold[5])
                {
                        if(exists $eight{$array[0]})
                        {
				if($eight{$array[0]}!=$j)
				{
					$eight{$array[0]}=-1;
				}
                      	}
			else
			{
				$eight{$array[0]}=$j;
			}
                }
                else
                {
                        next;
                }

		if($value[0]>=$threshold[6])         
                {        
                        if(exists $nine{$array[0]})
                        {
				if($nine{$array[0]}!=$j)
				{
					$nine{$array[0]}=-1;
				}
                        }
			else
			{
				$nine{$array[0]}=$j;
			}
                }        
                else
                {
                        next;
                }

                if($value[0]>=$threshold[7])
                {
                        if(exists $ten{$array[0]})
                        {
				if($ten{$array[0]}!=$j)
				{
					$ten{$array[0]}=-1;
				}
                        }
			else
			{
				$ten{$array[0]}=$j;
			}
                }
                else
                {
                        next;
                }
	}
	close IN;

	if($j==5||$j==8)
	{
		foreach $line (keys %three)
		{
			$i=$three{$line};
			if($i>=0)
			{
				$result[0][$i]++;
			}
		}
		foreach $line (keys %four)
		{
		        $i=$four{$line};
		        if($i>=0)
		        {
		                $result[1][$i]++;
		        }
		}
		foreach $line (keys %five)
		{
		        $i=$five{$line};
		        if($i>=0)
		        {
		                $result[2][$i]++;
		        }
		}
		foreach $line (keys %six)
		{
		        $i=$six{$line};
		        if($i>=0)
		        {
		                $result[3][$i]++;
		        }
		}
		foreach $line (keys %seven)
		{
		        $i=$seven{$line};
		        if($i>=0)
		        {
		                $result[4][$i]++;
		        }	
		}
		foreach $line (keys %eight)
		{
		        $i=$eight{$line};
		        if($i>=0)
		        {
		                $result[5][$i]++;
		        }
		}
		foreach $line (keys %nine)
		{
		        $i=$nine{$line};
		        if($i>=0)
		        {
		                $result[6][$i]++;
		        }
		}
		foreach $line (keys %ten)
		{
		        $i=$ten{$line};
		        if($i>=0)
		        {
		                $result[7][$i]++;
		        }
		}
	}
}

for($i=0;$i<8;$i++)
{
	print OUT "\>=$threshold[$i]";
	for($j=0;$j<@db;$j++)
	{
		print OUT "\t$result[$i][$j]";
	}
	print OUT "\n";
}
close OUT;
