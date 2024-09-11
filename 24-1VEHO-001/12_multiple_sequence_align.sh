#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=msa
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=20G
#SBATCH --output=/project/anderson/%j.out



fasta_files=/project/anderson/fasta_files
NCPU=10

/globalhome/hxo752/HPC/miniconda/conda-meta/clustalo -i ${fasta_files}/combined_sequences.fasta \
                                                     -o ${fasta_files}/msa.fa \
                                                     --threads ${NCPU}
