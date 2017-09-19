use strict; use warnings;

my $line;
my $ko;
my $i;
my $j;
my @ko_list;
my %contig_turn;
my %ko_turn;
my @up;
my @down;
my $temp;
my @list;
my $file;
my $num;
my @total;
my @array;

if(@ARGV!=3)
{
	print "perl $0 photo-list  as_gs  output\n";
	exit;
}

$list[0]="6dA-C";
$list[1]="6dH-C";
$list[2]="6dAH-C";
$list[3]="rd9A-C";
$list[4]="rd9H-C";
$list[5]="rd9AH-C";

$i=0;
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	$line=$_;
	($ko)=$line=~/^ko:(K\d+) /;
	$ko_list[$i]=$ko;
	$ko_turn{$ko}=$i;
	$i++;
}
close IN;
$num=$i;

for($i=0;$i<$num;$i++)
{
	for($j=0;$j<@list;$j++)
	{
		$up[$i][$j]=0;
		$down[$i][$j]=0;
	}
	$total[$i]=0;
}

##contig_Ko
if($ARGV[1]=~/as/)
{
	$file="/lustre/home/clslzy/bjia/Annotation/KEGG/KEGG-AS.txt";
}
else
{
	$file="/lustre/home/clslzy/bjia/Annotation/KEGG/KEGG-GS.txt";
}
open(IN,"<$file") or die "Can't open $file!\n";
while(<IN>)
{
	chomp;
	$line=$_;
	@array=split("\t",$line);
	if(exists $ko_turn{$array[1]})
	{
		$contig_turn{$array[0]}=$ko_turn{$array[1]};
		$total[$ko_turn{$array[1]}]++;
	}
}
close IN;

##eXpress result
for($i=0;$i<@list;$i++)
{
	if($ARGV[1]=~/as/)
	{
		$file="/lustre/home/clslzy/bjia/Diff-expression/Same/as".$list[$i]."-list.txt";
	}
	else
	{
		$file="/lustre/home/clslzy/bjia/Diff-expression/Same/gs".$list[$i]."-list.txt";    
	}
	open(IN,"<$file") or die "Can't open $file!\n";
	while(<IN>)
	{
		$line=$_;
		@array=split("\t",$line);
		if(! (exists $contig_turn{$array[0]}))
		{
			next;
		}
		if($array[1] eq "up")
		{
			$up[$contig_turn{$array[0]}][$i]++;
		}
		else
		{
			$down[$contig_turn{$array[0]}][$i]++;
		}
	}
	close IN;
}

open(OUT,">$ARGV[2]") or die "Can't create $ARGV[2]\n";
print OUT "KO\tNo.contigs";
for($i=0;$i<@list;$i++)
{
	print OUT "\t$list[$i]\_up\t$list[$i]\_down\t$list[$i]\_stable";
}
print OUT "\n";
for($i=0;$i<$num;$i++)
{
	print OUT "$ko_list[$i]\t$total[$i]";
	for($j=0;$j<@list;$j++)
	{
		$temp=$total[$i]-$up[$i][$j]-$down[$i][$j];
		print OUT "\t$up[$i][$j]\t$down[$i][$j]\t$temp";
	}
	print OUT "\n";
}
print OUT "\n";
