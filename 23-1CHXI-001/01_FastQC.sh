#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001analysis/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis
mkdir -p ${OUTDIR}/fastqc

fq1=$1; shift
fq2=$1;
fastqc -o ${OUTDIR}/fastqc --extract ${fq1}
fastqc -o ${OUTDIR}/fastqc --extract ${fq2}
