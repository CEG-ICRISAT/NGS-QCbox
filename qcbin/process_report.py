#!/usr/bin/env python
"""
This script collates all the sample wise reports and generates a final summary  report
"""
from __future__ import print_function
import glob
def summarize():
    qc_files = glob.glob('*detailed_qc_quick.txt')
    gh= open('QC_final_quick.txt','w')
    header = ['Sample', 'Reads before QC','Reads after QC', 'Percentage retained']
    print(*header, sep='\t', file=gh)
    for qc_file in qc_files:
        #print(qc_file)
        sample = qc_file.split('_',1)[0]
        with open(qc_file) as fh:
            fh.readline()
            for line in fh:
                if line.startswith('Total reads'): 
                    L = line.strip().split('\t')
                    reads_before = int(L[1]) + int(L[2])
                    reads_after = int(L[3]) + int(L[4]) + int(L[5])
                    perc_retained = reads_after*100.0/reads_before
                    result = [sample, reads_before, reads_after, round(perc_retained,2)]
                    print(*result, sep='\t', file=gh)
            
    gh.close()
