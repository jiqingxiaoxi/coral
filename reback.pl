##get the real anthozoa or symbiodinium reads
use strict; use warnings;

my $line;
my @temp;
my $i;
my $j;
my $k;
my @store1;
my @store2;
my @file;

if(@ARGV!=3)
{
	print "perl $0 prefix original_dir result_dir\n";
	exit;
}

if($ARGV[1]=~/\/$/)
{
	$file[0]=$ARGV[1].$ARGV[0].".paired1.fq";
	$file[1]=$ARGV[1].$ARGV[0].".paired2.fq";
        $file[2]=$ARGV[1].$ARGV[0].".single1.fq";
        $file[3]=$ARGV[1].$ARGV[0].".single2.fq";
}
else
{
        $file[0]=$ARGV[1]."/".$ARGV[0].".paired1.fq";
        $file[1]=$ARGV[1]."/".$ARGV[0].".paired2.fq";
        $file[2]=$ARGV[1]."/".$ARGV[0].".single1.fq";
        $file[3]=$ARGV[1]."/".$ARGV[0].".single2.fq";
}

if($ARGV[2]=~/\/$/)
{
        $file[4]=$ARGV[2].$ARGV[0].".paired1.fq";
        $file[5]=$ARGV[2].$ARGV[0].".paired2.fq";
        $file[6]=$ARGV[2].$ARGV[0].".single1.fq";
        $file[7]=$ARGV[2].$ARGV[0].".single2.fq";
	$file[8]=$ARGV[2].$ARGV[0]."-temp.paired1.fq";
        $file[9]=$ARGV[2].$ARGV[0]."-temp.paired2.fq";
        $file[10]=$ARGV[2].$ARGV[0]."-temp.single1.fq";
        $file[11]=$ARGV[2].$ARGV[0]."-temp.single2.fq";
}
else
{
        $file[4]=$ARGV[2]."/".$ARGV[0].".paired1.fq";
        $file[5]=$ARGV[2]."/".$ARGV[0].".paired2.fq";
        $file[6]=$ARGV[2]."/".$ARGV[0].".single1.fq";
        $file[7]=$ARGV[2]."/".$ARGV[0].".single2.fq";
	$file[8]=$ARGV[2]."/".$ARGV[0]."-temp.paired1.fq";
        $file[9]=$ARGV[2]."/".$ARGV[0]."-temp.paired2.fq";
        $file[10]=$ARGV[2]."/".$ARGV[0]."-temp.single1.fq";
        $file[11]=$ARGV[2]."/".$ARGV[0]."-temp.single2.fq";
}

for($j=0;$j<4;$j++)
{
	open(INONE,"gzip -dc $file[$j] |") or die "can't open $file[$j]\n";
	open(INTWO,"<$file[4+$j]") or die "can't open $file[4+$j]\n";
	open(OUT,">$file[8+$j]") or die "can't create $file[8+$j]\n";

	for($i=0;$i<4;$i++)
	{
		$store2[$i]=<INTWO>;
	}
	($temp[1])=$store2[0]=~/^\@(.+) \d/;

	$k=0;
	while(<INONE>)
	{
		chomp;
		$store1[$k]=$_;
		if($k!=3)
		{
			$k++;
			next;
		}
		($temp[0])=$store1[0]=~/^\@(.+) \d/;
		$k=0;
		if($temp[0] ne $temp[1])
		{
			for($i=0;$i<4;$i++)
			{
				print OUT "$store1[$i]\n";
			}
		}
		else
		{
			if(eof(INTWO))
			{
				last;
			}
			for($i=0;$i<4;$i++)
			{
				$store2[$i]=<INTWO>;
			}
			($temp[1])=$store2[0]=~/^\@(.+) \d/;
		}
	}
	close INTWO;

	while(<INONE>)
	{
		$line=$_;
		print OUT $line;
	}
	close INONE;
	close OUT;
	system("mv $file[8+$j] $file[4+$j]");
}
