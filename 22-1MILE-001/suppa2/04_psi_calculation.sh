#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=ivybridge
#SBATCH --job-name=suppa2_psi_calculation
#SBATCH --cpus-per-task=1
#SBATCH --mem=30G
#SBATCH --time=24:00:00
#SBATCH --output=%j.out

module load python

SUPPA=/globalhome/hxo752/HPC/anaconda3/envs/suppa/bin
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/tpm/
events=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/events
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/psi_calculations

mkdir -p ${OUTPUT}

sample_name=$1;

#psi calculation for events
python suppa.py psiPerEvent \
                --ioe-file ${events}/events_from_gtf_AL_strict.ioe \
                --expression-file ${DATA}/${sample_name}/qunat.sf \
                -o ${OUTPUT}
