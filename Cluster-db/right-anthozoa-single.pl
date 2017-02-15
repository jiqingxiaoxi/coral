use strict; use warnings;

my $line;
my @array;
my $i;
my $j;
my @value;
my $file;
my @db;
my @right;
my @wrong;
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

$db[0]="Ad";
$db[1]="Ep";
$db[2]="Nv";
$db[3]="Of";
$db[4]="Ps";
$db[5]="anthozoa-nucleotide";
$db[6]="anthozoa-gss";
$db[7]="anthozoa-est";
$db[8]="large-anthozoa-95";
$db[9]="small-anthozoa-95";
$threshold[0]=30;
$threshold[1]=40;
$threshold[2]=50;
$threshold[3]=60;
$threshold[4]=70;
$threshold[5]=80;
$threshold[6]=90;
$threshold[7]=100;

open(OUT,">$ARGV[1]") or die "Can't create $ARGV[1]\n";
print OUT "Num_Match\t$db[0]";
for($j=1;$j<8;$j++)
{
	print OUT "\t\+$db[$j]";
}
print OUT "\t$db[8]\t\+$db[9]\n";
##every threshold
for($i=0;$i<8;$i++)
{
	for($j=0;$j<@db;$j++)
	{
		$right[$i][$j]=0;
		$wrong[$i][$j]=0;
	}
}
##every db
for($j=0;$j<@db;$j++)
{
	for($i=0;$i<8;$i++)
	{
		if($j>0&&$j<8)
		{
			$right[$i][$j]=$right[$i][$j-1];
			$wrong[$i][$j]=$wrong[$i][$j-1];
		}	
		if($j==9)
		{
			$right[$i][$j]=$right[$i][$j-1];
			$wrong[$i][$j]=$wrong[$i][$j-1];
		}
	}
	$file=$ARGV[0]."-".$db[$j].".sam.gz";
	if($j==8||$j==0)
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
			if(! exists $three{$array[0]})
			{
				if($array[0]=~/coral/)
				{
					$right[0][$j]++;
				}
				else
				{
					$wrong[0][$j]++;
				}
				$three{$array[0]}=1;
			}
		}
		else
		{
			next;
		}
		
		if($value[0]>=$threshold[1])         
                {        
                        if(! exists $four{$array[0]})
                        {
				if($array[0]=~/coral/)
				{
                                	$right[1][$j]++;
				}
				else
				{
					$wrong[1][$j]++;
				}
                                $four{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

		if($value[0]>=$threshold[2])         
                {        
                        if(! exists $five{$array[0]})
                        {
				if($array[0]=~/coral/)
				{
					$right[2][$j]++;
				}
				else
				{
					$wrong[2][$j]++;
				}
                                $five{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

                if($value[0]>=$threshold[3])
                {
                        if(! exists $six{$array[0]})
                        {       
				if($array[0]=~/coral/)
				{          
                                	$right[3][$j]++;
				}
				else
				{
					$wrong[3][$j]++;
				}
                                $six{$array[0]}=1;
                        }
                }
                else
                {
                        next;
                }

		if($value[0]>=$threshold[4])         
                {        
                        if(! exists $seven{$array[0]})
                        {
				if($array[0]=~/coral/)
				{
                                	$right[4][$j]++;
				}
				else
				{
					$wrong[4][$j]++;
				}
                                $seven{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

                if($value[0]>=$threshold[5])
                {
                        if(! exists $eight{$array[0]})
                        {
				if($array[0]=~/coral/)
				{         
                                	$right[5][$j]++;
				}
				else
				{
					$wrong[5][$j]++;
				}
                                $eight{$array[0]}=1;
                      	}
                }
                else
                {
                        next;
                }

		if($value[0]>=$threshold[6])         
                {        
                        if(! exists $nine{$array[0]})
                        {
				if($array[0]=~/coral/)
				{
                                	$right[6][$j]++;
				}
				else
				{
					$wrong[6][$j]++;
				}
                                $nine{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

                if($value[0]>=$threshold[7])
                {
                        if(! exists $ten{$array[0]})
                        {        
				if($array[0]=~/coral/)
				{         
                                	$right[7][$j]++;
				}
				else
				{
					$wrong[7][$j]++;
				}
                                $ten{$array[0]}=1;
                        }
                }
                else
                {
                        next;
                }
	}
	close IN;
}
for($i=0;$i<8;$i++)
{
	print OUT "\>=$threshold[$i]";
	for($j=0;$j<@db;$j++)
	{
		$line=$right[$i][$j]/($right[$i][$j]+$wrong[$i][$j])*100;
		printf(OUT "\tR\_%d\,W\_%d\,Sp\_%0.2f%%",$right[$i][$j],$wrong[$i][$j],$line);
	}
	print OUT "\n";
}
close OUT;
