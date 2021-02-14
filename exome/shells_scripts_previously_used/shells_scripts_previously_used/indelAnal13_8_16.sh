#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

# extract the variants in the 1000G that are more than 0.05 allele freq
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant ../../bundle_hg19/1000G_phase1.indels.hg19.sites.vcf -o 1000G_AF005.vcf -select "AF > 0.05"


# select the variants that missed in 1000G (all the variants with AF>0.05) but present in my calls
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../bundle_hg19/ucsc.hg19.fasta -V recalibrated.filtered.indels.vcf --discordance 1000G_AF005.vcf -o filteredVariants_005.vcf 


