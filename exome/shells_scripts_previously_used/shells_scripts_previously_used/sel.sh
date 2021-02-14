#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

module load python/2.7

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -V filt_QUAL50_vqslod_PASS_DP_QD.vcf -o family489.vcf -sn M9804 -sn M9806 -sn M9807 -sn M9814 -sn M9810 -sn M9805


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET9804.vcf --variant family489.vcf -select "vc.getGenotype('M9804').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET9806.vcf --variant markHET9804.vcf -select "vc.getGenotype('M9806').isHet()"


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET9807.vcf --variant markHET9806.vcf -select "vc.getGenotype('M9807').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o markHET9814.vcf --variant markHET9807.vcf -select "vc.getGenotype('M9814').isHet()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark9810.vcf --variant markHET9814.vcf -select "vc.getGenotype('M9810').isHomRef()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../../bundle_hg19/ucsc.hg19.fasta -o mark.vcf --variant mark9810.vcf -select "vc.getGenotype('M9805').isHomRef()"




java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant mark.vcf -o family489_DP1.vcf -select 'vc.getGenotype("M9804").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP1.vcf -o family489_DP2.vcf -select 'vc.getGenotype("M9806").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP2.vcf -o family489_DP3.vcf -select 'vc.getGenotype("M9807").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP3.vcf -o family489_DP4.vcf -select 'vc.getGenotype("M9814").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP4.vcf -o family489_DP5.vcf -select 'vc.getGenotype("M9810").getDP() > 10.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant family489_DP5.vcf -o family489_DP.vcf -select 'vc.getGenotype("M9805").getDP() > 10.0'

python2.7 ../cava-v1.1.1/cava.py -c ../config.txt -i family489_DP.vcf -o family489_output
