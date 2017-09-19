use strict; use warnings;

my $line;
my $file;
my $in;
my $i;
my $j;
my $num_i;
my $num_j;
my @array;
my @text;
my $go;
my @list;
my $temp;
my %turn;
my @barplot;
my @point_x;
my @point_y;
my @point_status;
my @col;
my $min=0;

if(@ARGV!=3)
{
	print "perl $0  prefix_6d  prefix_9d prefix_output\n";
	exit;
}
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

$i=0;
open(LIST,"</share/home/user/bjia/GO-class/list") or die "Can't open list file!\n";
while(<LIST>)
{
	$line=$_;
	($file)=$line=~/GO\:(\d+)\t/;
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
	$i++
}
close LIST;

$i=0;
$j=0;
$file=$ARGV[0]."-up-MF.txt";
if(! (-e $file))
{
	print "Don't have $file!\n";
	exit;
}
open(IN,"<$file") or die "Can't open $file\n";
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
	$barplot[$i]=-log($temp)/log(10);
	($go)=$array[1]=~/\"(.+)\"/;
	if(! (exists $turn{$go}))
	{
		print "The $go in $file is not in class-go!\n";
		exit;
	}
	$col[$i]=$list[$turn{$go}];
	($text[$i])=$array[2]=~/\"(.+)\"/;
##the 9d
	$in=$ARGV[1]."-up-MF.txt";
	open(FILE,"<$in") or die "Can't open $in!\n";
	while(<FILE>)
	{
		$line=$_;
		if($line=~/\"$go\"/)
		{
			@array=split("\t",$line);
			if($array[6]=~/\</)
        		{
                		($temp)=$array[6]=~/\< (.+)\"/;
        		}
        		else
        		{
                		($temp)=$array[6]=~/\"(.+)\"/;
        		}
			$point_x[$j]=-log($temp)/log(10);
			$point_y[$j]=$i;
			$point_status[$j]=1;
			$j++;
			last;
		}
	}
	close FILE;

	$in=$ARGV[1]."-down-MF.txt";
        open(FILE,"<$in") or die "Can't open $in!\n";
        while(<FILE>)
        {
                $line=$_;
                if($line=~/\"$go\"/)
                {    
                        @array=split("\t",$line);
                        if($array[6]=~/\</)
                        {
                                ($temp)=$array[6]=~/\< (.+)\"/;
                        }
                        else
                        {
                                ($temp)=$array[6]=~/\"(.+)\"/;
                        }
                        $point_y[$j]=$i;
                        $point_x[$j]=log($temp)/log(10);
			$point_status[$j]=0;
                        $j++;
                        last;
                }
        }
        close FILE;
	$i++;
}
close IN;
##down
$file=$ARGV[0]."-down-MF.txt";
if(! (-e $file))
{
        print "Don't have $file!\n";
        exit;
}
open(IN,"<$file") or die "Can't open $file\n";
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
        $barplot[$i]=log($temp)/log(10);
	if($min>$barplot[$i])
	{
		$min=$barplot[$i];
	}
        ($go)=$array[1]=~/\"(.+)\"/;
        if(! (exists $turn{$go}))
        {
                print "The $go in $file is not in class-go!\n";
                exit;
        }
        $col[$i]=$list[$turn{$go}];
        ($text[$i])=$array[2]=~/\"(.+)\"/;
##the 9d
        $in=$ARGV[1]."-up-MF.txt";
        open(FILE,"<$in") or die "Can't open $in!\n";
        while(<FILE>)
        {
                $line=$_;
                if($line=~/\"$go\"/)
                {
                        @array=split("\t",$line);
                        if($array[6]=~/\</)
                        {
                                ($temp)=$array[6]=~/\< (.+)\"/;
                        }
                        else
                        {
                                ($temp)=$array[6]=~/\"(.+)\"/;
                        }
                        $point_y[$j]=$i;
                        $point_x[$j]=-log($temp)/log(10);
			$point_status[$j]=1;
                        $j++;
                        last;
                }
        }
        close FILE;
        $in=$ARGV[1]."-down-MF.txt";
        open(FILE,"<$in") or die "Can't open $in!\n";
        while(<FILE>)
        {
                $line=$_;
                if($line=~/\"$go\"/)
                {    
                        @array=split("\t",$line);
                        if($array[6]=~/\</)
                        {
                                ($temp)=$array[6]=~/\< (.+)\"/;
                        }
                        else
                        {
                                ($temp)=$array[6]=~/\"(.+)\"/;
                        }
                        $point_y[$j]=$i;
                        $point_x[$j]=log($temp)/log(10);
			$point_status[$j]=0;
                        $j++;
                        last;
                }
        }
        close FILE;
        $i++;
}
close IN;
$num_i=$i;
$num_j=$j;

$file=$ARGV[2].".R";
open(OUT,">$file") or die "can't create $file\n";
print OUT "pdf\(file=\"$ARGV[2]\.pdf\"\)\n";
print OUT "par\(mai=c\(0.5,1.5,3,3.5\)\)\n";
print OUT "x<-c\($barplot[$num_i-1]";
for($i=$num_i-2;$i>=0;$i--)
{
	print OUT "\,$barplot[$i]";
}
print OUT "\)\n";
print OUT "colour<-c\(\"$col[$num_i-1]\"";
for($i=$num_i-2;$i>=0;$i--)
{
	print OUT "\,\"$col[$i]\"";
}
print OUT "\)\n";
print OUT "barplot\(x,col=colour,horiz=TRUE,space=0,width=0.3\)\n";
for($i=0;$i<$num_j;$i++)
{
	$temp=0.15+0.3*($num_i-1-$point_y[$i]);
	$j=25-$point_status[$i];
	print OUT "points\($point_x[$i],$temp,cex=1.5,pch=$j,xpd=TRUE\)\n";
}

for($i=0;$i<$num_i;$i++)
{
	$temp=0.15+0.3*($num_i-1-$i);
	if($barplot[$i]>=0)
	{
		
		print OUT "text\(x=$min,y=$temp,labels=\"$text[$i]\",cex=1.1,xpd=TRUE,pos=4\)\n";
	}
	else
	{
		print OUT "text\(x=0,y=$temp,labels=\"$text[$i]\",cex=1.1,xpd=TRUE,pos=4\)\n";
	}
}

##p_value=0.05
$j=0.15+0.3*$num_i;
$i=-log(0.05)/log(10);
print OUT "lines\(x<-c\($i,$i\),y<-c\(0,$j\),lty=2,xpd=TRUE\)\n";
$i=-1*$i;
print OUT "lines\(x<-c\($i,$i\),y<-c\(0,$j\),lty=2,xpd=TRUE\)\n";
print OUT "dev.off\(\)\n";
close OUT;
system("Rscript $file");
system("rm $file");
