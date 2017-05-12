use strict; use warnings;

my $line;
my @array;
my @num;
my $flag;
my $i;
my @class;
my %turn;
my %min;
my %len;
my $gi;
my @total;

if(@ARGV!=5)
{
	print "perl $0 anthozoa symbiodinium other squence_file output\n";
	exit;
}

for($i=0;$i<3;$i++)
{
	$num[$i]=0;
	$total[$i]=0;
}
$class[0]="anthozoa";
$class[1]="symbiodinium";
$class[2]="Fungi_or_Bacteria_or_Archaea_or_Virus";

if($ARGV[0]=~/gz$/)
{
	open(IN,"gzip -dc $ARGV[0] |") or die "Can't open $ARGV[0]\n";
}
else
{
	open(IN,"<$ARGV[0]") or die "can't open $ARGV[0]\n";
}
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
	if(exists $min{$array[0]})
	{
		if($array[10]<$min{$array[0]})
		{
			$min{$array[0]}=$array[10];
			$turn{$array[0]}=0;
		}
	}
	else
	{
		$min{$array[0]}=$array[10];
		$turn{$array[0]}=0;
	}
}
close IN;

if($ARGV[1]=~/gz$/)
{
        open(IN,"gzip -dc $ARGV[1] |") or die "Can't open $ARGV[1]\n";
}
else
{
	open(IN,"<$ARGV[1]") or die "can't open $ARGV[1]\n";
}
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
	if(exists $min{$array[0]})
	{
		if($array[10]<=$min{$array[0]})
		{
			$min{$array[0]}=$array[10];
			$turn{$array[0]}=1;
		}
	}
	else
	{
		$min{$array[0]}=$array[10];
		$turn{$array[0]}=1;
	}
}
close IN;

if($ARGV[2]=~/gz$/)
{
	open(IN,"gzip -dc $ARGV[2] |") or die "Can't open $ARGV[2]\n";
}
else
{
	open(IN,"<$ARGV[2]") or die "Can't open $ARGV[2]\n";
}
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
	if(exists $min{$array[0]})
	{
        	if($array[10]<=$min{$array[0]})        
        	{
        		$min{$array[0]}=$array[10];        
        	        $turn{$array[0]}=2;
        	}
	}
	else
	{
		$min{$array[0]}=$array[10];
		$turn{$array[0]}=2;
	}
}
close IN;

if($ARGV[3]=~/gz$/)
{
	open(IN,"gzip -dc $ARGV[3] |") or die "can't open $ARGV[3]\n";
}
else
{
	open(IN,"<$ARGV[3]") or die "Can't open $ARGV[3]\n";
}
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		($gi)=$line=~/^\>(\d+)$/;
		$len{$gi}=0;
		next;
	}
	$len{$gi}=$len{$gi}+length($line);
}
close IN;

open(OUT,">$ARGV[4]") or die "Can't create $ARGV[4]\n";
print OUT "Number\tSource\n";

foreach $line (keys %min)
{
	print OUT "$line\t$class[$turn{$line}]\n";
	$num[$turn{$line}]++;
	$total[$turn{$line}]+=$len{$line};
}
close OUT;

for($i=0;$i<3;$i++)
{
	if($num[$i]!=0)
	{
		$total[$i]/=$num[$i];
	}
}
printf("anthozoa has %d, average length is %0.2fbp\n",$num[0],$total[0]);
printf("symbiodinium has %d, average length is %0.2fbp\n",$num[1],$total[1]);
printf("other has %d, average length is %0.2fbp\n",$num[2],$total[2]);
