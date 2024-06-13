#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=6
#BATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis

mkdir -p ${OUTDIR}/fastqc

for fq in $DATA/MCF7_A3H*.fastq.gz
do
   fastqc -o ${OUTDIR}/fastqc --extract ${fq}
   
done


