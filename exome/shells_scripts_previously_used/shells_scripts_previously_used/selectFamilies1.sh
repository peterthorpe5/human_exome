#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

# extract the variants in the 1000G that are more than 0.05 allele freq
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant ../../bundle_hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf -o 1000G_AF005.vcf -select "AF > 0.01"


# select the variants that missed in 1000G (all the variants with AF>0.05) but present in my calls
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../bundle_hg19/ucsc.hg19.fasta -V recalibrated.filtered.vcf --discordance 1000G_Gr001.vcf -o filteredVariants_001.vcf 

# select the variants with qual score more than 50
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filteredVariants_001.vcf -o filt001_QUAL50.vcf -select "QUAL >= 50.0"

# select the variants with vqslod more than or equal to 0
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt001_QUAL50.vcf -o filt001_QUAL50_VQ.vcf -select "VQSLOD >= 0.0"

# select only the variants that pass all the filters
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt001_QUAL50_VQ.vcf -o filt001_QUAL50_vqslod_PASS.vcf -select 'vc.isNotFiltered()'

# select the variants with GQ more than or equal to 10
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt001_QUAL50_vqslod_PASS.vcf -o filt001_QUAL50_vqslod_PASS_DP.vcf -select "DP >= 10.0"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt001_QUAL50_vqslod_PASS_DP.vcf -o filt001_QUAL50_vqslod_PASS_DP_QD.vcf -select "QD >= 10.0"

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../bundle_hg19/ucsc.hg19.fasta -V filt_QUAL50_vqslod_PASS_DP.vcf --discordance 1000G_Gr0005.vcf -o filt_QUAL50_vqslod_PASS_DP_af0005.vcf



#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS.vcf -o filt_QUAL50_vqslod_PASS_DP1.vcf -select 'vc.getGenotype("M3060").getDP() >= 5.0'

#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP1.vcf -o filt_QUAL50_vqslod_PASS_DP2.vcf -select 'vc.getGenotype("M3061").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP2.vcf  -o filt_QUAL50_vqslod_PASS_DP3.vcf -select 'vc.getGenotype("M3290").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP3.vcf  -o filt_QUAL50_vqslod_PASS_DP4.vcf -select 'vc.getGenotype("M3293").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP4.vcf  -o filt_QUAL50_vqslod_PASS_DP5.vcf -select 'vc.getGenotype("M3294").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP5.vcf -o filt_QUAL50_vqslod_PASS_DP6.vcf -select 'vc.getGenotype("M3300").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP6.vcf -o filt_QUAL50_vqslod_PASS_DP7.vcf -select 'vc.getGenotype("M3326").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP7.vcf -o filt_QUAL50_vqslod_PASS_DP8.vcf -select 'vc.getGenotype("M3328").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP8.vcf -o filt_QUAL50_vqslod_PASS_DP9.vcf -select 'vc.getGenotype("M3329").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP9.vcf -o filt_QUAL50_vqslod_PASS_DP10.vcf -select 'vc.getGenotype("M3622").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP10.vcf -o filt_QUAL50_vqslod_PASS_DP11.vcf -select 'vc.getGenotype("M4297").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP11.vcf -o filt_QUAL50_vqslod_PASS_DP12.vcf -select 'vc.getGenotype("M4298").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP12.vcf -o filt_QUAL50_vqslod_PASS_DP13.vcf -select 'vc.getGenotype("M4299").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP13.vcf -o filt_QUAL50_vqslod_PASS_DP14.vcf -select 'vc.getGenotype("M4300").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP14.vcf -o filt_QUAL50_vqslod_PASS_DP15.vcf -select 'vc.getGenotype("M4303").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP15.vcf -o filt_QUAL50_vqslod_PASS_DP16.vcf -select 'vc.getGenotype("M4305").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP16.vcf -o filt_QUAL50_vqslod_PASS_DP17.vcf -select 'vc.getGenotype("M4675").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP17.vcf -o filt_QUAL50_vqslod_PASS_DP18.vcf -select 'vc.getGenotype("M7766").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP18.vcf -o filt_QUAL50_vqslod_PASS_DP19.vcf -select 'vc.getGenotype("M7767").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP19.vcf -o filt_QUAL50_vqslod_PASS_DP20.vcf -select 'vc.getGenotype("M7769").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP20.vcf -o filt_QUAL50_vqslod_PASS_DP21.vcf -select 'vc.getGenotype("M8750").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP21.vcf -o filt_QUAL50_vqslod_PASS_DP22.vcf -select 'vc.getGenotype("M8988").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP22.vcf -o filt_QUAL50_vqslod_PASS_DP23.vcf -select 'vc.getGenotype("M8992").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP23.vcf -o filt_QUAL50_vqslod_PASS_DP24.vcf -select 'vc.getGenotype("M9804").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP24.vcf -o filt_QUAL50_vqslod_PASS_DP25.vcf -select 'vc.getGenotype("M9805").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP25.vcf -o filt_QUAL50_vqslod_PASS_DP26.vcf -select 'vc.getGenotype("M9806").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP26.vcf -o filt_QUAL50_vqslod_PASS_DP27.vcf -select 'vc.getGenotype("M9807").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP27.vcf -o filt_QUAL50_vqslod_PASS_DP28.vcf -select 'vc.getGenotype("M9810").getDP() > 7.0'
#java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP28.vcf -o filt_QUAL50_vqslod_PASS_DP.vcf -select 'vc.getGenotype("M9814").getDP() > 7.0'
#

