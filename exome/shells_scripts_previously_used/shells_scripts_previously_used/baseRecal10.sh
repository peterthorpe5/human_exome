#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  br10 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH

cd ..;

for i in $(cat names10.txt); do
echo "$i";
cd "$i"

cd "L001"
### reorder the bam file as well
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/ReorderSam.jar I=$i\_S1_L001_realigned.bam R=../../bundle_hg19/ucsc.hg19.fasta O=$i\_S1_L001_reordered.bam

### index the new bam file
samtools index $i\_S1_L001_reordered.bam

### basecalibrator is executed in two commands: BaseRecalibrator and PrintReads
### BaseRecalibrator
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_S1_L001_reordered.bam -knownSites ../../bundle_hg19/dbsnp_138.hg19.vcf -o $i\_L001_recal_data.grp

#### printReads
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T PrintReads -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_S1_L001_reordered.bam -BQSR $i\_L001_recal_data.grp -o $i\_L001_BaseRecalibrated.bam


######################################################################################################################################################################################################

### repeat the above commands for the directory L002
cd ../L002


### reorder the bam file as well
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/ReorderSam.jar I=$i\_S1_L002_realigned.bam R=../../bundle_hg19/ucsc.hg19.fasta O=$i\_S1_L002_reordered.bam

### index the new bam file
samtools index $i\_S1_L002_reordered.bam

### basecalibrator is executed in two commands: BaseRecalibrator and PrintReads
### BaseRecalibrator
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_S1_L002_reordered.bam -knownSites ../../bundle_hg19/dbsnp_138.hg19.vcf -o $i\_L002_recal_data.grp

#### printReads
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T PrintReads -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_S1_L002_reordered.bam -BQSR $i\_L002_recal_data.grp -o $i\_L002_BaseRecalibrated.bam


cd ../..

done
