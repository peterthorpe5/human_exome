#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  duplicates2 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

cd ..;
for i in $(cat names2.txt); do
echo "$i";
cd "$i"

cd "L001"
### CREATE INDEX =  create a BAM index when writing a coordinate-sorted BAM file
### Validation_strigency = SILENT: SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded.
### M = metrics for duplication 

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$i\_S1_L001_sorted_reads.bam O=$i\_S1_L001_duplicates.bam  CREATE_INDEX=false VALIDATION_STRINGENCY=SILENT M=output.metrics


### index the bam file 
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/BuildBamIndex.jar I=$i\_S1_L001_duplicates.bam

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../bundle_hg19/ucsc.hg19.fasta  -I $i\_S1_L001_duplicates.bam -o $i\_S1_L001_intervalListFromRTC.intervals

echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_S1_L001_duplicates.bam -known ../../bundle_hg19/dbsnp_138.hg19.vcf -R ../../bundle_hg19/ucsc.hg19.fasta -targetIntervals $i\_S1_L001_intervalListFromRTC.intervals -o $i\_S1_L001_realigned.bam


cd ../L002

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$i\_S1_L002_sorted_reads.bam O=$i\_S1_L002_duplicates.bam  CREATE_INDEX=false VALIDATION_STRINGENCY=SILENT M=output.metrics

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/BuildBamIndex.jar I=$i\_S1_L002_duplicates.bam

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_S1_L002_duplicates.bam -o $i\_S1_L002_intervalListFromRTC.intervals
echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_S1_L002_duplicates.bam -known ../../bundle_hg19/dbsnp_138.hg19.vcf -R ../../bundle_hg19/ucsc.hg19.fasta -targetIntervals $i\_S1_L002_intervalListFromRTC.intervals -o $i\_S1_L002_realigned.bam


cd ../..

done

