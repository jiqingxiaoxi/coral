use strict; use warnings;

my $line;
my @array;
my @num;
my $i;
my $j;
my $k;
my @before;
my @value;
my $read_name;
my $prefix;
my @file;
my $temp;
my @list;
my %read;
my @name;
my %first;
my %second;
my @total;
my $num_contig;
my %turn;
my @result;
my $flag;
my $new;

if(@ARGV!=5)
{
	print "perl $0 list contig_dir sam_dir record_dir  iden_threshold\(\%\)\n";
	exit;
}

open(LIST,"<$ARGV[0]") or die "$ARGV[0]\n";
while(<LIST>)
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;

	if($ARGV[1]=~/\/$/)
        {
                $file[0]=$ARGV[1].$prefix."-trinity.Trinity.fasta.gz";
        }
        else
        {
                $file[0]=$ARGV[1]."/".$prefix."-trinity.Trinity.fasta.gz";
        }

	open(IN,"gzip -dc $file[0] |") or die "can't open $file[0]\n";
	$num_contig=0;
	foreach $temp (keys %turn)
	{
		delete($turn{$temp});
	}
	while(<IN>)
	{
		$line=$_;
		if($line!~/^\>/)
		{
			next;
		}
		($temp)=$line=~/TRINITY_DN([\w\_\d]+)\s+/;
		$list[$num_contig]=$temp;
		$num[$num_contig]=0;
		$turn{$temp}=$num_contig;
		$num_contig++;
	}
	close IN;

	if($ARGV[2]=~/\/$/)
        {
                $file[0]=$ARGV[2].$prefix."-self.sam.gz";
        }
        else
        {
                $file[0]=$ARGV[2]."/".$prefix."-self.sam.gz";
        }
	$before[0]="";
	$before[1]="";
	open(IN,"gzip -dc $file[0] |") or die "Can't open $file[0]\n";
	while(<IN>)
	{
		$line=$_;
		@array=split("\t",$line);

		if($array[0] ne $before[0]) ##handle before
		{
			if($before[0] ne "")
			{
				$value[0]=$read{$before[0]}; ##transcript
				foreach $temp (keys %first)
				{
					$j=$turn{$temp}; ##contig
					$flag=0;
					for($i=0;$i<$num[$j];$i++)
					{
						if($name[$j][$i] eq $value[0])
						{
							$flag++;
							$result[$j][$i]=$result[$j][$i]+1/$total[0];
							last;
						}
					}
					if($flag==0)
					{
						$result[$j][$i]=1/$total[0];
						$name[$j][$i]=$value[0];
						$num[$j]++;
					}
				}

				foreach $temp (keys %second)
                                {
                                        $j=$turn{$temp}; ##contig
                                        $flag=0;
                                        for($i=0;$i<$num[$j];$i++)
                                        {
                                                if($name[$j][$i] eq $value[0])
                                                {
                                                        $flag++;
                                                        $result[$j][$i]=$result[$j][$i]+1/$total[1];
                                                        last;
                                                }
                                        }
                                        if($flag==0)
                                        {
                                                $result[$j][$i]=1/$total[1];
						$name[$j][$i]=$value[0];
                                                $num[$j]++;
                                        }
                                }
			}
			$before[0]=$array[0];
		##record file
			($temp)=$array[0]=~/^([\w\_]+)\_\d/;
			if($temp ne $before[1])
			{
				foreach $i (keys %read)
				{
					delete($read{$i});
				}
				@value=split("_",$prefix);
				$file[2]=$value[0]."_".$temp;
				
				if($temp=~/\_/)
				{
					$j=$value[1]/10;
					$file[2]=$file[2]."_".$j;
				}
				elsif($temp=~/coral/)
				{
					$file[2]=$file[2]."_10";
				}
				else
				{
					$file[2]=$file[2]."_".$value[1];
				}

				if($ARGV[3]=~/\/$/)
				{
					$file[2]=$ARGV[3].$file[2]."_readsnum.txt";
				}
				else
				{
					$file[2]=$ARGV[3]."/".$file[2]."_readsnum.txt";
				}
			##which column	
				if($value[2] eq "C")
				{
					$i=0;
				}
				else
				{
					$i=1;
				}
				$j=3*$i+$value[3];

				open(RECORD,"<$file[2]") or die "Can't open $file[2]\n";
				if($temp=~/\_/)
				{
					$i=1;
				}
				else
				{
					$i=0;
				}
				while(<RECORD>)
				{
					chomp;
					$new=$_;
					if($new=~/^transcript/)
					{
						next;
					}	
					@value=split("\t",$new);
					for($k=$i;$k<$i+$value[$j];$k++)
					{
						$read_name=$temp."_".$k;
						$read{$read_name}=$temp."_".$value[0];
					}
					$i=$i+$value[$j];
				}
				close RECORD;
				$before[1]=$temp;
			}
		##initial
			foreach $temp (keys %first)
			{
				delete($first{$temp});
			}
			foreach $temp (keys %second)
			{
				delete($second{$temp});
			}
			$total[0]=0;
			$total[1]=0;
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
		$value[6]=$value[2];
		$value[4]=($array[1]-$array[1]%64)/64%2;
	
		($value[3])=$line=~/NM\:i\:(\d+)/;
		$value[6]-=$value[3];
	
		$value[7]=$value[6]/$value[1]*100;
		if($value[7]<$ARGV[4])
		{
			next;
		}
		($temp)=$array[2]=~/TRINITY_DN(.+)$/;
		if($value[4]==1)
		{
			if(! exists $first{$temp})
			{
				$first{$temp}=1;
				$total[0]++;
			}
		}
		else
		{
			if(! exists $second{$temp})
                        {
                                $second{$temp}=1;
                                $total[1]++;
                        }        
                }
	}
	close IN;
###handle last one
	$value[0]=$read{$before[0]}; ##transcript
	foreach $temp (keys %first)
	{
		$j=$turn{$temp}; ##contig
        	$flag=0;
        	for($i=0;$i<$num[$j];$i++)
		{
        		if($name[$j][$i] eq $value[0])
			{
                		$flag++;
                		$result[$j][$i]=$result[$j][$i]+1/$total[0];
                		last;
			}
		}
		if($flag==0)
		{
			$result[$j][$i]=1/$total[0];
        		$name[$j][$i]=$value[0];
                        $num[$j]++;
		}
	}

	foreach $temp (keys %second)
	{
		$j=$turn{$temp}; ##contig
                $flag=0;
                for($i=0;$i<$num[$j];$i++)
		{
                	if($name[$j][$i] eq $value[0])
			{
                        	$flag++;
                                $result[$j][$i]=$result[$j][$i]+1/$total[1];
                                last;
			}
		}
		if($flag==0)
		{
                	$result[$j][$i]=1/$total[1];
                        $name[$j][$i]=$value[0];
                        $num[$j]++;
		}
	}
##output
	if($ARGV[2]=~/\/$/)
        {
                $file[3]=$ARGV[2].$prefix."-source.txt";
        }
        else
        {
                $file[3]=$ARGV[2]."/".$prefix."-source.txt";
        }
	open(OUT,">$file[3]") or die "Can't create $file[3]\n";
	print OUT "Contig\tIden\tReliability\n";
	for($i=0;$i<$num_contig;$i++)
	{
		print OUT "$list[$i]\t";
		$total[0]=0;
		$total[1]=0;
		for($j=0;$j<$num[$i];$j++)
		{
			$total[0]+=$result[$i][$j];
		}
		if($total[0]==0)
		{
			print OUT "NULL\tNULL\n";
			next;
		}
		for($j=0;$j<$num[$i];$j++)
		{
			if($result[$i][$j]/$total[0]>$total[1])
			{
				$total[1]=$result[$i][$j]/$total[0];
				$k=$name[$i][$j];
			}
		}
		$total[1]*=100;
		printf(OUT "%s\t%0.2f%%\n",$k,$total[1]);
	}
	close OUT;
	system("gzip $file[3]");
}
close LIST;


