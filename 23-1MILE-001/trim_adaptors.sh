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
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis/fastq_trimmed

mkdir -p ${OUTDIR}

for fq in $DATA/R23*_R1.fastq.gz
do
        path="${i%_R*}";
        sample_name=${path##*/};
   
        fastp -i ${OUTDIR}/${sample_name}_S2_L001_R1_001.fastq.gz -I ${OUTDIR}/${sample_name}_S2_L001_R2_001.fastq.gz -o ${OUTDIR}/${sample_name}_S2_L001_R1_001.fastq.gz -O ${OUTDIR}/${sample_name}_S2_L001_R2_001.fastq.gz

   
done 
