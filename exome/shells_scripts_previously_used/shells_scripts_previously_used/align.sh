### Follow the pipeline from http://gatkforums.broadinstitute.org/discussion/3893/calling-variants-on-cohorts-of-samples-using-the-haplotypecaller-in-gvcf-mode
### We use BWA (Burrows Wheeler Aligner) for the alignment of the fasta files.

### Download the (GRCh38/hg38) assembly of the human genome (hg38, GRCh38 Genome Reference Consortium Human Reference 38
wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.2bit'

### Install the twoBitTwoFa command line tool to convert the bit file to fa
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa

### Provide the rights to make it executable
chmod 755 twoBitToFa

### convert the bit file to fasta 
./twoBitToFa hg38.2bit hg38.fa

### Make the index the reference human genome (this may take a while)
### -a bwtw we use the indexing algorithm that is capable of handling the whole human genome
bwa index -a bwtsw hg38.fa

### align with the paired ends sequences
bwa aln -t 12 -n chg38/hg38.fa ../transcriptomics/FASTQ/M3060/M3060_S1_L001_R1_001.fastq.gz > M3060_S1_L001_R1_001.sai
bwa aln -t 12 -n hg38/hg38.fa ../transcriptomics/FASTQ/M3060/M3060_S1_L001_R2_001.fastq.gz > M3060_S1_L001_R2_001.sai

### convert the sai to sam 
bwa sampe hg38/hg38.fa M3060_S1_L001_R1_001.sai M3060_S1_L001_R2_001.sai ../transcriptomics/FASTQ/M3060/M3060_S1_L001_R1_001.fastq.gz ../transcriptomics/FASTQ/M3060/M3060_S1_L001_R2_001.fastq.gz > M3060_S1_L001.sam

### convert the sam to bam binary format
### -O defines the output in bam,sam or cram
samtools fixmate -O bam M3060_S1_L001.sam  M3060_S1_L001_fixmate.bam

### sort bam file to coordinate order
samtools sort -O bam -o M3060_S1_L001_sorted.bam -T out.prefix M3060_S1_L001_fixmate.bam

### create the index for the reference fasta file
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/CreateSequenceDictionary.jar R=hg38.fa O= hg38.dict

##################################################################################################
### picard
### I = input file
### O = output file
### S0 = Optional sort order to output in. Possible values: unsorted, queryname, coordinate, duplicate
### RGID = Read Group ID Default value: 1
### RGLB = Read Group Library Required.
### RGLP = Read Group platform
### RGPU = Read Group platform unit
### RGSM = Read Group sample name 


#java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/AddOrReplaceReadGroups.jar I=M3060_S1_L001_sorted.bam O=M3060_S1_L001.bam SO=coordinate RGID=M3060_S1_L001 RGLB=library RGPL=illumina RGPU=illumina RGSM=M3060


### CREATE INDEX =  create a BAM index when writing a coordinate-sorted BAM file
### Validation_strigency = SILENT: SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded.
### M = metrics for duplication 

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=M3060_S1_L001_sorted.bam O=M3060_S1_L001_duplicates.bam  CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT M=output.metrics


### index the bam file 
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/picard.jar BuildBamIndex I=M3060_S1_L001_duplicates.bam


###############################################################################################
### indel realignment
 
### Minimize the mismatches across all the reads
### Determining (small) suspicious intervals which are likely in need of realignment (RealignerTargetCreator)
### Running the realigner over those intervals (IndelRealigner tool)

echo "Create interval target realignment"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R hg38/hg38.faa -I M3060_S1_L001_duplicates.bam -o M3060_S1_L001_intervalListFromRTC.intervals

echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I M3060_S1_L001_duplicates.bam -R hg38/hg38.fa -targetIntervals M3060_S1_L001_intervalListFromRTC.intervals -o M3060_S1_L001_realigned.bam

####################################################################
### base recalibration
### This tool generates tables based on various user-specified covariates (such as read group, reported quality score, cycle, and context)
### - use the dbSNP 142 that supports both hg19 and hg38, http://genome.ucsc.edu/goldenPath/newsarch.html
### download the dbSNP vcf file  wget ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/VCF/All_20150603.vcf.gz

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R hg38/hg38.fa -I M3060_S1_L001_realigned.bam -knownSites All_20151104.vcf -o M3060_S1_L001_recal_data.grp 


