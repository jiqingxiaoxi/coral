use strict; use warnings;

my @file;
my $line;
my $prefix;

if(@ARGV!=1)
{
	print "perl $0 file_list\n";
	exit;
}

open(IN,"<$ARGV[0]") or die "Can't open $ARGV[0]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	
	($prefix)=$line=~/^(.+)\_1.fa/;
	$file[0]="task_".$prefix.".slurm";
	$file[1]=$line; ##gzip
	$file[2]=$prefix."_2.fa.gz";

	$file[3]=$prefix."_1.fa";
	$file[4]=$prefix."_2.fa";
	open(OUT,">$file[0]") or die "Can't create $file[0]\n";
	print OUT "\#\! /bin/bash\n";
	print OUT "\#SBATCH -n 4\n";
	print OUT "\#SBATCH -p cpu\n";
	print OUT "\#SBATCH -o log\-$prefix\n";
	print OUT "\#SBATCH -e err\-$prefix\n";
	print OUT "\#SBATCH --time=144:00:00\n";
	
	print OUT "gunzip -c /lustre/home/clslzy/bjia/simulate/$file[1] \> /tmp/$file[3]\n";
	print OUT "gunzip -c /lustre/home/clslzy/bjia/simulate/$file[2] \> /tmp/$file[4]\n";
	
	$file[5]=$prefix."-coral.sam";
	$file[6]=$prefix."-coral.sam.gz";
	$file[7]=$prefix."-symbiodinium.sam";
	$file[8]=$prefix."-symbiodinium.sam.gz";
	
	print OUT "/lustre/home/clslzy/bin/bowtie2/bowtie2 -p 4 --no-unal --no-hd --reorder --local -f -N 1 -D 50 -x /lustre/home/clslzy/bjia/Cluster/db-An -1 /tmp/$file[3] -2 /tmp/$file[4] -S /tmp/$file[5]\n";
	print OUT "/lustre/home/clslzy/bin/bowtie2/bowtie2 -p 4 --no-unal --no-hd --reorder --local -f -N 1 -D 50 -x /lustre/home/clslzy/bjia/Cluster/db-Sy -1 /tmp/$file[3] -2 /tmp/$file[4] -S /tmp/$file[7]\n";
	print OUT "gzip /tmp/$file[5]\n";
	print OUT "mv /tmp/$file[6] /lustre/home/clslzy/bjia/test_pipeline/Map\n";
	print OUT "gzip /tmp/$file[7]\n";
	print OUT "mv /tmp/$file[8] /lustre/home/clslzy/bjia/test_pipeline/Map\n";
	print OUT "rm /tmp/$file[3]\n";
	print OUT "rm /tmp/$file[4]\n";
	close OUT;
	system("sbatch $file[0]");
}
close IN;
