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

for i in $DATA/*_R1_001.fastq.gz
do
        path="${i%_R1*}";
        sample_name=${path##*/};
   
        fastp -i ${DATA}/${sample_name}_R1_001.fastq.gz \
              -I ${DATA}/${sample_name}_R2_001.fastq.gz \
              -o ${OUTDIR}/${sample_name}_R1_001.fastq.gz \
              -O ${OUTDIR}/${sample_name}_R2_001.fastq.gz \
              -h ${OUTDIR}/${sample_name}.fastp.html
done

wait

module load fastqc
DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastq_trimmed
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastqc_trimmed

mkdir -p ${OUTDIR}

for fq in $DATA/*.fastq.gz
do
   fastqc -o ${OUTDIR} --extract ${fq}
   
done 

wait 

cd /globalhome/hxo752/HPC/tools/
multiqc ${OUTDIR}/*_fastqc.zip -o ${OUTDIR}
