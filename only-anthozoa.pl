##compare the result of anthozoa and symbiodnium, get the reads only hit anthozoa
use strict; use warnings;

my $line;
my @temp;
my $i;
my $j;
my $k;
my @store;
my @file;
my @one;

if(@ARGV!=1)
{
	print "perl $0 prefix\n";
	exit;
}

if($ARGV[0]=~/^as/)
{
	$file[0]="/lustre/home/clslzy/bjia/QC-rRNA/AS/".$ARGV[0].".paired1.fq.gz";
	$file[1]="/lustre/home/clslzy/bjia/QC-rRNA/AS/".$ARGV[0].".paired2.fq.gz";
	$file[2]="/lustre/home/clslzy/bjia/QC-rRNA/AS/".$ARGV[0].".single1.fq.gz";
	$file[3]="/lustre/home/clslzy/bjia/QC-rRNA/AS/".$ARGV[0].".single2.fq.gz";

	$file[4]="/lustre/home/clslzy/bjia/Anthozoa/AS/".$ARGV[0].".paired1.fq.gz";
	$file[5]="/lustre/home/clslzy/bjia/Anthozoa/AS/".$ARGV[0].".paired2.fq.gz";
	$file[6]="/lustre/home/clslzy/bjia/Anthozoa/AS/".$ARGV[0].".single1.fq.gz";
	$file[7]="/lustre/home/clslzy/bjia/Anthozoa/AS/".$ARGV[0].".single2.fq.gz";

	$file[8]="/lustre/home/clslzy/bjia/Symbiodinium/AS/".$ARGV[0].".paired1.fq.gz";
        $file[9]="/lustre/home/clslzy/bjia/Symbiodinium/AS/".$ARGV[0].".paired2.fq.gz";
        $file[10]="/lustre/home/clslzy/bjia/Symbiodinium/AS/".$ARGV[0].".single1.fq.gz";
        $file[11]="/lustre/home/clslzy/bjia/Symbiodinium/AS/".$ARGV[0].".single2.fq.gz";

	$file[12]="/lustre/home/clslzy/bjia/Only-anthozoa/AS/".$ARGV[0].".paired1.fq";
        $file[13]="/lustre/home/clslzy/bjia/Only-anthozoa/AS/".$ARGV[0].".paired2.fq";
        $file[14]="/lustre/home/clslzy/bjia/Only-anthozoa/AS/".$ARGV[0].".single1.fq";
        $file[15]="/lustre/home/clslzy/bjia/Only-anthozoa/AS/".$ARGV[0].".single2.fq";
}
elsif($ARGV[0]=~/^gs/)
{
        $file[0]="/lustre/home/clslzy/bjia/QC-rRNA/GS/".$ARGV[0].".paired1.fq.gz";
        $file[1]="/lustre/home/clslzy/bjia/QC-rRNA/GS/".$ARGV[0].".paired2.fq.gz";
        $file[2]="/lustre/home/clslzy/bjia/QC-rRNA/GS/".$ARGV[0].".single1.fq.gz";
        $file[3]="/lustre/home/clslzy/bjia/QC-rRNA/GS/".$ARGV[0].".single2.fq.gz";

        $file[4]="/lustre/home/clslzy/bjia/Anthozoa/GS/".$ARGV[0].".paired1.fq.gz";
        $file[5]="/lustre/home/clslzy/bjia/Anthozoa/GS/".$ARGV[0].".paired2.fq.gz";
        $file[6]="/lustre/home/clslzy/bjia/Anthozoa/GS/".$ARGV[0].".single1.fq.gz";
        $file[7]="/lustre/home/clslzy/bjia/Anthozoa/GS/".$ARGV[0].".single2.fq.gz";

        $file[8]="/lustre/home/clslzy/bjia/Symbiodinium/GS/".$ARGV[0].".paired1.fq.gz";
        $file[9]="/lustre/home/clslzy/bjia/Symbiodinium/GS/".$ARGV[0].".paired2.fq.gz";
        $file[10]="/lustre/home/clslzy/bjia/Symbiodinium/GS/".$ARGV[0].".single1.fq.gz";
        $file[11]="/lustre/home/clslzy/bjia/Symbiodinium/GS/".$ARGV[0].".single2.fq.gz";

        $file[12]="/lustre/home/clslzy/bjia/Only-anthozoa/GS/".$ARGV[0].".paired1.fq";
        $file[13]="/lustre/home/clslzy/bjia/Only-anthozoa/GS/".$ARGV[0].".paired2.fq";
        $file[14]="/lustre/home/clslzy/bjia/Only-anthozoa/GS/".$ARGV[0].".single1.fq";
        $file[15]="/lustre/home/clslzy/bjia/Only-anthozoa/GS/".$ARGV[0].".single2.fq";
}
else
{
	print "Can't recognize the $ARGV[0] as prefix\n";
	exit;
}

