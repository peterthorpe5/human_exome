#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#####$ -q lowmemory.q ## queue name
#$ -pe multi 16

# extract the variants in gnomAD with PLINK at MAF 5%
# filter for Q30, vqslod >0, PASS, then work in families and filterfor DP > 10 and HET/HOMO filtering

set -e

cd /storage/home/users/av45/exome/reanalysis
gatk="/usr/local/Modules/modulefiles/tools/gatk/3.7.0/"
genome="/storage/home/users/av45/exome/bundle_hg19/"


module load plink/2.0


#plink2 --vcf ../gnomad/gnomad.exomes.r2.1.1.sites.vcf.bgz --extract-if-info "AF_nfe_nwe <= 0.05" \
#--out filter0.05.North_western_euro --write-snplist --threads 24 --set-missing-var-ids "@:#"

#plink2 --vcf recalibrated.filtered.vcf --extract filter0.05.North_western_euro.snplist \
#--export vcf --out recalibrated_MAF0.05_nwetest --allow-extra-chr --set-missing-var-ids "@:#"

# Change VCF v4.3 to VCF v4.2
#sed -i '1s/VCFv4.3/VCFv4.2/' recalibrated_MAF0.05_nwetest.vcf

# NEED TO ACTIVATE VCFTOOLS ENV! # vcftools.yaml has the specs used
#vcftools --vcf recalibrated_MAF0.05_nwetest.vcf --minQ 30 --recode --recode-INFO-all --out test_vcftools_Q30

bcftools view -i 'VQSLOD >= 0.0' test_vcftools_Q30.recode.vcf -o test_vcftools_Q30_VQSLOD.vcf

vcftools --vcf test_vcftools_Q30_VQSLOD.vcf --remove-filtered-all --recode --recode-INFO-all --out test_vcftools_Q30_VQSLOD_PASS


echo -e "\nNow work in families!"

cd annovar
echo "Running ANNOVAR"

perl table_annovar.pl ../test_vcftools_Q30_VQSLOD_PASS -buildver hg19 -out ../test_vcftools_Q30_VQSLOD_PASS.myanno -remove \
-protocol refGene,dbnsfp30a,dbscsnv11,gnomad_exome,tfbsConsSites -operation gx,f,f,f,r -nastring . -vcfinput -polish

cd ../

#bcftools view -i "gnomAD_exome_NFE <= 0.05"  test_vcftools_Q30_VQSLOD_PASS.recode.myanno.vcf.hg19_multianno.vcf -o Post_ANNOVAR_MAF_FILTERING_TEST.vcf # This will produce a different result. IN the beginning we filtered for north west EU MAF - now for all non-finnish EU!
