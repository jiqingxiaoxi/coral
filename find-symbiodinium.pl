##delete symbiodnium reads from paired file and single file
use strict; use warnings;

my $line;
my @temp;
my $i;
my $flag;
my $before;
my $stop;
my @store1;
my @store2;
my @value;
my @array;
my @file;
my @db;
my $j;

if(@ARGV!=3)
{
	print "perl $0 prefix input_dir output_dir\n";
	exit;
}

$db[1]="db-Sk";
$db[2]="db-Sm";
$db[3]="db-symbiodinium-est";
$db[4]="db-symbiodinium-gss";
$db[0]="db-symbiodinium-nucleotide";

$file[10]=time();
$file[10]="/tmp/".$file[10]."-".$ARGV[0];
system("mkdir $file[10]");

if($ARGV[1]=~/\/$/)
{
	$file[1]=$ARGV[1].$ARGV[0].".paired1.fq.gz";
	$file[2]=$ARGV[1].$ARGV[0].".paired2.fq.gz";
        $file[4]=$ARGV[1].$ARGV[0].".single1.fq.gz";
        $file[5]=$ARGV[1].$ARGV[0].".single2.fq.gz";
}
else
{
        $file[1]=$ARGV[1]."/".$ARGV[0].".paired1.fq.gz";
        $file[2]=$ARGV[1]."/".$ARGV[0].".paired2.fq.gz";
        $file[4]=$ARGV[1]."/".$ARGV[0].".single1.fq.gz";
        $file[5]=$ARGV[1]."/".$ARGV[0].".single2.fq.gz";
}

