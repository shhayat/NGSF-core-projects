#!/bin/bash

#SBATCH --job-name=download_tcga
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=10:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/mri_imaging_tcga

module load r/4.1.2

R CMD BATCH ${SCRIPT_DIR}/download_tcga.R
