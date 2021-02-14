
echo $1
cd mapping

#### test directory
if [ ! -d "$1" ]; then
	mkdir $1
fi
cd $1

### making first duplicate sample
if [ ! -d "1" ]; then
	mkdir 1
fi
cd 1

### making first duplicate sample
if [ ! -f "$1_1_mark_duplicates.bam" ]; then
	echo "File $1_1_mark_duplicates.bam doens't exist for sample $1_1" >> ../../../error_log.txt
	exit 1
fi

echo `pwd`
### mapping
### Two passing modes on the fly...
### https://groups.google.com/forum/#!topic/rna-star/pIYXNf8JbVk
### https://www.broadinstitute.org/gatk/guide/article?id=3891

## cigar = mismatches 
## SplitNCigarReads = https://www.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_rnaseq_SplitNCigarReads.php
## ReassignOneMappingQuality: At this step we also add one important tweak: we need to reassign mapping qualities, because STAR assigns good alignments a MAPQ of 255 (which technically means “unknown” and is therefore meaningless to GATK). So we use the GATK’s ReassignOneMappingQuality read filter to reassign all good alignments to the default value of 60. 

echo "Cutting intron/exons Ns for first replication: $1"
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SplitNCigarReads -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -I $1_1_mark_duplicates.bam -o $1_1_cutNs.bam -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS

cd ..
### making first duplicate sample
if [ ! -d "2" ]; then
	mkdir 2
fi
cd 2

### making first duplicate sample
if [ ! -f "$1_2_mark_duplicates.bam" ]; then
	echo "File $1_2_mark_duplicates.bam doens't exist for sample $1_2" >> ../../../error_log.txt
	exit 1
fi

echo `pwd`
### mapping
echo "Cutting intron/exons Ns for second replication: $1"
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T SplitNCigarReads -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -I $1_2_mark_duplicates.bam -o $1_2_cutNs.bam -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS

cd ../..


