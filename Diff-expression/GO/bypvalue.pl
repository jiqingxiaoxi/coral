use strict; use warnings;

my $line;
my @array;
my $gene;
my $i;
my @record;
my @value;
my $temp;
my %hash;
my %go;
my $flag;
my $j;
my %name;
my %space;
my %need;
my $k;
if(@ARGV!=5)
{
	print "perl $0 diff-file source_file gene2GO_file num_think output\n";
	exit;
}

open(IN,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	$need{$line}=1;
}
close IN;

for($i=0;$i<$ARGV[3];$i++)
{
	$record[$i][1]=1;
}

open(IN,"<$ARGV[0]") or die "can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^GI/)
	{
		next;
	}
	@array=split("\t",$line);

	if($array[2]>=$record[$ARGV[3]-1][1])
	{
		next;
	}
	if(! (exists $need{$array[0]}))
        {
                next;
        }
	for($j=$ARGV[3]-1;$j>=1;$j--)
	{
		if($array[2]<$record[$j][1])
		{
			$record[$j][0]=$record[$j-1][0];
			$record[$j][1]=$record[$j-1][1];
			$record[$j][2]=$record[$j-1][2];
		}
		else
		{
			last;
		}
	}
	if($array[2]<$record[0][1])
	{
		$record[0][0]=$array[0];
		$record[0][1]=$array[2];
		$record[0][2]=$array[1];
	}
	else
	{
		$record[$j+1][0]=$array[0];
		$record[$j+1][1]=$array[2];
		$record[$j+1][2]=$array[1];
	}
}
close IN;
for($i=0;$i<$ARGV[3];$i++)
{
	if($record[$i][1]==1)
	{
		last;
	}
	$hash{$record[$i][0]}=1;
}
open(IN,"<$ARGV[2]") or die "can't open $ARGV[2]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	@array=split("\t",$line);
	if(! (exists $hash{$array[0]}))
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

open(OUT,">$ARGV[4]") or die "can't create $ARGV[4]\n";
print OUT "Gene\tPvalue\tFC\tGO\tNamespace\tName\n";
for($i=0;$i<$ARGV[3];$i++)
{
	if($record[$i][1]==1)
	{
		last;
	}
	printf(OUT "%s\t%0.9f\t%0.9f\t",$record[$i][0],$record[$i][1],$record[$i][2]);
	if($hash{$record[$i][0]} eq "1")
	{
		print OUT "No GO\n";
		next;
	}
	@value=split(", ",$hash{$record[$i][0]});
	for($j=0;$j<@value;$j++)
	{
		if($j==0)
		{
			print OUT "$value[$j]\t$space{$value[$j]}\t$name{$value[$j]}\n";
		}
		else
		{
			print OUT "\t\t\t$value[$j]\t$space{$value[$j]}\t$name{$value[$j]}\n";
		}
	}
}
close OUT;
