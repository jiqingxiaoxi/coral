use strict; use warnings;

my $line;
my $file;
my @array;
my %source;
my $gi;
my @num;
my @result;
my $flag;
my $i;
my %turn;
my %min;
my @anthozoa;
my @symbiodinium;
my @other;
my $j;
my $k;
my $m;

if(@ARGV!=2)
{
	print "perl $0 source output\n";
	exit;
}
$anthozoa[0]="method6all-anthozoa-with.blastn.gz";
$anthozoa[1]="method6all-anthozoa-without.blastn.gz";
$anthozoa[2]="method6part-anthozoa-with.blastn.gz";
$anthozoa[3]="method6part-anthozoa-without.blastn.gz";

$symbiodinium[0]="method6all-symbiodinium-with.blastn.gz";     
$symbiodinium[1]="method6all-symbiodinium-without.blastn.gz";
$symbiodinium[2]="method6part-symbiodinium-with.blastn.gz";   
$symbiodinium[3]="method6part-symbiodinium-without.blastn.gz";

$other[0]="Complete_f.blastn.gz";
$other[1]="En_f.blastn.gz";
$other[2]="need.blastn.gz";

$num[0]=0;
$num[1]=0;
$num[2]=0;
open(OUT,">$ARGV[1]") or die "can't create $ARGV[1]\n";
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	$line=$_;
	if($line=~/^Con/)
	{
		next;
	}
	@array=split("\t",$line);
	if($array[2]=~/^coral/)
	{
		$source{$array[0]}=0;
		$num[0]++;
	}
	elsif($array[2]=~/^symbiodinium/)
	{
		$source{$array[0]}=1;
		$num[1]++;
	}
	else
	{
		$source{$array[0]}=2;
		$num[2]++;
	}
	$min{$array[0]}=10;
	$turn{$array[0]}=-1;
}
close IN;
print OUT "In source, anthozoa is $num[0], symbiodinium is $num[1], other is $num[2]\n";

for($i=0;$i<4;$i++)
{
	for($j=0;$j<4;$j++)
	{
		for($k=0;$k<3;$k++)
		{
			print OUT "$anthozoa[$i]\t$symbiodinium[$j]\t$other[$k]";
			open(IN,"gzip -dc $anthozoa[$i] |") or die "Can't open $anthozoa[$i]\n";
			while(<IN>)
			{
				$line=$_;
				if($line=~/^\#/)
				{
					$flag=0;
					next;
				}
				if($flag>0)
				{
					next;
				}
				@array=split("\t",$line);
				$flag++;
				if($array[10]>1e-5)
				{
					next;
				}		
				($gi)=$array[0]=~/gi\|(\d+)\|/;
				if($array[10]<$min{$gi})
				{
					$min{$gi}=$array[10];
					$turn{$gi}=0;
				}
			}
			close IN;

		        open(IN,"gzip -dc $symbiodinium[$j] |") or die "Can't open $symbiodinium[$j]\n";
			while(<IN>)
			{
				$line=$_;
			        if($line=~/^\#/)
			        {
			        	$flag=0;
			        	next;
			        }
			        if($flag>0)
			        {
			        	next;
			        }
			        @array=split("\t",$line);
			        $flag++;
			        if($array[10]>1e-5)
			        {
			        	next;
			        }               
			        ($gi)=$array[0]=~/gi\|(\d+)\|/;
				if($array[10]<=$min{$gi})
				{
					$min{$gi}=$array[10];
					$turn{$gi}=1;
				}
			}
			close IN;

			open(IN,"gzip -dc $other[$k] |") or die "Can't open $other[$k]\n";
			while(<IN>)
			{
				$line=$_;
			        if($line=~/^\#/)
			        {
			        	$flag=0;
			        	next;
			        }
			        if($flag>0)
			        {
			        	next;
			        }
			        @array=split("\t",$line);
			        $flag++;
				if(@array<10)
				{
					next;
				}
			        if($array[10]>1e-5)
			        {
			        	next;
			        }
			        ($gi)=$array[0]=~/gi\|(\d+)\|/;
			        if($array[10]<=$min{$gi})        
				{
			        	$min{$gi}=$array[10];        
			                $turn{$gi}=2;
			        }
			}
			close IN;
	
			for($m=0;$m<9;$m++)
			{
				$result[$m]=0;
			}

			foreach $gi (keys %turn)
			{
				if($turn{$gi}==-1)
				{
					next;
				}
				$result[3*$turn{$gi}+$source{$gi}]++;
				$turn{$gi}=-1;
				$min{$gi}=10;

			}
			for($m=0;$m<9;$m++)
			{
				print OUT "\t$result[$m]";
			}
			print OUT "\n";
		}
	}
}
close OUT;
