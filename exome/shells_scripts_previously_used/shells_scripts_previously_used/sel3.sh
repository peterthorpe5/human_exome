#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

module load python/2.7
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -V filt_QUAL50_vqslod_PASS_DP_QD.vcf -o family315.vcf -sn M3290 -sn M3300 -sn M3294 -sn M8988 -sn M3293


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET3290.vcf --variant family20_315.vcf -select "vc.getGenotype('M3290').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET3300.vcf --variant markHET3290.vcf -select "vc.getGenotype('M3300').isHet()"


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET3294.vcf --variant markHET3300.vcf -select "vc.getGenotype('M3294').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET8988.vcf --variant markHET3294.vcf -select "vc.getGenotype('M8988').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark3293.vcf --variant markHET8988.vcf -select "vc.getGenotype('M3293').isHomRef()"



java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant mark3293.vcf -o family20_315_DP1.vcf -select 'vc.getGenotype("M3290").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family20_315_DP1.vcf -o family20_315_DP2.vcf -select 'vc.getGenotype("M3300").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family20_315_DP2.vcf -o family20_315_DP3.vcf -select 'vc.getGenotype("M3294").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family20_315_DP3.vcf -o family20_315_DP4.vcf -select 'vc.getGenotype("M8988").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family20_315_DP4.vcf -o family20_315_DP.vcf -select 'vc.getGenotype("M3293").getDP() > 10.0'

#python2.7 ../cava-v1.1.1/cava.py -c ../config.txt -i family315_DP.vcf -o family315_output.vcf
