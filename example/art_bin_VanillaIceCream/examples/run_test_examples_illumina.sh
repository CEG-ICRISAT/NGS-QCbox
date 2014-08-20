#!/bin/bash
#illumina test examples
art=../art_illumina
#art=../../bin/MacOS64/art_illumina

# 1) simulation of single-end reads of 35bp with 10X using the built-in combined quality profile
$art -i ./testSeq.fa -o ./single_end_com -l 35 -f 10 -sam
#convert an aln file to a bed file
../aln2bed.pl single_end_com.bed single_end_com.aln

# 2) simulation of single-end reads of 35bp with 10X using the built-in seperated quality profiles for A, C, G, and T 
$art -i ./testSeq.fa -o ./single_end_sep -l 35 -f 10 -sp -sam
#convert an aln file to a bed file
../aln2bed.pl single_end_sep.bed single_end_sep.aln

# 3) simulation of paired-end reads of 50bp with the mean fragment size 500 and standard deviation 10
#    using the built-in combined read quality profiles
$art -i ./testSeq.fa -o ./paired_end_com -l 50 -f 10 -p -m 500 -s 10 -sam
#convert both aln files to a bed file
../aln2bed.pl paired_end_com.bed paired_end_com1.aln paired_end_com2.aln

# 4) simulation of paired-end reads of 50bp with the mean fragment size 500 and standard deviation 10
#   using the built-in seperated quality profiles for A, C, G, and T 
$art -i ./testSeq.fa -o ./paired_end_sep -l 50 -f 10 -p -m 500 -s 10 -sp -sam
#convert both aln files to a bed file
../aln2bed.pl paired_end_sep.bed paired_end_sep1.aln paired_end_sep2.aln

# 5) simulation of mate-pair reads of 50bp with the mean fragment size 2500 and standard deviation 50
#    using the built-in combined read quality profiles
$art -i ./testSeq.fa -o ./matepair_com -l 50 -f 10 -p -m 2500 -s 50 -sam
#convert both aln files to a bed file
../aln2bed.pl matepair_com.bed matepair_com1.aln matepair_com2.aln

# 6) amplicaton read simulation: generate two 50bp single-end reads from 5' end for each amplicon reference
$art -i ./amplicon_reference.fa  -amp  -o ./amp_5_end_com -l 50 -f 2 -sam
#convert both aln files to a bed file
../aln2bed.pl amp_5_end_com.bed  amp_5_end_com.aln

# 7) amplicaton read simulation: generate one 50bp paired-end reads from both ends for each amplicon reference
$art -i ./amplicon_reference.fa  -amp  -o ./amp_pair -p -l 50 -f 1 -sam
#convert both aln files to a bed file
../aln2bed.pl amp_pair.bed amp_pair1.aln amp_pair2.aln

# 8) amplicaton read simulation: generate one 50bp matepair reads from both ends for each amplicon reference
$art -i ./amplicon_reference.fa  -amp  -o ./amp_matepair -mp -l 50 -f 1 -sam
#convert both aln files to a bed file
../aln2bed.pl amp_matepair.bed amp_matepair1.aln amp_matepair2.aln

# 9) generate two identical simulation datasets with a fixed random seed
$art -i ./testSeq.fa -rs 777 -o ./paired_end_com_f1 -l 50 -f 10 -p -m 500 -s 10 -sam
$art -i ./testSeq.fa -rs 777 -o ./paired_end_com_f2 -l 50 -f 10 -p -m 500 -s 10 -sam

# 10) reduce the sequencing error rate to one 10th of the default profile for a paired-end read simulation  
$art -i ./testSeq.fa -qs 10 -qs2 10 -o ./paired_end_com_f1 -l 50 -f 10 -p -m 500 -s 10 -sam

# 11) turn off the masking of 'N' genomic regions  
$art -nf 0 -i ./testSeq.fa -o ./paired_nomask -l 50 -f 10 -p -m 500 -s 10 -sam
