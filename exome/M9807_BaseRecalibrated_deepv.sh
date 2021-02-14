cd /storage/home/users/pjt6/docker/deepvariant/

BIN_VERSION="0.10.0"
    # Run DeepVariant.
/opt/deepvariant/bin/run_deepvariant       --model_type=WES       --ref=ucsc.hg19.fasta       --reads=/storage/home/users/pjt6/docker/deepvariant/M9807_BaseRecalibrated.bam       --output_vcf=/storage/home/users/pjt6/docker/deepvariant/M9807_BaseRecalibrated.vcf       --output_gvcf=/storage/home/users/pjt6/docker/deepvariant/M9807_BaseRecalibrated.g.vcf.gz       --num_shards=10
 