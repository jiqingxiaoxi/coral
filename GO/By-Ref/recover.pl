use strict; use warnings;

my $line;
my @array;
my %up;
my %down;
my $file;
my %fc_up;
my %fc_down;
my %go;
my $flag;
my %name;
my %space;
my @value;
my %hash;
my $i;
my $temp;

if(@ARGV!=3)
{
	print "perl $0 handle  recovery  output_prefix\n";
	exit;
}

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
	if($array[2]==1)
	{
		next;
	}
	($temp)=$array[1]=~/\"(.+)\"/;
	if($array[2]>1)
	{
		$up{$temp}=$array[2];
	}
	else
	{
		$down{$temp}=$array[2];
	}
}
close IN;

open(IN,"<$ARGV[1]") or die "can't open $ARGV[1]\n";
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
        if($array[2]==1)
        {
                next;
        }
        ($temp)=$array[1]=~/\"(.+)\"/;
        if($array[2]>1)
        {
		if(exists $down{$temp})
		{
                	$fc_down{$temp}=$array[2];
			$hash{$temp}=1;
		}
        }
        else
        {
		if(exists $up{$temp})
		{
                	$fc_up{$temp}=$array[2];
			$hash{$temp}=1;
		}
        }
}
close IN;

open(IN,"</lustre/home/clslzy/bjia/By-Ref/Ad/GO/gene2GO.txt") or die "can't open gene2GO.txt\n";
while(<IN>)
{
        chomp;
        $line=$_;
        @array=split("\t",$line);
        if(! (exists $hash{$array[0]}))
        {
                next;
        }
        $hash{$array[0]}=$array[1];
        
        @value=split(", ",$array[1]);
        for($i=0;$i<@value;$i++)
        {
                $go{$value[$i]}=1;
        }
}
close IN;

$flag=0;
open(IN,"</lustre/home/clslzy/bjia/Annotation/GO/db/go.obo") or die "Can't open go.obo\n";
while(<IN>)
{
        chomp;
        $line=$_;
        if($line=~/^id: GO/)
        {
                ($temp)=$line=~/id: (GO:\d+)$/;
                if(exists $go{$temp})
                {
                        $flag=1;
                }
                else
                {
                        $flag=0;
                }
                next;
        }

        if($flag==0)
        {
                next;
        }
        if($line=~/^name:/)
        {
                ($name{$temp})=$line=~/name: (.+)$/;
                next;
        }

        if($line=~/^namespace:/)
        {
                ($space{$temp})=$line=~/namespace: (.+)$/;
                $flag=0;
        }
}
close IN;

$file=$ARGV[2]."-up.txt";
open(OUT,">$file") or die "can't create $file\n";
print OUT "Gene\tFC_handle\tFC_recovery\tGO\tNamespace\tName\n";
foreach $temp (keys %fc_up)
{
        printf(OUT "%s\t%0.2f\t%0.2f\t",$temp,$up{$temp},$fc_up{$temp});
        if($hash{$temp} eq "1")
        {
                print OUT "No GO\n";
                next;
        }
        @value=split(", ",$hash{$temp});
        for($i=0;$i<@value;$i++)
        {
                if($i==0)
                {
                        print OUT "$value[$i]\t$space{$value[$i]}\t$name{$value[$i]}\n";
                }
                else
                {
                        print OUT "\t\t\t$value[$i]\t$space{$value[$i]}\t$name{$value[$i]}\n";
                }
        }
}
close OUT;

$file=$ARGV[2]."-down.txt";
open(OUT,">$file") or die "can't create $file\n";
print OUT "Gene\tFC_handle\tFC_recovery\tGO\tNamespace\tName\n";
foreach $temp (keys %fc_down)
{
        printf(OUT "%s\t%0.2f\t%0.2f\t",$temp,$down{$temp},$fc_down{$temp});
        if($hash{$temp} eq "1")
        {
                print OUT "No GO\n";
                next;           
        }
        @value=split(", ",$hash{$temp});
        for($i=0;$i<@value;$i++)
        {
                if($i==0)
                {
                        print OUT "$value[$i]\t$space{$value[$i]}\t$name{$value[$i]}\n";
                }        
                else
                {
                        print OUT "\t\t\t$value[$i]\t$space{$value[$i]}\t$name{$value[$i]}\n";
                }
        }
}
close OUT;
