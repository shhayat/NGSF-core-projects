#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastp
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=3:00:00
#SBATCH --mem=20G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

module load fastp

DATA=/datastore/NGSF001/projects/23-1CHXI-001/Fastq
OUTDIR1=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/fastq_trimmed

mkdir -p ${OUTDIR1}
sample_name=$1;

       fastp -i ${DATA}/${sample_name}_R1.fastq.gz \
             -I ${DATA}/${sample_name}_R2.fastq.gz \
             -o ${OUTDIR1}/${sample_name}_R1.trimmed.fastq.gz \
             -O ${OUTDIR1}/${sample_name}_R2.trimmed.fastq.gz \
             -h ${OUTDIR1}/${sample_name}.fastp.html

module load fastqc
OUTDIR2=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/fastqc_trimmed

mkdir -p ${OUTDIR2}

fastqc -o ${OUTDIR2} --extract ${OUTDIR1}/${sample_name}_R1.trimmed.fastq.gz
fastqc -o ${OUTDIR2} --extract ${OUTDIR1}/${sample_name}_R2.trimmed.fastq.gz
