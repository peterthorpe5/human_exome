#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

module load python/2.7

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -V filt001_QUAL50_vqslod_PASS_DP_QD.vcf -o family489filt001.vcf -sn M9804 -sn M9806 -sn M9807 -sn M9814 -sn M9810 -sn M9805


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark_HET9804.vcf --variant family489filt001.vcf -select "vc.getGenotype('M9804').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark_HET9806.vcf --variant mark_HET9804.vcf -select "vc.getGenotype('M9806').isHet()"


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark_HET9807.vcf --variant mark_HET9806.vcf -select "vc.getGenotype('M9807').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark_HET9814.vcf --variant mark_HET9807.vcf -select "vc.getGenotype('M9814').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark_9810.vcf --variant mark_HET9814.vcf -select "vc.getGenotype('M9810').isHomRef()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markfilt001.vcf --variant mark_9810.vcf -select "vc.getGenotype('M9805').isHomRef()"




java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant markfilt001.vcf -o family489_DP1.vcf -select 'vc.getGenotype("M9804").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP1.vcf -o family489_DP2.vcf -select 'vc.getGenotype("M9806").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP2.vcf -o family489_DP3.vcf -select 'vc.getGenotype("M9807").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP3.vcf -o family489_DP4.vcf -select 'vc.getGenotype("M9814").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP4.vcf -o family489_DP5.vcf -select 'vc.getGenotype("M9810").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP5.vcf -o family489filt001_DP.vcf -select 'vc.getGenotype("M9805").getDP() > 10.0'

python2.7 ../cava-v1.1.1/cava.py -c config.txt -i family489filt001_DP.vcf -o family489filt001_output
