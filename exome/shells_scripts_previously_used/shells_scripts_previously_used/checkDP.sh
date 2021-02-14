

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant het_pat_homRef_controls.vcf -o filt_QUAL50_vqslod_PASS_DP1.vcf -select 'vc.getGenotype("M3060").getDP() >= 5.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP1.vcf -o filt_QUAL50_vqslod_PASS_DP2.vcf -select 'vc.getGenotype("M3326").getDP() >= 5.0'

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP2.vcf  -o filt_QUAL50_vqslod_PASS_DP3.vcf -select 'vc.getGenotype("M4675").getDP() >= 5.0'


rm -r filt_QUAL50_vqslod_PASS_DP1.vcf
rm -r filt_QUAL50_vqslod_PASS_DP1.vcf.idx
rm -r filt_QUAL50_vqslod_PASS_DP2.vcf
rm -r filt_QUAL50_vqslod_PASS_DP2.vcf.idx



java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP3.vcf  -o filt_QUAL50_vqslod_PASS_DP_QD.vcf -select "QD>5.0"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP_QD.vcf -o het_pat_homRef_controls_NonSynon.vcf -select "ExonicFunc.refGene == 'nonsynonymous_SNV'"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP_QD.vcf -o het_pat_homRef_controls_NonSense.vcf -select "ExonicFunc.refGene == 'stopgain'"

java -jar /usr/local/Modules/modulefiles/tools/gatk/3.4.0/GenomeAnalysisTK.jar -R ../../bundle_hg19/ucsc.hg19.fasta -T SelectVariants --variant filt_QUAL50_vqslod_PASS_DP_QD.vcf -o het_pat_homRef_controls_Synonymous.vcf -select "ExonicFunc.refGene == 'synonymous_SNV'"
