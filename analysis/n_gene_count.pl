#!/usr/bin/perl
use warnings;
use strict;


#2016/09/19 Vivian Yean z3414771
#outputs number of genes with Ns for each isolate

my $iso = "dataList";
open (my $fh1, "<", $iso) or die "Cannot open $iso: $!";
# stores STM number, start and end of each gene in separate arrays
# index to refer to the same gene
my @isolates;
while (my $line1 = <$fh1>){
   chomp $line1;
   push(@isolates, $line1);
}
close $fh1;

my $genes = "core.bed";
my $dir = "gene_snps/CORE_SNPS";
open (my $fh2, "<", $genes) or die "Cannot open $genes: $!";
# stores STM number, start and end of each gene in separate arrays
# index to refer to the same gene
my @stm;
while (my $line1 = <$fh2>){
   if ($line1 =~ /gene/){
      chomp $line1;
      my @line2 = split /\t/, $line1;
      push(@stm, $line2[3]);
   }
}
close $fh2;

#possible issues here
my @count;
my $in = 0;
foreach $a (@isolates){
   print "Running $a...\n";
   $count[0][$in] = $a;
   my $n = 0;
   my $atcg = 2;
   foreach $b (@stm){
      open (my $fh, "<", "$dir/$b") or die "Cannot open $b: $!";
      while (my $line = <$fh>){
         if ($line =~ /^$a/){
            chomp $line;
            if ($line =~ ","){
               my ($lol, $bases) = split(/,/, $line, 2);
#              print "$b: $lol :$bases\n";
               if ($bases =~ /\d/){
                  $n++;
               } else {
                  $atcg++;
               }
            } else {
               $atcg++;
            }
#           print "$n - $atcg\n";
         }
      }
      close $fh;
   }
   $count[1][$in] = $n;
   $count[2][$in] = $atcg;
   $in++;
}
print "Isolate\tNs\tATCG\n";
#=pod
#print arrays
my $i = 0;
for my $j (0 .. $#{$count[$i]}){
   for my $i (0 .. $#count){
      print "$count[$i][$j]\t";
   }
   print "\n";
}
#=cut
