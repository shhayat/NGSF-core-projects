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

INPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/alignment'
OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_induced_uninduced_samples'

mkdir -p ${OUTDIR}

CLONE_ID=$1; shift
sample_1=$1; shift
sample_2=$1; shift
sample_info=$1

echo "${INPUT_DIR}/${sample_1}/${sample_1}.vcf.gz" >> ${OUTDIR}/${CLONE_ID}_${sample_info}_vcf.txt
echo "${INPUT_DIR}/${sample_2}/${sample_2}.vcf.gz" >> ${OUTDIR}/${CLONE_ID}_${sample_info}_vcf.txt

bcftools concat -a \
                -d all \
                -O z \
                -f ${OUTDIR}/${CLONE_ID}_${sample_info}_vcf.txt \
                -o ${OUTDIR}/${CLONE_ID}_${sample_info}_concat.vcf.gz 
                
bcftools index -t ${OUTDIR}/${CLONE_ID}_${sample_info}_concat.vcf.gz 



