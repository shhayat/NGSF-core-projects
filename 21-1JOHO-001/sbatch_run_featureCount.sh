#!/bin/bash

#SBATCH --job-name=feature-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=3:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out
set -eux

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1JOHO-001
module load r/4.1.2

R CMD BATCH ${SCRIPT_DIR}/01_feature_count.R
