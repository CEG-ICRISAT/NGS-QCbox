#!/usr/bin/env python
import  sys
"""
script to  compute bam/sam alignment coveage given genome_size

usage: program genome.coverage genome_size

Arguments
@genome.coverage' is generated from bedtools genomecov -ibam  x.bam -bga
@genome_size is  the integer [alternately  computed by 'genomeLength.py' script

author: k.krishnamohan@cgiar.org

"""
if __name__ == '__main__':
    if(len(sys.argv) < 3):
        print """
        usage: program genome.coverage genome_size

        Arguments
        @genome.coverage' is generated from 'bedtools genomecov -ibam  input.bam -bga'
        @genome_size is  the integer [alternately  computed by 'genomeLength.py' script

        author: k.krishnamohan@cgiar.org


        """
        raise SystemExit
    genome_size = long(sys.argv[2])
    total_bases = 0
    bases_gte1x = 0
    bases_gte2x = 0
    bases_gte5x = 0
    bases_gte10x = 0
    bases_gte15x = 0
    bases_zero_depth = 0
    total_bases_depth = 0
    with open(sys.argv[1]) as fh:
        for line in fh:
            chro, start, end, depth = line.split()
            #print(chro,  start, end, depth)
            nbases = long(end)  - long(start)
            #print(nbases)
            depth = long(depth)
            total_bases_depth += depth * nbases
            total_bases += nbases
            if depth >= 1:
                bases_gte1x += nbases
            if depth >= 2:
                bases_gte2x += nbases
            if depth >= 5:
                bases_gte5x += nbases
            if depth >= 10:
                bases_gte10x += nbases
            if depth >= 15:
                bases_gte15x += nbases
            if depth == 0:
                bases_zero_depth += nbases

    print('genome coverage at >= 1x : {:.2f} % covered'.format((bases_gte1x*100.0)/genome_size))
    print('genome coverage at >=2 x : {:.2f} % covered'.format((bases_gte2x*100.0)/genome_size))
    print('genome coverage at >= 5x :{:.2f} % covered'.format((bases_gte5x*100.0)/genome_size))
    print('genome coverage at >= 10x : {:.2f} %covered'.format((bases_gte10x*100.0)/genome_size))
    print('genome coverage at >= 15x : {:.2f} % covered'.format((bases_gte15x*100.0)/genome_size))
    print('bases not covered {} : ({:.2f}%)'.format(bases_zero_depth, (bases_zero_depth*100.0)/genome_size))
    print('Avg depth : {:.2f}'.format(float(total_bases_depth)/genome_size))
    print('total bases {}  genome_size {}'.format(total_bases,genome_size))


