#combine coral, symbiodium and bacteria mRNA reads 
use strict; use warnings;

my $line;
my $i;
my $j;
my @file;

if(@ARGV!=3)
{
	print "perl $0 coverage_coral coverage_symbiodinium  batch(1 or 2)\n";
	exit;
}

##control
for($j=1;$j<=3;$j++)
{
	$file[0]=$ARGV[2]."_".$ARGV[1]."_C_".$j."_1.fa";
	$file[1]=$ARGV[2]."_".$ARGV[1]."_C_".$j."_2.fa";
	open(ONE,">$file[0]") or die "Can't create $file[0]\n";
	open(TWO,">$file[1]") or die "Can't create $file[1]\n";
##coral
	$file[2]=$ARGV[2]."_coral_".$ARGV[0]."_C_".$j."_1.fa";
	$file[3]=$ARGV[2]."_coral_".$ARGV[0]."_C_".$j."_2.fa";
	$i=0;
	open(FIRST,"<$file[2]") or die "Can't open $file[2]\n";
	open(SECOND,"<$file[3]") or die "Can't open $file[3]\n";
	while(<FIRST>)
	{
		$line=$_;
		if($line=~/^\>/)
		{
			print ONE "\>coral\_$i\/1\n";
			print TWO "\>coral\_$i\/2\n";
			$i++;
		}
		else
		{
			print ONE $line;
			$line=<SECOND>;
			$line=<SECOND>;
			print TWO $line;
		}
	}
	close FIRST;
	close SECOND;
##symbiodinium
	$file[2]=$ARGV[2]."_symbiodinium_".$ARGV[1]."_C_".$j."_1.fa";
	$file[3]=$ARGV[2]."_symbiodinium_".$ARGV[1]."_C_".$j."_2.fa";
        $i=0;
        open(FIRST,"<$file[2]") or die "Can't open $file[2]\n";
	open(SECOND,"<$file[3]") or die "Can't open $file[3]\n";
        while(<FIRST>)
        {
                $line=$_;
                if($line=~/^\>/)
                {
                        print ONE "\>symbiodinium\_$i\/1\n";
			print TWO "\>symbiodinium\_$i\/2\n";
			$i++;
                }
                else
                {
                        print ONE $line;
			$line=<SECOND>;
			$line=<SECOND>;
			print TWO $line; 
                }
        }
        close FIRST;
	close SECOND;
##bacteria
	if($ARGV[1]==10)
	{
		$file[2]=$ARGV[2]."_bacteria_40_C_".$j."_1.fa";
		$file[3]=$ARGV[2]."_bacteria_40_C_".$j."_2.fa";
	}
	else
	{
		$file[2]=$ARGV[2]."_bacteria_30_C_".$j."_1.fa";
		$file[3]=$ARGV[2]."_bacteria_30_C_".$j."_2.fa";
	}
	open(FIRST,"<$file[2]") or die "Can't open $file[2]\n";
	open(SECOND,"<$file[3]") or die "Can't open $file[3]\n";
        while(<FIRST>)
        {
                $line=$_;
		print ONE $line;
		$line=<SECOND>;
		print TWO $line;
	}
	close ONE;
	close TWO;
	close FIRST;
	close SECOND;
}

for($j=1;$j<=3;$j++)
{
        $file[0]=$ARGV[2]."_".$ARGV[1]."_H_".$j."_1.fa";
        $file[1]=$ARGV[2]."_".$ARGV[1]."_H_".$j."_2.fa";
        open(ONE,">$file[0]") or die "Can't create $file[0]\n";
        open(TWO,">$file[1]") or die "Can't create $file[1]\n";
##coral
        $file[2]=$ARGV[2]."_coral_".$ARGV[0]."_H_".$j."_1.fa";
        $file[3]=$ARGV[2]."_coral_".$ARGV[0]."_H_".$j."_2.fa";
        $i=0;
        open(FIRST,"<$file[2]") or die "Can't open $file[2]\n";
        open(SECOND,"<$file[3]") or die "Can't open $file[3]\n";
        while(<FIRST>)
        {
                $line=$_;
                if($line=~/^\>/)
                {
                        print ONE "\>coral\_$i\/1\n";
                        print TWO "\>coral\_$i\/2\n";
			$i++;
                }
                else
                {
                        print ONE $line;
                        $line=<SECOND>;
                        $line=<SECOND>;
                        print TWO $line;
                }
        }
        close FIRST;
        close SECOND;
##symbiodinium
        $file[2]=$ARGV[2]."_symbiodinium_".$ARGV[1]."_H_".$j."_1.fa";
        $file[3]=$ARGV[2]."_symbiodinium_".$ARGV[1]."_H_".$j."_2.fa";
        $i=0;
        open(FIRST,"<$file[2]") or die "Can't open $file[2]\n";
        open(SECOND,"<$file[3]") or die "Can't open $file[3]\n";
        while(<FIRST>)
        {
                $line=$_;
                if($line=~/^\>/)
                {
                        print ONE "\>symbiodinium\_$i\/1\n";
                        print TWO "\>symbiodinium\_$i\/2\n";
			$i++;
                }
                else
                {
                        print ONE $line;
                        $line=<SECOND>;
                        $line=<SECOND>;
                        print TWO $line; 
                }
        }
        close FIRST;
        close SECOND;
##bacteria
        if($ARGV[1]==10)
        {
                $file[2]=$ARGV[2]."_bacteria_40_H_".$j."_1.fa";
                $file[3]=$ARGV[2]."_bacteria_40_H_".$j."_2.fa";
        }
        else
        {
                $file[2]=$ARGV[2]."_bacteria_30_H_".$j."_1.fa";
                $file[3]=$ARGV[2]."_bacteria_30_H_".$j."_2.fa";
        }
        open(FIRST,"<$file[2]") or die "Can't open $file[2]\n";
        open(SECOND,"<$file[3]") or die "Can't open $file[3]\n";
        while(<FIRST>)
        {
                $line=$_;
                print ONE $line;
                $line=<SECOND>;
                print TWO $line;
        }
        close ONE;
        close TWO;
        close FIRST;
        close SECOND;
}
