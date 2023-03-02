#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools-filter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mem=2G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

##loading required modules
module load bedtools

INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis"
OUTPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/filtered_vcfs'

mkdir -p ${OUTPUT_DIR}
CLONE_ID=$1
OUTDIR_NAME=$2

#first concatenate all induced and uninduced samples per protein
${INPUT_DIR}/${OUTDIR_NAME}/${OUTDIR_NAME}.vcf.gz

gunzip ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}.vcf.gz
#Extract bases C converting. to T or G base
grep -P 'C\tG' ${INPUT_DIR}/${OUTDIR_NAME}/${OUTDIR_NAME}.vcf.gz >> ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}_filtered.vcf
grep -P 'C\tT' your_vcf_file.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}_filtered.vcf
grep -P 'C\tT/G' your_vcf_file.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}_filtered.vcf
grep -P 'C\tG/T' your_vcf_file.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}_filtered.vcf


bedtools flank -i ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}_filtered.vcf -g ${GENOME} -b 2

