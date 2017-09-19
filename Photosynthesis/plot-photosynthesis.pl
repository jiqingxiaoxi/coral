use strict; use warnings;

my $line;
my @array;
my $file;
my $i;
my $value;
my $max;
my @up;
my @down;
my @stable;
my @num;
my $j;
my $temp;

if(@ARGV!=3)
{
	print "perl $0 TPM diff prefix_output\n";
	exit;
}

$j=0;
open(IN,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^KO/)
	{
		next;
	}
	@array=split("\t",$line);
	$num[$j]=$array[1];
	for($i=2;$i<@array;$i=$i+3)
	{
		$up[$j][($i-2)/3]=$array[$i];
		$down[$j][($i-2)/3]=$array[$i+1];
		$stable[$j][($i-2)/3]=$array[$i+2];
	}
	$j++;
}
close IN;

$j=0;
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
$file=$ARGV[2].".R";
open(OUT,">$file") or die "Can't create $file\n";
print OUT "library\(\"Hmisc\"\)\n";
print OUT "pdf\(file=\"$ARGV[2]\.pdf\"\)\n";
print OUT "put\<\-matrix\(c\(1\:35\)\,nrow\=5\,ncol\=7\)\n";
print OUT "layout\(put)\n";
print OUT "par\(mar=c\(1\,2\,1.5\,2\)\)\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^KO/)
	{
		next;
	}
	@array=split("\t",$line);

	print OUT "x<-c\($array[2]";
	$max=$array[2]+$array[3];
	for($i=4;$i<@array;$i=$i+2)
	{
		print OUT "\,$array[$i]";
		if($array[$i]+$array[$i+1]>$max)
		{
			$max=$array[$i]+$array[$i+1];
		}
	}
	print OUT "\)\n";
	print OUT "mp=barplot\(x,main=\"$array[0]\",ylim=c\(0,$max\),space=c(0,0,0,0,1,0,0,0),col=c\(\"blue\",\"yellow\",\"seagreen\",\"red\",\"cyan\",\"burlywood1\",\"lightgreen\",\"darkorange\")\)\n";
	$value=$array[2]+$array[3];
	print OUT "up<-c\($value";
	for($i=4;$i<@array;$i=$i+2)
	{
		$value=$array[$i]+$array[$i+1];
		print OUT "\,$value";
	}
	print OUT "\)\n";

	$value=$array[2]-$array[3];
        print OUT "down<-c\($value";
        for($i=4;$i<@array;$i=$i+2)
        {
                $value=$array[$i]-$array[$i+1];
                print OUT "\,$value";
        }
        print OUT "\)\n";
	print OUT "errbar\(mp,x,up,down,add=TRUE,cex=0.1\)\n";

	$value=$max*0.9;
	print OUT "lines(x<-c(9.5,9.5),y<-c(0,$value),xpd=TRUE)\n";
	print OUT "lines(x<-c(9.5,10.5),y<-c(0,0),xpd=TRUE)\n";
	print OUT "text(x=11.5,y=0,labels=\"0\",xpd=TRUE)\n";
	print OUT "lines(x<-c(9.5,10.5),y<-c($value,$value),xpd=TRUE)\n";
	print OUT "text(x=11.5,y=$value,labels=\"$num[$j]\",xpd=TRUE)\n";
	if($num[$j]>5)
	{
		$temp=($num[$j]-($num[$j]%2))/2;
		$value=$temp/$num[$j]*$max*0.9;
		print OUT "lines(x<-c(9.5,10.5),y<-c($value,$value),xpd=TRUE)\n";
		print OUT "text(x=11.5,y=$value,labels=\"$temp\",xpd=TRUE)\n";
	}
	for($i=0;$i<6;$i++)
	{
		if($i<3)
		{
			$value=0.5+$i;
		}
		else
		{
			$value=2.5+$i;
		}
		$temp=$up[$j][$i]/$num[$j]*$max*0.9;
		print OUT "points($value,$temp,pch=24,bg=\"black\",cex=0.7,xpd=TRUE)\n";
		$temp=$down[$j][$i]/$num[$j]*$max*0.9;
		print OUT "points($value,$temp,pch=25,bg=\"black\",cex=0.7,xpd=TRUE)\n";
		$temp=$stable[$j][$i]/$num[$j]*$max*0.9;
		print OUT "points($value,$temp,pch=16,cex=0.7,xpd=TRUE)\n";
	}
	$j++;
}
close IN;
=pod
print OUT "par\(mar=c\(0,1,0,0\)\)\n";     
print OUT "plot(xlim<-c(0,1),ylim<-c(0,1))\n";
print OUT "legend(\"left\",legend=c(\"left y-axis(bar): TPM\",\"right y-axis(point): No. contigs\"))\n";
print OUT "par\(mar=c\(0,1,0,0\)\)\n";
print OUT "plot(xlim<-c(0,1),ylim<-c(0,1))\n";
print OUT "legend(\"left\",legend=c(\"handle 6 days, A\",\"handle 6 days, H\",\"handle 6 days, AH\",\"handle 6 days, C\",\"recover 9 days, A\",\"recover 9 days, H\",\"recover 9 days, AH\",\"recovery 9 days, C\"),pch=15,col=c(\"blue\",\"yellow\",\"seagreen\",\"red\",\"cyan\",\"burlywood1\",\"lightgreen\",\"darkorange\"),xpd=TRUE)\n";
print OUT "plot(xlim<-c(0,1),ylim<-c(0,1))\n";
print OUT "legend(\"left\",legend=c(\"up-expression\",\"down-expression\",\"stable-expression\"),pch=c(24,25,21),pt.bg=c(\"black\",\"black\",\"black\"),xpd=TRUE)\n";
=cut
print OUT "dev.off\(\)\n";
close OUT;
system("Rscript $file");
