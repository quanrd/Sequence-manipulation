#!/usr/bin/perl -w
# A perlscript written by Joseph Hughes, University of Glasgow
# use this perl script to generate a consensus from a fasta alignment
#run it from within the folder you have the alignments.


use strict;
use Getopt::Long; 
use Bio::SeqIO;
use Bio::AlignIO;


my ($alnfasta,$outcons,$thres,$iupac,$help);
&GetOptions(
	    'in:s'      => \$alnfasta,#aligned fastafile
	    'out:s'   => \$outcons,#printing out the consensus
	    't:s'   => \$thres,#consensus with threshold
	    "iupac"  => \$iupac,  # uses the iupac code
	    "help"  => \$help,  # provides help with usage
           );

if (($help)&&!($help)||!($alnfasta)||!($outcons)){
 print "Usage : Consensus.pl <list of arguments>\n";
 print " -in <txt> - the input alignment in fasta format\n";
 print " -out <txt> - the directory path for the output consensus in fasta format\n";
 print " -t <txt> - an optional threshold parameter as a percentage (0-100), so that positions in the alignment\n";
 print "            with lower percent-identity than the threshold are marked by ? in the consensus\n";
 print " -iupac <txt> - an optional parameter to make a consensus using IUPAC ambiguity codes from DNA and RNA.\n";
 print " -help        - Get this help\n";
 exit();
 }
if ($iupac){  
print "Generating consensus using the IUPAC ambiguity code...\n";
my $filename=$1."_consensus" if $alnfasta=~/(.+)\..+/;
my $in  = Bio::AlignIO->new(-file => "$alnfasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outcons" , '-format' => 'fasta');
my $ali = $in->next_aln();
my $iupac_consensus = $ali->consensus_iupac();   # dna/rna alignments only
my $seq = Bio::Seq->new(-seq => "$iupac_consensus",  
                        -display_id => $filename);

$out->write_seq($seq);
}elsif($thres){
print "Generating consensus using a threshold of $thres percent...\n";
my $filename=$1."_consensus" if $alnfasta=~/(.+)\..+/;
my $in  = Bio::AlignIO->new(-file => "$alnfasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outcons" , '-format' => 'fasta');
my $ali = $in->next_aln();
my $consensus_with_threshold = $ali->consensus_string($thres);
my $seq = Bio::Seq->new(-seq => "$consensus_with_threshold",  
                        -display_id => $filename);
$out->write_seq($seq);
}else{
print "Generating a strict consensus...\n";
my $filename=$1."_consensus" if $alnfasta=~/(.+)\..+/;
my $in  = Bio::AlignIO->new(-file => "$alnfasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outcons" , '-format' => 'fasta');
my $ali = $in->next_aln();
my $cons = $ali->consensus_string();
my $seq = Bio::Seq->new(-seq => "$cons",  
                        -display_id => $filename);
$out->write_seq($seq);
}