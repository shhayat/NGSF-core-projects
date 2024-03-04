#!/bin/bash

#SBATCH --job-name=feature-count
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=15:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load r/4.3.1
conda activate /globalhome/hxo752/HPC/anaconda3/envs/r-seurat

#R CMD BATCH ${SCRIPT_DIR}/1_filter_low_Quality_reads.R
R CMD BATCH ${SCRIPT_DIR}/2_batchCorrection_and_FindMarkerGenes.R
