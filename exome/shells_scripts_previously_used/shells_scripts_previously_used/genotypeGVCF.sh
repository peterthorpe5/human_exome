#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  gvcf ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

PATH=$PATH:/usr/local/Modules/modulefiles/tools/samtools/1.2/bin
export PATH

### call GenotypeVCFs on all samples
### joint variant calling

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T GenotypeGVCFs -R bundle_hg19/ucsc.hg19.fasta --variant M3060/mergedLanes/M3060.g.vcf --variant M3290/mergedLanes/M3290.g.vcf --variant M3294/mergedLanes/M3294.g.vcf --variant M3326/mergedLanes/M3326.g.vcf --variant M3329/mergedLanes/M3329.g.vcf --variant M4297/mergedLanes/M4297.g.vcf --variant M4299/mergedLanes/M4299.g.vcf --variant M4303/mergedLanes/M4303.g.vcf --variant M4675/mergedLanes/M4675.g.vcf --variant M7767/mergedLanes/M7767.g.vcf --variant M8750/mergedLanes/M8750.g.vcf --variant M8992/mergedLanes/M8992.g.vcf --variant M9805/mergedLanes/M9805.g.vcf --variant M9807/mergedLanes/M9807.g.vcf --variant M9814/mergedLanes/M9814.g.vcf --variant M3061/mergedLanes/M3061.g.vcf --variant M3293/mergedLanes/M3293.g.vcf --variant M3300/mergedLanes/M3300.g.vcf --variant M3328/mergedLanes/M3328.g.vcf --variant M3622/mergedLanes/M3622.g.vcf --variant M4298/mergedLanes/M4298.g.vcf --variant M4300/mergedLanes/M4300.g.vcf --variant M4305/mergedLanes/M4305.g.vcf --variant M7766/mergedLanes/M7766.g.vcf --variant M7769/mergedLanes/M7769.g.vcf --variant M8988/mergedLanes/M8988.g.vcf --variant M9804/mergedLanes/M9804.g.vcf --variant M9806/mergedLanes/M9806.g.vcf --variant M9810/mergedLanes/M9810.g.vcf --dbsnp bundle_hg19/dbsnp_138.hg19.vcf -stand_call_conf 20 -stand_emit_conf 20 -o total.vcf

