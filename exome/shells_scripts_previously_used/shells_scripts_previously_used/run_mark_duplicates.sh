
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
if [ ! -f "Aligned.sortedByCoord.out.bam" ]; then
	exit 1
fi

echo `pwd`
### mapping
### Two passing modes on the fly...
### https://groups.google.com/forum/#!topic/rna-star/pIYXNf8JbVk
### https://www.broadinstitute.org/gatk/guide/article?id=3891

### I = input file
### O = output file
### S0 = Optional sort order to output in. Possible values: unsorted, queryname, coordinate, duplicate
### RGID = Read Group ID Default value: 1
### RGLB = Read Group Library Required.
### RGLP = Read Group platform
### RGPU = Read Group platform unit
### RGSM = Read Group sample name 

echo "Mapping first duplicate: $1"
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/AddOrReplaceReadGroups.jar I=Aligned.sortedByCoord.out.bam O=$1_1.bam SO=coordinate RGID=$1_1 RGLB=library RGPL=illumina RGPU=illumina RGSM=$1


### CREATE INDEX =  create a BAM index when writing a coordinate-sorted BAM file
### Validation_strigency = SILENT: SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded.### M = metrics for duplication 
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$1_1.bam O=$1_1_mark_duplicates.bam  CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT M=output.metrics 


cd ..
### making first duplicate sample
if [ ! -d "2" ]; then
	mkdir 2
fi
cd 2

### making first duplicate sample
if [ ! -f "Aligned.sortedByCoord.out.bam" ]; then
	exit 1
fi

### mapping
echo "Mapping second duplicate: $1 "
java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/AddOrReplaceReadGroups.jar I=Aligned.sortedByCoord.out.bam O=$1_2.bam SO=coordinate RGID=$1_2 RGLB=library RGPL=illumina RGPU=illumina RGSM=$1

java -jar /usr/local/Modules/modulefiles/tools/picard-tools/1.119/MarkDuplicates.jar I=$1_2.bam O=$1_2_mark_duplicates.bam  CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT M=output.metrics 

cd ../..


