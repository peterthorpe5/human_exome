#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -V filt_QUAL50_vqslod_PASS_DP_ann.hg19_multianno.vcf -o patients.vcf -sn M3060 -sn M3326 -sn M4675

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -V filt_QUAL50_vqslod_PASS_DP_ann.hg19_multianno.vcf -o controls.vcf -sn M3061


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -o markHET3060.vcf --variant patients.vcf -select "vc.getGenotype('M3060').isHet()" 

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -o markHET3326.vcf --variant markHET3060.vcf -select "vc.getGenotype('M3326').isHet()"


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -o markHET.vcf --variant markHET3326.vcf -select "vc.getGenotype('M4675').isHet()"


java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -o markHOMRef.vcf --variant controls.vcf -select "vc.getGenotype('M3061').isHomRef()"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SelectVariants -R ../../bundle_hg19/ucsc.hg19.fasta -V markHET.vcf --concordance markHOMRef.vcf -o het_pat_homRef_controls.vcf

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant het_pat_homRef_controls.vcf -o het_pat_homRef_controls_NonSynon.vcf -select "ExonicFunc.refGene == 'nonsynonymous_SNV'"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant het_pat_homRef_controls.vcf -o het_pat_homRef_controls_NonSense.vcf -select "ExonicFunc.refGene == 'stopgain'"





















