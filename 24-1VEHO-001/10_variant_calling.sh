#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=mykrobe
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=120:00:00
#SBATCH --mem=10G
#SBATCH --output=/project/anderson/%j.out


source /globalhome/hxo752/HPC/.bashrc
sample_name=$1;
NCPU=2

mtbseq=/globalhome/hxo752/HPC/miniconda/bin
OUTDIR=/project/anderson/variant_calling
DATA=/project/anderson/trimmed_fastq

${mtbseq}/MTBseq  --step TBfull \
                  --threads 8
