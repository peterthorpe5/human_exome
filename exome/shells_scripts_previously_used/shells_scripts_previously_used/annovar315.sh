#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  annov315 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q highmemory.q 


#perl table_annovar.pl ../families_indels/filt_QUAL50_vqslod_PASS.vcf humandb/ -buildver hg19 -out myanno -remove -protocol refGene,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138 -operation g,f,f,f,f,f,f -nastring . -vcfinput

perl table_annovar.pl ../indelAnal_13_8_2016/family315/mark3293.vcf humandb/ -buildver hg19 -out ../indelAnal_13_8_2016/family315/mark_annovar -remove -protocol refGene,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138 -operation g,f,f,f,f,f,f -nastring . -vcfinput

#perl table_annovar.pl ../SNPanalysis_13_8_2016/family315/mark3293.vcf humandb/ -buildver hg19 -out ../SNPanalysis_13_8_2016/family315/mark_annovar -remove -protocol refGene,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138 -operation g,f,f,f,f,f,f -nastring . -vcfinput
