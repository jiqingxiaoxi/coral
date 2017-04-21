use strict; use warnings;

my $compare;
my $i;
my $file;
my @list;
my @compare;
my $j;
my %hash;
my $gi;
my %status;
my $out;

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

for($i=0;$i<@list;$i++)
{
	for($j=0;$j<@compare;$j++)
	{
		$out=$list[$i].$compare[$j]."-list.txt";
		open(OUT,">$out") or die "can't create $out file\n";
		print OUT "GI\tstatus\n";

		foreach $gi (keys %hash)
		{
			delete($hash{$gi});
			delete($status{$gi});
		}

		$file="../DESeq2/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
		if(! (-e $file))
		{
			last;
		}
		find_number($file,6,0,2);

		$file="../edgeR/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
		find_number($file,3,0,1);

		$file="../Limma/".$ARGV[0]."-".$list[$i].$compare[$j].".txt";
		find_number($file,5,0,1);

		foreach $gi (keys %hash)
		{
			if($hash{$gi}!=3)
			{
				next;
			}
			if($status{$gi} eq "up")
			{
				print OUT "$gi\tup\n";
			}
			elsif($status{$gi} eq "down")
			{
				print OUT "$gi\tdown\n";
			}
			else
			{
				next;
			}
		}
		close OUT;
	}
}

sub find_number
{
	my ($file,$pos,$location,$updown)=@_;
	my $line;
	my @array;
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
		($value)=$array[$location]=~/\"(\d+)\"/;
		if(exists $hash{$value})
		{
			$hash{$value}++;
		}
		else
		{
			$hash{$value}=1;
		}
		if(exists $status{$value})
		{
			if($status{$value} eq "mix")
			{
				next;
			}
			if($array[$updown]>0 && $status{$value} eq "down")
			{
				$status{$value}="mix";
				next;
			}
			if($array[$updown]<=0 && $status{$value} eq "up")
			{
				$status{$value}="mix";
			}
		}
		else
		{
			if($array[$updown]>0)
			{
				$status{$value}="up";
			}
			else
			{
				$status{$value}="down";
			}
		}
	}
	close IN;
}
