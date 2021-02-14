#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  ann.fam ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory

set -e

annovar="/storage/home/users/av45/exome/reanalysis/annovar"

#cd $annovar
echo "Running ANNOVAR"

for i in fam300 fam315 fam323 fam387 fam430 fam489
do
echo -e "\nRunning on $i output"
#perl $annovar/table_annovar.pl /storage/home/users/av45/exome/reanalysis/test_new_pipeline/${i}/${i}_output.vcf humandb/ -buildver hg19
#-out /storage/home/users/av45/exome/reanalysis/test_new_pipeline/${i}/${i}_output -remove \
#-protocol gnomad_exome -operation f -nastring . -vcfinput -polish

perl annovar/table_annovar.pl $i/${i}_output.vcf \
annovar/humandb/ -buildver hg19 -out $i/${i}_output.myanno -remove \
-protocol gnomad_exome,refGene,dbnsfp35c,avsnp150,tfbsConsSites,clinvar_20200316 \
-operation f,gx,f,f,r,f -nastring . -vcfinput -polish

 #refGene,dbnsfp30a,dbscsnv11,gnomad_exome,tfbsConsSites -operation gx,f,f,f,r -nastring . -vcfinput -polish
done
