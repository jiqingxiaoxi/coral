##take reads from SRR2005856 for simulate bacteria mRNA reads
use strict; use warnings;

my $line;
my $i;
my $j;
my $k;
my @file;
my @temp;

if(@ARGV!=5)
{
	print "perl $0 seed input_file1 input_file2 output_prefix total_reads\n";
	exit;
}

srand($ARGV[0]);
for($k=1;$k<=3;$k++)
{
	$file[1]=$ARGV[3]."_C_".$k."_1.fa";
	$file[2]=$ARGV[3]."_C_".$k."_2.fa";
	open(ONE,">$file[1]") or die "Can't create $file[1]\n";
	open(TWO,">$file[2]") or die "Can't create $file[2]\n";
	
	$i=0;
	while($i<$ARGV[4])
	{
		open(FIRST,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
		open(SECOND,"<$ARGV[2]") or die "Can't open $ARGV[2]\n";
		$j=0;
		while(<FIRST>)
		{
			$j++;
			if($j%4!=2)
			{
				next;
			}
			$line=$_;
			$temp[0]=<SECOND>;
			$temp[1]=<SECOND>;
			$temp[2]=<SECOND>;
			$temp[3]=<SECOND>;
			if(rand()>0.1)
			{
				next;
			}
			print ONE "\>bacteria\_$i\/1\n$line";
			print TWO "\>bacteria\_$i\/2\n$temp[1]";
			$i++;
			if($i==$ARGV[4])
			{
				last;
			}
		}
		close FIRST;
		close SECOND;
	}
	close ONE;
	close TWO;
}

for($k=1;$k<=3;$k++)
{
        $file[1]=$ARGV[3]."_H_".$k."_1.fa";
        $file[2]=$ARGV[3]."_H_".$k."_2.fa";
        open(ONE,">$file[1]") or die "Can't create $file[1]\n";
        open(TWO,">$file[2]") or die "Can't create $file[2]\n";
        
        $i=0;
        while($i<$ARGV[4])
        {
                open(FIRST,"<$ARGV[1]") or die "Can't open $ARGV[1]\n";
                open(SECOND,"<$ARGV[2]") or die "Can't open $ARGV[2]\n";
                $j=0;
                while(<FIRST>)
                {
                        $j++;
                        if($j%4!=2)
                        {
                                next;
                        }
                        $line=$_;
                        $temp[0]=<SECOND>;
                        $temp[1]=<SECOND>;
                        $temp[2]=<SECOND>;
                        $temp[3]=<SECOND>;
                        if(rand()>0.1)
                        {
                                next;
                        }
                        print ONE "\>bacteria\_$i\/1\n$line";
                        print TWO "\>bacteria\_$i\/2\n$temp[1]";
                        $i++;
			if($i==$ARGV[4])
			{
				last;
			}
                }
                close FIRST;
                close SECOND;
        }
        close ONE;
        close TWO;
}
