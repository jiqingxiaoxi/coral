use strict; use warnings;

my @store;
my $line;
my $i;
my $prefix;

if(@ARGV!=1)
{
	print "perl $0 input_list > output\n";
	exit;
}

print "File\tPer base sequence quality\tPer base sequence content\tPer sequence GC content\tAdapter Content\tOverrepresented sequences\tKmer Content\n";
open(LIST,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<LIST>)
{
	chomp;
	$line=$_;

	for($i=0;$i<6;$i++)
	{
		$store[$i]="No";
	}
	($prefix)=$line=~/\/(.+)\.fq\_fastqc.html/;
	open(IN,"<$line") or die "Can't open $line\n";
	while(<IN>)
	{
		$line=$_;
		if($line!~/Per base sequence quality/)
		{
			next;
		}
		($store[0])=$line=~/alt=\"\[(\w+)\]\"\/\>Per base sequence quality/;
		($store[1])=$line=~/alt=\"\[(\w+)\]\"\/>Per base sequence content/;
		($store[2])=$line=~/alt=\"\[(\w+)\]\"\/>Per sequence GC content/;
		($store[3])=$line=~/alt=\"\[(\w+)\]\"\/>Adapter Content/;
		($store[4])=$line=~/alt=\"\[(\w+)\]\"\/>Overrepresented sequences/;
		($store[5])=$line=~/alt=\"\[(\w+)\]\"\/>Kmer Content/;
		last;
	}
	close IN;
	print $prefix;
	for($i=0;$i<6;$i++)
	{
		print "\t$store[$i]";
	}
	print "\n";
}
close LIST;
