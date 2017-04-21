use strict; use warnings;

my $line;
my @file;
my @store;
my $i;
my $j;
my $num=0;
my $total;
my @array;
my $repeate;
my $value;
my %turn;

if(@ARGV!=4)
{
	print "perl $0 prefix_first  prefix_second  threshold_No._per_gene output_file\n";
	exit;
}

if($ARGV[1]=~/asrd9H/)
{
	$repeate=4;
	$file[6]=$ARGV[1]."3-sup-result.txt";
}
else
{
	$repeate=3;
}
for($i=1;$i<4;$i++)
{
	$file[$i-1]=$ARGV[0].$i."-result.txt";
	$file[$i+2]=$ARGV[1].$i."-result.txt";
}

open(IN,"<$file[0]") or die "can't open $file[0]\n";
while(<IN>)
{
	$line=$_;
	if($line=~/^bundle/)
	{
		next;
	}
	@array=split("\t",$line);
	$turn{$array[1]}=$num;
	$value=$array[6]+0.5;
	if($value=~/\./)
	{
		($value)=$value=~/^(\d+)\./;
	}
	$store[$num][0]=$value;
	$num++;
}
close IN;

for($i=1;$i<3+$repeate;$i++)
{
	open(IN,"<$file[$i]") or die "Can't open $file[$i]\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^bundle/)
		{
			next;
		}
		@array=split("\t",$line);
		$value=$array[6]+0.5;
		if($value=~/\./)
		{
			($value)=$value=~/^(\d+)\./;
		}
		$store[$turn{$array[1]}][$i]=$value;
	}
	close IN;
}

$file[1]=$ARGV[3].".data";
open(OUT,">$file[1]") or die "can't create $file[0]\n";
if($repeate==3)
{
	print OUT "ID\tOne1\tOne2\tOne3\tTwo1\tTwo2\tTwo3\n";
}
else
{
	print OUT "ID\tOne1\tOne2\tOne3\tTwo1\tTwo2\tTwo3\tTwo4\n";
}

foreach $i (keys %turn)
{
	$total=0;

	$num=$turn{$i};	
	for($j=0;$j<$repeate+3;$j++)
	{
		$total+=$store[$num][$j];
	}
	if($total<$ARGV[2])
	{
		next;
	}
	print OUT $i;
	for($j=0;$j<3+$repeate;$j++)
	{
		print OUT "\t$store[$num][$j]";
	}
	print OUT "\n";
}
close OUT;

$file[2]=$ARGV[3].".R";
open(OUT,">$file[2]");
print OUT "library\(DESeq2\)\n";
print OUT "cts\<\- as.matrix\(read.table\(\"$file[1]\"\,head=T\,row.names=1\)\)\n";
if($repeate==3)
{
	print OUT "coldata\<-data.frame\(file=c\(\"One1\",\"One2\",\"One3\",\"Two1\",\"Two2\",\"Two3\"\),condition=c\(\"One\",\"One\",\"One\",\"Two\",\"Two\",\"Two\"\),row.names=1\)\n";
}
else
{
	print OUT "coldata\<-data.frame\(file=c\(\"One1\",\"One2\",\"One3\",\"Two1\",\"Two2\",\"Two3\",\"Two4\"\),condition=c\(\"One\",\"One\",\"One\",\"Two\",\"Two\",\"Two\",\"Two\"\),row.names=1\)\n";
}
print OUT "dds \<- DESeqDataSetFromMatrix\(countData=cts,colData=coldata,design=\~condition\)\n"; 
print OUT "dds\$condition \<- factor\(dds\$condition, levels=c\(\"One\",\"Two\"\)\)\n";
print OUT "dds \<- DESeq\(dds\)\n";
print OUT "res \<- results\(dds\)\n";
print OUT "write.table\(res,file=\"$ARGV[3]\",sep=\"\\t\"\)\n";
close OUT;

system("Rscript $file[2]");
##system("rm $file[2]");
