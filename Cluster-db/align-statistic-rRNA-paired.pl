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
my $before;
my $one;
my $two;

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
print OUT "Num_Match\t$db[0]";
for($j=1;$j<6;$j++)
{
	print OUT "\t\+$db[$j]";
}
print OUT "\t$db[6]\t$db[7]\t$db[8]\n";
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
	for($i=0;$i<8;$i++)
	{
		if($j>0&&$j<6)
		{
			$result[$i][$j]=$result[$i][$j-1];
		}	
	}
	$file=$ARGV[0]."-".$db[$j].".sam.gz";
	if($j>=6||$j==0)
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
	$before="";
	while(<IN>)
	{
		$line=$_;
		@array=split("\t",$line);
		if(@array<10)
		{
			next;
		}
		if($before ne $array[0])
		{
			$before=$array[0];
			$one=0;
			$two=0;
		}

		$value[1]=($array[1]-$array[1]%2)/2%2;
		if($value[1]==0)
		{
			next;  ##not paired
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

	##first and second paired
		if(($array[1]-$array[1]%64)/64%2==1)
		{
			$one=$value[0];
		}
		else
		{
			$two=$value[0];
		}
		if($one>=$threshold[0]&&$two>=$threshold[0])
		{
			if(! exists $three{$array[0]})
			{
				$result[0][$j]++;
				$three{$array[0]}=1;
			}
		}
		else
		{
			next;
		}
		
		if($one>=$threshold[1]&&$two>=$threshold[1])  
                {        
                        if(! exists $four{$array[0]})
                        {
                                $result[1][$j]++;
                                $four{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

		if($one>=$threshold[2]&&$two>=$threshold[2])
                {        
                        if(! exists $five{$array[0]})
                        {
                                $result[2][$j]++;
                                $five{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

                if($one>=$threshold[3]&&$two>=$threshold[3])
                {
                        if(! exists $six{$array[0]})
                        {                 
                                $result[3][$j]++;
                                $six{$array[0]}=1;
                        }
                }
                else
                {
                        next;
                }

		if($one>=$threshold[4]&&$two>=$threshold[4])
                {        
                        if(! exists $seven{$array[0]})
                        {
                                $result[4][$j]++;
                                $seven{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

                if($one>=$threshold[5]&&$two>=$threshold[5])
                {
                        if(! exists $eight{$array[0]})
                        {                 
                                $result[5][$j]++;
                                $eight{$array[0]}=1;
                      	}
                }
                else
                {
                        next;
                }

		if($one>=$threshold[6]&&$two>=$threshold[6])
                {        
                        if(! exists $nine{$array[0]})
                        {
                                $result[6][$j]++;
                                $nine{$array[0]}=1;
                        }
                }        
                else
                {
                        next;
                }

                if($one>=$threshold[7]&&$two>=$threshold[7])
                {
                        if(! exists $ten{$array[0]})
                        {                 
                                $result[7][$j]++;
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
		print OUT "\t$result[$i][$j]";
	}
	print OUT "\n";
}
close OUT;
