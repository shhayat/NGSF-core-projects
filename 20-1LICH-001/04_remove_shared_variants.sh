#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

##loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

PROJECT_ID='20-1LICH-001'
INPUT_DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis"
CLONE_ID=$1
PREP1=$2
PREP2=$3

mkdir -p ${INPUT_DIR}/filtered_vcfs
OUTPUT_DIR='${INPUT_DIR}/filtered_vcfs'

bcftools isec -C \
              -c none \
              -O z \
              -w 1 \
              -o ${OUTPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}.vcf.gz \
              ${INPUT_DIR}${PREP1}_${PREP2}.vcf.gz \
              ${INPUT_DIR}${CLONE_ID}_uninduced_concat.vcf.gz

bcftools index -t ${OUTPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}.vcf.gz
