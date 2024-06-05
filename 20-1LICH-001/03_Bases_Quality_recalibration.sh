#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=recalibrate
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=10G
#SBATCH  --output=%j_recalibrate.out

module load StdEnv/2020
module load gatk/4.2.2.0

OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/alignment
REF=/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa
gatk_resource=/datastore/NGSF001/analysis/gatk_resource_bundle

sample_name=$1; shift
BAM_FILE=$1;

mkdir -p $OUTDIR/$sample_name

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" BaseRecalibrator \
  -I ${BAM_FILE} \
  -R ${REF} \
  -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  --known-sites ${gatk_resource}/Homo_sapiens_assembly38.dbsnp138.vcf \
  --known-sites ${gatk_resource}/1000G_phase1.snps.high_confidence.hg38.vcf.gz

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" ApplyBQSR \
  -I ${BAM_FILE} \
  -R ${REF} \
  --bqsr-recal-file ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  -O ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam
