#!/bin/bash

#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:25:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastqc
DATA=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/new_proj/fastqc

OUTDIR=$1
FASTQ_FILE=$2

#fastqc
fastqc -o $OUTDIR --extract ${FASTQ_FILE}

wait

#multiqc
multiqc $OUTDIR/*_fastqc.zip" -o  $OUTDIR
