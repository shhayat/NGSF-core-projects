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
OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis'

CLONE_ID=$1; shift
UNINDUCED_1=$3; shift
UNINDUCED_2=$4

echo "${INPUT_DIR}/${SAMPLE_ID}/${UNINDUCED_1}/${UNINDUCED_1}.vcf.gz" >> ${CLONE_ID}_uniduced_vcf.txt
echo "${INPUT_DIR}/${SAMPLE_ID}/${UNINDUCED_2}/${UNINDUCED_2}.vcf.gz" >> ${CLONE_ID}_uniduced_vcf.txt

bcftools concat -a \
                -d all \
                -O z \
                -f ${CLONE_ID}_uniduced_vcf.txt \
                -o ${INPUT_DIR}/${CLONE_ID}_uninduced_concat.vcf.gz 
                
bcftools index -t ${INPUT_DIR}/${CLONE_ID}_uninduced_concat.vcf.gz 
