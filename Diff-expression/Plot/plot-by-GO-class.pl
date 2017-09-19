use strict; use warnings;

my $line;
my $file;
my $i;
my $j;
my $k;
my @num;
my @array;
my @text;
my $go;
my @name;
my @xleft;
my @xright;
my @ybottom;
my @ytop;
my @list;
my $max1=0; ##up
my $max2=0; ##down
my $pos=0.2;
my $temp;
my @handle;
my @status;
my %turn;
my @coral;
my %hash;

if(@ARGV!=2)
{
	print "perl $0  anthozoa_symbiodinium prefix_output\n";
	exit;
}
$handle[0]="6dA-C";
$handle[1]="6dH-C";
$handle[2]="6dAH-C";
$handle[3]="rd9A-C";
$handle[4]="rd9H-C";
$handle[5]="rd9AH-C";
$status[0]="up";
$status[1]="down";
$list[0]="red";
$list[1]="blue3";
$list[2]="darkolivegreen1";
$list[3]="burlywood";
$list[4]="cadetblue";
$list[5]="chartreuse";
$list[6]="darkgoldenrod1";
$list[7]="darkmagenta";
$list[8]="deeppink2";
$list[9]="khaki1";
$list[10]="lightslategray";
$list[11]="navyblue";
$list[12]="aquamarine";
$list[13]="sienna";
$list[14]="violetred";
$list[15]="black";
$list[16]="chartreuse4";
$list[17]="cyan2";
$list[18]="darkolivegreen3";
$list[19]="mediumpurple3";
$list[20]="white";

$coral[0]="as";
$coral[1]="gs";

$i=0;
open(LIST,"</share/home/user/bjia/GO-class/list") or die "Can't open list file!\n";
while(<LIST>)
{
	chomp;
	$line=$_;
	@array=split("\t",$line);
	$name[$i]=$array[1];
	($file)=$array[0]=~/GO\:(\d+)$/;
	$file="/share/home/user/bjia/GO-class/GO_".$file.".list";
	open(IN,"<$file") or die "Can't open $file\n";
	while(<IN>)
	{
		chomp;
		$line=$_;
		if(exists $turn{$line})
		{
			$turn{$line}=20;
		}
		else
		{
			$turn{$line}=$i;
		}
	}
	close IN;
	$i++;
}
close LIST;

$pos=-1;
for($k=0;$k<@coral;$k++)
{
	for($i=0;$i<@handle;$i++)
	{
		$pos=$pos+1.2;
		for($j=0;$j<@status;$j++)
		{
			$file="/share/home/user/bjia/Same-topGO/".$coral[$k].$handle[$i]."-all-".$ARGV[0]."-".$status[$j]."-MF.txt";
			if(! (-e $file))
			{
				$num[6*$k+$i][$j]=0;
				next;
			}
			open(IN,"<$file") or die "Can't open $file\n";
			$num[$k*6+$i][$j]=0;
			while(<IN>)
			{
				$line=$_;
				if($line=~/^\"GO.ID/)
				{
					next;
				}
				if($line=~/^\"6/)
				{
					last;
				}
				@array=split("\t",$line);
				if($array[6]=~/\</)
				{
					($temp)=$array[6]=~/\< (.+)\"/;
				}
				else
				{
					($temp)=$array[6]=~/\"(.+)\"/;
				}
				if($temp>=0.05)
				{
					last;
				}
				$temp=-log($temp)/log(10);
				if($k==0&&$i==2)
				{
					$temp=$temp/3;
				}
				$xleft[12*$k+2*$i+$j][$num[$k*6+$i][$j]]=$pos;
				$xright[12*$k+2*$i+$j][$num[$k*6+$i][$j]]=$pos+0.8;
				if($num[$i+$k*6][$j]==0)
				{
					$ybottom[$k*12+2*$i+$j][$num[$k*6+$i][$j]]=0;
				}
				else
				{
					$ybottom[$k*12+2*$i+$j][$num[$k*6+$i][$j]]=$ytop[$k*12+2*$i+$j][$num[$k*6+$i][$j]-1];
				}
				$ytop[$k*12+2*$i+$j][$num[$k*6+$i][$j]]=$ybottom[$k*12+2*$i+$j][$num[$k*6+$i][$j]]+(1-2*$j)*$temp;

				($go)=$array[1]=~/\"(.+)\"/;
				if(exists $turn{$go})
				{
					$text[$k*12+2*$i+$j][$num[$k*6+$i][$j]]=$turn{$go};
					$hash{$turn{$go}}=1;
				}
				else
				{
					print "Don't have $go!\n";
					exit;
				}
				$num[$k*6+$i][$j]++;
			}
			close IN;
			if($num[$k*6+$i][$j]==0)
			{
				next;
			}
			if($j==0&&$ytop[$k*12+$i*2+$j][$num[$k*6+$i][$j]-1]>$max1)
			{
				$max1=$ytop[$k*12+$i*2+$j][$num[$k*6+$i][$j]-1];
				next;
			}
			if($j==1&&$ytop[$k*12+$i*2+$j][$num[$k*6+$i][$j]-1]<$max2)
			{
				$max2=$ytop[$k*12+$i*2+$j][$num[$k*6+$i][$j]-1];
			}
		}
	}
}

$file=$ARGV[1].".R";
open(OUT,">$file") or die "can't create $file\n";
print OUT "pdf\(file=\"$ARGV[1]\.pdf\"\)\n";
print OUT "plot\(x\<-c\(0,20\),y\<-c\($max1,$max2\)\)\n";
print OUT "lines\(x<-c\(0,13.2\),y<-c\(0,0\)\)\n";
for($i=0;$i<24;$i++)
{
	for($j=0;$j<$num[($i-$i%2)/2][$i%2];$j++)
	{
		print OUT "rect\(xleft=$xleft[$i][$j],xright=$xright[$i][$j],ybottom=$ybottom[$i][$j],ytop=$ytop[$i][$j],col=\"$list[$text[$i][$j]]\"\)\n";
	}
}
##lengend
print OUT "legend\(x=14.2,y=0,legend=c\(";
for($i=0;$i<20;$i++)
{
	if(! (exists $hash{$i}))
	{
		next;
	}
	print OUT "\"$name[$i]\"\,";
}
print OUT "\"others\"\),col=c\(";
for($i=0;$i<20;$i++) 
{
	if(! (exists $hash{$i}))
        {
                next;
        }
        print OUT "\"$list[$i]\"\,";
}
print OUT "\"white\"\),xpd=TRUE,cex=0.5,pch=15\)\n";
print OUT "dev.off\(\)\n";
close OUT;
system("Rscript $file");
