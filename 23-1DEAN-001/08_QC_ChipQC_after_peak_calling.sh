#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC-chipqc
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=%j.out

/globalhome/hxo752/HPC/anaconda3/envs/bioconductor-chipqc/bin/
Rscript QC_after_peak_calling.R
