use strict; use warnings;

my $line;
my @array;
my @value;
my $flag;
my $gi;
my %hash;

if(@ARGV!=3)
{
	print "perl $0 sam input_fa  output_fa\n";
	exit;
}

if($ARGV[0]=~/gz$/)
{
	open(IN,"gzip -dc $ARGV[0] |") or die "$ARGV[0]\n";
}
else
{
	open(IN,"<$ARGV[0]") or die "$ARGV[0]\n";
}
while(<IN>)
{
	$line=$_;
	@array=split("\t",$line);
	if(@array<10)
	{
		next;
	}

	$value[0]=length($array[9]);
	$value[1]=$value[0];

	if($array[5]=~/^\d+[SH]/)
	{
		($value[2])=$array[5]=~/^(\d+)[SH]/;
		$value[1]-=$value[2];
	}
	if($array[5]=~/\d+[SH]$/)
	{
		($value[2])=$array[5]=~/[IDM](\d+)[SH]$/;
		$value[1]-=$value[2];
	}

	($value[2])=$line=~/NM\:i\:(\d+)/;
	$value[1]-=$value[2];
	if($value[1]/$value[0]>=0.95)
	{
		$hash{$array[0]}=1;
	}
}
close IN;

if($ARGV[1]=~/gz/)
{
	open(IN,"gzip -dc $ARGV[1] |") or die "$ARGV[1]\n";
}
else
{
	open(IN,"<$ARGV[1]") or die "$ARGV[1]\n";
}
open(OUT,">$ARGV[2]") or die "$ARGV[2]\n";
$flag=0;
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		@array=split(" ",$line);
		($gi)=$array[0]=~/^\>(.+)$/;
		if(exists $hash{$gi})
		{
			$flag=0;
		}
		else
		{
			$flag=1;
		}
	}
	if($flag==1)
	{
		print OUT "$line\n";
	}
}
close IN;
close OUT;
