#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=coverage
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out


fq1=$1; shift
fq2=$1; shift
insert_size=$1;


fastq-info=/globalhome/hxo752/HPC/tools/fastq-info-2.0/bin
fasta_assembly=/project/anderson/genome/sequence.fasta
OUTDIR=/project/anderson/coverage_calculation

midir -p ${OUTDIR}
cd ${OUTDIR}

${fastq-info}/fastqinfo-2.0.sh ${fq1} ${fq2} ${fasta_assembly} ${insert_size}
