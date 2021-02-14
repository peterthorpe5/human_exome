#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  indel10 ## job name
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

### indel realignment

echo "Create interval target realignment"

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../bundle_hg19/ucsc.hg19.fasta  -I $i\_S1_L001_duplicates.bam -o $i\_S1_L001_intervalListFromRTC.intervals

echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_S1_L001_duplicates.bam -known ../../bundle_hg19/dbsnp_138.hg19.vcf -R ../../bundle_hg19/ucsc.hg19.fasta -targetIntervals $i\_S1_L001_intervalListFromRTC.intervals -o $i\_S1_L001_realigned.bam

### repeat the above commands for the directory L002
cd ../L002
echo "Lane 2"

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_S1_L002_duplicates.bam -o $i\_S1_L002_intervalListFromRTC.intervals
echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $i\_S1_L002_duplicates.bam -known ../../bundle_hg19/dbsnp_138.hg19.vcf -R ../../bundle_hg19/ucsc.hg19.fasta -targetIntervals $i\_S1_L002_intervalListFromRTC.intervals -o $i\_S1_L002_realigned.bam

cd ../..

done

