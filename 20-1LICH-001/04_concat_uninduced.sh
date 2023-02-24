#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:15:00
#SBATCH --mem=2G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
#set -eux

#loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

PROJECT_ID='20-1LICH-001'
INPUT_DIR="${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/mutect2_calling"
CLONE_ID=$1
UNINDUCED_PREP_D1=$2
UNINDUCED_PREP_E1=$3
UNINDUCED_PREP_D2=$4
UNINDUCED_PREP_E2=$5

echo "${INPUT_DIR}/${UNINDUCED_PREP_D1}_${UNINDUCED_PREP_E1}.vcf.gz" >> ${CLONE_ID}_uniduced_vcf.txt
echo "${INPUT_DIR}/${UNINDUCED_PREP_D2}_${UNINDUCED_PREP_E2}.vcf.gz" >> ${CLONE_ID}_uniduced_vcf.txt

#bcftools merge --force-samples ${INPUT_DIR}/${UNINDUCED_PREP_D1}_${UNINDUCED_PREP_E1}.vcf.gz ${INPUT_DIR}/${UNINDUCED_PREP_D2}_${UNINDUCED_PREP_E2}.vcf.gz -o ${INPUT_DIR}/${CLONE_ID}_uninduced_concat.vcf.gz -O z
bcftools concat -a \
                -d all \
                -O z \
                -f ${CLONE_ID}_uniduced_vcf.txt \
                -o ${INPUT_DIR}/${CLONE_ID}_uninduced_concat.vcf.gz 
                
bcftools index -t ${INPUT_DIR}/${CLONE_ID}_uninduced_concat.vcf.gz 
