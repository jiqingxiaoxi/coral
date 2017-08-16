use strict; use warnings;

my $line;
my @array;
my $i;
my $temp;
my $flag;
my %not;
my @file;
my %source;

if(@ARGV<5||@ARGV>6)
{
	print "perl $0 diff-file up_or_down  source_file gene2GO output_prefix  delete_diff\(optional\)\n";
	exit;
}

if(@ARGV==6)
{
	open(IN,"<$ARGV[5]") or die "can't $ARGV[5]\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^GI/)
        	{                                                                             
        	        next;
        	}
        	@array=split("\t",$line);
		$not{$array[0]}=1;
	}
	close IN;
}

open(IN,"<$ARGV[2]") or die "can't open $ARGV[2]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	$source{$line}=1;
}
close IN;

if($ARGV[1] eq "up")
{
	$flag=1;
}
elsif($ARGV[1] eq "down")
{
	$flag=0;
}
else
{
	print "please input up or down\n";
	exit;
}

$temp=time();
$file[0]="temp-".$temp.".txt";
open(OUT,">$file[0]") or die "Can't create $file[0]\n";
open(IN,"<$ARGV[0]") or die "can't open $ARGV[0]\n";
while(<IN>)
{
	$line=$_;
	if($line=~/^GI/)
	{
		next;
	}
	@array=split("\t",$line);
	if(! (exists $source{$array[0]}))
	{
		next;
	}
	if(exists $not{$array[0]})
	{
		next;
	}
	if($flag==1&&$array[1]<=1)
	{
		next;
	}
	if($flag==0&&$array[1]>=1)
	{
		next;
	}
	print OUT "$array[0]\n";
}
close IN;
close OUT;
##MF
$file[1]="temp-".$temp.".R";
open(OUT,">$file[1]") or die "can't create $file[1]\n";
print OUT "library\(topGO\)\n";
print OUT "geneID2GO\<-readMappings\(file=\"$ARGV[3]\"\)\n";
print OUT "geneNames\<-names\(geneID2GO\)\n";
print OUT "Interesting<-read.table\(\"$file[0]\",header=FALSE\)\n";
print OUT "myInterestingGenes<-Interesting\[,1\]\n";
print OUT "geneList<-factor\(as.integer\(geneNames \%in\% myInterestingGenes\)\)\n";
print OUT "names\(geneList\)<-geneNames\n";
print OUT "GOdata<-new\(\"topGOdata\",ontology=\"MF\",allGenes=geneList,annot=annFUN.gene2GO,gene2GO=geneID2GO,nodeSize=5\)\n";
print OUT "result<-runTest\(GOdata,algorithm=\"classic\",statistic=\"fisher\"\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=100\)\n"; ##output how many GO
$file[2]=$ARGV[4]."-MF.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");

##BP
$file[1]="temp-".$temp.".R";
open(OUT,">$file[1]") or die "can't create $file[1]\n";
print OUT "library\(topGO\)\n";
print OUT "geneID2GO\<-readMappings\(file=\"$ARGV[3]\"\)\n";
print OUT "geneNames\<-names\(geneID2GO\)\n";
print OUT "Interesting<-read.table\(\"$file[0]\",header=FALSE\)\n";
print OUT "myInterestingGenes<-Interesting\[,1\]\n";
print OUT "geneList<-factor\(as.integer\(geneNames \%in\% myInterestingGenes\)\)\n";
print OUT "names\(geneList\)<-geneNames\n";
print OUT "GOdata<-new\(\"topGOdata\",ontology=\"BP\",allGenes=geneList,annot=annFUN.gene2GO,gene2GO=geneID2GO,nodeSize=5\)\n";
print OUT "result<-runTest\(GOdata,algorithm=\"classic\",statistic=\"fisher\"\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=100\)\n"; ##output how many GO                                      
$file[2]=$ARGV[4]."-BP.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");

##CC
$file[1]="temp-".$temp.".R";
open(OUT,">$file[1]") or die "can't create $file[1]\n";
print OUT "library\(topGO\)\n";
print OUT "geneID2GO\<-readMappings\(file=\"$ARGV[3]\"\)\n";
print OUT "geneNames\<-names\(geneID2GO\)\n";
print OUT "Interesting<-read.table\(\"$file[0]\",header=FALSE\)\n";
print OUT "myInterestingGenes<-Interesting\[,1\]\n";
print OUT "geneList<-factor\(as.integer\(geneNames \%in\% myInterestingGenes\)\)\n";
print OUT "names\(geneList\)<-geneNames\n";
print OUT "GOdata<-new\(\"topGOdata\",ontology=\"CC\",allGenes=geneList,annot=annFUN.gene2GO,gene2GO=geneID2GO,nodeSize=5\)\n";
print OUT "result<-runTest\(GOdata,algorithm=\"classic\",statistic=\"fisher\"\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=100\)\n"; ##output how many GO                                      
$file[2]=$ARGV[4]."-CC.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");
system("rm $file[0]");
