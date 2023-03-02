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

INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_samples_per_protein"
OUTPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/filtered_vcfs'
GENOME='/datastore/NGSF001/analysis/references/human/gencode-30/GRCh38.primary_assembly.genome.fa'
mkdir -p ${OUTPUT_DIR}

CLONE_ID=$1
COND=$2
 

gunzip -k ${INPUT_DIR}/${OUTDIR_NAME}/${CLONE_ID}_${COND}_concat.vcf.gz

#Extract bases C converting. to T or G base
grep -P 'C\tG' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf
grep -P 'C\tT' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf
grep -P 'C\tTG' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf
grep -P 'C\tGT' ${INPUT_DIR}/${CLONE_ID}_${COND}_concat.vcf >> ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf


bedtools flank -i ${OUTPUT_DIR}/${CLONE_ID}_${COND}_concat_filtered.vcf -g ${GENOME} -b 2

