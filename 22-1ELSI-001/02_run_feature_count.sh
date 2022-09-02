#!/bin/bash

#SBATCH --job-name=star-align
#SBATCH --constraint=skylake
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=4:00:00
#SBATCH --mem=80G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1ELSI-001
module load r/4.1.2

R CMD BATCH ${SCRIPT_DIR}/feature_count.R