for($j=0;$j<4;$j++)
{
	open(IN,"gzip -dc $file[$j] |") or die "can't open $file[$j]\n";
	open(ANTHOZOA,"gzip -dc $file[4+$j] |") or die "can't open $file[4+$j]\n";
	open(SYMBIODINIUM,"gzip -dc $file[8+$j] |") or die "can't open $file[8+$j]\n";
	open(OUT,">$file[12+$j]") or die "can't create $file[8+$j]\n";

	for($i=0;$i<4;$i++)
	{
		$one[$i]=<ANTHOZOA>;
		chomp $one[$i];
		$line=<SYMBIODINIUM>;
                if($i==0)
                {
			($temp[0])=$one[0]=~/^\@(.+) \d/;
                        ($temp[1])=$line=~/^\@(.+) \d/;                                                                                                                                       
                }
	}

	$k=0;
	while(<IN>)
	{
		chomp;
		$store[$k]=$_;
		if($k!=3)
		{
			$k++;
			next;
		}
		($temp[2])=$store[0]=~/^\@(.+) \d/;
		$k=0;
		if(($temp[2] ne $temp[0])&&($temp[2] ne $temp[1]))
		{
			next;
		}
		if(($temp[2] eq $temp[0])&&($temp[2] eq $temp[1]))
		{
			if(eof(ANTHOZOA))
                	{
                        	last;
                	}
                	if(eof(SYMBIODINIUM))
                	{
                	        last;
                	}
                	for($i=0;$i<4;$i++)
                	{
                        	$one[$i]=<ANTHOZOA>;
				chomp $one[$i];
                        	$line=<SYMBIODINIUM>;
                        	if($i==0)
                        	{
					($temp[0])=$one[0]=~/^\@(.+) \d/;
                        	        ($temp[1])=$line=~/^\@(.+) \d/;
                        	}
                	}
			next;
		}
		if($temp[2] eq $temp[1])
		{
			if(eof(SYMBIODINIUM))
			{
				last;
			}
			for($i=0;$i<4;$i++)
			{
				$line=<SYMBIODINIUM>;
				if($i==0)
				{
					($temp[1])=$line=~/^\@(.+) \d/;
				}
			}
			next;
		}
		for($i=0;$i<4;$i++)
                {
                        print OUT "$store[$i]\n";
                }
		if(eof(ANTHOZOA))
		{
			last;
		}
		for($i=0;$i<4;$i++)
                {
                	$one[$i]=<ANTHOZOA>;
			chomp $one[$i];
                	if($i==0)
                        {
                        	($temp[0])=$one[0]=~/^\@(.+) \d/;
                        }
                }
	}
	close IN;
	if($temp[0] ne $temp[1])
	{
		print OUT "$one[0]\n$one[1]\n$one[2]\n$one[3]\n";
	}
	while(<ANTHOZOA>)
	{
		$line=$_;
		print OUT $line;
	}
	close ANTHOZOA;
	close SYMBIODINIUM;
	close OUT;
}
