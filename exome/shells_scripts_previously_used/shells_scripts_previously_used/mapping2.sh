#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  mapping1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name


PATH=$PATH:/usr/local/Modules/modulefiles/tools/bwa/0.7.7/bin/
export PATH
PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH

# make the index
# bwa index -a bwtsw ucsc.hg19.fasta
cd ..;
for i in $(cat names2.txt); do
echo "$i";
mkdir "$i";
cd "$i";

### run the alignment for the fastaq files of the first line

mkdir L001;
cd L001;

bwa mem -t 12 -M -R "@RG\tID:"$i"\tSM:"$i"\tPL:illumina" ../../bundle_hg19/ucsc.hg19.fasta ../../FASTQ/$i\/$i\_S1_L001_R1_001.fastq.gz ../../FASTQ/$i\/$i\_S1_L001_R2_001.fastq.gz > $i\_S1_L001_aligned_reads.sam

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/SortSam.jar INPUT=$i\_S1_L001_aligned_reads.sam OUTPUT=$i\_S1_L001_sorted_reads.bam SORT_ORDER=coordinate

cd ..

##############################################################

### run the alignment for the fastaq files of the second line

mkdir L002;
cd L002;

bwa mem -t 12 -M -R "@RG\tID:"$i"\tSM:"$i"\tPL:illumina" ../../bundle_hg19/ucsc.hg19.fasta ../../FASTQ/$i\/$i\_S1_L002_R1_001.fastq.gz ../../FASTQ/$i\/$i\_S1_L002_R2_001.fastq.gz > $i\_S1_L002_aligned_reads.sam

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/SortSam.jar INPUT=$i\_S1_L002_aligned_reads.sam OUTPUT=$i\_S1_L002_sorted_reads.bam SORT_ORDER=coordinate
cd ../..

### move to the next individual sample
done
