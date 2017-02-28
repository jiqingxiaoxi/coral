##delete rRNA reads from paired file and single file
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

if(@ARGV!=3)
{
	print "perl $0 prefix sam_dir original_fq_dir\n";
	exit;
}

if($ARGV[1]=~/\/$/)
{
	$file[0]=$ARGV[1].$ARGV[0].".paired.sam.gz";
	$file[1]=$ARGV[1].$ARGV[0].".paired1.fq";
	$file[2]=$ARGV[1].$ARGV[0].".paired2.fq";
	$file[3]=$ARGV[1].$ARGV[0].".single.sam.gz";
        $file[4]=$ARGV[1].$ARGV[0].".single1.fq";
        $file[5]=$ARGV[1].$ARGV[0].".single2.fq";
}
else
{
	$file[0]=$ARGV[1]."/".$ARGV[0].".paired.sam.gz";
        $file[1]=$ARGV[1]."/".$ARGV[0].".paired1.fq";
        $file[2]=$ARGV[1]."/".$ARGV[0].".paired2.fq";
        $file[3]=$ARGV[1]."/".$ARGV[0].".single.sam.gz";
        $file[4]=$ARGV[1]."/".$ARGV[0].".single1.fq";
        $file[5]=$ARGV[1]."/".$ARGV[0].".single2.fq";
}

if($ARGV[2]=~/\/$/)
{
        $file[6]=$ARGV[2].$ARGV[0].".paired1.fq.gz";
        $file[7]=$ARGV[2].$ARGV[0].".paired2.fq.gz";
        $file[8]=$ARGV[2].$ARGV[0].".single1.fq.gz";
        $file[9]=$ARGV[2].$ARGV[0].".single2.fq.gz";
}
else
{
        $file[6]=$ARGV[2]."/".$ARGV[0].".paired1.fq.gz";
        $file[7]=$ARGV[2]."/".$ARGV[0].".paired2.fq.gz";
        $file[8]=$ARGV[2]."/".$ARGV[0].".single1.fq.gz";
        $file[9]=$ARGV[2]."/".$ARGV[0].".single2.fq.gz";
}

##hand paired
open(SAM,"gzip -dc $file[0] |") or die "can't open $file[0]\n";
open(INONE,"gzip -dc $file[6] |") or die "can't open $file[6]\n";
open(INTWO,"gzip -dc $file[7] |") or die "can't open $file[7]\n";
open(OUTONE,">$file[1]") or die "can't create $file[1]\n";
open(OUTTWO,">$file[2]") or die "can't create $file[2]\n";

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
open(SAM,"gzip -dc $file[3] |") or die "can't open $file[3]\n";
open(INONE,"gzip -dc $file[8] |") or die "can't open $file[8]\n";
open(OUTONE,">$file[4]") or die "can't create $file[4]\n";

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
close INONE;
close OUTONE;

##single2
open(INTWO,"gzip -dc $file[9] |") or die "can't open $file[9]\n";
open(OUTTWO,">$file[5]") or die "can't create $file[5]\n";
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
