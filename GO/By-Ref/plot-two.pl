use strict; use warnings;

my $line;
my @array;
my @name;
my @pos;
my @col;
my @max;
my $num;
my $i;
my $j;
my $flag;
my @temp;
my @value;
my @gap;
my @status;
my $file;

if(@ARGV!=3)
{
	print "perl $0 input  output_prefix  number_gene\n";
	exit;
}


$i=0;
$j=0;
$flag=0;
$max[0]=0;
$max[1]=0;
$temp[5]=0;
$temp[6]=0;
open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^Gene\t/)
	{
		next;
	}
	@array=split("\t",$line);
	if($line=~/^\w+/)
	{
		if($flag!=0)
		{
			$name[$i]=$temp[0];
			$value[$i]=$temp[1];
			$col[$i]=$temp[2];
			$gap[$i]=0;
			$pos[$i]=$pos[$i-1]+1;
			$status[$i]=1; ##FC
			if($temp[3]>$max[0]) ##pvalue	
			{
				$max[0]=$temp[3];
			}
			if($temp[1]>$max[1])
			{
				$max[1]=$temp[1];
			}

			if($col[$i] eq "red")
			{
				$temp[5]=1;
			}
			else
			{
				$temp[6]=1;
			}
			$i++;
			$j++;
		}
		
		if($j>=$ARGV[2])
		{
			last;
		}
		$temp[0]=$array[0];
		$temp[1]=$array[2];
		if($array[2]>=1)
		{
			$temp[2]="red";
		}
		else
		{
			$temp[2]="green";
			$temp[1]=1/$array[2];
		}
		$temp[3]=$array[1];
		$flag=0;
	}
	if($array[3] eq "No GO")
	{
		next;
	}
	if($array[4] ne "molecular_function")
	{
		next;
	}
	if($flag==0)
	{
		$flag++;
		if($i==0)
		{
			$pos[$i]=0.5;
			$gap[$i]=0;
		}
		else
		{
			$pos[$i]=$pos[$i-1]+2;
			$gap[$i]=1;
		}
		$name[$i]=$array[5];
                $value[$i]=$temp[3];
                $col[$i]="white";
		$status[$i]=0;
	}
	else
	{
		$pos[$i]=$pos[$i-1]+1;
		$gap[$i]=0;
		$name[$i]=$array[5];
		$value[$i]=$temp[3];
		$col[$i]="white";
		$status[$i]=0;
	}
	$i++;
}
close IN;
$num=$i;

for($i=0;$i<$num;$i++)
{
	if($status[$i]==1)
	{
		next;
	}
	$value[$i]=$value[$i]/$max[0]*$max[1];
}

$file=$ARGV[1].".R";
open(OUT,">$file") or die "can't create $file\n";
print OUT "jpeg\(filename=\"$ARGV[1]\.jpeg\",quality=100\)\n";
print OUT "par\(mai=c\(0.5,3,0.5,1.5\)\)\n";
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

print OUT "col<-c\(";
for($i=0;$i<$num-1;$i++)
{
        print OUT "\"$col[$i]\"\,";  
}
print OUT "\"$col[$i]\"\)\n";

print OUT "barplot\(x,horiz=TRUE,space=gap,col=col\)\n";

if($max[0]>=0.04)
{
	print OUT "label<-c\(0,0.01,0.05\)\n";
	$value[0]=0.01/$max[0]*$max[1];
	$value[1]=0.05/$max[0]*$max[1];
}
elsif($max[0]>=0.01)
{
	print OUT "label<-c\(0,0.005,0.01\)\n";
	$value[0]=0.005/$max[0]*$max[1];
	$value[1]=0.01/$max[0]*$max[1];
}
elsif($max[0]>=0.005)
{
	print OUT "label<-c\(0,0.001,0.005\)\n";
	$value[0]=0.001/$max[0]*$max[1];
	$value[1]=0.005/$max[0]*$max[1];
}
elsif($max[0]>=0.001)
{
	print OUT "label<-c\(0,\"5e-4\",\"1e-3\"\)\n";	
	$value[0]=0.0005/$max[0]*$max[1];
	$value[1]=0.001/$max[0]*$max[1];
}
else
{
	printf(OUT "label<-c\(0,%1.1e,%1.1e\)\n",$max[0]/2,$max[0]);
	$value[0]=$max[1]/2;
	$value[1]=$max[1];
}
print OUT "axis\(3,labels=label,at=c\(0,$value[0],$value[1]\),xpd=TRUE\)\n";

for($i=0;$i<$num;$i++)
{
	if($status[$i]==1)
	{
		$value[0]=-1*$max[1]*2/3;
		print OUT "text\(x=$value[0],y=$pos[$i],labels=\"$name[$i]\",xpd=TRUE,pos=4,font=2,cex=0.9\)\n";
	}
	else
	{
		$value[0]=-1*$max[1];
		print OUT "text\(x=$value[0],y=$pos[$i],labels=\"$name[$i]\",xpd=TRUE,pos=4,cex=0.9\)\n";
	}
}
if($temp[5]==1&&$temp[6]==1)
{
	print OUT "legend\(x=$max[1],y=$pos[$num/2],legend=c\(\"FC-up\",\"FC-down\",\"Pvalue\"\),fill=c\(\"red\",\"green\",\"white\"\),xpd=TRUE\)\n";
}
elsif($temp[5]==1)
{
	print OUT "legend\(x=$max[1],y=$pos[$num/2],legend=c\(\"FC-up\",\"Pvalue\"\),fill=c\(\"red\",\"white\"\),xpd=TRUE\)\n";
}
else
{
	print OUT "legend\(x=$max[1],y=$pos[$num/2],legend=c\(\"FC-down\",\"Pvalue\"\),fill=c\(\"green\",\"white\"\),xpd=TRUE\)\n";
}
print OUT "text\(x=$max[1],y=-2.5,labels=\"FC\",xpd=TRUE,pos=4,font=2\)\n";
$pos[$num]=$pos[$num-1]+2.5;
print OUT "text\(x=$max[1],y=$pos[$num],labels=\"Pvalue\",xpd=TRUE,pos=4,font=2\)\n"; 
$value[0]=-1*$max[1]*0.9;
print OUT "text\(x=$value[0],y=-2.5,labels=\"$ARGV[1]\",xpd=TRUE,pos=4,font=4,col=\"red\"\)\n";
print OUT "dev.off\(\)\n";
close OUT;
system("Rscript $file");
system("rm $file");
