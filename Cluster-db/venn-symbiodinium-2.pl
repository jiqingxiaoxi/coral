use strict; use warnings;

my $line;
my @array;
my $i;
my $j;
my @value;
my $file;
my @db;
my @threshold;
my %three;
my %four;
my %five;
my %six;
my %seven;
my %eight;
my %nine;
my %ten;
my %self_three;
my %self_four;
my %self_five;
my %self_six;
my %self_seven;
my %self_eight;
my %self_nine;
my %self_ten;
my @total;

if(@ARGV!=2)
{
	print "perl $0 prefix_input  output\n";
	exit;
}

$db[0]="Sk";
$db[1]="Sm";
$db[2]="symbiodinium-nucleotide";
$db[3]="symbiodinium-gss";
$db[4]="symbiodinium-est";
$db[5]="final-symbiodinium";
$threshold[0]=30;
$threshold[1]=40;
$threshold[2]=50;
$threshold[3]=60;
$threshold[4]=70;
$threshold[5]=80;
$threshold[6]=90;
$threshold[7]=100;

for($i=0;$i<8;$i++)
{
	$total[$i]=0;
}
open(OUT,">$ARGV[1]") or die "Can't create $ARGV[1]\n";
print OUT "Num_Match\tSame\n";
##every db
for($j=0;$j<@db;$j++)
{
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
		if($j<5)
		{
			if($value[0]>=$threshold[0])
			{
				$three{$array[0]}=1;
			}
			else
			{
				next;
			}
		
			if($value[0]>=$threshold[1])         
                	{        
                                $four{$array[0]}=1;
        	        }        
        	        else
        	        {
        	                next;
        	        }

			if($value[0]>=$threshold[2])         
        	        {        
                        	$five{$array[0]}=1;
                	}        
                	else
                	{
                	        next;
                	}

                	if($value[0]>=$threshold[3])
                	{
                                $six{$array[0]}=1;
	                }
	                else
	                {
	                        next;
	                }

			if($value[0]>=$threshold[4])         
	                {        
                                $seven{$array[0]}=1;
	                }        
	                else
	                {
	                        next;
	                }

	                if($value[0]>=$threshold[5])
	                {
                                $eight{$array[0]}=1;
	                }
	                else
	                {
	                        next;
	                }

			if($value[0]>=$threshold[6])         
	                {        
                                $nine{$array[0]}=1;
	                }        
	                else
	                {
	                        next;
	                }

	                if($value[0]>=$threshold[7])
	                {
                                $ten{$array[0]}=1;
	                }
	                else
	                {
	                        next;
	                }
		}
		else
		{
			if($value[0]>=$threshold[0])
                        {
                                if(! exists $self_three{$array[0]})
                                {
                                        $self_three{$array[0]}=1;
					if(exists $three{$array[0]})
					{
						$total[0]++;
					}
                                }
                        }
                        else
                        {
                                next;
                        }
                
                        if($value[0]>=$threshold[1])         
                        {        
                                if(! exists $self_four{$array[0]})
                                {
                                        $self_four{$array[0]}=1;
					if(exists $four{$array[0]})
					{
						$total[1]++;
					}
                                }
                        }        
                        else
                        {
                                next;
                        }

                        if($value[0]>=$threshold[2])         
                        {        
                                if(! exists $self_five{$array[0]})
                                {
                                        $self_five{$array[0]}=1;
					if(exists $five{$array[0]})
					{
						$total[2]++;
					}
                                }
                        }        
                        else
                        {
                                next;
                        }

                        if($value[0]>=$threshold[3])
                        {
                                if(! exists $self_six{$array[0]})
                                {                 
                                        $self_six{$array[0]}=1;
					if(exists $six{$array[0]})
					{
						$total[3]++;
					}
                                }
                        }
                        else
                        {
                                next;
                        }

                        if($value[0]>=$threshold[4])         
                        {        
                                if(! exists $self_seven{$array[0]})
                                {
                                        $self_seven{$array[0]}=1;
					if(exists $seven{$array[0]})
					{
						$total[4]++;
					}
                                }
                        }        
                        else
                        {
                                next;
                        }

                        if($value[0]>=$threshold[5])
                        {
                                if(! exists $self_eight{$array[0]})
                                {                 
                                        $self_eight{$array[0]}=1;
					if(exists $eight{$array[0]})
					{
						$total[5]++;
					}
                                }
                        }
                        else
                        {
                                next;
                        }

                        if($value[0]>=$threshold[6])         
                        {        
                                if(! exists $self_nine{$array[0]})
                                {
                                        $self_nine{$array[0]}=1;
					if(exists $nine{$array[0]})
					{
						$total[6]++;
					}
                                }
                        }        
                        else
                        {
                                next;
                        }

                        if($value[0]>=$threshold[7])
                        {
                                if(! exists $self_ten{$array[0]})
                                {                 
                                        $self_ten{$array[0]}=1;
					if(exists $ten{$array[0]})
					{
						$total[7]++;
					}
                                }
                        }
                        else
                        {
                                next;
                        }
                }
	}
	close IN;
}
for($i=0;$i<8;$i++)
{
	print OUT "\>=$threshold[$i]\t$total[$i]\n";
}
close OUT;
