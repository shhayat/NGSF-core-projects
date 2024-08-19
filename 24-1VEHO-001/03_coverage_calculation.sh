#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=coverage
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/coverage_calculation/%j.out


fq1=$1; shift
fq2=$1; shift
insert_size=$1;


tool=/globalhome/hxo752/HPC/tools/fastq-info-2.0/bin
fasta_assembly=/project/anderson/genome/sequence.fasta
OUTDIR=/project/anderson/coverage_calculation

mkdir -p ${OUTDIR}
cd ${OUTDIR}

${tool}/fastqinfo-2.0.sh -r ${insert_size} ${fq1} ${fq2} ${fasta_assembly}
