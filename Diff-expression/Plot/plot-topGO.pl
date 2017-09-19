use strict; use warnings;

my $line;
my $file;
my $i;
my $j;
my $k;
my @num;
my @array;
my @text;
my $flag;
my $go;
my %name;
my @xleft;
my @xright;
my @ybottom;
my @ytop;
my %col;
my @list;
my $max1=0; ##up
my $max2=0; ##down
my $pos=0.2;
my $seq="";
my @legend;
my $temp;
my @handle;
my @status;
my %turn;
my $goturn=0;
my $colturn=0;
my @havego;
my @colgo;
my @coral;

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
$list[2]="brown1";
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
$coral[0]="as";
$coral[1]="gs";

open(IN,"</lustre/home/clslzy/bjia/Annotation/GO/db/go.obo") or die "Can't open go.obo file!\n";
$flag=0;
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^id\: GO/)
	{
		($go)=$line=~/id: (.+)$/;
		$flag=1;
		next;
	}
	if($line=~/^name\: /&&$flag==1)
	{
		($temp)=$line=~/name\: (.+)$/;
		next;
	}
	if($line=~/^namespace\:/ && $flag==1)
	{
		if($line=~/molecular\_function/)
		{
			$name{$go}=$temp;
		}
		$flag=0;
	}
}
close IN;

$pos=-0.8;
for($k=0;$k<@coral;$k++)
{
	for($i=0;$i<@handle;$i++)
	{
		$pos=$pos+1;
		for($j=0;$j<@status;$j++)
		{
			$file="/lustre/home/clslzy/bjia/Diff-expression/GO/Same-topGO/".$coral[$k].$handle[$i]."-all-".$ARGV[0]."-".$status[$j]."-MF.txt";
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
					if(exists $col{$turn{$go}})
					{
						$num[$k*6+$i][$j]++;
						next;
					}
					else
					{
						$col{$turn{$go}}=$colturn;
						$colgo[$colturn]=$name{$go};
						$colturn++;
					}
				}
				else
				{
					$turn{$go}=$goturn;
					$text[$k*12+2*$i+$j][$num[$k*6+$i][$j]]=$turn{$go};
					$havego[$goturn]=$name{$go};
					$goturn++;
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
print OUT "lines\(x<-c\(0,11.2\),y<-c\(0,0\)\)\n";
for($i=0;$i<24;$i++)
{
	for($j=0;$j<$num[($i-$i%2)/2][$i%2];$j++)
	{
		if(exists $col{$text[$i][$j]})
		{
			print OUT "rect\(xleft=$xleft[$i][$j],xright=$xright[$i][$j],ybottom=$ybottom[$i][$j],ytop=$ytop[$i][$j],col=\"$list[$col{$text[$i][$j]}]\"\)\n";
		}
		else
		{
			print OUT "rect\(xleft=$xleft[$i][$j],xright=$xright[$i][$j],ybottom=$ybottom[$i][$j],ytop=$ytop[$i][$j]\)\n";
			if($seq eq "")
			{
				$seq=$text[$i][$j].":".$havego[$text[$i][$j]];
			}
			else
			{
				$seq=$seq."; ".$text[$i][$j].":".$havego[$text[$i][$j]];
			}
		}
		$temp=($xleft[$i][$j]+$xright[$i][$j])/2;
		$flag=($ybottom[$i][$j]+$ytop[$i][$j])/2;
		print OUT "text\($temp,$flag,\"$text[$i][$j]\",cex=0.7\)\n";
	}
}
##lengend
print OUT "legend\(x=11.5,y=0,legend=c\(";
for($i=0;$i<$goturn;$i++)
{
	if(! (exists $col{$i}))
	{
		next;
	}
	print OUT "\"$i\:$colgo[$col{$i}]\"\,";
}
print OUT "\"others\"\),col=c\(";
for($i=0;$i<$goturn;$i++) 
{
	if(! (exists $col{$i}))
        {
                next;
        }
        print OUT "\"$list[$col{$i}]\"\,";
}
print OUT "\"white\"\),xpd=TRUE,cex=0.5,pch=15\)\n";
print OUT "dev.off\(\)\n";
close OUT;
system("Rscript $file");
