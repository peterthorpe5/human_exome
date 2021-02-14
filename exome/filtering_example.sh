#! -cwd

cd /storage/home/users/av45/exome/reanalysis/

module load plink/2.0 # this is the one that works

# to get some help
plink2 --help -extract-if-info

# MAF is minor allele frequency. 
# this is done to extract the SNPs in NOTHER WESTERN EUROPEAN that occur less than 
# 5% allele freuqncy.  or 2% for the next command 
plink2 --vcf ../gnomad/gnomad.exomes.r2.1.1.sites.vcf.bgz --extract-if-info AF_nfe_nwe'<'0.05 \
--out filter0.05.North_western_euro --write-snplist --threads 16

# 0.2
plink2 --vcf ../gnomad/gnomad.exomes.r2.1.1.sites.vcf.bgz --extract-if-info AF_nfe_nwe'<'0.02 \
--out filter0.02.North_western_euro --write-snplist --threads 16


# now to filter based on those low freq SNPs we have just got
plink2 --help extract

plink2 --vcf recalibrated.filtered.vcf --extract filter0.05.North_western_euro.snplist \
--export vcf --out recalibrated_MAF0.05nwetest.vcf --allow-extra-chr

plink2 --vcf recalibrated.filtered.vcf --extract filter0.02.North_western_euro.snplist \
--export vcf --out recalibrated_MAF0.02nwetest.vcf --allow-extra-chr




# EXTRA software for later 
# annovar to annotate the SNPs. 
# http://annovar.openbioinformatics.org/en/latest/user-guide/download/

# VEP
# https://www.ensembl.org/info/docs/tools/vep/index.html
# conda install -c bioconda ensembl-vep

# http://www.mutationtaster.org/

# http://genetics.bwh.harvard.edu/pph2/dokuwiki/downloads

# https://sift.bii.a-star.edu.sg/ 

# snpeffect


