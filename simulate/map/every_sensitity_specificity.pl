##get the sensitity and specificity of every dataset
##only statistic Part_all
use strict; use warnings;

my $line;
my @array;
my $i;
my $temp;
my @total;
my $flag;
my @ref;
my $num;
my @store;

if(@ARGV!=3)
{
	print "perl $0 input_align_statistic_result  ref  output\n";
	exit;
}

open(OUT,">$ARGV[2]") or die "Can't create $ARGV[2]\n";
##get how many columns
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line!~/^Ref/)
	{
		next;
	}
	@array=split("\t",$line);
	$num=@array;
	$num-=2;

	print OUT "Iterm";
	for($i=2;$i<@array;$i++)
	{
		print OUT "\t$array[$i]";
	}
	last;
}
close IN;
print OUT "\n";

open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	$line=$_;
	@array=split("\t",$line);
	
	if($line=~/^\d\_\d+/)
	{
		if($line=~/Part\_all/)
		{
			$flag=1;
			($temp)=$line=~/^(.+)\:Part/;
			print OUT "$temp\n";
		}
		else
		{
			$flag=0;
			next;
		}
		for($i=0;$i<12;$i++)
		{
			$total[$i]=0;
		}
		next;
	}
	if($flag!=1)
	{
		next;
	}

	if($line=~/^Ref/)
	{
		next;
	}
	if($line=~/^$ARGV[1]/)
	{
		print OUT "sensitivity";
		for($i=0;$i<$num;$i++)
		{
			($temp)=$array[2+$i]=~/\((.+)\%/;
			$store[0][$i]=$temp;
			print OUT "\t$temp";
			($ref[$i])=$array[2+$i]=~/^(\d+)\(/;
		}
		print OUT "\n";
		next;
	}

	if($line=~/^\w+/)
	{
		for($i=0;$i<$num;$i++)
                {
                        ($temp)=$array[2+$i]=~/^(\d+)\(/;
			$total[$i]+=$temp;
		}
		next;
	}

	if($flag==1)
	{
		print OUT "specificity";
		for($i=0;$i<$num;$i++)
		{
			$temp=$ref[$i]/($ref[$i]+$total[$i])*100;
			$store[1][$i]=$temp;
			printf(OUT "\t%0.3f",$temp);
		}
		$flag=2;
		print OUT "\n";
		print OUT "\(sen+spe\)/2";
		for($i=0;$i<$num;$i++)
                {
                        $temp=($store[0][$i]+$store[1][$i])/2;
                        printf(OUT "\t%0.3f",$temp);
                }
		print OUT "\n\n";
	}
}
close IN;
close OUT;
