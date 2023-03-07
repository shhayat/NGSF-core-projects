#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastp
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --mem=6G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastp

DATA=/datastore/NGSF001/projects/23-1MILE-001/Analysis/Fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis

mkdir -p ${OUTDIR}/fastq_trimmed

for fq in $DATA/R23*.fastq.gz
do
   
   fastp -i in.R1.fq.gz -I in.R2.fq.gz -o out.R1.fq.gz -O out.R2.fq.gz

   
done 
