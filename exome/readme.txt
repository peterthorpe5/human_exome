
### https://www.broadinstitute.org/gatk/guide/article?id=3891
### https://groups.google.com/forum/#!topic/rna-star/pIYXNf8JbVk

### create star index for reads with 100 base length
$ STAR --runThreadN 5 --runMode genomeGenerate --genomeDir indexStar_99 --genomeFastaFiles GRCh38.p2.genome.fa.gz --sjdbGTFfile gencode.v22.chr_patch_hapl_scaff.annotation.gff3.gz --sjdbOverhang 99

### to map...
STAR --runThreadN 10 --genomeDir /storage/home/public/genomes/homo_sapiens/STAR/indexStar_99 --readFilesIn ../../../FASTQ/$1/$1_S1_L002_R1_001.fastq.gz ../../../FASTQ/$1/$1_S1_L002_R2_001.fastq.gz --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat  --twopassMode Basic --bamRemoveDuplicatesType UniqueIdentical

### Picard processing
$ java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/AddOrReplaceReadGroups I=Aligned.sortedByCoord.out.bam O=$1_1.bam SO=coordinate RGID=id RGLB=library RGPL=platform RGPU=machine RGSM=sample 

$ java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates I=rg_added_sorted.bam O=$1_1_mark_duplicates.bam  CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT M=output.metrics 

#### remove 

http://gatkforums.broadinstitute.org/discussion/3893/calling-variants-on-cohorts-of-samples-using-the-haplotypecaller-in-gvcf-mode
explanation: https://www.broadinstitute.org/gatk/guide/article?id=1268
