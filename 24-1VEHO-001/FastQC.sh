#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=fastqc
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

module load fastqc
#DATA=/project/anderson/concatenated_fastq
#OUTDIR=/project/anderson/FastQC
DATA=/datastore/ChamberlainLab/trimmed_fastqs
OUTDIR=/project/anderson/FastQC_after_trimming
mkdir -p ${OUTDIR}

fq1=$1; shift
fq2=$1;
fastqc -o ${OUTDIR} --extract ${fq1}
fastqc -o ${OUTDIR} --extract ${fq2}
