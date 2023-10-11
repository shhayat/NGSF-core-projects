#!/bin/bash

#SBATCH --job-name=feature-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=3:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001
module load r/4.0.2

R CMD BATCH ${SCRIPT_DIR}/06_feature_count.R
