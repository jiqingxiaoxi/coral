use strict; use warnings;

my $line;
my $ko;
my $i;
my $j;
my @ko_list;
my %contig_turn;
my %ko_turn;
my @TPM;
my @list;
my $file;
my @average;
my @sd;
my $num;
my @total;
my @array;

if(@ARGV!=3)
{
	print "perl $0 photo-list  as_gs  output\n";
	exit;
}

$list[0]="6dA";
$list[1]="6dH";
$list[2]="6dAH";
$list[3]="6dC";
$list[4]="rd9A";
$list[5]="rd9H";
$list[6]="rd9AH";
$list[7]="rd9C";

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
		$TPM[$i][$j][1]=0;
		$TPM[$i][$j][2]=0;
		$TPM[$i][$j][3]=0;
		$sd[$i][$j]=0;
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
	for($j=1;$j<=3;$j++)
	{
		if($ARGV[1]=~/as/)
		{
			$file="/lustre/home/clslzy/bjia/eXpress/AS-95/as".$list[$i].$j."-result.txt";
		}
		else
		{
			$file="/lustre/home/clslzy/bjia/eXpress/GS-95/gs".$list[$i].$j."-result.txt";    
                }
		open(IN,"<$file") or die "Can't open $file!\n";
		while(<IN>)
		{
			chomp;
			$line=$_;
			@array=split("\t",$line);
			if(! (exists $contig_turn{$array[1]}))
			{
				next;
			}
			$TPM[$contig_turn{$array[1]}][$i][$j]+=$array[14];
		}
		close IN;
	}
}

open(OUT,">$ARGV[2]") or die "Can't create $ARGV[2]\n";
print OUT "KO\tNo.contigs";
for($i=0;$i<@list;$i++)
{
	print OUT "\t$list[$i]\_average\t$list[$i]\_sd";
}
print OUT "\n";
for($i=0;$i<$num;$i++)
{
	print OUT "$ko_list[$i]\t$total[$i]";
	for($j=0;$j<@list;$j++)
	{
		$average[$i][$j]=($TPM[$i][$j][1]+$TPM[$i][$j][2]+$TPM[$i][$j][3])/3;
		$sd[$i][$j]=($TPM[$i][$j][1]-$average[$i][$j])**2+($TPM[$i][$j][2]-$average[$i][$j])**2+($TPM[$i][$j][3]-$average[$i][$j])**2;
		$sd[$i][$j]=($sd[$i][$j]/3)**0.5;
		print OUT "\t$average[$i][$j]\t$sd[$i][$j]";
	}
	print OUT "\n";
}
print OUT "\n";
