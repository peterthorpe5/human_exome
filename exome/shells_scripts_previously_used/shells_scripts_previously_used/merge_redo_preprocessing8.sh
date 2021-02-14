#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  megre8 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH
cd ..;
for i in $(cat names8.txt); do
echo "$i";
cd "$i"

mkdir mergedLanes
cd mergedLanes

### merged the two lanes of each sample
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MergeSamFiles.jar I=../L001/$i\_L001_BaseRecalibrated.bam I=../L002/$i\_L002_BaseRecalibrated.bam O=$i\_merged.bam SORT_ORDER=coordinate

#samtools merge $i\_merged.bam ../L001/$i\_L001_BaseRecalibrated.bam ../L002/$i\_L001_BaseRecalibrated.bam

### mark the duplicates for the new merged bam file
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$i\_merged.bam O=$i\_duplicates.bam  CREATE_INDEX=false VALIDATION_STRINGENCY=SILENT M=output.metrics

### index for the merged bam file
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/BuildBamIndex.jar I=$i\_duplicates.bam

### create the interval
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_duplicates.bam -o $i\_intervalListFromRTC.intervals

### realignment
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_duplicates.bam -known ../../bundle_hg19/dbsnp_138.hg19.vcf -R ../../bundle_hg19/ucsc.hg19.fasta -targetIntervals $i\_intervalListFromRTC.intervals -o $i\_realigned.bam

### reorder the bam file (just to confirm it is in the right order)
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/ReorderSam.jar I=$i\_realigned.bam R=../../bundle_hg19/ucsc.hg19.fasta O=$i\_reordered.bam

### index the new bam file
samtools index $i\_reordered.bam

### basecalibrator is executed in two commands: BaseRecalibrator and PrintReads
### BaseRecalibrator
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_reordered.bam -knownSites ../../bundle_hg19/dbsnp_138.hg19.vcf -o $i\_recal_data.grp

#### printReads
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T PrintReads -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_reordered.bam -BQSR $i\_recal_data.grp -o $i\_BaseRecalibrated.bam

cd ../../

done

