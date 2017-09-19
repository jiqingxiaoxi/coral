use strict; use warnings;

my $line;
my @array;
my $temp;
my @file;

if(@ARGV!=5)
{
	print "perl $0 diff-file up_or_down  anthozoa_symbiodinium gene2GO output_prefix\n";
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

	if($array[1]!~/$ARGV[1]/)
	{
		next;
	}
	if($array[2]!~/$ARGV[2]/)
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
print OUT "len\<\-length\(score\(result\)\)\n";
print OUT "output<-GenTable\(GOdata,classic=result,topNodes=len\)\n"; ##output how many GO
$file[2]=$ARGV[4]."-MF.txt";
print OUT "write.table\(output,file=\"$file[2]\",sep=\"\\t\"\)\n";
close OUT;
system("Rscript $file[1]");
system("rm $file[1]");
=pod
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
=cut
system("rm $file[0]");
