#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH  --output=%j.out

set -eux

##loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis"
CONCATE_UNINDUCED="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_uninduced_samples"
mkdir -p ${INPUT_DIR}/filtered_vcfs
OUTPUT_DIR='${INPUT_DIR}/filtered_vcfs'
CLONE_ID=$1
INDUCED_SAMPLE=$2


bcftools isec -C \
              -c none \
              -O z \
              -w 1 \
              -o ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}.vcf.gz \
              ${INPUT_DIR}/${INDUCED_SAMPLE}/${INDUCED_SAMPLE}.vcf.gz \
              ${CONCATE_UNINDUCED}/${CLONE_ID}_uninduced_concat.vcf.gz

bcftools index -t ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}.vcf.gz
