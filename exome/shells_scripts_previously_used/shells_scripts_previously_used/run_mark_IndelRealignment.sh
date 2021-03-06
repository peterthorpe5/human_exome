
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
if [ ! -f "$1_1_cutNs.bam" ]; then
	echo "File $1_1_cutNs.bam doens't exist for sample $1_1" >> ../../../error_log.txt
	exit 1
fi

### making first duplicate sample
if [ ! -f "../2/$1_2_cutNs.bam" ]; then
	echo "File $1_2_cutNs.bam doens't exist for sample $1_2" >> ../../../error_log.txt
	exit 1
fi


echo `pwd`
### indel realignment
### Two passing modes on the fly...
### http://gatkforums.broadinstitute.org/discussion/5274/tumour-normal-exome-analysis-for-non-human-data

### https://www.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_indels_RealignerTargetCreator.php 
### Minimize the mismatches across all the reads
### Determining (small) suspicious intervals which are likely in need of realignment (RealignerTargetCreator)
### Running the realigner over those intervals (IndelRealigner tool)

### input: bam output file from reassingMapping Quality.  

echo "Create interval target realignment"
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -I $1_1_cutNs.bam -I ../2/$1_2_cutNs.bam -o $1.intervalListFromRTC.intervals

echo "Realignment"
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $1_1_cutNs.bam -I ../2/$1_2_cutNs.bam -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -targetIntervals $1.intervalListFromRTC.intervals --nWayOut '.ir.bam'

mv $1_2_cutNs.ir.bai ../2
mv $1_2_cutNs.ir.bam ../2

cd ../..


