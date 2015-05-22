#!/usr/bin/python
import multiprocessing as mp
import subprocess as sp
import os, sys
def run(args):
    filename, prog = args
    fname, mininsertlength, maxinsertlength = filename.strip().split(':')
    environment = os.environ.copy()   
    environment['MAX_INSERT_SIZE'] = maxinsertlength
    environment['MIN_INSERT_SIZE'] = mininsertlength
    p = sp.Popen(['bash', os.path.join(environment['QCBIN'], prog), filename], stdout=sp.PIPE, shell=False, env=environment)
    return p.communicate()    

if __name__ =='__main__':
    try: 
        print('QCBIN variable path set to '+ os.environ['QCBIN'])
    except KeyError:
        raise SystemExit('Before you run NGSQCBox-vX.Y.py, please run "source sourcme.ngsqcbox" at shell prompt in the unzipped package to set $QCBIN variable!')
    s = """
        NGSQCBox toolkit v 1.0
        ~~~~~~~~~~~~~~~~~~~~~~
        1) Quick mode QC
        2) Complete mode QC
        Enter a choice:
        """ 
    choice = int(raw_input(s))
     
    if choice == 1:
        prog = 'batchqc_quick.sh'
    elif choice == 2:
        reference_path = raw_input('Enter reference fasta full path: ') or 'example/phix.fa'
        #reference_path = 'example/phix.fa' 
        os.environ['REFERENCE'] = os.path.abspath(reference_path)
        genome_size = raw_input('Enter the reference genome size: ') or '5386'
        #genome_size = '5386'
        os.environ['GENOME_SIZE'] = genome_size
        
        bowtie2_path = raw_input('Enter bowtie2 index full path: ') or 'example/phix_index'
        #bowtie2_path = 'example/phix_index' 
        os.environ['BOWTIE2_INDEX_PATH'] = os.path.abspath(bowtie2_path)
        if os.environ['REFERENCE']  and  os.environ['GENOME_SIZE'] and os.environ['BOWTIE2_INDEX_PATH']:
            prog = 'batchqc_complete.sh'
        else:
            raise SystemExit('You failed to provide required reference/size/bowtie2 index path')
    else:
        raise SystemExit('Choice invalid ! cannot run QC')
    fastq_path = os.path.abspath(raw_input('Enter data folder path : ') or '/home/km/Documents/manuscripts/NGS-QCbox_MS/NGS-QCbox-v1.0/example') 
    #fastq_path = os.path.abspath('example')
    os.environ['DATA_PATH'] =  fastq_path
    #'/mnt/das/ngs/projects/QC_bin_test/test_data'     
    np = int(raw_input('Number of processors to use : '))
    os.environ['NPROCS'] = str(np)
    samples_file = os.path.join(fastq_path,'samples.txt')
    samples = []
    with open(samples_file) as  fh:
        for line in fh:
            samples.append((line.strip(), prog))
    os.chdir(fastq_path)

    p = mp.Pool(np)
    output = p.map(run, samples)
    p.close()
    p.join()
    from process_report import  summarize
    summarize() 
    print("QC completed!")