##### ERROR MESSAGE: Input files /storage/home/users/av45/exome/transcriptomics/FASTQ/M3060/All_20151104.vcf and reference have incompatible contigs: No overlapping contigs found.
##### ERROR   /storage/home/users/av45/exome/transcriptomics/FASTQ/M3060/All_20151104.vcf contigs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, X, Y, MT]


### i created the dictionary 
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T BaseRecalibrator -R ../../../mapping/hg38/hg38.fa -I reordered.bam -knownSites All_20151104.vcf -o M3060_recal_data.grp


### use the recalibration table data in M3060_S1_L001_recal_data.grp produced by BaseRecalibration to recalibrate the quality scores 
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T PrintReads -R hg38/hg38.fa -I M3060_S1_L001_realigned.bam -BQSR M3060_S1_L001_recal_data.grp -o M3060_S1_L001_recal.bam



#################################################################################################

### Each individual was run in two lanes. 
### based on http://gatkforums.broadinstitute.org/discussion/3060/how-should-i-pre-process-data-from-multiplexed-sequencing-and-multi-library-designs
### we run align - duplication - realignment and recalibration on each sample individually 

### merge bam files
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/picard.jar MergeSamFiles I=M3060_S1_L001_recal.bam I=M3060_S1_L002_recal.bam O=M3060_S1_merged.bam SORT_ORDER=coordinate


### rerun the markduplication, realignent and recalibration an extra time, to improve results and then, we move on to the HaplotypeCaller for each sample
### Realigning per-sample means that you will have consistent alignments across all lanes within a sample.












#####################################################################
### variant calling

### The program determines which regions of the genome it needs to operate on, based on the presence of significant evidence for variation.
### -stand_call_conf: The minimum phred-scaled confidence threshold at which variants should be called
### -stand_emit_conf: The minimum phred-scaled confidence threshold at which variants should be emitted
### - use the dbSNP 142 that supports both hg19 and hg38, http://genome.ucsc.edu/goldenPath/newsarch.html
### download the dbSNP vcf file  wget ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/VCF/All_20150603.vcf.gz


############ run the haplotypeCaller for each individual separately, to produce gvcf files
#### repeat this analysis for all the samples in the family

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T HaplotypeCaller -R hg38/hg38.fa -I M3060_S1_L001_recal.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp hg38/All_20150603.vcf.gz -o M3060_S1_L001_output_raw_snps_indels.g.vcf


### joint genotype calling
### include all the samples from each family

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T GenotypeGVCFs -R hg38/hg38.fa --variant M3060_S1_output_raw_snps_indels.g.vcf --variant XXXXX_S1_output_raw_snps_indels.g.vcf -stand_call_conf 20 -stand_emit_conf 20 -o family_name.vcf

#####################################################################
### variant recalibration

### first pass
### creating a Gaussian mixture model by looking at the distribution of annotation values over a high quality subset of the input call set, and then scoring all input variants according to the model.

### download the resources from  ftp://ftp.broadinstitute.org/bundle/2.8/hg19/

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T VariantRecalibrator -R hg38/hg38.fa -input family_name.vcf -resource:hapmap,known=false,training=true,truth=true,prior=15.0 -resource:hapmap,known=false,training=true,truth=true,prior=15.0 hapmap_3.3.hg19.sites.vcf -resource:omni,known=false,training=true,truth=false,prior=12.0 1000G_omni2.5.hg19.sites.vcf -resource:1000G,known=false,training=true,truth=false,prior=10.0 1000G_phase1.snps.high_confidence.hg19.sites.vcf -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 dbsnp_138.hg19.vcf -mode BOTH -recalFile output.recal -tranchesFile output.tranches -rscriptFile output.plots.R

### second pass
###  filtering variants based on score cutoffs identified in the first pass

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T ApplyRecalibration -R hg38/hg38.fa -input family_name.vcf --ts_filter_level 99.0 -tranchesFile output.tranches -recalFile output.recal -mode BOTH -o family_nale.recalibrated.filtered.vcf

#################################################################################


