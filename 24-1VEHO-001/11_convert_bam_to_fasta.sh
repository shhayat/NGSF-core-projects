#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=msa
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=48:00:00
#SBATCH --mem=60G
#SBATCH --output=/project/anderson/%j.out


module load bbmap/39.06 

sample_name=$1;
mapping=/project/anderson/mapping
OUTDIR=/project/anderson/fasta_files

mkdir -p ${OUTDIR}

#convert bam to fasta file for each samples
reformat.sh in=${mapping}/${sample_name}.aligned.bam out=${OUTDIR}/${sample_name}.fa
