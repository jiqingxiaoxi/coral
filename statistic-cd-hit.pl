use strict; use warnings;

my $line;
my @total;
my $file;
my $i;
my @list;
my $j;
my @iden;
my $size;

if(@ARGV!=4)
{
	print "perl $0 source_fa  cluster_dir  5_or_10  output\n";
	exit;
}

$iden[0]=0.99;
$iden[1]=0.98;
$iden[2]=0.97;
$iden[3]=0.96;
$iden[4]=0.95;
$iden[5]=0.94;
$iden[6]=0.93;
$iden[7]=0.92;
$iden[8]=0.91;
$iden[9]=0.9;

open(OUT,">$ARGV[3]") or die "Can't create $ARGV[3] file!\n";
print OUT "\tsource";
for($i=0;$i<$ARGV[2];$i++)
{
	print OUT "\t$iden[$i]";
	if($ARGV[1]=~/\/$/)
	{
		$file=$ARGV[1]."cluster-".$iden[$i];
	}
	else
	{
		$file=$ARGV[1]."/cluster-".$iden[$i];
	}
	if(-e $file)
	{
		$list[$i+1]=$file;
		next;
	}

	if($ARGV[1]=~/\/$/)
        {
                $file=$ARGV[1]."cluster-".$iden[$i].".gz";
        }
        else
        {
                $file=$ARGV[1]."/cluster-".$iden[$i].".gz";
        }
        if(-e $file)
        {
                $list[$i+1]=$file;
        }
	else
	{
		print "Don't exist cluster\-$iden[$i]!\n";
		exit;
	}
}
$list[0]=$ARGV[0];
print OUT "\n";

for($i=0;$i<=$ARGV[2];$i++)
{
	$total[0][$i]=0;
	$total[1][$i]=0;
	$total[2][$i]=0;
	if($list[$i]=~/gz$/)
	{
		open(IN,"gzip -dc $list[$i] |") or die "$list[$i]\n";
	}
	else
	{
		open(IN,"<$list[$i]") or die "$list[$i]\n";
	}
	while(<IN>)
	{
		chomp;
		$line=$_;
		if($line=~/^\>/)
		{
			$total[0][$i]++;
		}
		else
		{
			$total[2][$i]+=length($line);
		}
	}
	close IN;
	$total[1][$i]=$total[2][$i]/$total[0][$i];
}

##number of sequence
print OUT "Num_seq";
for($i=0;$i<=$ARGV[2];$i++)
{
	print OUT "\t$total[0][$i]";
}
print OUT "\n";

##average length
print OUT "Ave_len";
for($i=0;$i<=$ARGV[2];$i++)
{
	printf(OUT "\t%0.2f",$total[1][$i]);
}
print OUT "\n";

##total base
print OUT "Size";
for($i=0;$i<=$ARGV[2];$i++)
{
	$size=how_big($total[2][$i]);
	print OUT "\t$size";
}
print OUT "\n";
close OUT;

sub how_big
{
	my ($in)=@_;
	my $out;
	my $value;

	if($in<1024)
	{
		$out=$in."B";
		return $out;
	}

	$in=$in/1024;
	if($in<1024)
	{
		if($in=~/\.\d\d/)
		{
			($value)=$in=~/^(\d+\.\d\d)/;
			$out=$value."KB";
		}
		else
		{
			$out=$in."KB";
		}
		return $out;
	}

	$in=$in/1024;
        if($in<1024)
        {
                if($in=~/\.\d\d/)
                {
                        ($value)=$in=~/^(\d+\.\d\d)/;
                        $out=$value."MB";
                }
                else
                {
                        $out=$in."MB";
                }
                return $out;
        }

	$in=$in/1024;
	if($in=~/\.\d\d/)
	{
		($value)=$in=~/^(\d+\.\d\d)/;
		$out=$value."GB";
	}
	else
	{
		$out=$in."GB";
	}
	return $out;
}
