use strict; use warnings;

my $line;
my @file;
my @store;
my @list;
my @cluster;
my $i;
my $j;
my $k;
my $num;
my @array;

if(@ARGV!=3)
{
	print "perl $0 input_dir output_dir output_prefix\n";
	exit;
}

$list[0]="1_10";
$list[1]="1_5";
$list[2]="2_10";
$list[3]="2_5";
$cluster[0]=0.9;
$cluster[1]=0.95;

for($i=0;$i<4;$i++)
{
	for($j=0;$j<2;$j++)
	{
		if($ARGV[0]=~/\/$/)
		{
			if($ARGV[2]=~/rsem/i)
			{
				$file[0]=$ARGV[0].$list[$i]."_C_1-".$cluster[$j].".genes.results";
				$file[1]=$ARGV[0].$list[$i]."_C_2-".$cluster[$j].".genes.results";
				$file[2]=$ARGV[0].$list[$i]."_C_3-".$cluster[$j].".genes.results";
                        	$file[3]=$ARGV[0].$list[$i]."_H_1-".$cluster[$j].".genes.results";
				$file[4]=$ARGV[0].$list[$i]."_H_2-".$cluster[$j].".genes.results";
                        	$file[5]=$ARGV[0].$list[$i]."_H_3-".$cluster[$j].".genes.results";
			}
			else
			{
				$file[0]=$ARGV[0].$list[$i]."_C_1-".$cluster[$j]."-result.txt";
                                $file[1]=$ARGV[0].$list[$i]."_C_2-".$cluster[$j]."-result.txt";
                                $file[2]=$ARGV[0].$list[$i]."_C_3-".$cluster[$j]."-result.txt";
                                $file[3]=$ARGV[0].$list[$i]."_H_1-".$cluster[$j]."-result.txt";
                                $file[4]=$ARGV[0].$list[$i]."_H_2-".$cluster[$j]."-result.txt";
                                $file[5]=$ARGV[0].$list[$i]."_H_3-".$cluster[$j]."-result.txt";
                        }
		}
		else
		{
			if($ARGV[2]=~/rsem/i)
			{
				$file[0]=$ARGV[0]."/".$list[$i]."_C_1-".$cluster[$j].".genes.results";
                        	$file[1]=$ARGV[0]."/".$list[$i]."_C_2-".$cluster[$j].".genes.results";
                        	$file[2]=$ARGV[0]."/".$list[$i]."_C_3-".$cluster[$j].".genes.results";                        
                        	$file[3]=$ARGV[0]."/".$list[$i]."_H_1-".$cluster[$j].".genes.results";
                        	$file[4]=$ARGV[0]."/".$list[$i]."_H_2-".$cluster[$j].".genes.results";
                        	$file[5]=$ARGV[0]."/".$list[$i]."_H_3-".$cluster[$j].".genes.results";
			}
			else
			{
				$file[0]=$ARGV[0]."/".$list[$i]."_C_1-".$cluster[$j]."-result.txt";
                                $file[1]=$ARGV[0]."/".$list[$i]."_C_2-".$cluster[$j]."-result.txt";
                                $file[2]=$ARGV[0]."/".$list[$i]."_C_3-".$cluster[$j]."-result.txt";
                                $file[3]=$ARGV[0]."/".$list[$i]."_H_1-".$cluster[$j]."-result.txt";
                                $file[4]=$ARGV[0]."/".$list[$i]."_H_2-".$cluster[$j]."-result.txt";
                                $file[5]=$ARGV[0]."/".$list[$i]."_H_3-".$cluster[$j]."-result.txt";
                        } 
                }
		
		if($ARGV[1]=~/\/$/)
		{
			$file[6]=$ARGV[1].$list[$i]."-".$cluster[$j]."-".$ARGV[2]."-result.txt";
		}
		else
		{
			$file[6]=$ARGV[1]."/".$list[$i]."-".$cluster[$j]."-".$ARGV[2]."-result.txt";
		}
		$file[7]=rand();
		$file[7]="temp-".$file[7].".txt";

		$num=0;
		open(IN,"<$file[0]") or die "can't open $file[0]\n";
		while(<IN>)
		{
			$line=$_;
			if($line!~/^gi/)
			{
				next;
			}
			@array=split("\t",$line);
			$store[$num][0]=$array[0];
			$store[$num][1]=$array[4]+0.5;
			$num++;
		}
		close IN;

		for($k=1;$k<6;$k++)
		{
			open(IN,"<$file[$k]") or die "Can't open $file[$k]\n";
			$num=0;
			while(<IN>)
			{
				$line=$_;
				if($line!~/^gi/)
				{
					next;
				}
				@array=split("\t",$line);
				$store[$num][$k+1]=$array[4]+0.5;
				$num++;
			}
			close IN;
		}

		open(OUT,">/tmp/$file[7]") or die "can't create $file[7]\n";
		print OUT "gene\tC-1\tC-2\tC-3\tH-1\tH-2\tH-3\n";
		for($k=0;$k<$num;$k++)
		{
			printf(OUT "%s\t%d\t%d\t%d\t%d\t%d\t%d\n",$store[$k][0],$store[$k][1],$store[$k][2],$store[$k][3],$store[$k][4],$store[$k][5],$store[$k][6]);
		}
		close OUT;

		$file[8]=rand();
		$file[8]="temp-".$file[8].".R";
		open(OUT,">/tmp/$file[8]") or die "Can't create $file[8]\n";
		print OUT "library\(DESeq2\)\n";
		print OUT "cts \<- as.matrix\(read.csv\(\"/tmp/$file[7]\",sep=\"\\t\",row.names=1\)\)\n";
		print OUT "coldata \<- data.frame\(File=c\(\"C-1\",\"C-2\",\"C-3\",\"H-1\",\"H-2\",\"H-3\"\),condition=c\(\"N\",\"N\",\"N\",\"Y\",\"Y\",\"Y\"))\n";
		print OUT "dds \<- DESeqDataSetFromMatrix\(countData = cts,colData = coldata,design = \~ condition\)\n";
		print OUT "dds \<- dds\[ rowSums\(counts\(dds\)\) \> 2, \]\n";
		print OUT "dds\$condition \<- factor\(dds\$condition, levels=c\(\"N\",\"Y\"\)\)\n";
		print OUT "dds \<- DESeq\(dds\)\n";
		print OUT "res \<- results\(dds\)\n";
		print OUT "write.table\(res,file=\"$file[6]\",sep=\"\\t\"\)\n";
		close OUT;

		system("Rscript /tmp/$file[8]");
		system("rm /tmp/$file[7]");
		system("rm /tmp/$file[8]");
	}
}
