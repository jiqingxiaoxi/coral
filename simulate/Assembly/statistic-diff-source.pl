##where does the contig come from
use strict; use warnings;

my $line;
my @array;
my $prefix;
my $file;
my $i;
my @name;
my @iden;
my $temp;
my @result;

if(@ARGV!=4)
{
	print "perl $0 file_list source_contig_dir  source_read_dir  output_file\n";
	exit;
}

open(OUT,">$ARGV[3]") or die "Can't create $ARGV[3]\n";
print OUT "dataset\tUnknown_by_contig\tUnknown_by_read\tNo._same\tNo._diff\tAve_iden_same\tAve_iden_diff\tAve_reliable_same\tAve_reliable_diff\n";
open(LIST,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<LIST>)
{
	$line=$_;
	($prefix)=$line=~/^(.+)\_1.fa/;

	for($i=0;$i<8;$i++)
	{
		$result[$i]=0;
	}
	if($ARGV[1]=~/\/$/)
        {
		$file=$ARGV[1].$prefix."-source.txt.gz";
        }
        else
        {
		$file=$ARGV[1]."/".$prefix."-source.txt.gz";
        }

	open(IN,"gzip -dc $file |") or die "Can't open $file\n";
	$i=0;
	while(<IN>)
	{
		$line=$_;
		if($line=~/^Contig/)
		{
			next;
		}
		@array=split("\t",$line);
		if($array[2] eq "NULL")
		{
			$result[0]++;
		}
		($temp)=$array[3]=~/^(.+)\%/;
		$name[$i]=$array[2];
		$iden[$i]=$temp;
		$i++;
	}
	close IN;

##according to reads
	if($ARGV[2]=~/\/$/)
        {
                $file=$ARGV[2].$prefix."-source.txt.gz";
        }
        else
        {
                $file=$ARGV[2]."/".$prefix."-source.txt.gz";
        }

        open(IN,"gzip -dc $file |") or die "Can't open $file\n";      
        $i=0;
        while(<IN>)
        {
                $line=$_;
                if($line=~/^Contig/)
                {
                        next;
                }
                @array=split("\t",$line);
		($temp)=$array[2]=~/^(.+)\%/;
		if($array[1] eq "NULL")
		{
			$result[1]++;
			$i++;
			next;
		}
		if($name[$i] eq "NULL")
		{
			$i++;
			next;
		}
		if($name[$i] eq $array[1])
		{
			$result[2]++;
			$result[4]+=$iden[$i];
			$result[6]+=$temp;
		}
		else
		{
			$result[3]++;
			$result[5]+=$iden[$i];
			$result[7]+=$temp;
		}
		$i++;
	}
	close IN;
	$result[4]/=$result[2];
	$result[5]/=$result[3];
	$result[6]/=$result[2];
	$result[7]/=$result[3];
	printf(OUT "%s\t%d\t%d\t%d\t%d\t%0.2f%%\t%0.2f%%\t%0.2f%%\t%0.2f%%\n",$prefix,$result[0],$result[1],$result[2],$result[3],$result[4],$result[5],$result[6],$result[7]);
}
close LIST;
close OUT;

