## gatk doesn't support the hg38 therefore we run the whole analysis using hg19 or b37
## we download the bundle from gatk 
mkdir bundle_b37
cd bundle_b37
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/b37/*  
cd ..

mkdir bundle_hg19
cd bundle_hg19
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/*
cd ..

################################################################################################################################################################
### mapping 

#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  mapping ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name


PATH=$PATH:/usr/local/Modules/modulefiles/tools/bwa/0.7.7/bin/
export PATH
PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH

for i in $(cat names.txt); do
echo "$i";
mkdir "$i";
cd "$i";

### run the alignment for the fastaq files of the first line

mkdir L001;
cd L001;

bwa mem -t 12 -M -R "@RG\tID:"$i"\tSM:L001\tPL:illumina" ../../../mapping/hg38/hg38.fa ../../../transcriptomics/FASTQ/$i\/$i\_S1_L001_R1_001.fastq.gz ../../../transcriptomics/FASTQ/$i\/$i\_S1_L001_R2_001.fastq.gz > $i\_S1_L001_aligned_reads.sam

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/SortSam.jar INPUT=$i\_S1_L001_aligned_reads.sam OUTPUT=$i\_S1_L001_sorted_reads.bam SORT_ORDER=coordinate

cd ..

########################################################################################################

### run the alignment for the fastaq files of the second line

mkdir L002;
cd L002;

### convert the sai to sam 
bwa mem -t 12 -M -R "@RG\tID:"$i"\tSM:L001\tPL:illumina" ../../../mapping/hg38/hg38.fa ../../../transcriptomics/FASTQ/$i\/$i\_S1_L002_R1_001.fastq.gz ../../../transcriptomics/FASTQ/$i\/$i\_S1_L002_R2_001.fastq.gz > $i\_S1_L002_aligned_reads.sam

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/SortSam.jar INPUT=$i\_S1_L002_aligned_reads.sam OUTPUT=$i\_S1_L002_sorted_reads.bam SORT_ORDER=coordinate
cd ../..
### move to the next individual sample
done



################################################################################################################################################################
### mark duplicates

#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  duplicates ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name


for i in $(cat names.txt); do
echo "$i";
cd "$i"

cd "L001"
### CREATE INDEX =  create a BAM index when writing a coordinate-sorted BAM file
### Validation_strigency = SILENT: SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded.
### M = metrics for duplication 

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$i\_S1_L001_sorted_reads.bam O=$i\_S1_L001_duplicates.bam  CREATE_INDEX=false VALIDATION_STRINGENCY=SILENT M=output.metrics


### index the bam file 
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/BuildBamIndex.jar I=$i\_S1_L001_duplicates.bam

cd ../L002

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$i\_S1_L002_sorted_reads.bam O=$i\_S1_L002_duplicates.bam  CREATE_INDEX=false VALIDATION_STRINGENCY=SILENT M=output.metrics

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/BuildBamIndex.jar I=$i\_S1_L002_duplicates.bam
cd ../..

done


################################################################################################################################################################
### indel realignment

#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  indel_realignment ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH

for i in $(cat names1.txt); do
echo "$i";
cd "$i"

cd "L001"

### indel realignment

echo "Create interval target realignment"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../../mapping/hg38/hg38.fa -I $i\_S1_L001_duplicates.bam -o $i\_S1_L001_intervalListFromRTC.intervals

echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_S1_L001_duplicates.bam -known ../../All_20151104_vcfSorter.vcf -R ../../../mapping/hg38/hg38.fa -targetIntervals $i\_S1_L001_intervalListFromRTC.intervals -o $i\_S1_L001_realigned.bam


###################################################################################################################################################################################


### repeat the above commands for the directory L002
cd ../L002
echo "Lane 2"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../../mapping/hg38/hg38.fa -I $i\_S1_L002_duplicates.bam -o $i\_S1_L002_intervalLi
stFromRTC.intervals
echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_S1_L002_duplicates.bam -known ../../All_20151104_vcfSorter.vcf -R ../../../mapping/hg38/hg38.fa -targetIntervals $i\_S1_L002_intervalListFromRTC.intervals -o $i\_S1_L002_realigned.bam


cd ../..

done



################################################################################################################################################################
### base recalibration

#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  duplicates ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH


### base recalibration
### This tool generates tables based on various user-specified covariates (such as read group, reported quality score, cycle, and context)

### in order for the base calibrator, not to have errors, we need the bam file to be sorted and the vcf file to be sorted according to the fasta file
### I tried the perl script available http://gatkforums.broadinstitute.org/discussion/1328/errors-about-contigs-in-bam-or-vcf-files-not-being-properly-sorted  
### it didn't work

### I tried the vcf-sort from vcftools, it didn't work either
### I couldn't find the SortVcf tool in Picard either

### download the perl script from https://code.google.com/p/vcfsorter/ and run it after create the dictionary for the reference file


### ALREADY DONE
### create the dictionary for the reference file
################ java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/CreateSequenceDictionary.jar R=../../hg38/hg38.fa O=../../hg38/hg38.dict

### run the vcfsorter script
############### perl vcfsorter.pl ../mapping/hg38/hg38.dict All_20151104.vcf > All_20151104_vcfSorter.vcf

for i in $(cat names2.txt); do
echo "$i";
cd "$i"

cd "L001"

### reorder the bam file as well
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/ReorderSam.jar I=$i\_S1_L001_realigned.bam R=../../../mapping/hg38/hg38.fa O=$i\_S1_L001_reordered.bam

### index the new bam file
samtools index $i\_S1_L001_reordered.bam

### basecalibrator is executed in two commands: BaseRecalibrator and PrintReads
### BaseRecalibrator
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../../../mapping/hg38/hg38.fa -I $i\_S1_L001_reordered.bam -knownSites ../../All_20151104_vcfSorter.vcf -o $i\_L001_recal_data.grp

#### printReads
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T PrintReads -R ../../../mapping/hg38/hg38.fa -I $i\_S1_L001_reordered.bam -BQSR $i\_L001_recal_data.grp -o $i\_L001_BaseRecalibrated.bam


######################################################################################################################################################################################################

### repeat the above commands for the directory L002
cd ../L002


### reorder the bam file as well
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/ReorderSam.jar I=$i\_S1_L002_realigned.bam R=../../../mapping/hg38/hg38.fa O=$i\_S1_L002_reordered.bam

### index the new bam file
samtools index $i\_S1_L002_reordered.bam

### basecalibrator is executed in two commands: BaseRecalibrator and PrintReads
### BaseRecalibrator
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../../../mapping/hg38/hg38.fa -I $i\_S1_L002_reordered.bam -knownSites ../../All_20151104_vcfSorter.vcf -o $i\_L002_recal_data.grp

#### printReads
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T PrintReads -R ../../../mapping/hg38/hg38.fa -I $i\_S1_L002_reordered.bam -BQSR $i\_L002_recal_data.grp -o $i\_L002_BaseRecalibrated.bam


cd ../..

done
          


