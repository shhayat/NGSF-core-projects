#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=trim
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

module purge
module load python/3.10
module load StdEnv/2020
module load scipy-stack/2023a
module load fastp/0.23.4

OUTDIR=/project/anderson/trimmed_fastq

NCPU=1

sample_name=$1; shift
fq1=$1; shift
fq2=$1;

mkdir -p ${OUTDIR}

fastp -i ${fq1} \
       -I ${fq2} \
       -o ${OUTDIR}/${sample_name}_R1.fastq.gz \
       -O ${OUTDIR}/${sample_name}_R2.fastq.gz \
       -h ${OUTDIR}/${sample_name}.fastp.html \
       --thread $NCPU \
       --length_required 100 \
       --average_qual 20 \
       --trim_poly_x \
       --trim_poly_g \
       --detect_adapter_for_pe \
       --unpaired1 ${OUTDIR}/${sample_name}_R1_unpaired.fastq.gz \
       --unpaired2 ${OUTDIR}/${sample_name}_R2_unpaired.fastq.gz
 
