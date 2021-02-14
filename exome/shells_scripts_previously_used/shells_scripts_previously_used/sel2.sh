#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

module load python/2.7

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -V filt_QUAL20_vqslod_PASS_DP_QD.vcf -o family20_387.vcf -sn M4305 -sn M4303 -sn M4299 -sn M4298 -sn M4297 -sn M4300
