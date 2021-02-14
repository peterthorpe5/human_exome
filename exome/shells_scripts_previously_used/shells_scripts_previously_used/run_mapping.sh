
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

echo `pwd`
### mapping
### Two passing modes on the fly...
### https://groups.google.com/forum/#!topic/rna-star/pIYXNf8JbVk
### https://www.broadinstitute.org/gatk/guide/article?id=3891
### runThreadN: how many thread to use to preform the alignment
### genomeDir: the path for the index directory for the reference 
### readFilesIn: the fastaq files
### outSAMtype BAM SortedByCoordinate: sort with coordinate (similar to sort of samtools)
### readFilesCommand zcat: uncompress
### twopassMode Basic: recent command that preforms the two passes on the fly(https://github.com/alexdobin/STAR/releases)
### --bamRemoveDuplicatesType UniqueIdentical: mark all multimappers, and duplicate unique mappers. The coordinates, FLAG, CIGAR must be identical (why do we need that? afterward we makr the duplicates with piccard otherwise)



echo "Mapping first duplicate: $1"
STAR --runThreadN 12 --genomeDir /storage/home/public/genomes/homo_sapiens/STAR/indexStar_99 --readFilesIn ../../../FASTQ/$1/$1_S1_L001_R1_001.fastq.gz ../../../FASTQ/$1/$1_S1_L001_R2_001.fastq.gz --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat --twopassMode Basic --bamRemoveDuplicatesType UniqueIdentical


cd ..
### making first duplicate sample
if [ ! -d "2" ]; then
	mkdir 2
fi
cd 2


### mapping
echo "Mapping second duplicate: $1 "
STAR --runThreadN 12 --genomeDir /storage/home/public/genomes/homo_sapiens/STAR/indexStar_99 --readFilesIn ../../../FASTQ/$1/$1_S1_L002_R1_001.fastq.gz ../../../FASTQ/$1/$1_S1_L002_R2_001.fastq.gz --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat --twopassMode Basic --bamRemoveDuplicatesType UniqueIdentical

cd ../..


