use strict; use warnings;

my $line;
my $prefix;
my $file;
my $i;
my @result;
my %hash;
my $total;
my $value;
my $turn;

if(@ARGV!=3)
{
	print "perl $0 file_list  file_dir  output_file\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "can't open $ARGV[0]\n"; 
open(OUT,">$ARGV[2]") or die "Can't create $ARGV[2]\n"; 
print OUT "file\tNo.\tMax\tAverage\tN50\n";
while(<LIST>) 
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;
        if($ARGV[1]=~/\/$/)
        {
                $file=$ARGV[1].$prefix."-trinity.Trinity.fasta.gz";
        }
        else
        {
                $file=$ARGV[1]."/".$prefix."-trinity.Trinity.fasta.gz";
        }

	foreach $value (keys %hash)
	{
		delete($hash{$value});
	}
	$turn=0;
	for($i=0;$i<4;$i++)
	{
		$result[$i]=0;
	}
	open(IN,"gzip -dc $file |") or die "Can't open $file\n";
	while(<IN>)
	{
		$line=$_;
		if($line!~/^\>/)
		{
			next;
		}
		($value)=$line=~/len=(\d+) path/;
		if($value<300)
		{
			next;
		}
		$hash{$turn}=$value;
		$turn++;
		if($value>$result[1])
		{
			$result[1]=$value;
		}
		$result[2]+=$value;
	}
	close IN;
	$result[0]=$turn;
	$total=$result[2]/2;
	$result[2]/=$turn;
##N50
	$value=0;
	foreach $turn (sort{$hash{$a}<=>$hash{$b}} keys %hash)
	{
		$value+=$hash{$turn};
		if($value>=$total)
		{
			$result[3]=$hash{$turn};
			last;
		}
	}
##output
        print OUT $prefix;
	printf OUT ("\t%d\t%d\t%0.2f\t%d\n",$result[0],$result[1],$result[2],$result[3]);
}
close LIST;
close OUT;
