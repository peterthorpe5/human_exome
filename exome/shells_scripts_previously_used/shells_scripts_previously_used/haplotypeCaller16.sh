#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  haplotype16 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH

### call the variant for each individual separately
cd ..;
for i in $(cat names16.txt); do
echo "$i";
cd "$i"
cd mergedLanes;

### test before running how the multithread argument work (-nct, -nt). If they don't work just remove them.
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T HaplotypeCaller -R ../../bundle_hg19/ucsc.hg19.fasta -I $i\_BaseRecalibrated.bam --emitRefConfidence GVCF --genotyping_mode DISCOVERY --dbsnp ../../bundle_hg19/dbsnp_138.hg19.vcf -o $i\.g.vcf

cd ../..

done