for($j=0;$j<@db;$j++)
{
	$file[0]=$file[10]."/paired.sam";
	$file[3]=$file[10]."/single.sam";
	system("/lustre/home/clslzy/bin/bowtie2/bowtie2 -p 8 -N 1 --no-unal --reorder --no-hd -D 50 --local -x /lustre/home/clslzy/bjia/Database/db-bowtie2/$db[$j] -1 $file[1] -2 $file[2] -S $file[0]");
	system("/lustre/home/clslzy/bin/bowtie2/bowtie2 -p 8 -N 1 --no-unal --reorder --no-hd -D 50 --local -x /lustre/home/clslzy/bjia/Database/db-bowtie2/$db[$j] -U $file[4],$file[5] -S $file[3]");

	$file[6]=$file[10]."/paired1.fq";
	$file[7]=$file[10]."/paired2.fq";
	$file[8]=$file[10]."/single1.fq";
	$file[9]=$file[10]."/single2.fq";
##hand paired
	open(SAM,"<$file[0]") or die "can't open $file[0]\n";
	if($file[1]=~/gz$/)
	{
		open(INONE,"gzip -dc $file[1] |") or die "can't open $file[1]\n";
	}
	else
	{
		open(INONE,"<$file[1]") or die "can't open $file[1]\n";
	}
	if($file[2]=~/gz$/)
	{
		open(INTWO,"gzip -dc $file[2] |") or die "can't open $file[2]\n";
	}
	else
	{
		open(INTWO,"<$file[2]") or die "can't open $file[2]\n";
	}
	open(OUTONE,">$file[6]") or die "can't create $file[6]\n";
	open(OUTTWO,">$file[7]") or die "can't create $file[7]\n";

	for($i=0;$i<4;$i++)
	{
		$store1[$i]=<INONE>;
		chomp $store1[$i];
		$store2[$i]=<INTWO>;
		chomp $store2[$i];
	}
	($temp[0])=$store1[0]=~/^\@(.+) \d/;
	($temp[1])=$store2[0]=~/^\@(.+) \d/;

	$before="";
	$stop=0;
	while(<SAM>)
	{
		$line=$_;
		@array=split("\t",$line);
		if(@array<10)
		{
			next;
		}
		if($before eq $array[0])
		{
			next;
		}
	        $value[0]=length($array[9]);
	        if($array[5]=~/^\d+[SH]/)
	        {
	        	($value[1])=$array[5]=~/^(\d+)[SH]/;
	        	$value[0]-=$value[1];
	        }
	        if($array[5]=~/\d+[SH]$/)
	        {
	        	($value[1])=$array[5]=~/[A-Z](\d+)[SH]$/;
	        	$value[0]-=$value[1];
	        }
	        ($value[1])=$line=~/NM\:i\:(\d+)/;
	        $value[0]-=$value[1];
		if($value[0]<30)
		{
			next;
		}
		$before=$array[0];
		$flag=0;
		while($flag==0)
		{
			if($array[0] ne $temp[0])
			{
				print OUTONE "$store1[0]\n$store1[1]\n$store1[2]\n$store1[3]\n";
			}
			else
			{
				$flag=1;
			}
			if(eof(INONE))
			{
				$stop=1;
				last;
			}
			for($i=0;$i<4;$i++)
			{
				$store1[$i]=<INONE>;
				chomp $store1[$i];
			}
			($temp[0])=$store1[0]=~/^\@(.+) \d/;
		}
	
		$flag=0;
		while($flag==0)
		{
			if($array[0] ne $temp[1])
			{
				print OUTTWO "$store2[0]\n$store2[1]\n$store2[2]\n$store2[3]\n";
			}
			else
			{
				$flag=1;
			}
			if(eof(INTWO))
			{
				last;
			}
			for($i=0;$i<4;$i++)
			{
	                       	$store2[$i]=<INTWO>;
				chomp $store2[$i];
			}
			($temp[1])=$store2[0]=~/^\@(.+) \d/;
		}
	}
	close SAM;
	if($stop==0)
	{
		print OUTONE "$store1[0]\n$store1[1]\n$store1[2]\n$store1[3]\n";
		while(<INONE>)
		{
			$line=$_;
			print OUTONE $line;
		}

		print OUTTWO "$store2[0]\n$store2[1]\n$store2[2]\n$store2[3]\n";
		while(<INTWO>)
		{
			$line=$_;
			print OUTTWO $line;
		}
	}
	close INONE;
	close INTWO;
	close OUTONE;
	close OUTTWO;

	##hand single
	##single1
	open(SAM,"<$file[3]") or die "can't open $file[3]\n";
	if($file[4]=~/gz$/)
	{
		open(INONE,"gzip -dc $file[4] |") or die "can't open $file[4]\n";
	}
	else
	{
		open(INONE,"<$file[4]") or die "can't open $file[4]\n";
	}
	open(OUTONE,">$file[8]") or die "can't create $file[8]\n";

	for($i=0;$i<4;$i++)
	{
	        $store1[$i]=<INONE>;
	        chomp $store1[$i];
	}
	($temp[0])=$store1[0]=~/^\@(.+) \d/;

	$before="";
	$stop=0;
	while(<SAM>)
	{
	        $line=$_;
	        @array=split("\t",$line);
	        if(@array<10)
	        {
	                next;
	        }
	        if($before eq $array[0])
	        {
	                next;
	        }
	        $value[0]=length($array[9]);
	        if($array[5]=~/^\d+[SH]/)
	        {
	                ($value[1])=$array[5]=~/^(\d+)[SH]/;
	                $value[0]-=$value[1];
	        }
	        if($array[5]=~/\d+[SH]$/)
	        {
	                ($value[1])=$array[5]=~/[A-Z](\d+)[SH]$/;
	                $value[0]-=$value[1];
	        }
	        ($value[1])=$line=~/NM\:i\:(\d+)/;
	        $value[0]-=$value[1];
	        if($value[0]<30)
	        {
	                next;
	        }
	        $before=$array[0];
	        $flag=0;
	        while($flag==0)
	        {
	                if($array[0] ne $temp[0])
	                {
	                        print OUTONE "$store1[0]\n$store1[1]\n$store1[2]\n$store1[3]\n";
	                }
	                else
	                {
	                        $flag=1;
	                }
	                if(eof(INONE))
	                {
	                        $stop=1;
	                        last;
	                }
	                for($i=0;$i<4;$i++)
	                {
	                        $store1[$i]=<INONE>;
	                        chomp $store1[$i];
	                }
	                ($temp[0])=$store1[0]=~/^\@(.+) \d/;
	        }
	        if($stop==1)
		{
			last;
		}
	}
	if(! eof(INONE))
        {
                print OUTONE "$store1[0]\n$store1[1]\n$store1[2]\n$store1[3]\n";
                while(<INONE>)
                {
                        $line=$_;
                        print OUTONE $line;
                }
        }
	close INONE;
	close OUTONE;

	##single2
	if($file[5]=~/gz/)
	{
		open(INTWO,"gzip -dc $file[5] |") or die "can't open $file[5]\n";
	}
	else
	{
		open(INTWO,"<$file[5]") or die "can't open $file[5]\n";
	}
	open(OUTTWO,">$file[9]") or die "can't create $file[9]\n";
	for($i=0;$i<4;$i++)
	{
		$store2[$i]=<INTWO>;
		chomp $store2[$i];
	}
	($temp[1])=$store2[0]=~/^\@(.+) \d/;
	
	while($flag==0)
	{
		if($array[0] ne $temp[1])
		{
	        	print OUTTWO "$store2[0]\n$store2[1]\n$store2[2]\n$store2[3]\n";
		}
	        else
	        {
	        	$flag=1;
	        }
	        if(eof(INTWO))
	        {
	        	last;
	        }
	        for($i=0;$i<4;$i++)
	        {
	        	$store2[$i]=<INTWO>;
	        	chomp $store2[$i];
	        }
	        ($temp[1])=$store2[0]=~/^\@(.+) \d/;
	}

	$before="";
	$stop=0;
	while(<SAM>)
	{
	        $line=$_;
	        @array=split("\t",$line);
	        if(@array<10)
	        {
	                next;
	        }
	        if($before eq $array[0])
	        {
	                next;
	        }
	        $value[0]=length($array[9]);
	        if($array[5]=~/^\d+[SH]/)
	        {
	                ($value[1])=$array[5]=~/^(\d+)[SH]/;
	                $value[0]-=$value[1];
	        }
	        if($array[5]=~/\d+[SH]$/)
	        {
	                ($value[1])=$array[5]=~/[A-Z](\d+)[SH]$/;
	                $value[0]-=$value[1];
	        }
	        ($value[1])=$line=~/NM\:i\:(\d+)/;
	        $value[0]-=$value[1];
	        if($value[0]<30)
	        {
	                next;
	        }
	        $before=$array[0];
	        $flag=0;
	        while($flag==0)
	        {
	                if($array[0] ne $temp[1])
	                {
	                        print OUTTWO "$store2[0]\n$store2[1]\n$store2[2]\n$store2[3]\n";
	                }
	                else
	                {
	                        $flag=1;
	                }
	                if(eof(INTWO))
	                {
				$stop=1;
	                        last;
	                }
	                for($i=0;$i<4;$i++)
	                {
	                        $store2[$i]=<INTWO>;
	                        chomp $store2[$i];
	                }
	                ($temp[1])=$store2[0]=~/^\@(.+) \d/;
	        }
	        if($stop==1)
	        {
	                last;	
	        }
	}
	close SAM;

	if($stop!=1)
	{
		print OUTTWO "$store2[0]\n$store2[1]\n$store2[2]\n$store2[3]\n";
		while(<INTWO>)
		{
			$line=$_;
			print OUTTWO $line;
		}
	}
	close INTWO;
	close OUTTWO;

	$file[1]=$file[10]."/".$ARGV[0].".paired1.fq";
	system("mv $file[6] $file[1]");
	$file[2]=$file[10]."/".$ARGV[0].".paired2.fq";
	system("mv $file[7] $file[2]");

	$file[4]=$file[10]."/".$ARGV[0].".single1.fq";
	system("mv $file[8] $file[4]");
	$file[5]=$file[10]."/".$ARGV[0].".single2.fq";
	system("mv $file[9] $file[5]");
}

if($ARGV[2]=~/\/$/)
{
	$file[6]=$ARGV[2].$ARGV[0].".paired1.fq";
	$file[7]=$ARGV[2].$ARGV[0].".paired2.fq";
	$file[8]=$ARGV[2].$ARGV[0].".single1.fq";
        $file[9]=$ARGV[2].$ARGV[0].".single2.fq";
}
else
{
	$file[6]=$ARGV[2]."/".$ARGV[0].".paired1.fq";
        $file[7]=$ARGV[2]."/".$ARGV[0].".paired2.fq";
        $file[8]=$ARGV[2]."/".$ARGV[0].".single1.fq";
        $file[9]=$ARGV[2]."/".$ARGV[0].".single2.fq";
}
system("mv $file[1] $file[6]");
system("mv $file[2] $file[7]");
system("mv $file[4] $file[8]");
system("mv $file[5] $file[9]");
system("rm -r $file[10]");

