use strict; use warnings;

my $i;
my $line;
my $j=0;
my $seq;
my $len;
my $part;

if(@ARGV<1)
{
	print "perl $0 input_files > output_file\n";
	exit;
}

for($i=0;$i<@ARGV;$i++)
{
	if($ARGV[$i]=~/gz$/)
	{
		open(IN,"gzip -dc $ARGV[$i] |") or die "$ARGV[$i]\n";
	}
	else
	{
		open(IN,"<$ARGV[$i]") or die "$ARGV[$i]\n";
	}

	$len=0;
	while(<IN>)
	{
		chomp;
		$line=$_;
		if($line=~/^\>/)
		{
			if($len>=50)
			{
				print "\>$j\n";
				if($seq=~/^[Nn]/)
				{
					$part=substr($seq,0,20);
					print "$part\n";
					$part=substr($seq,20,($len-20));
					print "$part\n";
				}
				else
				{
					$part=substr($seq,0,1);
					print "$part\n";
					$part=substr($seq,1,($len-1));
					print "$part\n";
				}
				$j++;
			}
			$seq="";
			$len=0;
			next;
		}
		$seq=$seq.$line;
		$len=$len+length($line);
	}
	close IN;
	if($len>=50)
	{
		print "\>$j\n";
		if($seq=~/^[Nn]/)
		{
			$part=substr($seq,0,20);
			print "$part\n";
			$part=substr($seq,20,($len-20));
			print "$part\n";
		}
		else
		{
			$part=substr($seq,0,1);
                        print "$part\n";
                        $part=substr($seq,1,($len-1));
                        print "$part\n";
                }
	}
}
