use strict; use warnings;

my $line;
my @array;
my $i;
my $before="";
my @value;
my $name;
my $prefix;
my @file;
my $temp;
my $flag;
my @store;

if(@ARGV!=4)
{
	print "perl $0 list include\(coral or symbiodinium\) iden_threshold\(\%\)  output_dir\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "$ARGV[0]\n";
while(<LIST>)
{
	chomp;
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;

	$file[0]="/lustre/home/clslzy/bjia/test_pipeline/Map/".$prefix."-".$ARGV[1].".sam.gz"; ##SAM
	$file[1]="/lustre/home/clslzy/bjia/simulate/".$prefix."_1.fa.gz";
	$file[2]="/lustre/home/clslzy/bjia/simulate/".$prefix."_2.fa.gz";
	if($ARGV[3]=~/\/$/)
	{
		$file[3]=$ARGV[3].$prefix."-include_1.fa";
		$file[4]=$ARGV[3].$prefix."-include_2.fa";
	}
	else
	{
		$file[3]=$ARGV[3]."/".$prefix."_1.fa";
                $file[4]=$ARGV[3]."/".$prefix."_2.fa";
        }

	open(IN,"gzip -dc $file[0] |") or die "can't open $file[0]\n";
	open(FAONE,"gzip -dc $file[1] |") or die "Can't open $file[1]\n";
	open(FATWO,"gzip -dc $file[2] |") or die "Can't open $file[2]\n";
	open(OUTONE,">$file[3]") or die "Can't create $file[3]\n";
	open(OUTTWO,">$file[4]") or die "Can't create $file[4]\n";

	$before="";
	while(<IN>)
	{
		$line=$_;
		@array=split("\t",$line);

		if($array[0] ne $before) ##handle before
		{
			if($before ne "" && $flag==1)
			{
				$temp=0;
				$i=0;
				while(<FAONE>)
				{
					$store[0][$i]=$_;
					$store[1][$i]=<FATWO>;
					$i++;

					if($i==2)
					{
						($name)=$store[0][0]=~/^\>(.+)\/1/;
						if($name eq $before)
						{
							print OUTONE $store[0][0],$store[0][1];
							print OUTTWO $store[1][0],$store[1][1];
							$temp++;
							last;
						}
						else
						{
							$i=0;
						}
					}
				}
				if($temp==0)
				{
					print "Can't find the $before sequence!\n";
					exit;
				}	
			}
			$before=$array[0];
			$flag=0;
		}

		if($flag)
		{
			next;
		}
		$value[1]=length($array[9]);
		$value[2]=$value[1];
		if($array[5]=~/^\d+[SH]/)
		{
			($value[3])=$array[5]=~/^(\d+)[SH]/;
			$value[2]-=$value[3];
		}
		if($array[5]=~/\d+[SH]$/)
		{
			($value[3])=$array[5]=~/[A-Z](\d+)[SH]$/;
			$value[2]-=$value[3];
		}
	
		($value[3])=$line=~/NM\:i\:(\d+)/;
		$value[2]-=$value[3];
	
		$value[3]=$value[2]/$value[1]*100;
		if($value[3]>=$ARGV[2])
		{
			$flag++;
		}

	}
	close IN;
##last one
	if($before ne "" && $flag==1)
	{
        	$temp=0;
                $i=0;
                while(<FAONE>)
                {
                	$store[0][$i]=$_;
                        $store[1][$i]=<FATWO>;
                        $i++;

                        if($i==2)
                        {
                        	($name)=$store[0][0]=~/^\>(.+)\/1/;
                        	if($name eq $before)
                        	{
                        		print OUTONE $store[0][0],$store[0][1];
                        		print OUTTWO $store[1][0],$store[1][1];
                        		$temp++;
                        		last;
                        	}
                        	else
                        	{
                        		$i=0;
                        	}
                        }
		}
                if($temp==0)
                {
                	print "Can't find the $before sequence!\n";
                	exit;
                }
	}
	close IN;
	close FAONE;
	close FATWO;
	close OUTONE;
	close OUTTWO;
}
close LIST;
