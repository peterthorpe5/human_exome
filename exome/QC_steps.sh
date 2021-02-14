#!/bin/bash

module load plink/1.9

~/plink2 --vcf recalibrated.filtered.vcf -mind 0.05 --geno 0.05 --out TEMP2 --make-bed --nonfounders --snps-only --threads 12

plink --bfile TEMP2 --hwe 1e-6 --maf 0.01 --out TEMP3 --nonfounders --make-bed

 ~/plink --bfile TEMP3 --update-ids ../../New_data_Nadine/New_GWAS_Data_01.2020_NEW/2019-266-ILL_DIVUNJ_N\=322/update_ids --out TEMP4 --make-bed

plink --bfile TEMP4 --check-sex --nonfounders --make-bed

grep 'PROBLEM'  plink.sexcheck > sex_issues.txt

awk '{print $1, $2,$4}' sex_issues.txt > update_sex

#sed -i '1s/^/#FID#IID\tSEX\n/' update_sex

plink --bfile TEMP4 --update-sex update_sex --out TEMP5 --make-bed

# Check heterozigosity
# Find unrelated SNPs
~/plink --bfile TEMP5 -indep-pairwise 50 5 0.2 --out indepSNP

plink --bfile TEMP5 --extract indepSNP.prune.in --het --out R_check

Rscript --no-save check_heterozygosity_rate.R

Rscript --no-save heterozygosity_outliers_list.R

sed 's/"// g' fail-het-qc.txt | awk '{print$1, $2}'> het_fail_ind.txt

# Remove heterozygosity rate outliers.
plink --bfile TEMP5 --remove het_fail_ind.txt --make-bed --out TEMP6


# Check relatedness

#~/plink --vcf recalibrated.filtered.vcf --indep-pairwise 50 5 0.2 --out indepSNP --threads 12 --allow-extra-chr

~/plink2  --allow-extra-chr --make-king-table --threads 12 --vcf 
