##where does the contig come from
use strict; use warnings;

my $line;
my $value;
my @array;
my $max;
my $prefix;
my @file;
my $store;
my $name;

if(@ARGV!=2)
{
	print "perl $0 file_list blastn_dir\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<LIST>)
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;

	$max=0; ##whole;
	$store="";	
	if($ARGV[1]=~/\/$/)
        {
                $file[0]=$ARGV[1].$prefix.".blastn.gz";
		$file[1]=$ARGV[1].$prefix."-source.txt";
        }
        else
        {
                $file[0]=$ARGV[1]."/".$prefix.".blastn.gz";
		$file[1]=$ARGV[1]."/".$prefix."-source.txt";
        }
	open(IN,"gzip -dc $file[0] |") or die "Can't open $file[0]\n";
	open(OUT,">$file[1]") or die "Can't create $file[1]\n";
	print OUT "Contig\tLength\tRef\tIden\(Whole\)\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^\#\s+Query/)
		{
			($name,$value)=$line=~/TRINITY\_DN(\d+\_c\d+\_g\d+\_i\d+)\s+len\=(\d+)\s+path/;

			if($max==0)
			{
				if($store ne "")
				{
					print OUT "\tNULL\tNULL\n";
				}
			}
			else
			{
				printf(OUT "\t%s\t%0.2f%%\n",$store,$max);
			}
			$max=0;
			print OUT "$name\t$value";
			next;
		}

		if($line=~/^\#/)
		{
			next;
		}
		@array=split("\t",$line);
		if($array[2]*$array[3]/$value>$max)
		{
			$max=$array[2]*$array[3]/$value;
			$store=$array[1];
		}
	}
	close IN;
	if($max==0)
	{
		print OUT "\tNULL\tNULL\n";
	}
	else
	{
		printf(OUT "\t%s\t%0.2f%%\n",$store,$max);
	}
	close OUT;
	system("gzip $file[1]");
}
close LIST;

