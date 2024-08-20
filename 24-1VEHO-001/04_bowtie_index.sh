#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --output=%j.out
set -eux

cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64

GENOME=/project/anderson/genome
OUTDIR=/project/anderson/

bowtie2-build ${GENOME}/sequence.fasta ${OUTDIR}/bowtie_index
