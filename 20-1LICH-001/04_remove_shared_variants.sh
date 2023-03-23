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

INPUT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_samples_per_protein
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/removed_shared_varaints_between_uninduced_induced
mkdir -p ${OUTDIR}

CLONE_ID=$1
COND=$2

bcftools isec -C \
              -c all \
              -O z \
              -w 1 \
              -o ${OUTDIR}/${CLONE_ID}_I.vcf.gz \
              ${INPUT_DIR}/${CLONE_ID}_I_concat.vcf.gz \
              ${INPUT_DIR}/${CLONE_ID}_U_concat.vcf.gz

bcftools index -t ${OUTDIR}/${CLONE_ID}_I.vcf.gz
