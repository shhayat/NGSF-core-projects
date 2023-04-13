#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=select_variants
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --mem=2G
#SBATCH  --output=%j.out

##loading required modules for bedtools

#module load bedtools
module load nixpkgs/16.09 
module load gcc/5.4.0
module load intel/2016.4
module load intel/2017.1
module load bedtools

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1SADO-001/analysis/star_alignment

SAMPLE_NAME=$1;
BAM=$2;

bedtools bamtobed -i ${DIR}/${SAMPLE_NAME}/${BAM} > ${DIR}/${SAMPLE_NAME}/${SAMPLE_NAME}.bed
