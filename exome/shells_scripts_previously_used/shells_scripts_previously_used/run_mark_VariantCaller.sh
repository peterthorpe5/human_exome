
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

### making first duplicate sample
if [ ! -f "../2/$1_2_cutNs.ir.bam" ]; then
	echo "File ../2/$1_2_cutNs.ir.bam doens't exist for sample $1_2" >> ../../../error_log.txt
	exit 1
fi


echo `pwd`
echo "Variant Caller..."
java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -T HaplotypeCaller -R /storage/home/public/genomes/homo_sapiens/STAR/GRCh38.p2.genome.fa -I $1_1_cutNs.ir.bam -I ../2/$1_2_cutNs.ir.bam -stand_call_conf 20 -stand_emit_conf 20 --dbsnp /storage/home/public/genomes/homo_sapiens/dbSNP/All_20150416.vcf.gz -o $1_output.raw.snps.indels.vcf

cd ../..


