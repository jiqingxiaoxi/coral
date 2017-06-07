use strict; use warnings;

my $line;
my @array;
my $i;
my $temp;
my $flag;
my %not;
my @file;

if(@ARGV<3||@ARGV>4)
{
	print "perl $0 diff-file up_or_down  output_prefix  delete_diff\(optional\)\n";
	exit;
}

if(@ARGV==4)
{
	open(IN,"<$ARGV[3]") or die "can't $ARGV[3]\n";
	while(<IN>)
	{
		$line=$_;
		if($line=~/^\"feature/)
        	{                                                                             
        	        next;
        	}
        	@array=split(" ",$line);
		if($array[3]>=0.05)
		{
			last;
		}
        	($array[1])=$array[1]=~/\"(.+)\"/;
		$not{$array[1]}=1;
	}
	close IN;
}

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
	if($line=~/^\"feature/)
	{
		next;
	}
	@array=split(" ",$line);
	if($array[3]>=0.05)
	{
		last;
	}
	if($flag==1&&$array[2]<=1)
	{
		next;
	}
	if($flag==0&&$array[2]>=1)
	{
		next;
	}
	($array[1])=$array[1]=~/\"(.+)\"/;
	print OUT "$array[1]\n";
}
close IN;
close OUT;

##MF
$file[1]="temp-".$temp.".R";
open(OUT,">$file[1]") or die "can't create $file[1]\n";
print OUT "library\(topGO\)\n";
print OUT "geneID2GO\<-readMappings\(file=\"/lustre/home/clslzy/bjia/By-Ref/Ad/GO/gene2GO.txt\"\)\n";
print OUT "geneNames\<-names\(geneID2GO\)\n";
print OUT "Interesting<-read.table\(\"$file[0]\",header=FALSE\)\n";
print OUT "myInterestingGenes<-Interesting\[,1\]\n";
print OUT "geneList<-factor\(as.integer\(geneNames \%in\% myInterestingGenes\)\)\n";
print OUT "names\(geneList\)<-geneNames\n";
print OUT "GOdata<-new\(\"topGOdata\",ontology=\"MF\",allGenes=geneList,annot=annFUN.gene2GO,gene2GO=geneID2GO,nodeSize=5\)\n";
print OUT "result<-runTest\(GOdata,algorithm=\"classic\",statistic=\"fisher\"\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=100\)\n"; ##output how many GO
$file[2]=$ARGV[2]."-MF.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");

##BP
$file[1]="temp-".$temp.".R";
open(OUT,">$file[1]") or die "can't create $file[1]\n";
print OUT "library\(topGO\)\n";
print OUT "geneID2GO\<-readMappings\(file=\"/lustre/home/clslzy/bjia/By-Ref/Ad/GO/gene2GO.txt\"\)\n";
print OUT "geneNames\<-names\(geneID2GO\)\n";
print OUT "Interesting<-read.table\(\"$file[0]\",header=FALSE\)\n";
print OUT "myInterestingGenes<-Interesting\[,1\]\n";
print OUT "geneList<-factor\(as.integer\(geneNames \%in\% myInterestingGenes\)\)\n";
print OUT "names\(geneList\)<-geneNames\n";
print OUT "GOdata<-new\(\"topGOdata\",ontology=\"BP\",allGenes=geneList,annot=annFUN.gene2GO,gene2GO=geneID2GO,nodeSize=5\)\n";
print OUT "result<-runTest\(GOdata,algorithm=\"classic\",statistic=\"fisher\"\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=100\)\n"; ##output how many GO                                      
$file[2]=$ARGV[2]."-BP.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");

##CC
$file[1]="temp-".$temp.".R";
open(OUT,">$file[1]") or die "can't create $file[1]\n";
print OUT "library\(topGO\)\n";
print OUT "geneID2GO\<-readMappings\(file=\"/lustre/home/clslzy/bjia/By-Ref/Ad/GO/gene2GO.txt\"\)\n";
print OUT "geneNames\<-names\(geneID2GO\)\n";
print OUT "Interesting<-read.table\(\"$file[0]\",header=FALSE\)\n";
print OUT "myInterestingGenes<-Interesting\[,1\]\n";
print OUT "geneList<-factor\(as.integer\(geneNames \%in\% myInterestingGenes\)\)\n";
print OUT "names\(geneList\)<-geneNames\n";
print OUT "GOdata<-new\(\"topGOdata\",ontology=\"CC\",allGenes=geneList,annot=annFUN.gene2GO,gene2GO=geneID2GO,nodeSize=5\)\n";
print OUT "result<-runTest\(GOdata,algorithm=\"classic\",statistic=\"fisher\"\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=100\)\n"; ##output how many GO                                      
$file[2]=$ARGV[2]."-CC.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");
system("rm $file[0]");
