#!/bin/bash

#SBATCH --job-name=seurat_run
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=15:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load r/4.3.1
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA-002
#R CMD BATCH ${SCRIPT_DIR}/1_filter_low_quality_reads.R
R CMD BATCH ${SCRIPT_DIR}/2_cluster_analysis.R