#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N  VQSR_indel ## job name
#$ -S /bin/bash
#$ -cwd ## Execute the job from the current working directory
#$ -q lowmemory.q ## queue name

### variant recalibration

### first pass
### creating a Gaussian mixture model by looking at the distribution of annotation values over a high quality subset of the input call set, and then scoring all input variants according to the model.

### description of the arguments in the resources 
# the known arguments is not being used at all by the algorithm, it is just to decide in the end which variants are known and which novel according to the database specified.
# training argument defines which databases will be used to create the gaussian mixture model. 
# true defines which databases will be used to define the true sensitivity and specificity of the called variants. After training is done, what level shall I cut the variants. what pecentage of sites overlap with the true sets that I have retained in my callset. For example, retain X% of the calls that were originally in the database specified.    
## the model is a bayesian model therefore prior is the prior probability that any variant that was found in this database was true. 

## for example prior=15 means probability equals to 98.9% of a variant is true by simpy being a member of hapmap
## prior = 6 means 87% probability of the variant is true by just being a member of omni.
## the percentages are being decided by experience using the databases

### in our case we will use all the datasets for training but we use only the 1000G project to define the tru sensitivity. This is because our variants are expected to be rare and the 1000 genome project has many variants in low allele frequency compared to hapmap

### download the resources from ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/b37/ 


##########################################################
## annotation being used to call the variants

### all the variant annotators can be found here: https://www.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_annotator_BaseQualityRankSumTest.php
### Below I just mention the ones used for the variant recalibraiton here.

### ***** rankSumTest may not work on Variant recalibration. ******

## QD This annotation puts the variant confidence QUAL score into perspective by normalizing for the amount of coverage available. Because each read contributes a little to the QUAL score, variants in regions with deep coverage can have artificially inflated QUAL scores, giving the impression that the call is supported by more evidence than it really is. To compensate for this, we normalize the variant confidence by depth, which gives us a more objective picture of how well supported the call is. The QD is the QUAL score normalized by allele depth (AD) for a variant

## MQ: This annotation provides an estimation of the mapping quality of reads supporting each alternate allele in a variant call. It outputs a version of this annotation that includes all alternate alleles in a single calculation.

## MQRankSum: This variant-level annotation compares the mapping qualities of the reads supporting the reference allele with those supporting each alternate allele. To be clear, it does so separately for each alternate allele.The ideal result is a value close to zero, which indicates there is little to no difference. A negative value indicates that the reads supporting the alternate allele have lower mapping quality scores than those supporting the reference allele. Conversely, a positive value indicates that the reads supporting the alternate allele have higher mapping quality scores than those supporting the reference allele.

## ReadPosRankSum: This variant-level annotation tests whether there is evidence of bias in the position of alleles within the reads that support them, between the reference and each alternate allele. To be clear, it does so separately for each alternate allele.Seeing an allele only near the ends of reads is indicative of error, because that is where sequencers tend to make the most errors. However, some variants located near the edges of sequenced regions will necessarily be covered by the ends of reads, so we can't just set an absolute "minimum distance from end of read" threshold. That is why we use a rank sum test to evaluate whether there is a difference in how well the reference allele and the alternate allele are supported.

## SOR: Symmetric Odds Ratio of 2x2 contingency table to detect strand bias, Strand bias is a type of sequencing bias in which one DNA strand is favored over the other, which can result in incorrect evaluation of the amount of evidence observed for one allele vs. the other.



## FS: Strand bias is a type of sequencing bias in which one DNA strand is favored over the other, which can result in incorrect evaluation of the amount of evidence observed for one allele vs. the other.The AS_FisherStrand annotation is one of several methods that aims to evaluate whether there is strand bias in the data. 

## AB: This is an experimental annotation that attempts to estimate whether the data supporting a heterozygous genotype call fits allelic ratio expectations, or whether there might be some bias in the data.

## BaseCounts: This annotation returns the counts of A, C, G, and T bases across all samples, in that order.

## AF: Allele Frequency, for each ALT allele, in the same order as listed

## AC: Allele count in genotypes, for each ALT allele, in the same order as listed

## AN: Total number of alleles in called genotypes

## DP: Approximate read depth; some reads may have been filtered

## AD: gives the unfiltered count of reads that support a given allele for an individual sample.

## GC: The GC content is the number of GC bases relative to the total number of bases (# GC bases / # all bases) around this site on the reference. Some sequencing technologies have trouble with high GC content because of the stronger bonds of G-C nucleotide pairs, so high GC values tend to be associated with low coverage depth and lower confidence calls. 





java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T VariantRecalibrator -R bundle_hg19/ucsc.hg19.fasta -input total.vcf -resource:hapmap,known=false,training=true,truth=false,prior=10.0 ../bundle_hg19/hapmap_3.3.hg19.sites.vcf -resource:omni,known=false,training=true,truth=false,prior=12.0 ../bundle_hg19/1000G_omni2.5.hg19.sites.vcf -resource:1000G,known=false,training=true,truth=true,prior=15.0 ../bundle_hg19/1000G_phase1.indels.hg19.sites.vcf -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 bundle_hg19/dbsnp_138.hg19.vcf -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an AF -an AC -an DP -mode INDEL -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 100.0 -recalFile output.indels.recal -tranchesFile output.indels.tranches -rscriptFile output2.plots.indels.R

### second pass
###  filtering variants based on score cutoffs identified in the first pass

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T ApplyRecalibration -R bundle_hg19/ucsc.hg19.fasta -input total.vcf --ts_filter_level 90.0 -tranchesFile output.indels.tranches -recalFile output.indels.recal -mode INDEL -o recalibrated.filtered.indels.vcf


