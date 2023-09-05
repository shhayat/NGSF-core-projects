#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=markdup_add_RG
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=4:00:00
#SBATCH --mem=40G
#SBATCH  --output=recalibrate.out

module load gatk/4.2.5.0 

#DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment
REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome.fa
dbsnp=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/dbsnp
sample_name=$1; shift
BAM_FILE=$1;

gatk --java-options "-Xmx2G" BaseRecalibrator \
  -I ${BAM_FILE} \
  -R ${REF} \
  -O ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  --known-sites ${dbsnp}/Homo_sapiens_assembly38.dbsnp138.vcf.gz \
  --known-sites ${dbsnp}/1000G_phase1.snps.high_confidence.hg38.vcf.gz

gatk --java-options "-Xmx2G" ApplyBQSR \
  -I ${BAM_FILE} \
  -R ${REF} \
  --bqsr-recal-file ${OUTDIR}/${sample_name}/${sample_name}_recal_data.table \
  -O ${OUTDIR}/${sample_name}/${sample_name}_bqsr.bam
