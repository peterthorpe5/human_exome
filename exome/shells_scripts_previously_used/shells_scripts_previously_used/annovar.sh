#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N ann ## job name
#$ -S /bin/bash ## shell where it will run this job
#$ -j y ## join error output to normal output
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

#perl table_annovar.pl ../families_indels/filt_QUAL50_vqslod_PASS.vcf humandb/ -buildver hg19 -out myanno -remove -protocol refGene,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138 -operation g,f,f,f,f,f,f -nastring . -vcfinput

#perl table_annovar.pl ../SNPanalysis_13_8_2016/family300/markHET.vcf humandb/ -buildver hg19 -out ../SNPanalysis_13_8_2016/family300/markHET_annovar.vcf -remove -protocol refGene,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138 -operation g,f,f,f,f,f,f -nastring . -vcfinput 

perl table_annovar.pl ../indelAnal_13_8_2016/family300/markHET.vcf humandb/ -buildver hg19 -out ../indelAnal_13_8_2016/family300/markHET_annovar.vcf -remove -protocol refGene,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138 -operation g,f,f,f,f,f,f -nastring . -vcfinput
