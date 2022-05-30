#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux


module load fastqc
DATA=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/depletion_test/human/fastqc

mkdir -p ${OUTDIR}

FASTQ_FILE=$1

#fastqc
fastqc -o ${OUTDIR} --extract ${FASTQ_FILE}
