use strict; use warnings;

my $compare;
my $total;
my $i;
my $file;
my @list;
my @compare;
my $j;

if(@ARGV!=1)
{
	print "perl $0 eXpress_or_sailfish\n";
	exit;
}

$compare[0]="6dA-C";
$compare[1]="6dH-C";
$compare[2]="6dAH-C";
$compare[3]="rd9A-C";
$compare[4]="rd9H-C";
$compare[5]="rd9AH-C";
$compare[6]="Cd9-6";
$compare[7]="Ad9-6";
$compare[8]="Hd9-6";
$compare[9]="AHd9-6";
$list[0]="as";
$list[1]="gs";

print "compare\tDESeq_p_0.05\tDESeq_adjp_0.05\tDESeq2_p_0.05\tDESeq2_adjp_0.05\tedgeR_p_0.05\tLimma_p_0.05\tLimma_adjp_0.05\n";
for($i=0;$i<@list;$i++)
{
	for($j=0;$j<@compare;$j++)
	{
		print "$list[$i]\:$compare[$j]";
		$file="DESeq/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
		if(! (-e $file))
		{
			print "\tNULL\tNULL";
		}
		else
		{
			$total=find_number($file,7);
			print "\t$total";
			$total=find_number($file,8);
			print "\t$total";
		}
		
		$file="DESeq2/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
                if(! (-e $file))
                {
                        print "\tNULL\tNULL";
                }
                else
                {
                        $total=find_number($file,5);
                        print "\t$total";
                        $total=find_number($file,6);
                        print "\t$total";
                }

		$file="edgeR/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
                if(! (-e $file))
                {
                        print "\tNULL";
                }
                else
                {
                        $total=find_number($file,3);
                        print "\t$total";
                }

		$file="Limma/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
                if(! (-e $file))
                {
                        print "\tNULL\tNULL\n";
                }
                else
                {
                        $total=find_number($file,4);
                        print "\t$total";
                        $total=find_number($file,5);
                        print "\t$total\n";
                }
	}
}

sub find_number
{
	my ($file,$pos)=@_;
	my $num=0;
	my $line;
	my @array;

	open(IN,"<$file") or die "can't open $file\n";
	while(<IN>)
	{
		chomp;
		$line=$_;
		if($line!~/^\"\d+/)
		{
			next;
		}
		@array=split("\t",$line);
		if($array[$pos]!~/\d+/)
		{
			next;
		}
		if($array[$pos]<0.05)
		{
			$num++;
		}
	}
	close IN;
	return $num;
}
