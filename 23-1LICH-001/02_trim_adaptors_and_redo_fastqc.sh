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

DATA=/datastore/NGSF001/projects/23-1LICH-001/concatenated_latest_fastq_with_previous_fastq
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastq_trimmed

mkdir -p ${OUTDIR}
sample_name=$1;

        fastp -i ${DATA}/${sample_name}_R1.fastq.gz \
              -I ${DATA}/${sample_name}_R2.fastq.gz \
              -o ${OUTDIR}/${sample_name}_R1.fastq_trimmed.gz \
              -O ${OUTDIR}/${sample_name}_R2.fastq_fastq_trimmed.gz \
              -h ${OUTDIR}/${sample_name}.fastp.html
done


module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastq_trimmed
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastqc_trimmed

mkdir -p ${OUTDIR}

fastqc -o ${OUTDIR} --extract ${OUTDIR}/${sample_name}_R1.fastq_trimmed.gz
fastqc -o ${OUTDIR} --extract ${OUTDIR}/${sample_name}_R2.fastq_fastq_trimmed.gz

