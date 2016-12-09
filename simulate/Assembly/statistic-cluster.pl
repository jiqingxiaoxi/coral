##the precision of cluster at diff iden
use strict; use warnings;

my $line;
my $num;
my $i;
my $j;
my $flag;
my @result;
my $prefix;
my $file;
my $name;
my @ref;
my @array;
my %hash;
my %status;
my $gi;

if(@ARGV!=4)
{
	print "perl $0 list source_dir cluster_dir output_file\n";
	exit;
}

$i=0;
open(LIST,"<$ARGV[0]") or die "$ARGV[0]\n";
while(<LIST>)
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;

	if($ARGV[1]=~/\/$/)
        {
                $file=$ARGV[1].$prefix."-source.txt.gz";
        }
        else
        {
                $file=$ARGV[1]."/".$prefix."-source.txt.gz";
        }
	open(IN,"gzip -dc $file |") or die "Can't open $file\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^Contig/)
		{
			next;
		}
		@array=split("\t",$line);
		$ref[$i]=$array[2];
		$i++
	}
	close IN;
}
close LIST;

open(OUT,">$ARGV[3]") or die "Can't create $ARGV[3]\n";
print OUT "cluster\tleft_contigs\tleft_trans\tcontigs\/trans\tthis_cluster\tthis_error_cluster\tall_cluster\tall_error_cluster\n";
for($i=0.99;$i>0.79;$i=$i-0.01)
{
	if($ARGV[2]=~/\/$/)
	{
		$file=$ARGV[2]."cluster-".$i;
	}
	else
	{
		$file=$ARGV[2]."/"."cluster-".$i;
	}
	open(IN,"<$file") or die "can't open $file\n";
	for($j=0;$j<9;$j++)
	{
		$result[$j]=0;
	}

	foreach $name (keys %hash)
	{
		delete($hash{$name});
	}
	while(<IN>)
	{
		$line=$_;
		if($line!~/^\>/)
		{
			next;
		}
		$result[0]++;
		($gi)=$line=~/gi\|(\d+)\|/;
		if(! exists $hash{$ref[$gi]})
		{
			$hash{$ref[$gi]}=1;
			$result[1]++;
		}
	}
	close IN;
	$result[2]=$result[0]/$result[1];

##cluster
	$num=0;
	if($ARGV[2]=~/\/$/)
        {
                $file=$ARGV[2]."cluster-".$i.".clstr";
        }
        else
        {
                $file=$ARGV[2]."/"."cluster-".$i.".clstr";
        }
        open(IN,"<$file") or die "can't open $file\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^\>/)
		{
			if($num!=0)
			{
				if($num!=1)
				{
					$result[3]++;
					if($flag>1)
					{
						$result[4]++;
						$status{$name}="N";
					}
					else
					{
						if(! exists $status{$name})
						{
							$status{$name}="Y";
						}
					}
				}
				if(exists $status{$name})
				{
					$result[6]++;
					if($status{$name} eq "N")
					{
						$result[7]++;
					}
				}
			}
		##initial
			$num=0;
			$flag=0;
			foreach $i (keys %hash)
			{
				delete($hash{$i});
			}
			next;
		}
		($gi)=$line=~/gi\|(\d+)\|/;
		$num++;
		if(! exists $hash{$ref[$gi]})
		{
			$hash{$ref[$gi]}=1;
			$flag++;
		}
		if($line=~/\*/)
		{
			$name=$gi;
		}
	}
	close IN;
##last one
	if($num!=1)
	{
        	$result[3]++;
                if($flag>1)
		{
                	$result[4]++;
                	$status{$name}="N";
		}
                else
		{
                	if(! exists $status{$name})
			{
                        	$status{$name}="Y";
			}
		}
	}
	if(exists $status{$name})
	{
        	$result[6]++;
                if($status{$name} eq "N")
		{
                	$result[7]++;
		}
	}

	$result[5]=$result[4]/$result[3]*100;
	$result[8]=$result[7]/$result[6]*100;
	printf(OUT "%s\t%d\t%d\t%0.1f\t%d\t%d\(%0.2f%%\)\t%d\t%d\(%0.2f%%\)\n",$i,$result[0],$result[1],$result[2],$result[3],$result[4],$result[5],$result[6],$result[7],$result[8]);
}
close OUT;
