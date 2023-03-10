#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=gatk-pon
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#loading required modules
module load gatk/4.2.2.0

INPUT_DIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis'
OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/panel_of_normal'

mkdir -p ${OUTDIR}

CLONE_ID=$1
SAMPLE1=$2
SAMPLE2=$3
COND=$4 #INDUCED OR UNINDUCED

gatk CreateSomaticPanelOfNormals \
   -vcfs ${INPUT_DIR}/${SAMPLE1}/${SAMPLE1}.vcf.gz \
   -vcfs ${INPUT_DIR}/${SAMPLE2}/${SAMPLE2}.vcf.gz \
   -O ${OUTDIR}/${CLONE_ID}_${COND}_pon.vcf.gz
