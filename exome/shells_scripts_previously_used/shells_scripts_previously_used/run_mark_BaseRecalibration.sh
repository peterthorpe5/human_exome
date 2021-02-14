
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
if [ ! -f "$1_1_cutNs.ir.bam" ]; then
	echo "File $1_1_cutNs.ir.bam doens't exist for sample $1_1" >> ../../../error_log.txt
	exit 1
fi


echo `pwd`
### Recalibration
echo "Recalibration..."
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -I $1_1_cutNs.bam -I ../2/$1_2_cutNs.bam -o $1.intervalListFromRTC.intervals


cd ..

### making first duplicate sample
if [ ! -d "1" ]; then
	mkdir 1
fi
cd 1

### making first duplicate sample
if [ ! -f "$1_2_cutNs.ir.bam" ]; then
	echo "File $1_2_cutNs.ir.bam doens't exist for sample $1_2" >> ../../../error_log.txt
	exit 1
fi

echo `pwd`
echo "Recalibration..."
java -Xmx8g -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T IndelRealigner -S Silent -I $1_1_cutNs.bam -I ../2/$1_2_cutNs.bam -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -targetIntervals $1.intervalListFromRTC.intervals --nWayOut '.ir.bam'

cd ../..


