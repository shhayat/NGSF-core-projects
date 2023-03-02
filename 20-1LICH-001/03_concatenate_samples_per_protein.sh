#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH  --output=%j.out
#set -eux

#loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

INPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis'
OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_samples_per_protein'

mkdir -p ${OUTDIR}

CLONE_ID=$1
SAMPLE1=$2
SAMPLE2=$3
COND=$4 #INDUCED OR UNINDUCED

echo "${INPUT_DIR}/${SAMPLE1}/${SAMPLE1}.vcf.gz" >> ${OUTDIR}/${CLONE_ID}_${COND}_vcf.txt
echo "${INPUT_DIR}/${SAMPLE2}/${SAMPLE2}.vcf.gz" >> ${OUTDIR}/${CLONE_ID}_${COND}_vcf.txt

bcftools concat -a \
                -d all \
                -O z \
                -f ${OUTDIR}/${CLONE_ID}_${COND}_vcf.txt \
                -o ${OUTDIR}/${CLONE_ID}_${COND}_concat_vcf.gz
                
bcftools index -t ${OUTDIR}/${CLONE_ID}_${COND}_concat_vcf.gz
