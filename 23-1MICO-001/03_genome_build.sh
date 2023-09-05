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

module load bowtie2/2.5.1

#GENOME=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFastaGENOME==Homo_sapiens_assembly38.fasta
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/indices

mkdir -p $OUTDIR
#bowtie2-build ${GENOME}/Homo_sapiens_assembly38.fasta ${OUTDIR}/bowtie_index
bowtie2-build ${GENOME}/Homo_sapiens_assembly38.fasta ${OUTDIR}/bowtie_index
