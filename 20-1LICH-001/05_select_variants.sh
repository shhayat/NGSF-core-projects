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

OUTPUT_DIR=

CLONE_ID=$1
INDUCED_SAMPLE=$2
#Extract C to T or G 
bedtools flank [OPTIONS] -i ${OUTPUT_DIR}/${CLONE_ID}_${INDUCED_SAMPLE}.vcf.gz -g <GENOME> -b 2

