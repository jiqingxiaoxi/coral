use strict; use warnings;

my $line;
my @array;
my $value;
my $pos;
my $len;
my @temp;

if(@ARGV!=1)
{
	print "perl $0 input_list > output\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<LIST>)
{
	chomp;
	$line=$_;

	open(IN,"<$line") or die "Can't open $line\n";
	while(<IN>)
	{
		$line=$_;
		if($line!~/Per base sequence quality/)
		{
			next;
		}

		if($line!~/Possible Source/)
		{
			last;
		}

		($value)=$line=~/Possible Source\<\/th\>\<\/tr\>\<\/thead\>\<tbody\>(.+)\<\/tbody\>\<\/table\>\<\/div\>\<div class=\"module\"\>\<h2 id=\"M10\"\>/;
		while($value=~/\<\/td\>\<\/tr\>/)
		{
			$pos=index($value,"</td></tr>");
			$temp[0]=substr($value,0,$pos);
			($temp[1],$temp[2])=$temp[0]=~/\<tr\>\<td\>(\w+)\<\/td\>\<td\>\d+\<\/td\>\<td\>.+\<\/td\>\<td\>(.+)$/;
			$len=length($value);
			$value=substr($value,($pos+10),($len-$pos-10));
			if($temp[2] ne "No Hit")
			{
				print "$temp[1]\t$temp[2]\n";
			}
		}
		last;
	}
	close IN;
}
close LIST;
