use strict; use warnings;

my $line;
my @array;
my %hash;
my %num;
my $i;
my @value;
my $temp;
my %go;
my $flag;
my %name;
my %space;
my %fc;

if(@ARGV!=4)
{
	print "perl $0 one two three output\n";
	exit;
}

for($i=0;$i<3;$i++)
{
	open(IN,"<$ARGV[$i]") or die "can't open $ARGV[$i]\n";
	while(<IN>)
	{
	        $line=$_;
	        if($line=~/^\"feature/)
	        {
	                next;
	        }
	        @array=split(" ",$line);
	        if($array[3]>=0.05)
	        {
	                last;
	        }
	        ($temp)=$array[1]=~/\"(.+)\"/;
		if(exists $fc{$temp})
		{
			$fc{$temp}=$fc{$temp}."-".$array[2];
			$num{$temp}++;
		}
		else
		{
			$num{$temp}=1;
			$fc{$temp}=$array[2];
		}
	}
	close IN;
}

open(IN,"</lustre/home/clslzy/bjia/By-Ref/Ad/GO/gene2GO.txt") or die "can't open gene2GO.txt\n";
while(<IN>)
{
	chomp;
	$line=$_;
	@array=split("\t",$line);
	if(! (exists $num{$array[0]}))
	{
		next;
	}
	if($num{$array[0]}!=3)
	{
		next;
	}
	$hash{$array[0]}=$array[1];
	
	@value=split(", ",$array[1]);
	for($i=0;$i<@value;$i++)
	{
		$go{$value[$i]}=1;
	}
}
close IN;

$flag=0;
open(IN,"</lustre/home/clslzy/bjia/Annotation/GO/db/go.obo") or die "Can't open go.obo\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^id: GO/)
	{
		($temp)=$line=~/id: (GO:\d+)$/;
		if(exists $go{$temp})
		{
			$flag=1;
		}
		else
		{
			$flag=0;
		}
		next;
	}

	if($flag==0)
	{
		next;
	}
	if($line=~/^name:/)
	{
		($name{$temp})=$line=~/name: (.+)$/;
		next;
	}

	if($line=~/^namespace:/)
	{
		($space{$temp})=$line=~/namespace: (.+)$/;
		$flag=0;
	}
}
close IN;

open(OUT,">$ARGV[3]") or die "can't create $ARGV[3]\n";
print OUT "Gene\t";
for($i=0;$i<3;$i++)
{
	if($ARGV[$i]=~/6dAH/ || $ARGV[$i]=~/rd9AH/)
	{
		print OUT "FC_AH\t";
	}
	elsif($ARGV[$i]=~/6dA/ || $ARGV[$i]=~/rd9A/)
	{
		print OUT "FC_A\t";
	}
	else
	{
		print OUT "FC_H\t";
	}
}
print OUT "GO\tNamespace\tName\n";

foreach $temp (keys %num)
{
	if($num{$temp}!=3)
	{
		next;
	}
	@value=split("-",$fc{$temp});
	printf(OUT "%s\t%0.2f\t%0.2f\t%0.2f\t",$temp,$value[0],$value[1],$value[2]);
	if(! (exists $hash{$temp}))
	{
		print OUT "No GO\n";
		next;
	}
	@value=split(", ",$hash{$temp});
	for($i=0;$i<@value;$i++)
	{
		if($i==0)
		{
			print OUT "$value[$i]\t$space{$value[$i]}\t$name{$value[$i]}\n";
		}
		else
		{
			print OUT "\t\t\t\t$value[$i]\t$space{$value[$i]}\t$name{$value[$i]}\n";
		}
	}
}
close OUT;
