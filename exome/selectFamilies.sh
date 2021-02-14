#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R bundle_hg19/ucsc.hg19.fasta -V recalibrated.filtered.vcf  -o f323.vcf -sn M3060 -sn M3061 -sn M3326 -sn M4675

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_VQ_QUAL.vcf -o filt_VQ_QUAL_QD.vcf -select "QD >= 5.0"

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant recalibrated.filtered.vcf -o filt_VQ.vcf -select "VQSLOD >= 0.0"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant recalibrated.filtered.vcf -o filt_QUAL.vcf -select "QUAL <= 50.0" 
