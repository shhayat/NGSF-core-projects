#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/fastqc

mkdir -p ${OUTDIR}

fq1=$1; shift
fq2=$1;
fastqc -o ${OUTDIR}/fastqc --extract ${fq1}
fastqc -o ${OUTDIR}/fastqc --extract ${fq2}
