#!/bin/bash

#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=00:30:00
#SBATCH --mem=4G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastqc
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/new_proj/fastqc

FASTQ_FILE=$1

#fastqc
fastqc -o $OUTDIR --extract ${FASTQ_FILE}
