from collections import defaultdict
import os

old = """/storage/home/users/av45/exome/gatk/FASTQ/M3060/sorted_reads.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/sorted_1.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/duplicates.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/duplicates_addReplace.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/realigned.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/realigned_AddReplace.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/reordered.bam
/storage/home/users/av45/exome/gatk/FASTQ/M3060/M3060_S1_L001_recal.bam
/storage/home/users/av45/exome/gatk/M3060/mergedLanes/M3060_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3290/mergedLanes/M3290_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3294/mergedLanes/M3294_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M7767/mergedLanes/M7767_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4299/mergedLanes/M4299_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3328/mergedLanes/M3328_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M9806/mergedLanes/M9806_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4305/mergedLanes/M4305_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M8750/mergedLanes/M8750_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M9807/mergedLanes/M9807_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4303/mergedLanes/M4303_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M7766/mergedLanes/M7766_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M9804/mergedLanes/M9804_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M8992/mergedLanes/M8992_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3329/mergedLanes/M3329_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3061/mergedLanes/M3061_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3300/mergedLanes/M3300_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M9805/mergedLanes/M9805_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4300/mergedLanes/M4300_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M7769/mergedLanes/M7769_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3622/mergedLanes/M3622_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M8988/mergedLanes/M8988_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M9810/mergedLanes/M9810_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4298/mergedLanes/M4298_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M9814/mergedLanes/M9814_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4675/mergedLanes/M4675_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3326/mergedLanes/M3326_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M4297/mergedLanes/M4297_BaseRecalibrated.bam
/storage/home/users/av45/exome/gatk/M3293/mergedLanes/M3293_BaseRecalibrated.bam""".split()
bams = []
for i in old:
    new = os.path.split(i)[-1]
    new2 = "/storage/home/users/pjt6/docker/deepvariant/%s" % new
    bams.append(new2)
    #print(bams)



for entry in bams:
    family = os.path.split(entry)[-1]
    print(family)
    family = family.rstrip()
    outsh = "%s_deepv.sh" % family.split(".bam")[0]
    f_out = open(outsh, "w")
    # 6 cores, so only 1 runs on a "node*" at a time. 
    #print("\nqsub -l hostname=phylo -pe multi 10 -l singularity -b y singularity run /storage/home/users/pjt6/docker/deepvariant/deepvariant_0.10.0.sif /storage/home/users/pjt6/docker/deepvariant/%s_deepv.sh\n" % family.split(".bam")[0])
    #f_out.write("#!/bin/bash\n")
    #f_out.write("#$ -cwd\n")
    #f_out.write("#$ -pe multi 2\n")
    f_out.write("cd /storage/home/users/pjt6/docker/deepvariant/\n")
    deepv_cmd = """
        LC_ALL = "en_US.UTF-8"
        LC_CTYPE = "en_US.UTF-8"
        LANG = "en_US.UTF-8"

BIN_VERSION="0.10.0"
    # Run DeepVariant.
/opt/deepvariant/bin/run_deepvariant \
      --model_type=WES \
      --ref=ucsc.hg19.fasta \
      --reads=%s \
      --output_vcf=/storage/home/users/pjt6/docker/deepvariant/%s.vcf \
      --output_gvcf=/storage/home/users/pjt6/docker/deepvariant/%s.g.vcf.gz \
      --num_shards=10\n """ % (entry, entry.split(".bam")[0], entry.split(".bam")[0])
                              

    f_out.write(deepv_cmd)

    f_out.close()
    
