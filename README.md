# NGS-QCbox

A Parallel, Automated and Rapid Quality Control Pipeline for analysing the big data of NGS.

A QC tool box for Next generation sequencing data of Illumina HiSeq and MiSeq

Authors: KAVS Krishna Mohan, Aamir W Khan, Dadakhalandar Doddamani and Rajeev K Varshney
email: k.krishnamohan@cgiar.org, a.khan@cgiar.org, d.doddamani@cgiar.org, r.k.varshney@cgiar.org
institution: ICRISAT, Patancheru, India

NGS-QCbox is a commandline pipeline that enables NGS quality control to be performed with ease. The outputs include base and read level statistics, genome coverage and variant infomation.

## REQUIREMENTS
Java 1.7 (preferrably 1.7.0_11)
bash >= v4(assuming that you are working on Linux environment)
Python >= v2.6
(These are mostly  available on Linux platforms by default)

## INSTALL
```
git clone https://github.com/CEG-ICRISAT/NGS-QCbox.git
```
OR 

Download zip file from https://github.com/CEG-ICRISAT/NGS-QCbox/archive/master.zip
```
$ unzip  NGS-QCBox-master.zip
```
 and then 
```
$ cd NGS-QCbox
$ source sourcme.ngsqcbox (This sets $QCBIN shell variable)
```
Now navigate to the workspace containing data, data folder, (I assume the fastq files to be QCed are  in a dir called samples)
prepare a file called 'samples.txt' with the format:
```
sample1:500:700
sample2:550:800
sample3:300:600
sample4:450:760
```
This is sample id, min insert size and max insert size delimited by colon. Make sure you have the 'samples.txt' file in the current working dir.
and then run
```
$ $QCBIN/NGS-QCbox-v0.1.py 
An example session:
        NGSQCBox toolkit v 0.1
        ~~~~~~~~~~~~~~~~~~~~~~
        1) Quick mode QC
        2) Complete mode QC
        Enter a choice:
        2
Enter reference fasta full path: <path to reference file>
Enter the reference genome size: <enter reference genome size>
Enter bowtie2 index full path: <provide bowtie index path>
Enter data folder path : <provide data folder containing samples in *.fastq.gz format>
Number of processors to use :  <provide number of processors to use>
```
Quick mode run is  similar, just choose option 1, at  menu (see above).
NGSQCbox-v0.1.py, the Python script, is the main script that parallelizes the tasks for processing multiple samples generated from hiseq or miseq in batches.

## PREREQUISITES
Remember to set the path for reference (fasta format), bowtie2-index  and genome size in the complete_qc.bpipe / quick_qc.bpipe in qcbin dir.
Insert sizes need to be included in a formatted text file called ‘samples.txt’. 

## ASSUMPTIONS
-The input fastq files are gzip compressed format (*.fastq.gz).
-The samples to be analyzed are in a folder  - this is data path
-The quality range is assumed to be in phred+33 format.

## DATASETS USED FOR TESTING
The simulated paired end read datasets used for testing this software are the following public web-links
```
http://de.iplantcollaborative.org/dl/d/B1B7C2BB-0252-4B96-AA3C-2F28DA42A277/A_R1.fastq.gz
http://de.iplantcollaborative.org/dl/d/655AE8D6-B88F-4612-A330-1EE747ECB1FF/A_R2.fastq.gz
http://de.iplantcollaborative.org/dl/d/F88E2188-CF0D-4451-B56E-5FDE16E39797/B_R1.fastq.gz
http://de.iplantcollaborative.org/dl/d/A59BC8E4-991C-4A41-8CE4-B79CC7D938BB/B_R2.fastq.gz
```
## RESULTS
Quick mode run generates a folder by name [sample]_QC_quick and complete mode generates [sample]_QC_complete in the data path folder containing samples.

-The pipeline generates two files namely, "detailed_qc_[complete|quick].txt"  and "QC_final_[complete|quick].txt"; depending on the quick/complete mode of the pipeline run.
1. detailed_QC_[quick|complete].txt contains information on counts of reads, bases, read length range, counts of A/T/G/C/N, percentage of GC content and quality range

2. QC_final_[quick|complete].txt summarizes the above information for all the samples. It contains in addition to  the  reads generated and retained after quality trimming, pecentage of alignment, genome coverage at 1X to 15X and mean read depth observed from alignment.

## DISCLAIMER
-This tool has been tested on Linux platform only (ubuntu 12.10 and 14.04). It should work on any other linux flavour provided you have the tools in REQUIREMENTS section.

## LICENSE
GPL v3
A copy of GPL3 is included in the package


