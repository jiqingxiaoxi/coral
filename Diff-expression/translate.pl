use strict; use warnings;

my $line;
my $file;
my $len;
my $seq;
my $gi;
my $two;

if(@ARGV!=2)
{
	print "perl $0 inpuf_fa output_fa\n";
	exit;
}

$file=$ARGV[1]."-temp.fa";
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
open(OUT,">$file") or die "Can't create $file\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		($gi)=$line=~/^\>(\d+)$/;
		next;
	}
	$len=length($line);
	print OUT "\>$gi\-1\n$line\n";

	$seq=substr($line,1,($len-1));
	print OUT "\>$gi\-2\n$seq\n";

	$seq=substr($line,2,($len-2));
	print OUT "\>$gi\-3\n$seq\n";

	$two=ff($line);
	print OUT "\>$gi\-4\n$two\n";

	$seq=substr($two,1,($len-1));
	print OUT "\>$gi\-5\n$seq\n";

	$seq=substr($two,2,($len-2));
	print OUT "\>$gi\-6\n$seq\n";
}
close IN;
close OUT;

system("java -jar -Xmx800m /lustre/home/clslzy/bjia/software/macse_git_agro_v1.02/jar_file/macse.jar -prog translateNT2AA -seq $file -out_AA $ARGV[1]");
system("rm $file");

sub ff
{
	my ($in)=@_;
	my $out="";
	my $i;
	my @array;

	@array=split("",$in);
	for($i=@array-1;$i>=0;$i--)
	{
		if($array[$i] eq "A")
		{
			$out=$out."T";
		}
		elsif($array[$i] eq "T")
		{
			$out=$out."A";
		}
		elsif($array[$i] eq "C")
		{
			$out=$out."G";
		}
		elsif($array[$i] eq "G")
		{
			$out=$out."C";
		}
		else
		{
			$out=$out."N";
		}
	}
	return $out;
}
