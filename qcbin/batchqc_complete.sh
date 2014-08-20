#!/bin/bash

echo -e "Sample\tRead pairs in millions\tRead pairs after QC\t% Read pairs retained\t% Read Aligned\tgenome coverage at >= 1x\tgenome coverage at >= 2x\tgenome coverage at >= 5x\tgenome coverage at >= 10x\tgenome coverage at >= 15x\tBases not covered\tAverage depth\tInsert Size Range" > QC_final_complete.txt
COUNTER=0
line=$1
name=$(echo $line | sed 's/:.*//g')
min_ins=$(echo $line | sed 's/:/\t/g'| awk '{print $2}')
max_ins=$(echo $line | sed 's/:/\t/g'| awk '{print $3}')

#if [ ! -d "$name" ]; then
#    echo "Folder: $name not found!"
#    exit 1
#fi

mkdir $name\_QC_complete
cd $name\_QC_complete
cp ../$name*.gz .
ln -s `ls | grep '.*R1.*.fastq.gz$'` Read1.gz
ln -s `ls | grep '.*R2.*.fastq.gz$'` Read2.gz
#sed -i "s/\(MAX_INSERT_SIZE=\).*/\\1$max_ins/" $QCBIN/complete_qc.bpipe
#sed -i "s/\(MIN_INSERT_SIZE=\).*/\\1$min_ins/" $QCBIN/complete_qc.bpipe
$QCBIN/bpipe/bin/bpipe run $QCBIN/complete_qc.bpipe > log
rea1=`grep -n '^File.*Read1.gz$' log | sed 's/:/ /' | awk '{print $1}'`
rea11=`expr $rea1 + 15`
rea2=`grep -n '^File.*Read2.gz$' log | sed 's/:/ /' | awk '{print $1}'`
rea21=`expr $rea2 + 15`
afrea1=`grep -n '^File.*Read1.gz.qtrim' log | sed 's/:/ /' | awk '{print $1}'`
afrea11=`expr $afrea1 + 15`
afrea2=`grep -n '^File.*Read1.gz.2.qtrim' log | sed 's/:/ /' | awk '{print $1}'`
afrea21=`expr $afrea2 + 15`
afrea3=`grep -n '^File.*Read1.gz.3.qtrim' log | sed 's/:/ /' | awk '{print $1}'`
afrea31=`expr $afrea3 + 15`
align=`grep 'overall alignment rate' log | awk '{print $1}'`
g1=`grep 'genome coverage at >= 1x' log | sed 's/.*:/:/' | awk '{print $2}'`
g2=`grep 'genome coverage at >=2 x' log | sed 's/.*:/:/' | awk '{print $2}'`
g5=`grep 'genome coverage at >= 5x' log | sed 's/.*://' | awk '{print $1}'`
g10=`grep 'genome coverage at >= 10x' log | sed 's/.*:/:/' | awk '{print $2}'`
g15=`grep 'genome coverage at >= 15x' log | sed 's/.*:/:/' | awk '{print $2}'`
gbsn=`grep 'bases not covered' log | sed 's/.*:/:/' | awk '{print $2}'`
avg_dep=`grep 'Avg depth' log | sed 's/.*:/:/' | awk '{print $2}'`
head -$rea11 log | tail -15 | sed 's/\(.*\):.*/\1/' > filewa
head -$rea11 log | tail -15 | sed 's/^/\t/' | sed 's/.*:\(.*\)/\1/' > file1
head -$rea21 log | tail -15 | sed 's/^/\t/' | sed 's/.*:\(.*\)/\1/' > file2
head -$afrea11 log | tail -15 | sed 's/^/\t/' | sed 's/.*:\(.*\)/\1/' > file3
head -$afrea21 log | tail -15 | sed 's/^/\t/' | sed 's/.*:\(.*\)/\1/' > file4
head -$afrea31 log | tail -15 | sed 's/^/\t/' | sed 's/.*:\(.*\)/\1/' > file5
paste filewa file1 file2 file3 file4 file5 > file
echo -e "$name\tRead1\tRead2\tRead1 after QC\tRead2 after QC\tSingleton" >> detailed_qc_complete.txt
cat file >> detailed_qc_complete.txt
cp detailed_qc_complete.txt ../$name\_detailed_qc_complete.txt
rm file*
p1=`head -3 detailed_qc_complete.txt | tail -1 | awk '{print $3}'`
p2=`head -3 detailed_qc_complete.txt | tail -1 | awk '{print $5}'`
COUNTER=$(expr $COUNTER '+' 1)
#echo -e "$COUNTER \n"
rm ./*.fastq.gz ./Read*.gz
gzip Read1.gz.qtrim 
gzip Read1.gz.2.qtrim 
gzip Read1.gz.3.qtrim 
cic=`echo "$p2 * 100 / $p1 " | bc -l`
p3=`echo "scale=2;$cic * 10/10 " | bc -l`
ne1=`echo "scale=3;$p1 / 1000000 " | bc -l`
ne2=`echo "scale=3;$p2 / 1000000 " | bc -l`
echo -e "$name\t$ne1\t$ne2\t$p3\t$align\t$g1\t$g2\t$g5\t$g10\t$g15\t$gbsn\t$avg_dep\t$min_ins-$max_ins" >> ../QC_final_complete.txt
cd ../
