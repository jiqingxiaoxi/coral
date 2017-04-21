use strict; use warnings;

my $line;
my @array;
my $gi;
my $seq;
my $i;
my $before=-1;
my $max;

while(<>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		($gi)=$line=~/^\>(\d+)\-/;
		if($gi==$before)
		{
			next;
		}
		if($before!=-1)
		{
			print "\>$before\n$seq\n";
		}
		$before=$gi;
		$seq="";
		$max=0;
		next;
	}
	$line=~tr/*/2/;
	@array=split("2",$line);
	for($i=0;$i<@array;$i++)
	{
		if(length($array[$i])>$max)
		{
			$max=length($array[$i]);
			$seq=$array[$i];
		}
	}
}
print "\>$gi\n$seq\n";
