use strict; use warnings;

my $line;
my @array;
my @name;
my @pos;
my $max=0;
my $num;
my $i=0;
my @value;
my @gap;
my $file;
my $temp;

if(@ARGV!=3)
{
	print "perl $0 input  output_prefix  number_gene\n";
	exit;
}


open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\"GO.ID\"/)
	{
		next;
	}
	@array=split("\t",$line);
	($temp)=$array[6]=~/\"(.+)\"/;

	if($temp>=0.05)
	{
		last;
	}
	$value[$i]=$temp;
	if($temp>$max)
	{
		$max=$temp;
	}
	($temp)=$array[2]=~/\"(.+)\"/;
	$name[$i]=$temp;
	if($i==0)
	{
		$pos[$i]=0.5;
		$gap[$i]=0;
	}
	else
	{
		$pos[$i]=$pos[$i-1]+1.5;
		$gap[$i]=0.5;
	}
	$i++;
	if($i>=$ARGV[2])
	{
		last;
	}
}
close IN;
$num=$i;

$file=$ARGV[1].".R";
open(OUT,">$file") or die "can't create $file\n";
print OUT "jpeg\(filename=\"$ARGV[1]\.jpeg\",quality=100\)\n";
print OUT "par\(mai=c\(0.5,3,0.5,1\)\)\n";
print OUT "x<-c\(";
for($i=0;$i<$num-1;$i++)
{
	print OUT "$value[$i]\,";
}
print OUT "$value[$i]\)\n";

print OUT "gap<-c\(";
for($i=0;$i<$num-1;$i++)
{
        print OUT "$gap[$i]\,";
}
print OUT "$gap[$i]\)\n";

print OUT "barplot\(x,horiz=TRUE,space=gap,col=\"white\"\)\n";

$temp=-1*$max;
for($i=0;$i<$num;$i++)
{
	print OUT "text\(x=$temp,y=$pos[$i],labels=\"$name[$i]\",xpd=TRUE,pos=4,cex=0.9\)\n";
}
$temp=0.8*$max;
print OUT "legend\(x=$temp,y=$pos[$num/2],legend=\"Pvalue\",fill=\"white\",xpd=TRUE\)\n";
print OUT "text\(x=$max,y=-2.5,labels=\"Pvalue\",xpd=TRUE,pos=4,font=2\)\n";
$temp=-0.9*$max;
print OUT "text\(x=$temp,y=-2.2,labels=\"$ARGV[1]\",xpd=TRUE,pos=4,font=4,col=\"red\"\)\n";
print OUT "dev.off\(\)\n";
close OUT;
system("Rscript $file");
system("rm $file");
