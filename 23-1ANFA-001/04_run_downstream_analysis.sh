#!/bin/bash

#SBATCH --job-name=seurat_run
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=15:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

#R4.3.2 used by the r-seurat env
source $HOME/.bashrc
conda activate /globalhome/hxo752/HPC/anaconda3/envs/r-seurat

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANFA-001
#R CMD BATCH ${SCRIPT_DIR}/1_filter_low_Quality_reads.R
R CMD BATCH ${SCRIPT_DIR}/2_batchCorrection_and_FindMarkerGenes.R
conda deactivate
