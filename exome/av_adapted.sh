#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  filt1 ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

# extract the variants in gnomAD with PLINK - done
# filter for Q30, vqslod >0, ...

set -e

cd /storage/home/users/av45/exome/reanalysis
gatk="/usr/local/Modules/modulefiles/tools/gatk/3.7.0/"
genome="/storage/home/users/av45/exome/bundle_hg19/"

for i in   recalibrated_MAF0.05nwetest.vcf.vcf #recalibrated_MAF0.02_nwetest.vcf.vcf
do
echo "work on $i"
MAF=$(echo "$i" | cut -d '_' -f2)

# select the variants with qual score more than 30
java -jar ${gatk}/GenomeAnalysisTK.jar -R ${genome}/ucsc.hg19.fasta -T SelectVariants --variant $i -o filt_QUAL50.$MAF.vcf -select "QUAL >= 50.0"

# select the variants with vqslod more than or equal to 0
#java -jar ${gatk}/GenomeAnalysisTK.jar -R ${genome}/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL30.$MAF.vcf -o filt_QUAL30_VQ.$MAF.vcf -select "VQSLOD >= 0.0"

# select only the variants that pass all the filters
#java -jar ${gatk}/GenomeAnalysisTK.jar -R ${genome}/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL30_VQ.$MAF.vcf -o filt_QUAL30_vqslod_PASS.$MAF.vcf -select 'vc.isNotFiltered()'

# Use file avocve, do DP filterign within families
#java -jar ${gatk}/GenomeAnalysisTK.jar -R ${genome}/ucsc.hg19.fasta -T VariantFiltration -o output1.$MAF.vcf --variant filt_QUAL30_vqslod_PASS.$MAF.vcf --genotypeFilterExpression "DP >= 10" --genotypeFilterName  "FT" 

#java -jar ${gatk}/GenomeAnalysisTK.jar -R ${genome}/ucsc.hg19.fasta -T SelectVariants --variant output1.$MAF.vcf -select 'vc.hasAttribute("FT")' -o final_filtered.$MAF.vcf 

done



















