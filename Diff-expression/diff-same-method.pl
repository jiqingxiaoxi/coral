use strict; use warnings;

my $compare;
my $total;
my $file;
my @compare;
my $j;
my %hash;
my $gi;

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

print "compare\teXpress\tsailfish\tBoth\teXpress\tsailfish\tBoth\teXpress\tsailfish\tBoth\teXpress\tsailfish\tBoth\n";
for($j=0;$j<@compare;$j++)
{
	print $compare[$j];

	$file="DESeq/eXpress-as".$compare[$j].".txt";
	$total=find_number($file,8,1);
	print "\t$total";
	$file="DESeq/sailfish-as".$compare[$j].".txt";
        $total=find_number($file,8,1);
        print "\t$total";
	$total=0;
	foreach $gi (keys %hash)
	{
		if($hash{$gi}==2)
		{
			$total++;
		}
		delete($hash{$gi});
	}
	print "\t$total";

	$file="DESeq2/eXpress-as".$compare[$j].".txt";
        $total=find_number($file,6,0);
        print "\t$total";
        $file="DESeq2/sailfish-as".$compare[$j].".txt";
        $total=find_number($file,6,0);
        print "\t$total";
        $total=0;
        foreach $gi (keys %hash)
        {
                if($hash{$gi}==2)
                {
                        $total++;
                }
                delete($hash{$gi});
        }
        print "\t$total";

	$file="edgeR/eXpress-as".$compare[$j].".txt";
        $total=find_number($file,3,0);
        print "\t$total";
        $file="edgeR/sailfish-as".$compare[$j].".txt";
        $total=find_number($file,3,0);
        print "\t$total";
        $total=0;
        foreach $gi (keys %hash)
        {
                if($hash{$gi}==2)
                {
                        $total++;
                }
                delete($hash{$gi});
        }
        print "\t$total";

	$file="Limma/eXpress-as".$compare[$j].".txt";
        $total=find_number($file,5,0);
        print "\t$total";
        $file="Limma/sailfish-as".$compare[$j].".txt";
        $total=find_number($file,5,0);
        print "\t$total";
        $total=0;
        foreach $gi (keys %hash)
        {
                if($hash{$gi}==2)
                {
                        $total++;
                }
                delete($hash{$gi});
        }
        print "\t$total\n";
}

sub find_number
{
	my ($file,$pos,$location)=@_;
	my $line;
	my @array;
	my $num=0;
	my $value;

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
		if($array[$pos]>=0.05)
		{
			next;
		}
		$num++;
		($value)=$array[$location]=~/\"(\d+)\"/;
		if(exists $hash{$value})
		{
			$hash{$value}++;
		}
		else
		{
			$hash{$value}=1;
		}
	}
	close IN;
	return $num;
}
