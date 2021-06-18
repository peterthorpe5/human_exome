import os
from sys import stdin,argv


def seq_getter(filename_in):
    "this is a function to open up a .xml file blast results, the out put of\
is all the unique hit"
    from Bio.Seq import Seq
    from Bio.SeqRecord import SeqRecord
    from Bio import SeqIO
    for seq_record in SeqIO.parse(filename_in, "fasta"):
        print("%s\t1\t%s" % (seq_record.id, str(len(seq_record.seq))))


seq_getter(argv[1])

#seq_getter('assembly2_scaffolds.fasta',\
           #'scaffold318.fasta')
print 'done'

