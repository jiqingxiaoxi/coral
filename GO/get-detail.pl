use strict; use warnings;

my $line;
my $flag;
my $go;
my $value;
my %hash;
my $file;
my @array;
my $num;

if(@ARGV!=2)
{
	print "perl $0 go.obo list\n";
	exit;
}

open(LIST,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
while(<LIST>)
{
	$line=$_;
	@array=split("\t",$line);
	($file)=$array[0]=~/GO\:(\d+)$/;
	$file="GO_".$file.".list";
	$num=1;
	$hash{$array[0]}=1;

	while($num!=0)
	{
		$num=0;
		open(IN,"<$ARGV[0]") or die "can't open $ARGV[0]\n";
		while(<IN>)
		{
			chomp;
			$line=$_;
			if($line=~/^id\: GO/)
			{
				($go)=$line=~/id: (GO.+)$/;
				if(exists $hash{$go})
				{
					$flag=0;
				}
				else
				{
					$flag=1;
				}
				next;
			}

			if($line=~/^is\_a\: GO/&&$flag==1)
			{
				($value)=$line=~/is\_a\: (GO\:\d+) /;
				if(exists $hash{$value})
				{
					$hash{$go}=1;
					$flag=0;
					$num++;
				}
			}
		}
		close IN;	
		print "$num\n";
	}
	open(OUT,">$file") or die "Can't create $file\n";
	foreach $go (keys %hash)
	{
		print OUT "$go\n";
		delete($hash{$go});
	}
	close OUT;
}

