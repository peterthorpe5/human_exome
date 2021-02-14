#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  vep ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

perl variant_effect_predictor.pl --cache -i ../../../family_analysis/filt_QUAL50_vqslod_PASS_DP.vcf  -o ../../../family_analysis/filt_QUAL50_vqslod_PASS_DP_vepAnnotation.vcf
