#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=suppa2_psi_calculation
#SBATCH --cpus-per-task=1
#SBATCH --mem=30G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

SUPPA=/globalhome/hxo752/HPC/anaconda3/envs/suppa/bin
events=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/events
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/psi_calculations

mkdir -p $OUTPUT
#psi calculation for events
python3.4 suppa.py psiPerEvent --ioe-file <ioe-file> --expression-file <expression-file> -o $OUTPUT
