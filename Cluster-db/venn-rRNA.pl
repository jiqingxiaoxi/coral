use strict; use warnings;

my $line;
my @array;
my $i;
my $j;
my $k;
my $num;
my $flag;
my @value;
my $file;
my @db;
my @threshold;
my @name;
my @first;
my @second;
my @third;
my @total;

if(@ARGV!=3)
{
	print "perl $0 prefix_input sequence_file  output\n";
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
$threshold[0]=30;
$threshold[1]=40;
$threshold[2]=50;
$threshold[3]=60;
$threshold[4]=70;
$threshold[5]=80;
$threshold[6]=90;
$threshold[7]=100;

if($ARGV[1]=~/gz$/)
{
	open(IN,"gzip -dc $ARGV[1] |") or die "$ARGV[1]\n";
}
else
{
	open(IN,"<$ARGV[1]") or die "$ARGV[1]\n";
}

$line=<IN>;
chomp $line;
if($line=~/^\@/)
{
	$num=4;
	($name[0])=$line=~/^.(.+)$/;
}
else
{
	$num=2;
	($name[0])=$line=~/^.(.+)$/;
}
$i=1;
$j=1;
while(<IN>)
{
	$i++;
	if($i%$num!=1)
	{
		next;
	}
	chomp;
	$line=$_;
	($name[$j])=$line=~/^.(.+)$/;
	$j++;
}
close IN;
$num=$j;

for($i=0;$i<$num;$i++)
{
	for($j=0;$j<8;$j++)
	{
		$first[$i][$j]=0;
		$second[$i][$j]=0;
		$third[$i][$j]=0;
	}
}
##every db
for($j=0;$j<@db;$j++)
{
	$file=$ARGV[0]."-".$db[$j].".sam.gz";
	$i=0;
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
	
		$flag=0;
		while($i<$num)
		{
			if($name[$i]=~/^$array[0]/)
			{
				$flag=1;
				last;
			}
			$i++;
		}
		if($flag==0)
		{
			print "Don't have $array[0]\n";
			exit;
		}
		for($k=0;$k<8;$k++)
		{
			if($value[0]>=$threshold[$k])
			{
				if($j<6)
				{
					$first[$i][$k]=1;
				}
				elsif($j==6)
				{
					$second[$i][$k]=1;
				}
				else
				{
					$third[$i][$k]=1;
				}
			}
		}
	}
	close IN;
}
open(OUT,">$ARGV[2]") or die "can't create $ARGV[2]\n";
print OUT "Num_Match\tAll\t0.95\n";
for($i=0;$i<8;$i++)
{
	print OUT "\>=$threshold[$i]\t";
	$total[0]=0;
	$total[1]=0;
	for($j=0;$j<$num;$j++)
	{
		if($first[$j][$i]&&$second[$j][$i])
		{
			$total[0]++;
		}
		if($first[$j][$i]&&$third[$j][$i])
		{
			$total[1]++;
		}
        }
        print OUT "$total[0]\t$total[1]\n";
}
close OUT;
