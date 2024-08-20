#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=1
#SBATCH --time=10:00:00
#SBATCH --mem=60G
#SBATCH --output=%j.out
set -eux

module load bowtie2/2.5.2 

GENOME=/project/anderson/genome
OUTDIR=/project/anderson/index

bowtie2-build ${GENOME}/sequence.fasta ${OUTDIR}/bowtie_index
